<template>
  <div class="detail-container">
    <a-page-header
        class="header-card"
        title="订单详情"
        @back="() => router.push({ path: '/admin/order' })"
    >
      <template #extra>
        <div class="header-status">
          <span class="status-label">订单状态：</span>
          <a-tag :color="getStatusColor(order?.status)" class="status-tag">
            {{ formatStatus(order?.status) }}
          </a-tag>
        </div>
      </template>
      <a-row class="header-info">
        <a-col :span="6">
          <div class="info-item">
            <span class="label">订单编号</span>
            <span class="value">{{ order?.id }}</span>
          </div>
        </a-col>
        <a-col :span="6">
          <div class="info-item">
            <span class="label">下单时间</span>
            <span class="value">{{ formatDateTime(order?.create_Time) }}</span>
          </div>
        </a-col>
        <a-col :span="6">
          <div class="info-item">
            <span class="label">实付金额</span>
            <span class="value price">¥{{ formatPrice(order?.financePlanId && order?.downPayment ? order?.downPayment : order?.amount) }}</span>
          </div>
        </a-col>
      </a-row>
    </a-page-header>

    <a-row :gutter="16" class="content-body">
      <a-col :xs="24" :lg="17">
        <a-card class="main-content-card">
          <a-tabs v-model:activeKey="activeTab">
            <a-tab-pane key="1" tab="订单概览">
              <a-descriptions title="配送与联系" :column="2">
                <a-descriptions-item label="提车门店">{{ order?.storeLocation }}</a-descriptions-item>
                <a-descriptions-item label="联系电话">{{ order?.phone }}</a-descriptions-item>
                <a-descriptions-item label="购车数量">{{ order?.number }} 辆</a-descriptions-item>
                <a-descriptions-item label="支付时间">{{ formatDateTime(order?.payTime) }}</a-descriptions-item>
              </a-descriptions>

              <a-divider />

              <a-descriptions title="价格构成" :column="2">
                <a-descriptions-item label="商品原价">¥{{ formatPrice(order?.originalPrice || order?.amount) }}</a-descriptions-item>
                <a-descriptions-item label="优惠金额" v-if="order?.discountAmount">
                  <span class="text-danger">-¥{{ formatPrice(order?.discountAmount) }}</span>
                </a-descriptions-item>
                <a-descriptions-item label="金融方案" v-if="order?.financePlanId" :span="2">
                  <div class="finance-info-box">
                    <p class="name">{{ financePlanInfo?.name }}</p>
                    <p class="desc">首付{{ financePlanInfo?.downPaymentRate }}% | {{ financePlanInfo?.periods }}期 | 利率{{ financePlanInfo?.interestRate }}%</p>
                  </div>
                </a-descriptions-item>
              </a-descriptions>
            </a-tab-pane>

            <a-tab-pane key="2" tab="车辆信息">
              <div class="vehicle-detail" v-if="vehicleInfo">
                <a-row :gutter="24" align="middle">
                  <a-col :span="8">
                    <a-image :src="vehicleInfo.imageUrl || '/default-vehicle.jpg'" class="vehicle-img" />
                  </a-col>
                  <a-col :span="16">
                    <h2 class="vehicle-title">{{ vehicleInfo.brand }} {{ vehicleInfo.name }}</h2>
                    <a-descriptions :column="2" size="small">
                      <a-descriptions-item label="续航里程">{{ vehicleInfo.rangeKm }}km</a-descriptions-item>
                      <a-descriptions-item label="电池类型">{{ formatBatteryType(vehicleInfo.batteryType) }}</a-descriptions-item>
                      <a-descriptions-item label="指导价">¥{{ formatPrice(vehicleInfo.price) }}</a-descriptions-item>
                      <a-descriptions-item label="库存状态">{{ vehicleInfo.stock > 0 ? '现货' : '缺货' }}</a-descriptions-item>
                    </a-descriptions>
                  </a-col>
                </a-row>
              </div>
            </a-tab-pane>

            <a-tab-pane key="3" tab="购车人信息">
              <a-descriptions v-if="userInfo" :column="2">
                <a-descriptions-item label="用户姓名">{{ userInfo.nickName }}</a-descriptions-item>
                <a-descriptions-item label="登录账号">{{ userInfo.userName }}</a-descriptions-item>
                <a-descriptions-item label="联系电话">{{ userInfo.phonenumber }}</a-descriptions-item>
                <a-descriptions-item label="用户ID">{{ userInfo.userId }}</a-descriptions-item>
              </a-descriptions>
            </a-tab-pane>
          </a-tabs>
        </a-card>
      </a-col>

      <a-col :xs="24" :lg="7">
        <a-card title="工单处理" class="action-card">
          <div class="steps-wrapper">
            <a-steps direction="vertical" size="small" :current="order?.status">
              <a-step title="提交订单" />
              <a-step title="完成支付" />
              <a-step title="车辆准备" />
              <a-step title="完成提车" />
            </a-steps>
          </div>

          <a-divider />

          <a-space direction="vertical" style="width: 100%" size="middle">
            <a-button
                v-if="order?.status === 1"
                type="primary"
                block
                size="large"
                @click="handleConfirmOrder"
            >
              确认准备就绪
            </a-button>
            <a-button
                v-if="order?.status === 2"
                type="primary"
                block
                size="large"
                @click="handleMarkPickup"
            >
              完成提车核销
            </a-button>
            <a-button block size="large" ghost type="primary" @click="() => router.push({ path: '/admin/order' })">
              返回列表
            </a-button>
          </a-space>
        </a-card>
      </a-col>
    </a-row>
  </div>
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
const financePlanInfo = ref(null)
const activeTab = ref('1')

// 逻辑函数保持不变，仅格式化和 API 调用逻辑
const formatStatus = (status) => {
  const statusMap = { 0: '待支付', 1: '已支付', 2: '待提车', 3: '已完成', 4: '已取消' }
  return statusMap[status] || '未知'
}

const getStatusColor = (status) => {
  const colorMap = { 0: 'orange', 1: 'blue', 2: 'cyan', 3: 'green', 4: 'red' }
  return colorMap[status] || 'default'
}

const formatPrice = (price) => {
  if (!price) return '0.00'
  return Number(price).toLocaleString('zh-CN', { minimumFractionDigits: 2 })
}

const formatBatteryType = (type) => {
  const typeMap = { 0: '三元锂电池', 1: '磷酸铁锂电池', 2: '其他' }
  return typeMap[type] || '未知'
}

const formatDateTime = (dateTime) => dateTime ? dayjs(dateTime).format('YYYY-MM-DD HH:mm') : '-'

const getOrderInfo = async () => {
  const orderId = route.query.id
  if (!orderId) return router.push({ path: '/admin/order' })
  loading.value = true
  try {
    const res = await request({ url: '/carsale/admin/order/detail/' + orderId, method: 'get' })
    order.value = res.data
    if (order.value) {
      loadUserInfo(order.value.userId)
      loadVehicleInfo(order.value.vehicleId)
      if (order.value.financePlanId) loadFinancePlanInfo(order.value.financePlanId)
    }
  } finally {
    loading.value = false
  }
}

const loadUserInfo = async (userId) => {
  const res = await request({ url: '/carsale/admin/user/list', method: 'get', params: { pageNum: 1, pageSize: 1000 } })
  userInfo.value = (res.rows || res.data || []).find(u => u.userId === userId)
}

const loadVehicleInfo = async (vehicleId) => {
  const res = await request({ url: '/carsale/admin/vehicle/detail/' + vehicleId, method: 'get' })
  vehicleInfo.value = res.data
}

const loadFinancePlanInfo = async (planId) => {
  const res = await request({ url: '/carsale/finance/list', method: 'get' })
  financePlanInfo.value = (res.data || []).find(p => p.id === planId)
}

const handleConfirmOrder = () => {
  Modal.confirm({
    title: '确认车辆准备就绪',
    content: '确认后将通知用户前往门店提车，是否继续？',
    onOk: async () => {
      await request({ url: '/carsale/admin/order/status/update', method: 'put', data: { id: order.value.id, status: 2 }})
      message.success('已更新为待提车状态')
      getOrderInfo()
    }
  })
}

const handleMarkPickup = () => {
  Modal.confirm({
    title: '确认完成提车',
    content: '请确认用户已现场取车并完成手续。',
    onOk: async () => {
      await request({ url: '/carsale/admin/order/status/update', method: 'put', data: { id: order.value.id, status: 3, pickupTime: dayjs().format('YYYY-MM-DD HH:mm:ss') }})
      message.success('订单已完成')
      getOrderInfo()
    }
  })
}

onMounted(getOrderInfo)
</script>

<style scoped>
.detail-container {
  padding: 24px;
  background-color: #f0f2f5;
  min-height: 100vh;
}

.header-card {
  background: #fff;
  border-radius: 8px;
  margin-bottom: 16px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

.header-status {
  display: flex;
  align-items: center;
}

.status-label {
  color: #8c8c8c;
}

.status-tag {
  font-size: 14px;
  padding: 4px 12px;
}

.header-info {
  margin-top: 16px;
  padding-top: 16px;
  border-top: 1px solid #f0f0f0;
}

.info-item {
  display: flex;
  flex-direction: column;
}

.info-item .label {
  color: #8c8c8c;
  font-size: 12px;
  margin-bottom: 4px;
}

.info-item .value {
  color: #262626;
  font-weight: 500;
}

.info-item .price {
  color: #ff4d4f;
  font-size: 18px;
}

.main-content-card {
  border-radius: 8px;
  min-height: 500px;
}

.action-card {
  border-radius: 8px;
  position: sticky;
  top: 24px;
}

.finance-info-box {
  background: #f0f5ff;
  padding: 12px;
  border-radius: 4px;
  border: 1px solid #adc6ff;
}

.finance-info-box .name {
  margin: 0;
  font-weight: bold;
  color: #1d39c4;
}

.finance-info-box .desc {
  margin: 4px 0 0 0;
  font-size: 12px;
  color: #2f54eb;
}

.vehicle-detail {
  padding: 16px 0;
}

.vehicle-img {
  border-radius: 8px;
  border: 1px solid #f0f0f0;
}

.vehicle-title {
  margin-top: 0;
  margin-bottom: 16px;
  color: #262626;
}

.steps-wrapper {
  padding: 20px 0;
}

.text-danger {
  color: #ff4d4f;
  font-weight: bold;
}
</style>
