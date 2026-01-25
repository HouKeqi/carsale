<template>
  <a-card class="main-page" v-loading="loading">
    <div v-if="order">
      <a-page-header
        title="订单详情"
        @back="() => router.push({ path: '/customer/order/my-list' })"
      />

      <a-divider />

      <!-- 订单状态 -->
      <a-card :bordered="false" style="margin-bottom: 20px">
        <a-steps :current="getStatusStep(order.status)" :status="getStatusStepStatus(order.status)">
          <a-step title="待支付" />
          <a-step title="已支付" />
          <a-step title="待提车" />
          <a-step title="已完成" />
        </a-steps>
        <!-- 待提车提醒 -->
        <a-alert
          v-if="order.status === 2"
          message="待提车提醒"
          description="您的订单已准备就绪，请前往所选门店完成线下核验并提走车辆。"
          type="info"
          show-icon
          style="margin-top: 20px"
        />
      </a-card>

      <a-row :gutter="20">
        <!-- 左侧：订单信息 -->
        <a-col :span="16">
          <a-card title="订单信息" :bordered="false" style="margin-bottom: 20px">
            <a-descriptions :column="2" bordered>
              <a-descriptions-item label="订单编号" :span="2">
                {{ order.id }}
              </a-descriptions-item>
              <a-descriptions-item label="订单状态">
                <a-tag :color="getStatusColor(order.status)">
                  {{ formatStatus(order.status) }}
                </a-tag>
              </a-descriptions-item>
              <a-descriptions-item label="成交金额">
                <span style="font-size: 20px; color: #ff4d4f; font-weight: bold">
                  ¥{{ formatPrice(order.amount) }}
                </span>
              </a-descriptions-item>
              <a-descriptions-item label="购车数量">
                {{ order.number }} 辆
              </a-descriptions-item>
              <a-descriptions-item label="提车门店">
                {{ order.storeLocation }}
              </a-descriptions-item>
              <a-descriptions-item label="联系方式">
                {{ order.phone }}
              </a-descriptions-item>
              <a-descriptions-item label="下单时间">
                {{ formatDateTime(order.create_Time) }}
              </a-descriptions-item>
              <a-descriptions-item label="支付时间" v-if="order.payTime">
                {{ formatDateTime(order.payTime) }}
              </a-descriptions-item>
              <a-descriptions-item label="提车时间" v-if="order.pickupTime">
                {{ formatDateTime(order.pickupTime) }}
              </a-descriptions-item>
            </a-descriptions>
          </a-card>

          <!-- 车辆信息 -->
          <a-card title="车辆信息" :bordered="false" v-if="vehicleInfo">
            <a-row :gutter="20">
              <a-col :span="8">
                <img
                  :src="vehicleInfo.imageUrl || '/default-vehicle.jpg'"
                  style="width: 100%; max-height: 200px; object-fit: contain"
                />
              </a-col>
              <a-col :span="16">
                <h3>{{ vehicleInfo.brand }} {{ vehicleInfo.name }}</h3>
                <a-descriptions :column="1" size="small">
                  <a-descriptions-item label="品牌">{{ vehicleInfo.brand }}</a-descriptions-item>
                  <a-descriptions-item label="续航里程">{{ vehicleInfo.rangeKm }}km</a-descriptions-item>
                  <a-descriptions-item label="电池类型">{{ formatBatteryType(vehicleInfo.batteryType) }}</a-descriptions-item>
                  <a-descriptions-item label="指导价">¥{{ formatPrice(vehicleInfo.price) }}</a-descriptions-item>
                  <a-descriptions-item label="上市时间">{{ vehicleInfo.launchDate }}</a-descriptions-item>
                </a-descriptions>
                <a-button
                  type="link"
                  style="padding: 0; margin-top: 10px"
                  @click="viewVehicleDetail"
                >
                  查看车辆详情
                </a-button>
              </a-col>
            </a-row>
          </a-card>
        </a-col>

        <!-- 右侧：操作区域 -->
        <a-col :span="8">
          <a-card title="操作" :bordered="false">
            <a-space direction="vertical" style="width: 100%">
              <a-button
                v-if="order.status === 0"
                type="primary"
                block
                size="large"
                @click="handlePay"
              >
                立即支付
              </a-button>
              <a-button
                v-if="order.status === 0"
                block
                size="large"
                danger
                @click="handleCancel"
              >
                取消订单
              </a-button>
              <a-button
                v-if="order.status === 3 && !evaluation"
                type="primary"
                block
                size="large"
                @click="handleEvaluate"
              >
                评价订单
              </a-button>
              <a-button
                v-if="order.status === 3 && evaluation"
                type="default"
                block
                size="large"
                @click="handleViewEvaluation"
              >
                查看评价
              </a-button>
              <a-button
                block
                size="large"
                @click="() => router.push({ path: '/customer/order/my-list' })"
              >
                返回订单列表
              </a-button>
            </a-space>
          </a-card>
        </a-col>
      </a-row>
    </div>
  </a-card>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { message, Modal } from 'ant-design-vue'
import { useRouter, useRoute } from 'vue-router'
import request from '@/utils/request'
import dayjs from 'dayjs'

const router = useRouter()
const route = useRoute()
const loading = ref(false)
const order = ref(null)
const vehicleInfo = ref(null)
const evaluation = ref(null)

// 格式化状态
const formatStatus = (status) => {
  const statusMap = {
    0: '待支付',
    1: '已支付',
    2: '待提车',
    3: '已完成',
    4: '已取消'
  }
  return statusMap[status] || '未知'
}

// 获取状态颜色
const getStatusColor = (status) => {
  const colorMap = {
    0: 'orange',
    1: 'blue',
    2: 'cyan',
    3: 'green',
    4: 'red'
  }
  return colorMap[status] || 'default'
}

// 获取状态步骤
const getStatusStep = (status) => {
  if (status === 0) return 0
  if (status === 1) return 1
  if (status === 2) return 2
  if (status === 3) return 3
  return 0
}

// 获取状态步骤状态
const getStatusStepStatus = (status) => {
  if (status === 4) return 'error'
  if (status === 3) return 'finish'
  return 'process'
}

// 格式化价格
const formatPrice = (price) => {
  if (!price) return '0.00'
  return Number(price).toLocaleString('zh-CN', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2
  })
}

// 格式化电池类型
const formatBatteryType = (type) => {
  if (type === null || type === undefined) return '未选择'
  const typeMap = {
    0: '三元锂电池',
    1: '磷酸铁锂电池',
    2: '其他'
  }
  return typeMap[type] || '未知'
}

// 格式化日期时间
const formatDateTime = (dateTime) => {
  if (!dateTime) return '-'
  return dayjs(dateTime).format('YYYY-MM-DD HH:mm:ss')
}

// 获取订单详情
const getOrderInfo = async () => {
  const orderId = route.query.id
  if (!orderId) {
    message.error('订单ID不存在')
    router.push({ path: '/customer/order/my-list' })
    return
  }

  loading.value = true
  try {
    const res = await request({
      url: '/carsale/order/detail/' + orderId,
      method: 'get'
    })
    order.value = res.data
    if (order.value) {
      // 获取车辆信息
      await loadVehicleInfo(order.value.vehicleId)
      // 检查是否已评价
      await checkEvaluation(orderId)
    }
  } catch (error) {
    message.error('获取订单信息失败')
    router.push({ path: '/customer/order/my-list' })
  } finally {
    loading.value = false
  }
}

// 检查评价状态
const checkEvaluation = async (orderId) => {
  try {
    const res = await request({
      url: '/carsale/evaluation/my/list',
      method: 'get',
      params: { pageNum: 1, pageSize: 1000 }
    })
    const evaluations = res.rows || res.data || []
    const found = evaluations.find(e => e.orderId === parseInt(orderId))
    if (found) {
      evaluation.value = found
    }
  } catch (error) {
    console.error('检查评价状态失败', error)
  }
}

// 加载车辆信息
const loadVehicleInfo = async (vehicleId) => {
  try {
    const res = await request({
      url: '/carsale/vehicle/' + vehicleId,
      method: 'get'
    })
    vehicleInfo.value = res.data?.vehicle
  } catch (error) {
    console.error('获取车辆信息失败', error)
  }
}

// 支付
const handlePay = () => {
  router.push({ path: '/customer/order/pay', query: { id: order.value.id } })
}

// 取消订单
const handleCancel = () => {
  Modal.confirm({
    title: '提示',
    content: '确定要取消该订单吗？',
    okText: '确定',
    cancelText: '取消',
    onOk: async () => {
      try {
        await request({
          url: '/carsale/order/cancel/' + order.value.id,
          method: 'put'
        })
        message.success('取消成功')
        getOrderInfo()
      } catch (error) {
        message.error('取消失败')
      }
    }
  })
}

// 评价
const handleEvaluate = () => {
  router.push({
    path: '/customer/evaluation/create',
    query: { orderId: order.value.id, vehicleId: order.value.vehicleId }
  })
}

// 查看评价
const handleViewEvaluation = () => {
  router.push({
    path: '/customer/evaluation/my-list'
  })
}

// 查看车辆详情
const viewVehicleDetail = () => {
  router.push({
    path: '/customer/vehicle/detail',
    query: { id: order.value.vehicleId }
  })
}

onMounted(() => {
  getOrderInfo()
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
