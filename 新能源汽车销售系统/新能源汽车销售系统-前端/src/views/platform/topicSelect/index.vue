<template>
  <!-- 学生选择课题 -->
  <div class="app-container">

    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="题目" prop="topic">
        <el-input
          v-model="queryParams.topic"
          placeholder="请输入论文题目"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
        <el-button type="danger" :disabled="multiple" @click="select">批量选择</el-button>
      </el-form-item>
    </el-form>



    <!-- 表格数据 -->

    <!-- 学生选择最多3个课题-->
    <el-table v-loading="loading" :data="topicList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="题目" align="center" prop="topic" />
      <el-table-column label="类型" align="center" prop="type" />
      <el-table-column label="要求" align="center" prop="ask" />
      <el-table-column label="教师姓名" align="center" prop="teacherName" />


    </el-table>

  </div>

</template>



<script>


import { delUser, getUserProfile } from '@/api/system/user'
import {
  addPaperManage,
  delPaperManage,
  getPaperManage,
  listPaperManage, UnselectPaperList,
  updatePaperManage
} from '@/api/platform/paperManage'
import { addSelectPaper, selectPaper, updateSelectPaperByUserId } from '@/api/platform/selectPaper'

export default{
  created() {
    this.getList();
  },

  data() {
    return {
      user: {},
      // 学生多选的3个课题
      multipleSelection: [],
      // 遮罩层
      loading: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        topic: null,
      },
      // 表单参数
      form: {},
      // 非单个禁用
      single: true,
      // 表格数据
      topicList:null,
      // 多选课题的选择数据
      selectData:{
        selectId1:null,
        selectId2:null,
        selectId3:null,
        userId:null,
      },




    }
  },

  methods: {
    getList() {
      this.queryParams.code = "已通过"
      UnselectPaperList(this.queryParams).then(response => {
        this.topicList = response.rows;
        this.total = response.total;
        this.loading = false;
      })
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




    /** 多选框选中数据 */
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.id);
      this.topics = selection.map(item => item.topic);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
      this.multipleSelection = selection;

    },

    resetSelectData(){
      this.selectData={
        selectId1:null,
        selectId2:null,
        selectId3:null,
        userId:null,
      }
    },


    select(){
      if (this.multipleSelection.length > 3)
      {
        this.$modal.msgWarning("所选课题不能超过3个")
        return
      }
      this.resetSelectData();
      for (let i = 0; i < this.multipleSelection.length; i++) {
        this.selectData[`selectId${i+1}`] = this.ids[i];
      }
      console.log(this.selectData);
      selectPaper(this.selectData).then(response => {
        this.$modal.msgSuccess("新增成功");
        this.getList();
      });







    },


  }
}
</script>
