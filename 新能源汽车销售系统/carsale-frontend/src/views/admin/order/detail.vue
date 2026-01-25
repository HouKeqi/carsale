<template>
  <a-card class="main-page" v-loading="loading">
    <div v-if="order">
      <a-page-header
        title="订单详情"
        @back="() => router.push({ path: '/admin/order' })"
      />

      <a-divider />

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

          <!-- 用户信息 -->
          <a-card title="用户信息" :bordered="false" style="margin-bottom: 20px" v-if="userInfo">
            <a-descriptions :column="2" bordered>
              <a-descriptions-item label="用户ID">{{ userInfo.userId }}</a-descriptions-item>
              <a-descriptions-item label="用户名">{{ userInfo.userName }}</a-descriptions-item>
              <a-descriptions-item label="昵称">{{ userInfo.nickName }}</a-descriptions-item>
              <a-descriptions-item label="手机号">{{ userInfo.phonenumber }}</a-descriptions-item>
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
                  <a-descriptions-item label="库存数量">{{ vehicleInfo.stock }}</a-descriptions-item>
                  <a-descriptions-item label="上市时间">{{ vehicleInfo.launchDate }}</a-descriptions-item>
                </a-descriptions>
              </a-col>
            </a-row>
          </a-card>
        </a-col>

        <!-- 右侧：操作区域 -->
        <a-col :span="8">
          <a-card title="操作" :bordered="false">
            <a-space direction="vertical" style="width: 100%">
              <a-button
                v-if="order.status === 1"
                type="primary"
                block
                size="large"
                @click="handleConfirmOrder"
              >
                确认订单/准备就绪
              </a-button>
              <a-button
                v-if="order.status === 2"
                type="primary"
                block
                size="large"
                @click="handleMarkPickup"
              >
                标记提车
              </a-button>
              <a-button
                block
                size="large"
                @click="() => router.push({ path: '/admin/order' })"
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
const userInfo = ref(null)
const vehicleInfo = ref(null)

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
    router.push({ path: '/admin/order' })
    return
  }

  loading.value = true
  try {
    const res = await request({
      url: '/carsale/admin/order/detail/' + orderId,
      method: 'get'
    })
    order.value = res.data
    if (order.value) {
      // 获取用户信息
      await loadUserInfo(order.value.userId)
      // 获取车辆信息
      await loadVehicleInfo(order.value.vehicleId)
    }
  } catch (error) {
    message.error('获取订单信息失败')
    router.push({ path: '/admin/order' })
  } finally {
    loading.value = false
  }
}

// 加载用户信息
const loadUserInfo = async (userId) => {
  try {
    const res = await request({
      url: '/carsale/admin/user/list',
      method: 'get',
      params: { pageNum: 1, pageSize: 1000 }
    })
    const users = res.rows || res.data || []
    userInfo.value = users.find(u => u.userId === userId)
  } catch (error) {
    console.error('获取用户信息失败', error)
  }
}

// 加载车辆信息
const loadVehicleInfo = async (vehicleId) => {
  try {
    const res = await request({
      url: '/carsale/admin/vehicle/detail/' + vehicleId,
      method: 'get'
    })
    vehicleInfo.value = res.data
  } catch (error) {
    console.error('获取车辆信息失败', error)
  }
}

// 确认订单/准备就绪
const handleConfirmOrder = () => {
  Modal.confirm({
    title: '提示',
    content: '确认该订单已准备就绪，可以通知用户提车？',
    okText: '确定',
    cancelText: '取消',
    onOk: async () => {
      try {
        await request({
          url: '/carsale/admin/order/status/update',
          method: 'put',
          data: {
            id: order.value.id,
            status: 2
          }
        })
        message.success('操作成功')
        getOrderInfo()
      } catch (error) {
        message.error(error.response?.data?.msg || '操作失败')
      }
    }
  })
}

// 标记提车
const handleMarkPickup = () => {
  Modal.confirm({
    title: '提示',
    content: '确认该订单已完成提车？',
    okText: '确定',
    cancelText: '取消',
    onOk: async () => {
      try {
        await request({
          url: '/carsale/admin/order/status/update',
          method: 'put',
          data: {
            id: order.value.id,
            status: 3,
            pickupTime: dayjs().format('YYYY-MM-DD HH:mm:ss')
          }
        })
        message.success('操作成功')
        getOrderInfo()
      } catch (error) {
        message.error(error.response?.data?.msg || '操作失败')
      }
    }
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
