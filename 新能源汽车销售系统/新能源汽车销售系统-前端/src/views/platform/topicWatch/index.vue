<template>
  <!-- 学生选择课题 -->
  <div class="app-container">

    <!-- 表格数据 -->
    <el-switch active-text="查看已绑定的课题" v-model="value_1"  active-color="#13ce66" inactive-color="#808080" @change="change_value()"></el-switch>

    <!-- 学生选择最多3个课题-->
    <el-table v-loading="loading" :data="topicList">
      <el-table-column label="题目" align="center" prop="topic" />
      <el-table-column label="类型" align="center" prop="type" />
      <el-table-column label="要求" align="center" prop="ask" />
      <el-table-column label="教师姓名" align="center" prop="teacherName" />
      <el-table-column label="操作" width="180" v-if="this.value == false">
        <template v-slot="scope">
          <el-popconfirm cancel-button-type="info" title="确定删除吗？" @confirm="del_select(scope.row.id)">
            <el-button slot="reference" type="danger" size="small" style="margin-left: 5px">删除</el-button>
          </el-popconfirm>
        </template>
      </el-table-column>


    </el-table>

  </div>

</template>



<script>


import { delUser, getUserProfile } from '@/api/system/user'
import {
  addPaperManage,
  delPaperManage,
  getPaperManage,
  listPaperManage,
  updatePaperManage
} from '@/api/platform/paperManage'
import {
  addSelectPaper,
  delSelectPaperByPaperId, getSelectBondPaper,
  getSelectPaper,
  selectPaper,
  updateSelectPaperByUserId
} from '@/api/platform/selectPaper'

export default{
  created() {
    this.getList();
  },

  data() {
    return {
      user: {},
      // 遮罩层
      loading: true,

      // 显示搜索条件
      showSearch: true,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        topic: null,
      },

      // 表格数据
      topicList:null,

      value_1:false,

      value:false,



    }
  },

  methods: {

    getList() {
      this.queryParams.code = "已通过";
      if(this.value == false)
      {
        getSelectPaper().then(response => {
          this.topicList = response.rows;
          this.total = response.total;
          this.loading = false;
        })
      }
      else {
        console.log("getSelectBondPaper");
        getSelectBondPaper().then(response => {
          this.topicList = response.rows;
          this.total = response.total;
          this.loading = false;
        })
      }

    },

    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },



    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },

    change_value()
    {
      if(this.value===true)
        this.value = false;
      else
        this.value = true;

      this.getList();
    },

    del_select(id){
      delSelectPaperByPaperId(id).then(response => {
        this.$modal.msgSuccess("删除成功");
        this.getList();
      })
    },




  },

}
</script>
