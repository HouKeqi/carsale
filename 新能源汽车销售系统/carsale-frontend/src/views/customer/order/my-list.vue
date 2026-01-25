<template>
  <a-card class="main-page">
    <!-- 搜索区域 -->
    <div>
      <a-select
        v-model:value="searchForm.status"
        placeholder="订单状态"
        allowClear
        style="width: 150px; float: right; margin-bottom: 1rem; margin-left: 1rem"
        @change="search"
      >
        <a-select-option :value="0">待支付</a-select-option>
        <a-select-option :value="1">已支付</a-select-option>
        <a-select-option :value="2">待提车</a-select-option>
        <a-select-option :value="3">已完成</a-select-option>
        <a-select-option :value="4">已取消</a-select-option>
      </a-select>
    </div>

    <a-table
      class="table"
      :columns="columns"
      :data-source="orderList"
      :pagination="pagination"
      :loading="loading"
      bordered
    >
      <template #bodyCell="{ column, record }">
        <template v-if="column.key === 'index'">
          {{ (pagination.current - 1) * pagination.pageSize + orderList.indexOf(record) + 1 }}
        </template>
        <template v-if="column.key === 'status'">
          {{ formatStatus(record.status) }}
        </template>
        <template v-if="column.key === 'amount'">
          {{ formatPrice(record.amount) }}
        </template>
        <template v-if="column.key === 'createTime'">
          {{ formatDateTime(record.create_Time) }}
        </template>
        <template v-if="column.key === 'operation'">
          <span>
            <a @click="handleDetail(record.id)">查看详情</a>
            <template v-if="record.status === 0">
              <a-divider type="vertical" />
              <a @click="handlePay(record.id)" style="color: #52c41a">立即支付</a>
              <a-divider type="vertical" />
              <a @click="handleCancel(record.id)" style="color: #ff4d4f">取消订单</a>
            </template>
            <template v-if="record.status === 3">
              <a-divider type="vertical" />
              <a v-if="evaluationMap[record.id]" @click="handleViewEvaluation(evaluationMap[record.id])" style="color: #1890ff">查看评价</a>
              <a v-else @click="handleEvaluate(record)" style="color: #52c41a">评价</a>
            </template>
          </span>
        </template>
      </template>
    </a-table>
  </a-card>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { message, Modal } from 'ant-design-vue'
import { useRouter } from 'vue-router'
import request from '@/utils/request'
import dayjs from 'dayjs'

const router = useRouter()
const loading = ref(false)
const orderList = ref([])
const vehicleMap = ref({})
const evaluationMap = ref({}) // 存储订单ID对应的评价信息

const searchForm = reactive({
  status: null
})

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  status: null
})

const pagination = reactive({
  current: 1,
  pageSize: 10,
  total: 0,
  showTotal: (total) => `共 ${total} 条`,
  showSizeChanger: true,
  pageSizeOptions: ['10', '20', '50', '100'],
  onChange: (page, size) => {
    pagination.current = page
    pagination.pageSize = size
    queryParams.pageNum = page
    queryParams.pageSize = size
    getList()
  },
  onShowSizeChange: (current, size) => {
    pagination.current = 1
    pagination.pageSize = size
    queryParams.pageNum = 1
    queryParams.pageSize = size
    getList()
  }
})

const columns = [
  {
    title: '序号',
    key: 'index',
    align: 'center',
    width: 60
  },
  {
    title: '订单编号',
    dataIndex: 'id',
    key: 'id',
    width: 180
  },
  {
    title: '车型',
    key: 'vehicle',
    width: 200,
    customRender: ({ record }) => {
      const vehicle = vehicleMap.value[record.vehicleId]
      return vehicle ? `${vehicle.brand} ${vehicle.name}` : `车型ID: ${record.vehicleId}`
    }
  },
  {
    title: '订单状态',
    key: 'status',
    align: 'center',
    width: 100
  },
  {
    title: '购车数量',
    dataIndex: 'number',
    key: 'number',
    align: 'center',
    width: 100
  },
  {
    title: '成交金额',
    key: 'amount',
    align: 'right',
    width: 120
  },
  {
    title: '提车门店',
    dataIndex: 'storeLocation',
    key: 'storeLocation',
    width: 150
  },
  {
    title: '下单时间',
    key: 'createTime',
    width: 180
  },
  {
    title: '操作',
    key: 'operation',
    align: 'center',
    width: 200,
    fixed: 'right'
  }
]

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

// 查询列表
const getList = async () => {
  loading.value = true
  try {
    const res = await request({
      url: '/carsale/order/my/page',
      method: 'get',
      params: queryParams
    })
    orderList.value = res.rows || res.data || []
    pagination.total = res.total || 0
    loadVehicleInfo()
    loadEvaluationInfo()
  } catch (error) {
    message.error('获取订单列表失败')
  } finally {
    loading.value = false
  }
}

// 加载评价信息
const loadEvaluationInfo = async () => {
  try {
    const res = await request({
      url: '/carsale/evaluation/my/list',
      method: 'get',
      params: { pageNum: 1, pageSize: 1000 }
    })
    const evaluations = res.rows || res.data || []
    evaluationMap.value = {}
    evaluations.forEach(evaluation => {
      if (evaluation.orderId) {
        evaluationMap.value[evaluation.orderId] = evaluation
      }
    })
  } catch (error) {
    console.error('获取评价信息失败', error)
  }
}

// 加载车辆信息
const loadVehicleInfo = async () => {
  const vehicleIds = [...new Set(orderList.value.map(o => o.vehicleId))]
  if (vehicleIds.length > 0) {
    try {
      const res = await request({
        url: '/carsale/vehicle/search',
        method: 'get',
        params: { pageNum: 1, pageSize: 100 }
      })
      res.rows?.forEach(v => {
        vehicleMap.value[v.id] = v
      })
    } catch (error) {
      console.error('获取车辆信息失败', error)
    }
  }
}

// 搜索
const search = () => {
  queryParams.status = searchForm.status
  queryParams.pageNum = 1
  pagination.current = 1
  getList()
}

// 查看详情
const handleDetail = (id) => {
  router.push({ path: '/customer/order/detail', query: { id } })
}

// 立即支付
const handlePay = (id) => {
  router.push({ path: '/customer/order/pay', query: { id } })
}

// 取消订单
const handleCancel = (id) => {
  Modal.confirm({
    title: '提示',
    content: '确定要取消该订单吗？',
    okText: '确定',
    cancelText: '取消',
    onOk: async () => {
      try {
        await request({
          url: '/carsale/order/cancel/' + id,
          method: 'put'
        })
        message.success('取消成功')
        getList()
      } catch (error) {
        message.error('取消失败')
      }
    }
  })
}

// 评价
const handleEvaluate = (order) => {
  router.push({
    path: '/customer/evaluation/create',
    query: { orderId: order.id, vehicleId: order.vehicleId }
  })
}

// 查看评价
const handleViewEvaluation = (evaluation) => {
  router.push({
    path: '/customer/evaluation/my-list'
  })
}

onMounted(() => {
  getList()
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
