<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="用户名称" prop="userName">
        <el-input
          v-model="queryParams.userName"
          placeholder="请输入用户名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="手机号码" prop="phonenumber">
        <el-input
          v-model="queryParams.phonenumber"
          placeholder="请输入手机号码"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="loading" :data="userList">
      <el-table-column label="用户ID" align="center" prop="userId" width="100" />
      <el-table-column label="用户名称" align="center" prop="userName" />
      <el-table-column label="真实姓名" align="center" prop="realName" />
      <el-table-column label="手机号码" align="center" prop="phonenumber" />
      <el-table-column label="身份证号" align="center" prop="idCard" />
      <el-table-column label="地址" align="center" prop="address" />
      <el-table-column label="注册时间" align="center" prop="createTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="200" align="center">
        <template slot-scope="scope">
          <el-button size="mini" type="text" @click="handleViewOrders(scope.row.userId)">购车记录</el-button>
          <el-button size="mini" type="text" @click="handleViewPreferences(scope.row.userId)">浏览偏好</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 购车记录对话框 -->
    <el-dialog title="购车记录" :visible.sync="ordersDialogVisible" width="1000px" append-to-body>
      <el-table :data="userOrders" v-loading="ordersLoading">
        <el-table-column label="订单编号" prop="id" width="180" />
        <el-table-column label="车型ID" prop="vehicleId" width="100" />
        <el-table-column label="订单状态" prop="status" width="100">
          <template slot-scope="scope">
            <dict-tag :options="dict.type.carsale_order_status" :value="scope.row.status" />
          </template>
        </el-table-column>
        <el-table-column label="成交金额" prop="amount" width="120">
          <template slot-scope="scope">
            ¥{{ scope.row.amount?.toLocaleString() }}
          </template>
        </el-table-column>
        <el-table-column label="下单时间" prop="create_Time" width="180">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.create_Time) }}</span>
          </template>
        </el-table-column>
      </el-table>
    </el-dialog>

    <!-- 浏览偏好对话框 -->
    <el-dialog title="浏览偏好" :visible.sync="preferencesDialogVisible" width="800px" append-to-body>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="订单数量">{{ preferences.orderCount }}</el-descriptions-item>
        <el-descriptions-item label="评价数量">{{ preferences.evaluationCount }}</el-descriptions-item>
      </el-descriptions>
      <el-divider />
      <h4>订单列表</h4>
      <el-table :data="preferences.orders" style="margin-top: 10px">
        <el-table-column label="订单编号" prop="id" width="180" />
        <el-table-column label="车型ID" prop="vehicleId" width="100" />
        <el-table-column label="成交金额" prop="amount" width="120">
          <template slot-scope="scope">
            ¥{{ scope.row.amount?.toLocaleString() }}
          </template>
        </el-table-column>
        <el-table-column label="下单时间" prop="create_Time" width="180">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.create_Time) }}</span>
          </template>
        </el-table-column>
      </el-table>
    </el-dialog>
  </div>
</template>

<script>
import { getUserList, getUserOrders, getUserPreferences } from '@/api/carsale/adminUser'
import { parseTime } from '@/utils/ruoyi'

export default {
  name: 'AdminUser',
  dicts: ['carsale_order_status'],
  data() {
    return {
      loading: false,
      showSearch: true,
      total: 0,
      userList: [],
      userOrders: [],
      ordersLoading: false,
      ordersDialogVisible: false,
      preferences: {},
      preferencesDialogVisible: false,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        userName: null,
        phonenumber: null
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      getUserList(this.queryParams).then(response => {
        this.userList = response.rows
        this.total = response.total
        this.loading = false
      })
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.resetForm('queryForm')
      this.handleQuery()
    },
    handleViewOrders(userId) {
      this.ordersDialogVisible = true
      this.ordersLoading = true
      getUserOrders(userId).then(response => {
        this.userOrders = response.rows
        this.ordersLoading = false
      })
    },
    handleViewPreferences(userId) {
      this.preferencesDialogVisible = true
      getUserPreferences(userId).then(response => {
        this.preferences = response.data
      })
    }
  }
}
</script>
