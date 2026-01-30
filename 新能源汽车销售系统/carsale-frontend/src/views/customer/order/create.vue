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
            {{ promo.title }} - {{ formatDiscountType(promo.discountType) }}：
            <span v-if="promo.discountType === 0">¥{{ formatPrice(promo.discountAmount || promo.discountValue) }}</span>
            <span v-else>{{ promo.description || '查看详情' }}</span>
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
      <a-form-item label="价格明细">
        <a-card :bordered="true" style="background: #f9f9f9">
          <a-row :gutter="16">
            <a-col :span="12">
              <div style="margin-bottom: 8px">
                <span style="color: #666; font-size: 12px">原价：</span>
                <span style="color: #333; font-size: 16px; font-weight: bold">
                  ¥{{ formatPrice(form.originalPrice || 0) }}
                </span>
              </div>
            </a-col>
            <a-col :span="12">
              <div style="margin-bottom: 8px">
                <span style="color: #666; font-size: 12px">优惠金额：</span>
                <span style="color: #ff4d4f; font-size: 16px; font-weight: bold">
                  -¥{{ formatPrice(form.discountAmount || 0) }}
                </span>
              </div>
            </a-col>
          </a-row>
        </a-card>
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
      
      <!-- 金融方案选择 -->
      <a-form-item label="金融方案" name="financePlanId">
        <a-select
          v-model:value="form.financePlanId"
          placeholder="请选择金融方案（可选）"
          style="width: 100%"
          allowClear
          @change="handleFinancePlanChange"
        >
          <a-select-option
            v-for="plan in financePlanList"
            :key="plan.id"
            :value="plan.id"
          >
            {{ plan.name }} - 利率{{ plan.interestRate }}%
          </a-select-option>
        </a-select>
        <div style="margin-top: 8px; color: #999; font-size: 12px">
          选择金融方案后，系统将自动计算月供金额
        </div>
      </a-form-item>
      
      <!-- 月供计算结果显示 -->
      <a-form-item v-if="financeResult" label="月供详情">
        <a-card :bordered="true" style="background: #f5f5f5">
          <a-row :gutter="16">
            <a-col :span="12">
              <div style="margin-bottom: 12px">
                <div style="color: #666; font-size: 12px; margin-bottom: 4px">首付金额</div>
                <div style="color: #333; font-size: 18px; font-weight: bold">
                  ¥{{ formatPrice(financeResult.downPayment) }}
                </div>
              </div>
            </a-col>
            <a-col :span="12">
              <div style="margin-bottom: 12px">
                <div style="color: #666; font-size: 12px; margin-bottom: 4px">贷款金额</div>
                <div style="color: #333; font-size: 18px; font-weight: bold">
                  ¥{{ formatPrice(financeResult.loanAmount) }}
                </div>
              </div>
            </a-col>
            <a-col :span="12">
              <div style="margin-bottom: 12px">
                <div style="color: #666; font-size: 12px; margin-bottom: 4px">月供</div>
                <div style="color: #ff4d4f; font-size: 24px; font-weight: bold">
                  ¥{{ formatPrice(financeResult.monthlyPayment) }}
                </div>
              </div>
            </a-col>
            <a-col :span="12">
              <div style="margin-bottom: 12px">
                <div style="color: #666; font-size: 12px; margin-bottom: 4px">总利息</div>
                <div style="color: #333; font-size: 18px; font-weight: bold">
                  ¥{{ formatPrice(financeResult.totalInterest) }}
                </div>
              </div>
            </a-col>
          </a-row>
        </a-card>
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
const financePlanList = ref([])
const financeResult = ref(null)

const form = reactive({
  vehicleId: null,
  number: 1,
  storeLocation: null,
  phone: null,
  amount: null,
  financePlanId: null,
  originalPrice: null,
  discountAmount: null,
  downPayment: null
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

// 获取金融方案列表
const getFinancePlanList = async () => {
  try {
    const res = await request({
      url: '/carsale/finance/list',
      method: 'get'
    })
    financePlanList.value = res.data || []
  } catch (error) {
    console.error('获取金融方案列表失败', error)
  }
}

// 处理金融方案变化
const handleFinancePlanChange = async (planId) => {
  if (!planId || !selectedVehicle.value) {
    financeResult.value = null
    form.downPayment = null
    return
  }
  
  try {
    // 使用折扣后的价格计算金融方案（需付价 = 原价 - 直降优惠）
    const discountedPrice = form.amount || (selectedVehicle.value.price * form.number)
    
    const res = await request({
      url: '/carsale/finance/calculate',
      method: 'post',
      data: {
        planId: planId,
        vehiclePrice: discountedPrice
      }
    })
    financeResult.value = res.data
    // 保存首付金额
    form.downPayment = res.data.downPayment
  } catch (error) {
    message.error('计算月供失败')
    financeResult.value = null
    form.downPayment = null
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

// 获取优惠类型对应的颜色
const getDiscountTypeColor = (type) => {
  const colorMap = {
    0: 'red',      // 直降 - 红色
    1: 'orange',   // 赠品 - 橙色
    2: 'blue'       // 置换补贴 - 蓝色
  }
  return colorMap[type] || 'default'
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
        // 每辆车都享受优惠，所以优惠金额要乘以车辆数量
        // 优先使用 discountAmount，如果没有则使用 discountValue（兼容旧数据）
        const promoAmount = promo.discountAmount || promo.discountValue || 0
        discountAmount += promoAmount * form.number
      }
    }
  })
  
  // 保存原价和折扣金额
  form.originalPrice = baseAmount
  form.discountAmount = discountAmount
  form.amount = Math.max(0, baseAmount - discountAmount)
  
  // 如果已选择金融方案，需要重新计算
  if (form.financePlanId) {
    handleFinancePlanChange(form.financePlanId)
  }
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
  getFinancePlanList()
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
