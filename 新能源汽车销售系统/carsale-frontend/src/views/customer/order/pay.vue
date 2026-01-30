<template>
  <a-card class="main-page" v-loading="loading">
    <div v-if="order">
      <a-result
        status="info"
        title="订单支付"
        sub-title="请选择支付方式完成支付"
      >
        <template #extra>
          <a-card :bordered="false" style="margin-top: 20px; width: 100%">
            <a-descriptions :column="2" bordered>
              <a-descriptions-item label="订单编号" :span="2">
                {{ order.id }}
              </a-descriptions-item>
              <a-descriptions-item label="车型">
                {{ vehicleInfo ? `${vehicleInfo.brand} ${vehicleInfo.name}` : `车型ID: ${order.vehicleId}` }}
              </a-descriptions-item>
              <a-descriptions-item label="购车数量">
                {{ order.number }} 辆
              </a-descriptions-item>
              
              <!-- 价格明细 -->
              <a-descriptions-item label="原价" :span="2">
                <span style="font-size: 16px; color: #666">
                  ¥{{ formatPrice(order.originalPrice || order.amount) }}
                </span>
              </a-descriptions-item>
              <a-descriptions-item label="优惠金额" :span="2" v-if="order.discountAmount && order.discountAmount > 0">
                <span style="font-size: 16px; color: #ff4d4f">
                  -¥{{ formatPrice(order.discountAmount) }}
                </span>
              </a-descriptions-item>
              <a-descriptions-item label="折扣后价格" :span="2">
                <span style="font-size: 18px; color: #333; font-weight: bold">
                  ¥{{ formatPrice(order.amount) }}
                </span>
              </a-descriptions-item>
              
              <!-- 金融方案信息 -->
              <a-descriptions-item label="金融方案" :span="2" v-if="order.financePlanId && financePlanInfo">
                <a-tag color="blue">
                  {{ financePlanInfo.name }} - 首付{{ financePlanInfo.downPaymentRate }}% / {{ financePlanInfo.periods }}期 / 利率{{ financePlanInfo.interestRate }}%
                </a-tag>
              </a-descriptions-item>
              
              <!-- 实付价格 -->
              <a-descriptions-item label="实付价格" :span="2">
                <span style="font-size: 24px; color: #ff4d4f; font-weight: bold">
                  ¥{{ formatPrice(order.financePlanId && order.downPayment ? order.downPayment : order.amount) }}
                </span>
                <span v-if="order.financePlanId && order.downPayment" style="margin-left: 10px; font-size: 12px; color: #999">
                  （首付金额，剩余金额分期支付）
                </span>
                <span v-else style="margin-left: 10px; font-size: 12px; color: #999">
                  （全款支付）
                </span>
              </a-descriptions-item>
              
              <a-descriptions-item label="提车门店">
                {{ order.storeLocation }}
              </a-descriptions-item>
              <a-descriptions-item label="联系方式">
                {{ order.phone }}
              </a-descriptions-item>
              <a-descriptions-item label="下单时间" :span="2">
                {{ formatDateTime(order.create_Time) }}
              </a-descriptions-item>
            </a-descriptions>
          </a-card>

          <a-divider />

          <div style="margin: 20px 0">
            <h3>选择支付方式</h3>
            <a-radio-group v-model:value="paymentMethod" style="width: 100%">
              <a-radio :value="1" style="display: block; padding: 15px; margin-bottom: 10px; border: 1px solid #d9d9d9; border-radius: 4px">
                <a-space>
                  <span style="font-size: 24px">💰</span>
                  <span style="font-size: 16px; font-weight: bold">支付宝</span>
                </a-space>
              </a-radio>
              <a-radio :value="2" style="display: block; padding: 15px; margin-bottom: 10px; border: 1px solid #d9d9d9; border-radius: 4px">
                <a-space>
                  <span style="font-size: 24px">💳</span>
                  <span style="font-size: 16px; font-weight: bold">微信支付</span>
                </a-space>
              </a-radio>
              <a-radio :value="3" style="display: block; padding: 15px; margin-bottom: 10px; border: 1px solid #d9d9d9; border-radius: 4px">
                <a-space>
                  <span style="font-size: 24px">🏦</span>
                  <span style="font-size: 16px; font-weight: bold">银行卡</span>
                </a-space>
              </a-radio>
            </a-radio-group>
          </div>

          <a-alert
            message="支付提示"
            description="请在30分钟内完成支付，超时订单将自动取消"
            type="warning"
            show-icon
            style="margin: 20px 0"
          />

          <a-space style="width: 100%; justify-content: center; margin-top: 30px">
            <a-button type="primary" size="large" :loading="paying" @click="handlePay">
              确认支付
            </a-button>
            <a-button size="large" @click="handleCancel">
              取消
            </a-button>
          </a-space>
        </template>
      </a-result>
    </div>
  </a-card>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { message } from 'ant-design-vue'
import { useRouter, useRoute } from 'vue-router'
import request from '@/utils/request'
import dayjs from 'dayjs'

const router = useRouter()
const route = useRoute()
const loading = ref(false)
const paying = ref(false)
const order = ref(null)
const vehicleInfo = ref(null)
const financePlanInfo = ref(null)
const paymentMethod = ref(1)

// 格式化价格
const formatPrice = (price) => {
  if (!price) return '0.00'
  return Number(price).toLocaleString('zh-CN', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2
  })
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
      // 如果订单不是待支付状态，跳转到订单详情
      if (order.value.status !== 0) {
        message.info('该订单已支付或已取消')
        router.push({ path: '/customer/order/detail', query: { id: orderId } })
        return
      }
      // 获取车辆信息
      await loadVehicleInfo(order.value.vehicleId)
      // 获取金融方案信息
      if (order.value.financePlanId) {
        await loadFinancePlanInfo(order.value.financePlanId)
      }
    }
  } catch (error) {
    message.error('获取订单信息失败')
    router.push({ path: '/customer/order/my-list' })
  } finally {
    loading.value = false
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

// 加载金融方案信息
const loadFinancePlanInfo = async (planId) => {
  try {
    const res = await request({
      url: '/carsale/finance/list',
      method: 'get'
    })
    const plans = res.data || []
    financePlanInfo.value = plans.find(p => p.id === planId)
  } catch (error) {
    console.error('获取金融方案信息失败', error)
  }
}

// 支付
const handlePay = async () => {
  if (!paymentMethod.value) {
    message.warning('请选择支付方式')
    return
  }

  paying.value = true
  try {
    await request({
      url: '/carsale/order/pay/' + order.value.id,
      method: 'put'
    })
    message.success('支付成功')
    // 跳转到订单详情页面
    router.push({ path: '/customer/order/detail', query: { id: order.value.id } })
  } catch (error) {
    message.error('支付失败，请重试')
  } finally {
    paying.value = false
  }
}

// 取消
const handleCancel = () => {
  router.push({ path: '/customer/order/my-list' })
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
