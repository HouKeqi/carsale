<template>
  <a-card class="main-page">
    <a-tabs v-model:activeKey="activeTab">
      <a-tab-pane key="info" tab="个人信息">
        <a-form
          ref="formRef"
          :model="form"
          :rules="rules"
          :label-col="{ span: 6 }"
          :wrapper-col="{ span: 18 }"
          style="max-width: 600px"
        >
          <a-form-item label="用户账号">
            <a-input v-model:value="form.userName" disabled />
          </a-form-item>
          <a-form-item label="用户昵称" name="nickName">
            <a-input v-model:value="form.nickName" />
          </a-form-item>
          <a-form-item label="真实姓名" name="realName">
            <a-input v-model:value="form.realName" />
          </a-form-item>
          <a-form-item label="手机号码" name="phonenumber">
            <a-input v-model:value="form.phonenumber" />
          </a-form-item>
          <a-form-item label="身份证号" name="idCard">
            <a-input v-model:value="form.idCard" />
          </a-form-item>
          <a-form-item label="地址" name="address">
            <a-textarea v-model:value="form.address" :rows="3" />
          </a-form-item>
          <a-form-item>
            <a-button type="primary" @click="submitForm">保存</a-button>
            <a-button @click="reset" style="margin-left: 10px">重置</a-button>
          </a-form-item>
        </a-form>
      </a-tab-pane>
      <a-tab-pane key="orders" tab="我的订单">
        <a-table :data-source="orderList" :loading="orderLoading" :pagination="false" :columns="orderColumns" bordered>
          <template #bodyCell="{ column, record }">
            <template v-if="column.key === 'vehicle'">
              {{ getVehicleName(record.vehicleId) }}
            </template>
            <template v-if="column.key === 'status'">
              {{ formatStatus(record.status) }}
            </template>
            <template v-if="column.key === 'amount'">
              {{ formatPrice(record.amount) }}
            </template>
            <template v-if="column.key === 'create_Time'">
              {{ formatDateTime(record.create_Time) }}
            </template>
            <template v-if="column.key === 'operation'">
              <a @click="handleOrderDetail(record.id)">查看详情</a>
            </template>
          </template>
        </a-table>
      </a-tab-pane>
      <a-tab-pane key="evaluations" tab="我的评价">
        <a-table :data-source="evaluationList" :loading="evalLoading" :pagination="false" :columns="evalColumns" bordered>
          <template #bodyCell="{ column, record }">
            <template v-if="column.key === 'score'">
              <a-rate :value="record.score" disabled />
            </template>
            <template v-if="column.key === 'create_Time'">
              {{ formatDateTime(record.create_Time) }}
            </template>
          </template>
        </a-table>
      </a-tab-pane>
    </a-tabs>
  </a-card>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { message } from 'ant-design-vue'
import { useRouter } from 'vue-router'
import request from '@/utils/request'
import dayjs from 'dayjs'

const router = useRouter()
const activeTab = ref('info')
const formRef = ref(null)
const orderList = ref([])
const orderLoading = ref(false)
const evaluationList = ref([])
const evalLoading = ref(false)
const vehicleMap = ref({})

const orderColumns = [
  {
    title: '订单编号',
    dataIndex: 'id',
    key: 'id',
    width: 180
  },
  {
    title: '车型',
    key: 'vehicle',
    width: 200
  },
  {
    title: '订单状态',
    dataIndex: 'status',
    key: 'status',
    width: 100
  },
  {
    title: '成交金额',
    dataIndex: 'amount',
    key: 'amount',
    width: 120
  },
  {
    title: '下单时间',
    dataIndex: 'create_Time',
    key: 'create_Time',
    width: 180
  },
  {
    title: '操作',
    key: 'operation',
    width: 150
  }
]

const evalColumns = [
  {
    title: '订单编号',
    dataIndex: 'orderId',
    key: 'orderId',
    width: 180
  },
  {
    title: '评分',
    key: 'score',
    width: 150
  },
  {
    title: '评价内容',
    dataIndex: 'comment',
    key: 'comment'
  },
  {
    title: '评价时间',
    dataIndex: 'create_Time',
    key: 'create_Time',
    width: 180
  }
]

const form = reactive({
  userName: '',
  nickName: '',
  realName: '',
  phonenumber: '',
  idCard: '',
  address: ''
})

const rules = {
  nickName: [{ required: true, message: '用户昵称不能为空', trigger: 'blur' }],
  phonenumber: [
    { required: true, message: '手机号码不能为空', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
  ]
}

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

// 格式化价格
const formatPrice = (price) => {
  if (!price) return '0.00'
  return '¥' + Number(price).toLocaleString('zh-CN', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2
  })
}

// 格式化日期时间
const formatDateTime = (dateTime) => {
  if (!dateTime) return '-'
  return dayjs(dateTime).format('YYYY-MM-DD HH:mm:ss')
}

// 获取车型名称
const getVehicleName = (vehicleId) => {
  if (!vehicleId) return '-'
  // 处理类型匹配问题（字符串和数字）
  const vehicle = vehicleMap.value[vehicleId] || vehicleMap.value[String(vehicleId)] || vehicleMap.value[Number(vehicleId)]
  return vehicle ? `${vehicle.brand} ${vehicle.name}` : `车型ID: ${vehicleId}`
}

// 加载车辆信息（根据订单中的 vehicleId）
const loadVehicleInfo = async () => {
  const vehicleIds = [...new Set(orderList.value.map(o => o.vehicleId).filter(id => id != null))]
  if (vehicleIds.length === 0) return
  
  try {
    const res = await request({
      url: '/carsale/vehicle/search',
      method: 'get',
      params: { pageNum: 1, pageSize: 1000 }
    })
    const vehicles = res.rows || res.data || []
    vehicles.forEach(v => {
      // 同时支持字符串和数字类型的 key
      vehicleMap.value[v.id] = v
      vehicleMap.value[String(v.id)] = v
      vehicleMap.value[Number(v.id)] = v
    })
  } catch (error) {
    console.error('获取车辆信息失败', error)
  }
}

// 获取用户信息
const getUserInfo = async () => {
  try {
    const res = await request({
      url: '/getInfo',
      method: 'get'
    })
    if (res.user) {
      Object.assign(form, {
        userName: res.user.userName || '',
        nickName: res.user.nickName || '',
        realName: res.user.realName || '',
        phonenumber: res.user.phonenumber || '',
        idCard: res.user.idCard || '',
        address: res.user.address || ''
      })
    }
  } catch (error) {
    console.error('获取用户信息失败', error)
  }
}

// 获取订单列表
const getOrderList = async () => {
  orderLoading.value = true
  try {
    const res = await request({
      url: '/carsale/order/my/page',
      method: 'get',
      params: { pageNum: 1, pageSize: 10 }
    })
    orderList.value = res.rows || res.data || []
    // 获取订单列表后，加载对应的车型信息
    await loadVehicleInfo()
  } catch (error) {
    console.error('获取订单列表失败', error)
  } finally {
    orderLoading.value = false
  }
}

// 获取评价列表
const getEvaluationList = async () => {
  evalLoading.value = true
  try {
    const res = await request({
      url: '/carsale/evaluation/my/list',
      method: 'get',
      params: { pageNum: 1, pageSize: 10 }
    })
    evaluationList.value = res.rows || res.data || []
  } catch (error) {
    console.error('获取评价列表失败', error)
  } finally {
    evalLoading.value = false
  }
}

// 提交表单
const submitForm = () => {
  formRef.value.validate().then(async () => {
    try {
      await request({
        url: '/system/user/profile',
        method: 'put',
        data: form
      })
      message.success('修改成功')
      getUserInfo()
    } catch (error) {
      message.error('修改失败')
    }
  }).catch(() => {
    // 验证失败
  })
}

// 重置
const reset = () => {
  getUserInfo()
}

// 查看订单详情
const handleOrderDetail = (id) => {
  router.push({ path: '/customer/order/detail', query: { id } })
}

onMounted(() => {
  getUserInfo()
  getOrderList()
  getEvaluationList()
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
