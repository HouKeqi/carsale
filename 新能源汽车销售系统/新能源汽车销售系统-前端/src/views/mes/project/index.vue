<template>
  <div class="app-container">

    <!-- 搜索栏 -->
    <!-- 属性解释   inline:行类表单  showSearch:显示搜索框 -->
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true"  v-show="showSearch" label-width="68px">
      <el-form-item label="项目名称" prop="projectName">
        <!-- 属性解释   @keyup.enter.native: 回车键 ,按键回车触发事件 -->
        <el-input
          v-model="queryParams.projectName"
          placeholder="请输入项目名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>

      <el-form-item label="项目负责人" prop="projectHeader">
        <el-input
          v-model="queryParams.projectHeader"
          placeholder="项目负责人"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>

      <el-form-item label="项目时间">
        <el-date-picker
          v-model="dateRange"
          style="width: 240px"
          value-format="yyyy-MM-dd"
          type="daterange"
          range-separator="-"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
        ></el-date-picker>
      </el-form-item>

      <el-form-item label="状态" prop="status">
        <!-- 属性解释  v-model:绑定值  placeholder:提示文字,为输入框设置一个默认的提示信息  clearable:是否可清空 -->
        <el-select v-model="queryParams.status" placeholder="项目状态" clearable>
          <el-option
            v-for="dict in dict.type.mes_project_status"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>

      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 添加或修改项目维护对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">

        <el-form-item label="项目名称" prop="projectName">
          <el-input v-model="form.projectName" placeholder="请输入项目名称" />

        </el-form-item>
        <el-form-item label="项目负责人" prop="projectHeader">
          <el-input v-model="form.projectHeader" placeholder="请输入项目负责人" />
        </el-form-item>

        <el-form-item label="项目时间">
          <el-date-picker v-model="dateRangeForm" style="width: 240px" value-format="yyyy-MM-dd" type="daterange"
                          range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期"></el-date-picker>
        </el-form-item>

        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio
              v-for="dict in dict.type.mes_project_status" :key="dict.value" :label="dict.value">{{dict.label}}</el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item label="项目描述" prop="introduce">
          <el-input v-model="form.introduce" type="textarea" placeholder="请输入项目描述" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 按钮显示 -->
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <!-- v-hasPermi属性 判断是否有【mes:project:add】权限 -->
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd"
                   v-hasPermi="['mes:project:add']">新增</el-button>
      </el-col>

      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single"
                   @click="handleUpdate" v-hasPermi="['mes:project:edit']">修改</el-button>
      </el-col>

      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple"
                   @click="handleDelete" v-hasPermi="['mes:project:remove']">删除</el-button>
      </el-col>

      <el-col :span="1.5">
        <el-button type="warning" plain icon="el-icon-download" size="mini" @click="handleExport"
                   v-hasPermi="['mes:project:export']">导出</el-button>
      </el-col>

      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <!-- 表格数据显示 -->
    <el-table v-loading="loading" :data="projectList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="项目编号" align="center" prop="id" />
      <el-table-column label="负责人" align="center" prop="projectHeader" />
      <el-table-column label="项目名称" align="center" prop="projectName" />
      <el-table-column label="状态" align="center" prop="status">
        <!-- 传过来的status是0/1,修改成数据字典中的挂起/正常 -->
        <template slot-scope="scope">
          <!-- options是字典中的数据, 将value中的值与 option数据字典中的value进行对比, 找到对应的label【挂起/正常】, 显示在页面上 -->
          <dict-tag :options="dict.type.mes_project_status" :value="scope.row.status"/>
        </template>
      </el-table-column>

      <el-table-column label="开始时间" align="center" prop="startDate" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.startDate) }}</span>
        </template>
      </el-table-column>

      <el-table-column label="结束时间" align="center" prop="endDate" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.endDate) }}</span>
        </template>
      </el-table-column>

      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)"
                     v-hasPermi="['mes:project:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)"
                     v-hasPermi="['mes:project:remove']">删除</el-button>
        </template>
      </el-table-column>

    </el-table>

    <!-- 分页显示，其中@pagination属性: 页面发生变化时, 调用getList方法 -->
    <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum"
                :limit.sync="queryParams.pageSize" @pagination="getList"/>

  </div>
</template>

<script>
// @ = src文件, 导入src/api/mes/project.js文件中的getMesProjectList方法
import { getMesProjectList, addMesProject, getMesProject, editMesProject, deleteMesProject} from "@/api/mes/project";
import { delPost } from '@/api/system/post'
export default {
  dicts: ['mes_project_status'],
  data() {
    return {
      // 遮罩层
      loading: false,
      // 岗位表格数据
      projectList: [],
      // 总条数
      total : 0,
      // 对话框标题
      title: "新增项目维护",
      // 是否显示对话框
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        projectHeader: undefined,
        projectName: undefined,
        status: undefined
      },
      // 是否显示搜索框
      showSearch:true,
      // 表单参数
      form: {

      },
      // 表单验证规则
      rules:{
        projectName: [
          { required: true, message: "项目名称不能为空", trigger: "blur" }
        ],
        projectHeader: [
          { required: true, message: "项目负责人不能为空", trigger: "blur" }
        ]
      },
      // 日期范围
      dateRange: [],
      dateRangeForm: [],
      // 复选框
      ids:[],
      single: true, // 非单选
      multiple: true, // 没有选择

    }
  },
  created() {
    this.getList();
  },

  methods:{
    getList(){
      this.loading = true;
      getMesProjectList(this.queryParams).then(res => {
        console.log(res);
        this.projectList = res.rows;
        this.total = res.total;
        this.loading = false;
      })
    },

    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.handleStartAndEndDate(this.queryParams,this.dateRange);
      this.getList();
    },


    handleStartAndEndDate(data,dateRange)
    {
      if(dateRange == null || dateRange.length === 0)
      {
        data.startDate = null;
        data.endDate = null;
        return;
      }
      data.startDate = dateRange[0];
      data.endDate = dateRange[1];
      console.log(data);
    },


    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.dateRange = [];
      this.handleQuery();
    },

    /** 新增按钮操作 */
    handleAdd(){
      this.title = "新增项目维护";
      this.open = true;
      // 重置对话框
      this.reset();
    },

    /** 表单重置 */
    reset() {
      this.form = {
        id: undefined,
        projectName: undefined,
        projectHeader: undefined,
        status: "0",
        introduce: undefined
      };
      this.dateRangeForm = [];
      this.resetForm("form");
    },

    /** 提交按钮操作 */
    submitForm()
    {
      this.handleStartAndEndDate(this.form,this.dateRangeForm);
      // 判断新增/修改【有没有id】
      if(this.form.id)
      {
        // 修改
        editMesProject(this.form).then(res => {
          this.$modal.msgSuccess("修改成功");
          this.getList();
        })
      }
      else
      {
        // 新增
        addMesProject(this.form).then(res => {
          this.$modal.msgSuccess("新增成功");
          this.getList();

        })
      }
      this.open = false;
    },

    cancel(){
      this.open = false;
      // 重置表单
      this.reset();
    },

    handleUpdate(row){
      this.title = "编辑项目维护";
      this.open = true;
      // 重置对话框
      this.reset();
      // 加载维护项目的信息
      let id = row.id || this.ids[0];
      getMesProject(id).then(res => {
        this.form = res.data;
        this.dateRangeForm[0] = this.form.startDate;
        this.dateRangeForm[1] = this.form.endDate;
      })
    },

    /** 多选框选中数据 */
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.id)
      this.single = selection.length!=1
      this.multiple = !selection.length
    },

    /** 删除按钮操作 */
    handleDelete(row) {
      // 路径参数，数组和单个数都可以
      const ids = row.postId || this.ids;
      this.$modal.confirm('是否确认删除项目编号为"' + ids + '"的项目？').then(function() {
        return deleteMesProject(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },

    /** 导出按钮操作 */
    handleExport() {
      // this.download('mes/project/export', {
      //   ...this.queryParams
      // }, `post_${new Date().getTime()}.xlsx`)
      this.download('mes/project/export', {
        ...this.queryParams
      }, `项目维护列表_${new Date().getTime()}.xlsx`)
    }


  }
}
</script>

<style scoped lang="scss">

</style>
