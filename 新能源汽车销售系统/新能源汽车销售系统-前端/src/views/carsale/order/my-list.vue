<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
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
      <el-table-column label="车型" prop="vehicleId" width="150">
        <template slot-scope="scope">
          <span v-if="vehicleMap[scope.row.vehicleId]">
            {{ vehicleMap[scope.row.vehicleId].brand }} {{ vehicleMap[scope.row.vehicleId].name }}
          </span>
        </template>
      </el-table-column>
      <el-table-column label="订单状态" prop="status" width="100">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.carsale_order_status" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column label="购车数量" prop="number" width="100" />
      <el-table-column label="成交金额" prop="amount" width="120">
        <template slot-scope="scope">
          ¥{{ scope.row.amount?.toLocaleString() }}
        </template>
      </el-table-column>
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
            style="color: #f56c6c"
            @click="handleCancel(scope.row.id)"
          >取消订单</el-button>
          <el-button
            v-if="scope.row.status === 3"
            size="mini"
            type="text"
            style="color: #67c23a"
            @click="handleEvaluate(scope.row)"
          >评价</el-button>
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
import { getMyOrderList, cancelOrder } from '@/api/carsale/order'
import { searchVehicle } from '@/api/carsale/vehicle'
import { parseTime } from '@/utils/ruoyi'

export default {
  name: 'MyOrderList',
  dicts: ['carsale_order_status'],
  data() {
    return {
      loading: false,
      showSearch: true,
      total: 0,
      orderList: [],
      vehicleMap: {},
      queryParams: {
        pageNum: 1,
        pageSize: 10,
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
      getMyOrderList(this.queryParams).then(response => {
        this.orderList = response.rows
        this.total = response.total
        this.loadVehicleInfo()
        this.loading = false
      })
    },
    loadVehicleInfo() {
      const vehicleIds = [...new Set(this.orderList.map(o => o.vehicleId))]
      if (vehicleIds.length > 0) {
        searchVehicle({ pageNum: 1, pageSize: 100 }).then(response => {
          response.rows.forEach(v => {
            this.vehicleMap[v.id] = v
          })
        })
      }
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
      this.$router.push({ path: '/carsale/order/detail', query: { id: id } })
    },
    handleCancel(id) {
      this.$modal.confirm('确认取消该订单？').then(() => {
        return cancelOrder(id)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess('取消成功')
      })
    },
    handleEvaluate(order) {
      this.$router.push({ path: '/carsale/evaluation/create', query: { orderId: order.id, vehicleId: order.vehicleId } })
    }
  }
}
</script>
