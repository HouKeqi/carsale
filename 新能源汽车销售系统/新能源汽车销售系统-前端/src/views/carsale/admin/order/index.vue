<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="订单编号" prop="id">
        <el-input
          v-model="queryParams.id"
          placeholder="请输入订单编号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="订单状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择订单状态" clearable>
          <el-option label="待支付" :value="0" />
          <el-option label="已支付" :value="1" />
          <el-option label="待提车" :value="2" />
          <el-option label="已完成" :value="3" />
          <el-option label="已取消" :value="4" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="loading" :data="orderList">
      <el-table-column label="订单编号" prop="id" width="180" />
      <el-table-column label="用户ID" prop="userId" width="100" />
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
      <el-table-column label="购车数量" prop="number" width="100" />
      <el-table-column label="提车门店" prop="storeLocation" />
      <el-table-column label="下单时间" prop="create_Time" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.create_Time) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="200" align="center">
        <template slot-scope="scope">
          <el-button size="mini" type="text" @click="handleDetail(scope.row.id)">查看详情</el-button>
          <el-button
            v-if="scope.row.status === 0"
            size="mini"
            type="text"
            style="color: #67c23a"
            @click="handleConfirmPay(scope.row)"
          >确认支付</el-button>
          <el-button
            v-if="scope.row.status === 1"
            size="mini"
            type="text"
            style="color: #409eff"
            @click="handleMarkPickup(scope.row)"
          >标记提车</el-button>
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
  </div>
</template>

<script>
import { getAdminOrderList, updateOrderStatus } from '@/api/carsale/order'
import { parseTime } from '@/utils/ruoyi'

export default {
  name: 'AdminOrder',
  dicts: ['carsale_order_status'],
  data() {
    return {
      loading: false,
      showSearch: true,
      total: 0,
      orderList: [],
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        id: null,
        status: null
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      getAdminOrderList(this.queryParams).then(response => {
        this.orderList = response.rows
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
    handleDetail(id) {
      // 可以打开详情对话框或跳转到详情页
      this.$modal.msgInfo('订单详情功能待实现')
    },
    handleConfirmPay(row) {
      this.$modal.confirm('确认该订单已支付？').then(() => {
        updateOrderStatus({
          id: row.id,
          status: 1
        }).then(() => {
          this.$modal.msgSuccess('操作成功')
          this.getList()
        })
      })
    },
    handleMarkPickup(row) {
      this.$modal.confirm('确认该订单已提车？').then(() => {
        updateOrderStatus({
          id: row.id,
          status: 2
        }).then(() => {
          this.$modal.msgSuccess('操作成功')
          this.getList()
        })
      })
    }
  }
}
</script>
