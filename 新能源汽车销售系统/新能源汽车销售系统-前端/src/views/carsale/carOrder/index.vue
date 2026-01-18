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
            v-for="dict in dict.type.carsale_carorder_status"
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





    <!-- 按钮显示 -->
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <!-- v-hasPermi属性 判断是否有【carsale:carorder:add】权限 -->
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd"
                   v-hasPermi="['carsale:carorder:add']">新增</el-button>
      </el-col>

      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single"
                   @click="handleUpdate" v-hasPermi="['carsale:carorder:edit']">修改</el-button>
      </el-col>

      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple"
                   @click="handleDelete" v-hasPermi="['carsale:carorder:remove']">删除</el-button>
      </el-col>

      <el-col :span="1.5">
        <el-button type="warning" plain icon="el-icon-download" size="mini" @click="handleExport"
                   v-hasPermi="['carsale:carorder:export']">导出</el-button>
      </el-col>

      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>


    <!-- 表格数据显示 -->
    <el-table v-loading="loading" :data="CarOrderList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="项目编号" align="center" prop="id" />
      <el-table-column label="负责人" align="center" prop="projectHeader" />
      <el-table-column label="项目名称" align="center" prop="projectName" />
      <el-table-column label="状态" align="center" prop="status">
        <!-- 传过来的status是0/1,修改成数据字典中的挂起/正常 -->
        <template slot-scope="scope">
          <!-- options是字典中的数据, 将value中的值与 option数据字典中的value进行对比, 找到对应的label【挂起/正常】, 显示在页面上 -->
          <dict-tag :options="dict.type.carsale_carorder_status" :value="scope.row.status"/>
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
                     v-hasPermi="['carsale:carorder:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)"
                     v-hasPermi="['carsale:carorder:remove']">删除</el-button>
        </template>
      </el-table-column>

    </el-table>

    <!-- 分页显示，其中@pagination属性: 页面发生变化时, 调用getList方法 -->
    <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum"
                :limit.sync="queryParams.pageSize" @pagination="getList"/>


    <!-- 添加或修改用户购车对话框 -->
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
              v-for="dict in dict.type.carsale_carorder_status" :key="dict.value" :label="dict.value">{{dict.label}}</el-radio>
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





  </div>
</template>

<script>
import { getCarOrderList, addCarOrder ,editCarOrder,deleteCarOrder,getCarOrder} from "@/api/carsale/carOrder";
export default {
  // 引入自定义的数据字典
  dicts: ['carsale_carorder_status'],
  data() {
    return {
      CarOrderList: [],
      loading: true,
      total:0 ,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        projectHeader: undefined,
        projectName: undefined,
        status: undefined,
      },

      //是否显示搜索栏
      showSearch: true,

      // 时间区间，dateRange[0]代表开始时间，dateRange[1]代表结束时间,具体赋值的时候，会在 handleQuery 函数里面完成
      dateRange: [],

      // 对话框里面的时间参数
      dateRangeForm:[],

      // 添加或修改用户购车对话框标题
      title: "添加用户购车",

      // "添加或修改用户购车对话框"是否可见，默认隐藏
      open: false,

      // 添加或修改用户购车对话框数据
      form: {
        id: undefined,
        projectName: undefined,
        projectHeader: undefined,
        status: undefined,
        introduce: undefined
      },

      // 添加或修改用户购车对话框验证规则
      rules: {
        projectName: [
          { required: true, message: "项目名称不能为空", trigger: "blur" }
        ],
        projectHeader: [
          { required: true, message: "项目负责人不能为空", trigger: "blur" }
        ],
      },

      // 复选框
      ids:[],
      single: true,
      multiple: true,


    };
  },
  created() {
    this.getList();
  },
  methods: {

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

    getList() {
      this.loading = true;
      getCarOrderList(this.queryParams).then( body => {
        console.log(body);
        this.CarOrderList = body.rows;
        this.total = body.total;
        this.loading = false;
      })
    },

    /** 多选框选中数据 */
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.id)
      this.single = selection.length!=1
      this.multiple = !selection.length
    },

    /** 搜索框操作 */
    handleQuery(){
      // 重置页码
      this.queryParams.pageNum = 1;

      this.handleStartAndEndDate(this.queryParams,this.dateRange) ;

      // 输出
      // 输出一句话“啊啊啊啊啊”,后面加上queryParams
      console.log("最终提交的 Body 数据：", this.queryParams);

      this.getList();
    },

    /** 查询的重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.dateRange = [];
      this.handleQuery();
    },

    /** 新增按钮操作 */
    handleAdd() {
      this.title = "新增项目维护";
      this.open = true;
      this.reset();
    },

    /** 对话框的提交按钮 操作 */
    /** 提交按钮操作 */
    submitForm()
    {
      this.handleStartAndEndDate(this.form,this.dateRangeForm);

      // 强制将 status 转为数字后再提交
      if (this.form.status !== undefined && this.form.status !== null) {
        this.form.status = parseInt(this.form.status);
      }

      // 判断新增/修改【有没有id】
      if(this.form.id)
      {
        // 输出修改数据
        console.log("最终提交的 Body 数据：", this.form);
        // 修改
        editCarOrder(this.form).then(res => {
          this.$modal.msgSuccess("修改成功");
          this.getList();
        })
      }
      else
      {
        // 新增
        addCarOrder(this.form).then(res => {
          this.$modal.msgSuccess("新增成功");
          this.getList();

        })
      }
      this.open = false;
    },

    /** 对话框的取消按钮 操作 */
    cancel() {
      this.open = false;
      // 重置表单
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

    /** 表格某一行的修改按钮操作 */
    handleUpdate(row){
      this.title = "编辑项目维护";
      this.open = true;
      // 重置对话框
      this.reset();
      // 加载维护项目的信息
      let id = row.id || this.ids[0];
      getCarOrder(id).then(res => {
        this.form = res.data;
        this.dateRangeForm[0] = this.form.startDate;
        this.dateRangeForm[1] = this.form.endDate;
      })
    },

    /** 表格某一行的删除按钮操作 */
    handleDelete(row) {
      // 路径参数，数组和单个数都可以
      const ids = row.id || this.ids;
      this.$modal.confirm('是否确认删除项目编号为"' + ids + '"的项目？').then(function() {
        return deleteCarOrder(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },

    /** 导出按钮操作 */
    handleExport() {
      this.download('carsale/carOrder/export', {
        ...this.queryParams
      }, `用户购车列表_${new Date().getTime()}.xlsx`)
    }



  },
}
</script>
