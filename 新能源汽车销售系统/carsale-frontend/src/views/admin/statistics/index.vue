<template>
  <a-card class="main-page">
    <!-- 时间筛选 -->
    <div style="margin-bottom: 1rem">
      <a-range-picker
        v-model:value="dateRange"
        format="YYYY-MM-DD"
        @change="handleDateChange"
        style="width: 300px; float: right"
      />
    </div>

    <!-- 统计卡片 -->
    <a-row :gutter="20" style="margin-bottom: 20px">
      <a-col :span="6">
        <a-card>
          <a-statistic
            title="销售额"
            :value="salesAmount"
            :precision="2"
            prefix="¥"
            :value-style="{ color: '#3f8600' }"
          />
        </a-card>
      </a-col>
      <a-col :span="6">
        <a-card>
          <a-statistic
            title="新增用户数"
            :value="newUsersCount"
            :value-style="{ color: '#1890ff' }"
          />
        </a-card>
      </a-col>
    </a-row>

    <!-- 图表 -->
    <a-row :gutter="20">
      <a-col :span="12">
        <a-card title="销量TOP5车型">
          <div id="top5Chart" style="width: 100%; height: 400px;"></div>
        </a-card>
      </a-col>
      <a-col :span="12">
        <a-card title="品牌销售占比">
          <div id="brandChart" style="width: 100%; height: 400px;"></div>
        </a-card>
      </a-col>
    </a-row>

    <a-row :gutter="20" style="margin-top: 20px">
      <a-col :span="12">
        <a-card title="续航里程销售占比">
          <div id="rangeChart" style="width: 100%; height: 400px;"></div>
        </a-card>
      </a-col>
    </a-row>
  </a-card>
</template>

<script setup>
import { ref, reactive, onMounted, onBeforeUnmount } from 'vue'
import { message } from 'ant-design-vue'
import request from '@/utils/request'
import dayjs from 'dayjs'
import * as echarts from 'echarts'

const dateRange = ref(null)
const salesAmount = ref(0)
const newUsersCount = ref(0)
let top5Chart = null
let brandChart = null
let rangeChart = null

const queryParams = reactive({
  startTime: null,
  endTime: null
})

// 初始化图表
const initCharts = () => {
  top5Chart = echarts.init(document.getElementById('top5Chart'))
  brandChart = echarts.init(document.getElementById('brandChart'))
  rangeChart = echarts.init(document.getElementById('rangeChart'))
}

// 日期变化
const handleDateChange = (dates) => {
  if (dates && dates.length === 2) {
    queryParams.startTime = dates[0].format('YYYY-MM-DD')
    queryParams.endTime = dates[1].format('YYYY-MM-DD')
  } else {
    queryParams.startTime = null
    queryParams.endTime = null
  }
  loadAllData()
}

// 加载所有数据
const loadAllData = async () => {
  await Promise.all([
    getSalesAmount(),
    getNewUsersCount(),
    getTop5Vehicles(),
    getBrandDistribution(),
    getRangeDistribution()
  ])
}

// 获取销售额
const getSalesAmount = async () => {
  try {
    const res = await request({
      url: '/carsale/admin/statistics/sales-amount',
      method: 'get',
      params: queryParams
    })
    salesAmount.value = res.data?.amount || 0
  } catch (error) {
    console.error('获取销售额失败', error)
  }
}

// 获取新增用户数
const getNewUsersCount = async () => {
  try {
    const res = await request({
      url: '/carsale/admin/statistics/new-users',
      method: 'get',
      params: queryParams
    })
    newUsersCount.value = res.data?.count || 0
  } catch (error) {
    console.error('获取新增用户数失败', error)
  }
}

// 获取销量TOP5
const getTop5Vehicles = async () => {
  try {
    const res = await request({
      url: '/carsale/admin/statistics/top5-vehicles',
      method: 'get',
      params: queryParams
    })
    const data = res.data || []
    const option = {
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
    top5Chart.setOption(option)
  } catch (error) {
    console.error('获取销量TOP5失败', error)
  }
}

// 获取品牌销售占比
const getBrandDistribution = async () => {
  try {
    const res = await request({
      url: '/carsale/admin/statistics/brand-distribution',
      method: 'get',
      params: queryParams
    })
    const data = res.data || []
    const option = {
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
    brandChart.setOption(option)
  } catch (error) {
    console.error('获取品牌销售占比失败', error)
  }
}

// 获取续航里程销售占比
const getRangeDistribution = async () => {
  try {
    const res = await request({
      url: '/carsale/admin/statistics/range-distribution',
      method: 'get',
      params: queryParams
    })
    const data = res.data || []
    const option = {
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
    rangeChart.setOption(option)
  } catch (error) {
    console.error('获取续航里程销售占比失败', error)
  }
}

onMounted(() => {
  initCharts()
  loadAllData()
  // 监听窗口大小变化
  window.addEventListener('resize', () => {
    top5Chart?.resize()
    brandChart?.resize()
    rangeChart?.resize()
  })
})

onBeforeUnmount(() => {
  top5Chart?.dispose()
  brandChart?.dispose()
  rangeChart?.dispose()
  window.removeEventListener('resize', () => {})
})
</script>

<style scoped>
.main-page {
  padding: 2%;
  margin-top: 2vh;
  height: 90vh;
  overflow-y: auto;
}
</style>
