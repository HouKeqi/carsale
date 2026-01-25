<template>
  <a-card class="main-page">
    <a-form
      ref="formRef"
      :model="form"
      :rules="rules"
      :label-col="{ span: 6 }"
      :wrapper-col="{ span: 18 }"
    >
      <a-form-item label="选择车型" name="vehicleId">
        <a-select
          v-model:value="form.vehicleId"
          placeholder="请选择车型"
          style="width: 100%"
          @change="handleVehicleChange"
        >
          <a-select-option
            v-for="vehicle in vehicleList"
            :key="vehicle.id"
            :value="vehicle.id"
          >
            {{ vehicle.brand }} {{ vehicle.name }} - ¥{{ formatPrice(vehicle.price) }}
          </a-select-option>
        </a-select>
      </a-form-item>
      <!-- 促销活动显示 -->
      <a-form-item v-if="promotions && promotions.length > 0" label="促销活动">
        <div>
          <a-tag v-for="promo in promotions" :key="promo.id" color="red" style="margin-right: 10px; margin-bottom: 10px">
            {{ promo.title }} - {{ formatDiscountType(promo.discountType) }}：¥{{ formatPrice(promo.discountValue) }}
          </a-tag>
        </div>
      </a-form-item>
      <a-form-item label="购车数量" name="number">
        <a-input-number v-model:value="form.number" :min="1" :max="10" style="width: 100%" />
      </a-form-item>
      <a-form-item label="提车门店" name="storeLocation">
        <a-select
          v-model:value="form.storeLocation"
          placeholder="请选择提车门店"
          style="width: 100%"
        >
          <a-select-option
            v-for="store in storeList"
            :key="store.id"
            :value="store.name"
          >
            {{ store.name }} - {{ store.address }}
          </a-select-option>
        </a-select>
      </a-form-item>
      <a-form-item label="联系方式" name="phone">
        <a-input v-model:value="form.phone" placeholder="请输入联系方式" />
      </a-form-item>
      <a-form-item label="成交金额" name="amount">
        <a-input-number
          v-model:value="form.amount"
          :min="0"
          :precision="2"
          style="width: 100%"
        />
        <span style="margin-left: 10px; color: #999">（根据车型和数量自动计算，可手动调整）</span>
      </a-form-item>
      <a-form-item>
        <a-button type="primary" @click="submitForm">提交订单</a-button>
        <a-button @click="handleCancel" style="margin-left: 10px">取消</a-button>
      </a-form-item>
    </a-form>
  </a-card>
</template>

<script setup>
import { ref, reactive, onMounted, watch } from 'vue'
import { message } from 'ant-design-vue'
import { useRouter, useRoute } from 'vue-router'
import request from '@/utils/request'

const router = useRouter()
const route = useRoute()
const formRef = ref(null)
const vehicleList = ref([])
const storeList = ref([])
const selectedVehicle = ref(null)
const promotions = ref([])

const form = reactive({
  vehicleId: null,
  number: 1,
  storeLocation: null,
  phone: null,
  amount: null
})

const rules = {
  vehicleId: [{ required: true, message: '请选择车型', trigger: 'change' }],
  number: [{ required: true, message: '请输入购车数量', trigger: 'blur' }],
  storeLocation: [{ required: true, message: '请选择提车门店', trigger: 'change' }],
  phone: [{ required: true, message: '请输入联系方式', trigger: 'blur' }],
  amount: [{ required: true, message: '请输入成交金额', trigger: 'blur' }]
}

// 格式化价格
const formatPrice = (price) => {
  if (!price) return '0.00'
  return Number(price).toLocaleString('zh-CN', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2
  })
}

// 获取车辆列表
const getVehicleList = async () => {
  try {
    const res = await request({
      url: '/carsale/vehicle/search',
      method: 'get',
      params: { pageNum: 1, pageSize: 100 }
    })
    vehicleList.value = res.rows || res.data || []
    const vehicleId = route.query.vehicleId
    if (vehicleId) {
      form.vehicleId = parseInt(vehicleId)
      handleVehicleChange(parseInt(vehicleId))
    }
  } catch (error) {
    message.error('获取车辆列表失败')
  }
}

// 获取门店列表
const getStoreList = async () => {
  try {
    const res = await request({
      url: '/carsale/store/list',
      method: 'get'
    })
    storeList.value = res.data || []
  } catch (error) {
    message.error('获取门店列表失败')
  }
}

// 格式化优惠类型
const formatDiscountType = (type) => {
  const typeMap = {
    0: '直降',
    1: '赠品',
    2: '置换补贴'
  }
  return typeMap[type] || '未知'
}

// 获取促销活动
const getPromotions = async (vehicleId) => {
  if (!vehicleId) {
    promotions.value = []
    return
  }
  try {
    const res = await request({
      url: '/carsale/vehicle/' + vehicleId,
      method: 'get'
    })
    promotions.value = res.data?.promotions || []
    // 计算优惠后的价格
    calculateFinalAmount()
  } catch (error) {
    console.error('获取促销活动失败', error)
    promotions.value = []
  }
}

// 计算最终金额（考虑促销优惠）
const calculateFinalAmount = () => {
  if (!selectedVehicle.value) return
  
  let baseAmount = selectedVehicle.value.price * form.number
  let discountAmount = 0
  
  // 计算总优惠金额（只计算直降类型）
  promotions.value.forEach(promo => {
    if (promo.discountType === 0 && promo.status === 1) {
      // 检查活动是否在有效期内
      const now = new Date()
      const startTime = promo.startTime ? new Date(promo.startTime) : null
      const endTime = promo.endTime ? new Date(promo.endTime) : null
      if ((!startTime || now >= startTime) && (!endTime || now <= endTime)) {
        discountAmount += (promo.discountValue || 0)
      }
    }
  })
  
  form.amount = Math.max(0, baseAmount - discountAmount)
}

// 车型变化
const handleVehicleChange = async (vehicleId) => {
  selectedVehicle.value = vehicleList.value.find(v => v.id === vehicleId)
  if (selectedVehicle.value) {
    // 获取促销活动
    await getPromotions(vehicleId)
  } else {
    promotions.value = []
    form.amount = null
  }
}

// 监听数量变化
watch(() => form.number, (newVal) => {
  if (selectedVehicle.value) {
    calculateFinalAmount()
  }
})

// 提交表单
const submitForm = () => {
  formRef.value.validate().then(async () => {
    try {
      const res = await request({
        url: '/carsale/order/create',
        method: 'post',
        data: form
      })
      message.success('订单创建成功')
      // 跳转到支付页面，传递订单ID
      // 后端返回的订单对象在res.data中
      const orderId = res.data?.id
      if (orderId) {
        router.push({ path: '/customer/order/pay', query: { id: orderId } })
      } else {
        // 如果无法获取订单ID，跳转到订单列表
        message.warning('无法获取订单ID，请稍后在订单列表中查看')
        router.push({ path: '/customer/order/my-list' })
      }
    } catch (error) {
      message.error('订单创建失败')
    }
  }).catch(() => {
    // 验证失败
  })
}

// 取消
const handleCancel = () => {
  router.back()
}

onMounted(() => {
  getVehicleList()
  getStoreList()
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
