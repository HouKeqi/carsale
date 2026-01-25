<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" label-width="100px" style="margin-bottom: 20px">
      <el-form-item label="开始时间">
        <el-date-picker
          v-model="queryParams.startTime"
          type="date"
          placeholder="选择开始时间"
          value-format="yyyy-MM-dd"
          style="width: 200px"
        />
      </el-form-item>
      <el-form-item label="结束时间">
        <el-date-picker
          v-model="queryParams.endTime"
          type="date"
          placeholder="选择结束时间"
          value-format="yyyy-MM-dd"
          style="width: 200px"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">查询</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="20" style="margin-bottom: 20px">
      <el-col :span="6">
        <el-card>
          <div class="stat-item">
            <div class="stat-label">销售额</div>
            <div class="stat-value">¥{{ salesAmount?.toLocaleString() || 0 }}</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card>
          <div class="stat-item">
            <div class="stat-label">新增用户数</div>
            <div class="stat-value">{{ newUsersCount || 0 }}</div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20">
      <el-col :span="12">
        <el-card>
          <div slot="header">销量TOP5车型</div>
          <div id="top5Chart" style="width: 100%; height: 400px;"></div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card>
          <div slot="header">品牌销售占比</div>
          <div id="brandChart" style="width: 100%; height: 400px;"></div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-top: 20px">
      <el-col :span="12">
        <el-card>
          <div slot="header">续航里程销售占比</div>
          <div id="rangeChart" style="width: 100%; height: 400px;"></div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import * as echarts from 'echarts'
import { getTop5Vehicles, getSalesAmount, getNewUsersCount, getBrandDistribution, getRangeDistribution } from '@/api/carsale/statistics'

export default {
  name: 'Statistics',
  data() {
    return {
      queryParams: {
        startTime: null,
        endTime: null
      },
      salesAmount: 0,
      newUsersCount: 0,
      top5Chart: null,
      brandChart: null,
      rangeChart: null
    }
  },
  mounted() {
    this.initCharts()
    this.handleQuery()
  },
  beforeDestroy() {
    if (this.top5Chart) {
      this.top5Chart.dispose()
    }
    if (this.brandChart) {
      this.brandChart.dispose()
    }
    if (this.rangeChart) {
      this.rangeChart.dispose()
    }
  },
  methods: {
    initCharts() {
      this.top5Chart = echarts.init(document.getElementById('top5Chart'))
      this.brandChart = echarts.init(document.getElementById('brandChart'))
      this.rangeChart = echarts.init(document.getElementById('rangeChart'))
    },
    handleQuery() {
      this.getSalesAmount()
      this.getNewUsersCount()
      this.getTop5Vehicles()
      this.getBrandDistribution()
      this.getRangeDistribution()
    },
    resetQuery() {
      this.queryParams.startTime = null
      this.queryParams.endTime = null
      this.handleQuery()
    },
    getSalesAmount() {
      getSalesAmount(this.queryParams.startTime, this.queryParams.endTime).then(response => {
        this.salesAmount = response.data.amount || 0
      })
    },
    getNewUsersCount() {
      getNewUsersCount(this.queryParams.startTime, this.queryParams.endTime).then(response => {
        this.newUsersCount = response.data.count || 0
      })
    },
    getTop5Vehicles() {
      getTop5Vehicles(this.queryParams.startTime, this.queryParams.endTime).then(response => {
        const data = response.data || []
        const option = {
          title: {
            text: '销量TOP5车型'
          },
          tooltip: {
            trigger: 'axis',
            axisPointer: {
              type: 'shadow'
            }
          },
          xAxis: {
            type: 'category',
            data: data.map(item => item.name || `${item.brand} ${item.name}`)
          },
          yAxis: {
            type: 'value'
          },
          series: [{
            data: data.map(item => item.sales_count || 0),
            type: 'bar'
          }]
        }
        this.top5Chart.setOption(option)
      })
    },
    getBrandDistribution() {
      getBrandDistribution(this.queryParams.startTime, this.queryParams.endTime).then(response => {
        const data = response.data || []
        const option = {
          title: {
            text: '品牌销售占比'
          },
          tooltip: {
            trigger: 'item'
          },
          series: [{
            type: 'pie',
            radius: '50%',
            data: data.map(item => ({
              value: item.sales_count || 0,
              name: item.brand
            }))
          }]
        }
        this.brandChart.setOption(option)
      })
    },
    getRangeDistribution() {
      getRangeDistribution(this.queryParams.startTime, this.queryParams.endTime).then(response => {
        const data = response.data || []
        const option = {
          title: {
            text: '续航里程销售占比'
          },
          tooltip: {
            trigger: 'item'
          },
          series: [{
            type: 'pie',
            radius: '50%',
            data: data.map(item => ({
              value: item.sales_count || 0,
              name: item.range_category
            }))
          }]
        }
        this.rangeChart.setOption(option)
      })
    }
  }
}
</script>

<style scoped lang="scss">
.stat-item {
  text-align: center;
}

.stat-label {
  font-size: 14px;
  color: #909399;
  margin-bottom: 10px;
}

.stat-value {
  font-size: 32px;
  color: #409eff;
  font-weight: bold;
}
</style>
