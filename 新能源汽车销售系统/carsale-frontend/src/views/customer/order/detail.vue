<template>
  <div class="detail-container">
    <a-card :loading="loading" :bordered="false" class="main-content-card">
      <a-page-header
          title="订单详情"
          style="padding: 0 0 24px 0"
          @back="() => router.push({ path: '/customer/order/my-list' })"
      >
        <template #extra>
          <a-space>
            <a-button v-if="order?.status === 0" danger @click="handleCancel">取消订单</a-button>
            <a-button v-if="order?.status === 0" type="primary" size="large" @click="handlePay">立即支付</a-button>
            <a-button v-if="order?.status === 3 && !evaluation" type="primary" @click="handleEvaluate">评价订单</a-button>
            <a-button v-if="order?.status === 3 && evaluation" @click="handleViewEvaluation">查看评价</a-button>
          </a-space>
        </template>

        <div v-if="order" class="header-info-display">
          <a-statistic title="订单状态" :value="formatStatus(order.status)" class="header-stat">
            <template #suffix>
              <a-badge :status="order.status === 4 ? 'error' : 'processing'" />
            </template>
          </a-statistic>
          <a-statistic title="应付总额" :precision="2" prefix="¥" :value="order.amount" class="header-stat price-highlight" />
          <a-statistic title="订单编号" :value="order.id" class="header-stat-id" />
        </div>
      </a-page-header>

      <a-divider style="margin: 0" />

      <div class="steps-section" v-if="order && order.status !== 4">
        <a-steps :current="getStatusStep(order.status)" :status="getStatusStepStatus(order.status)">
          <a-step title="待支付" />
          <a-step title="已支付" />
          <a-step title="待提车" />
          <a-step title="已完成" />
        </a-steps>
      </div>

      <a-row :gutter="24" class="content-row">
        <a-col :xs="24" :lg="16">
          <a-card title="基本明细" :bordered="false" class="inner-info-card">
            <a-descriptions :column="2" bordered size="small">
              <a-descriptions-item label="下单时间">{{ formatDateTime(order?.create_Time) }}</a-descriptions-item>
              <a-descriptions-item label="提车门店">{{ order?.storeLocation }}</a-descriptions-item>
              <a-descriptions-item label="联系电话">{{ order?.phone }}</a-descriptions-item>
              <a-descriptions-item label="购车数量">{{ order?.number }} 辆</a-descriptions-item>
              <a-descriptions-item label="支付时间" v-if="order?.payTime">{{ formatDateTime(order.payTime) }}</a-descriptions-item>
              <a-descriptions-item label="提车时间" v-if="order?.pickupTime">{{ formatDateTime(order.pickupTime) }}</a-descriptions-item>
            </a-descriptions>
          </a-card>

          <a-card title="价格明细" :bordered="false" class="inner-info-card">
            <a-descriptions :column="2" bordered size="small">
              <a-descriptions-item label="原价" :span="2">
                <span style="font-size: 16px; color: #666">
                  ¥{{ formatPrice(order?.originalPrice || order?.amount) }}
                </span>
              </a-descriptions-item>
              <a-descriptions-item label="优惠金额" :span="2" v-if="order?.discountAmount && order?.discountAmount > 0">
                <span style="font-size: 16px; color: #ff4d4f">
                  -¥{{ formatPrice(order?.discountAmount) }}
                </span>
              </a-descriptions-item>
              <a-descriptions-item label="折扣后价格" :span="2">
                <span style="font-size: 18px; color: #333; font-weight: bold">
                  ¥{{ formatPrice(order?.amount) }}
                </span>
              </a-descriptions-item>
              <a-descriptions-item label="金融方案" :span="2" v-if="order?.financePlanId && financePlanInfo">
                <a-tag color="blue">
                  {{ financePlanInfo.name }} - 首付{{ financePlanInfo.downPaymentRate }}% / {{ financePlanInfo.periods }}期 / 利率{{ financePlanInfo.interestRate }}%
                </a-tag>
              </a-descriptions-item>
              <a-descriptions-item label="实付价格" :span="2">
                <span style="font-size: 20px; color: #ff4d4f; font-weight: bold">
                  ¥{{ formatPrice(order?.financePlanId && order?.downPayment ? order?.downPayment : order?.amount) }}
                </span>
                <span v-if="order?.financePlanId && order?.downPayment" style="margin-left: 10px; font-size: 12px; color: #999">
                  （首付金额）
                </span>
                <span v-else style="margin-left: 10px; font-size: 12px; color: #999">
                  （全款）
                </span>
              </a-descriptions-item>
            </a-descriptions>
          </a-card>

          <a-card title="车辆信息" :bordered="false" class="inner-info-card vehicle-detail-card" v-if="vehicleInfo">
            <div class="vehicle-flex-box">
              <div class="image-wrapper">
                <img :src="vehicleInfo.imageUrl || '/default-vehicle.jpg'" alt="vehicle" />
              </div>
              <div class="specs-wrapper">
                <h3>{{ vehicleInfo.brand }} {{ vehicleInfo.name }}</h3>
                <div class="tag-row">
                  <a-tag color="blue">{{ formatBatteryType(vehicleInfo.batteryType) }}</a-tag>
                  <a-tag color="green">{{ vehicleInfo.rangeKm }}km 续航</a-tag>
                </div>
                <a-descriptions :column="1" size="small" style="margin-top: 12px">
                  <a-descriptions-item label="官方指导价">¥{{ formatPrice(vehicleInfo.price) }}</a-descriptions-item>
                  <a-descriptions-item label="上市日期">{{ vehicleInfo.launchDate }}</a-descriptions-item>
                </a-descriptions>
                <a-button type="link" @click="viewVehicleDetail" class="detail-link-btn">
                  查看产品详细技术参数
                </a-button>
              </div>
            </div>
          </a-card>
        </a-col>

        <a-col :xs="24" :lg="8">
          <a-card title="服务指南" :bordered="false" class="inner-info-card side-card">
            <a-alert
                v-if="order?.status === 2"
                message="待提车提醒"
                description="请务必携带下单手机号对应的设备及有效身份证件。"
                type="info"
                show-icon
                style="margin-bottom: 20px"
            />

            <div class="help-section">
              <p class="help-title">温馨提示：</p>
              <ul class="help-list">
                <li>支付完成后，我们将为您锁定库存。</li>
                <li>提车时请在门店专业人员陪同下验车。</li>
                <li>如有疑问，请致电门店或联系在线客服。</li>
              </ul>
            </div>

            <a-divider />
            <a-button block @click="() => router.push({ path: '/customer/order/my-list' })">
              返回订单列表
            </a-button>
          </a-card>
        </a-col>
      </a-row>
    </a-card>
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
const vehicleInfo = ref(null)
const evaluation = ref(null)
const financePlanInfo = ref(null)

// 状态处理
const formatStatus = (status) => {
  const statusMap = { 0: '待支付', 1: '已支付', 2: '待提车', 3: '已完成', 4: '已取消' }
  return statusMap[status] || '未知'
}

const getStatusStep = (status) => {
  if (status === 4) return 0
  return status
}

const getStatusStepStatus = (status) => {
  if (status === 4) return 'error'
  return 'process'
}

const formatPrice = (p) => p ? Number(p).toLocaleString('zh-CN', { minimumFractionDigits: 2 }) : '0.00'

const formatBatteryType = (type) => {
  const typeMap = { 0: '三元锂电池', 1: '磷酸铁锂电池', 2: '其他' }
  return typeMap[type] ?? '未说明'
}

const formatDateTime = (val) => val ? dayjs(val).format('YYYY-MM-DD HH:mm:ss') : '-'

// 数据获取
const getOrderInfo = async () => {
  const orderId = route.query.id
  if (!orderId) {
    message.error('订单ID不存在')
    router.push({ path: '/customer/order/my-list' })
    return
  }

  loading.value = true
  try {
    const res = await request({ url: `/carsale/order/detail/${orderId}`, method: 'get' })
    order.value = res.data
    if (order.value) {
      const promises = [
        loadVehicleInfo(order.value.vehicleId),
        checkEvaluation(orderId)
      ]
      if (order.value.financePlanId) {
        promises.push(loadFinancePlanInfo(order.value.financePlanId))
      }
      await Promise.all(promises)
    }
  } catch (error) {
    message.error('获取订单详情失败')
  } finally {
    loading.value = false
  }
}

const loadVehicleInfo = async (id) => {
  try {
    const res = await request({ url: `/carsale/vehicle/${id}`, method: 'get' })
    vehicleInfo.value = res.data?.vehicle
  } catch (e) { console.error(e) }
}

const checkEvaluation = async (orderId) => {
  try {
    const res = await request({ url: '/carsale/evaluation/my/list', method: 'get' })
    const list = res.rows || res.data || []
    evaluation.value = list.find(e => e.orderId === parseInt(orderId))
  } catch (e) { console.error(e) }
}

const loadFinancePlanInfo = async (planId) => {
  try {
    const res = await request({ url: '/carsale/finance/list', method: 'get' })
    const plans = res.data || []
    financePlanInfo.value = plans.find(p => p.id === planId)
  } catch (e) { console.error(e) }
}

// 交互逻辑
const handlePay = () => router.push({ path: '/customer/order/pay', query: { id: order.value.id } })

const handleCancel = () => {
  Modal.confirm({
    title: '确定取消订单吗？',
    content: '取消后将无法恢复，优惠券可能无法退回。',
    onOk: async () => {
      await request({ url: `/carsale/order/cancel/${order.value.id}`, method: 'put' })
      message.success('已取消')
      getOrderInfo()
    }
  })
}

const handleEvaluate = () => router.push({
  path: '/customer/evaluation/create',
  query: { orderId: order.value.id, vehicleId: order.value.vehicleId }
})

const handleViewEvaluation = () => router.push({ path: '/customer/evaluation/my-list' })
const viewVehicleDetail = () => router.push({ path: '/customer/vehicle/detail', query: { id: order.value.vehicleId } })

onMounted(getOrderInfo)
</script>

<style scoped>
.detail-container {
  padding: 24px;
  background-color: #f0f2f5;
  min-height: 100vh;
}

.main-content-card {
  max-width: 1200px;
  margin: 0 auto;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

.header-info-display {
  display: flex;
  margin-top: 16px;
  gap: 60px;
}

.price-highlight :deep(.ant-statistic-content) {
  color: #ff4d4f;
  font-weight: bold;
}

.header-stat-id :deep(.ant-statistic-content) {
  font-size: 16px;
  color: #666;
}

.steps-section {
  padding: 40px 10%;
  background: #fff;
}

.content-row {
  margin-top: 24px;
}

.inner-info-card {
  margin-bottom: 24px;
  border-radius: 4px;
}

.vehicle-detail-card {
  background: #fafafa;
}

.vehicle-flex-box {
  display: flex;
  gap: 24px;
  align-items: center;
}

.image-wrapper {
  flex: 0 0 240px;
  height: 160px;
  background: #fff;
  padding: 10px;
  border-radius: 4px;
  display: flex;
  align-items: center;
}

.image-wrapper img {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.specs-wrapper h3 {
  font-size: 20px;
  margin-bottom: 8px;
}

.tag-row {
  margin-bottom: 12px;
}

.detail-link-btn {
  padding: 0;
  margin-top: 8px;
}

.side-card {
  background: #fff;
  border: 1px solid #e8e8e8;
}

.help-title {
  font-weight: bold;
  margin-bottom: 10px;
  color: #333;
}

.help-list {
  padding-left: 20px;
  color: #8c8c8c;
  line-height: 2;
}

/* 移动端适配建议 */
@media (max-width: 768px) {
  .header-info-display {
    flex-direction: column;
    gap: 16px;
  }
  .vehicle-flex-box {
    flex-direction: column;
  }
  .image-wrapper {
    flex: none;
    width: 100%;
  }
}
</style>
