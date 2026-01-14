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

    <!-- 新增、导出按钮 -->
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['platform:topic:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['platform:topic:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['platform:topic:remove']"
        >删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <!-- 添加或修改产品建模对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="题目" prop="topic">
          <el-input v-model="form.topic" placeholder="请输入题目" />
        </el-form-item>
        <el-form-item label="类型">
          <el-select v-model="form.type" placeholder="请选择课题类型">
            <el-option
              v-for="item in topic_type_options"
              :key="item.id"
              :label="item.label"
              :value="item.label"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="要求" prop="ask">
          <el-input v-model="form.ask" type="textarea" placeholder="请输入课题要求" />
        </el-form-item>
      </el-form>

      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>


    <!-- 表格数据 -->

    <!-- 老师发布课题-->
    <el-table v-loading="loading" :data="topicList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="题目" align="center" prop="topic" />
      <el-table-column label="类型" align="center" prop="type" />
      <el-table-column label="要求" align="center" prop="ask" />
      <el-table-column label="状态" align="center" prop="code" />

      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['platform:topic:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['platform:topic:remove']"
          >删除</el-button>
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
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },

    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },

    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加课题";
    },

    /** 表单重置 */
    reset() {
      this.form = {
        type: null,
        topic: null,
        ask: null,
      };
      this.resetForm("form");
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
      this.queryParams.teacherName = this.user.userName;
      this.handleQuery();
    },


    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids;
      getPaperManage(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改课题信息";
      });
    },

    /** 多选框选中数据 */
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.id);
      this.topics = selection.map(item => item.topic);
      this.single = selection.length != 1;
      this.multiple = !selection.length;
    },

    /** 删除按钮操作 */
    handleDelete(row) {
      const id = row.id || this.ids;
      const topic = row.topic || this.topics;
      this.$modal.confirm('是否确认删除题目为"' + topic + '"的课题？').then(function() {
        return delPaperManage(id);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },

  }
}
</script>
