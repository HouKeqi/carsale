<template>
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
      </el-form-item>
    </el-form>



    <!-- 表格数据 -->

    <el-table v-loading="loading" :data="topicList">
      <el-table-column label="题目" align="center" prop="topic" />
      <el-table-column label="类型" align="center" prop="type" />
      <el-table-column label="要求" align="center" prop="ask" />
      <el-table-column label="教师姓名" align="center" prop="teacherName" />
      <el-table-column label="状态" align="center" prop="code" />

      <el-table-column label="操作" width="180" >
        <template v-slot="scope" >
          <el-button type="primary" size="small" @click="pass_Topic(scope.row.id)"
                     v-if="scope.row.code === '未审核' || scope.row.code === '未通过'">通过</el-button>
          <el-button type="primary" size="small" @click="not_pass_Topic(scope.row.id)"
                     v-if="scope.row.code === '未审核' || scope.row.code === '未通过'">未通过</el-button>
        </template>
      </el-table-column>

<!--      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">-->
<!--        <template slot-scope="scope">-->
<!--          <el-button-->
<!--            size="mini"-->
<!--            type="text"-->
<!--            icon="el-icon-edit"-->
<!--            @click="handleUpdate(scope.row)"-->
<!--            v-hasPermi="['mes:product:edit']"-->
<!--          >修改</el-button>-->
<!--          <el-button-->
<!--            size="mini"-->
<!--            type="text"-->
<!--            icon="el-icon-delete"-->
<!--            @click="handleDelete(scope.row)"-->
<!--            v-hasPermi="['mes:product:remove']"-->
<!--          >删除</el-button>-->
<!--        </template>-->
<!--      </el-table-column>-->
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

export default{
  created() {
    this.getList();
  },

  data() {
    return {
      user: {},
      // 遮罩层
      loading: true,
      // 非多个禁用
      multiple: true,
      // 弹出层标题
      title: "",
      // 显示搜索条件
      showSearch: true,
      // 查询参数
      // 打开对话框
      open:false,
      // 表单校验
      rules: {
        topic: [
          { required: true, message: "题目不能为空", trigger: "blur" }
        ],
      },
      // 论文类型选择
      topic_type_options: [
        {
          value: '选项1',
          label: '工程设计'
        }, {
          value: '选项2',
          label: '专题研究'
        }, {
          value: '选项3',
          label: '文献综述'
        }, {
          value: '选项4',
          label: '综合实验'
        }],
      // 表单参数
      form: {},
      // 非单个禁用
      single: true,
      // 表格数据
      topicList:null,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        topic: null,
      },



    }
  },

  methods: {
    getList() {
      listPaperManage(this.queryParams).then(response => {
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

    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updatePaperManage(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            this.form.code = "未审核";
            this.form.teacherName = this.user.userName;
            addPaperManage(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },

    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },

    /** 论文审核通过 按钮操作 */
    pass_Topic(id){
      console.log(id);
      console.log(id);
      console.log(id);
      console.log(id);
      console.log(id);
      this.$modal.confirm('是否确认通过该课题？').then(function() {
        return updatePaperManage({id:id,code:"已通过"});
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("审核成功");
      }).catch(() => {});
    },

    /** 论文审核不通过 按钮操作 */
    not_pass_Topic(id){
      this.$modal.confirm('是否确认不通过该课题？').then(function() {
        return updatePaperManage({id:id,code:"未通过"});
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("审核成功");
      }).catch(() => {});
    },

  }
}
</script>
