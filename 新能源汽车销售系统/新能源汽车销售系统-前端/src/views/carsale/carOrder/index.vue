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

  </div>
</template>

<script>
import { getCarOrderList } from "@/api/carsale/carOrder";
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
        status: undefined
      },

      //是否显示搜索栏
      showSearch: true,

      // 时间区间，dateRange[0]代表开始时间，dateRange[1]代表结束时间,具体赋值的时候，会在 handleQuery 函数里面完成
      dateRange: [],

    };
  },
  created() {
    this.getList();
  },
  methods: {

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

      // 设置时间参数
      if (this.dateRange && this.dateRange.length === 2) {
        this.queryParams.startDate = this.dateRange[0];
        this.queryParams.endDate = this.dateRange[1];
      } else {
        // 如果清空了时间，也要清空查询参数里的时间
        this.queryParams.startDate = undefined;
        this.queryParams.endDate = undefined;
      }

      this.getList();
    },

    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.dateRange = [];
      this.handleQuery();
    },





  },
}
</script>
