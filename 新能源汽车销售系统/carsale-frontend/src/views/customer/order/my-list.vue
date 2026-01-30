<template>
  <div class="order-list-container">
    <a-card :bordered="false" class="search-card">
      <div class="header-flex">
        <a-tabs v-model:activeKey="searchForm.status" @change="search" class="status-tabs">
          <a-tab-pane :key="null" tab="全部订单" />
          <a-tab-pane :key="0" tab="待支付" />
          <a-tab-pane :key="1" tab="已支付" />
          <a-tab-pane :key="2" tab="待提车" />
          <a-tab-pane :key="3" tab="已完成" />
          <a-tab-pane :key="4" tab="已取消" />
        </a-tabs>

      </div>
    </a-card>

    <a-card :bordered="false" class="table-card">
      <a-table
          :columns="columns"
          :data-source="orderList"
          :pagination="pagination"
          :loading="loading"
          :scroll="{ x: 1000 }"
          row-key="id"
      >
        <template #bodyCell="{ column, record }">
          <template v-if="column.key === 'orderInfo'">
            <div class="order-id-text">ID: {{ record.id }}</div>
            <div class="vehicle-name-text">
              {{ vehicleMap[record.vehicleId] ?
                `${vehicleMap[record.vehicleId].brand} ${vehicleMap[record.vehicleId].name}` :
                '加载中...'
              }}
            </div>
          </template>

          <template v-if="column.key === 'status'">
            <a-tag :color="getStatusColor(record.status)">
              {{ formatStatus(record.status) }}
            </a-tag>
          </template>

          <template v-if="column.key === 'amount'">
            <span class="price-text">{{ formatPrice(record.amount) }}</span>
          </template>

          <template v-if="column.key === 'createTime'">
            <span class="time-text">{{ formatDateTime(record.create_Time) }}</span>
          </template>

          <template v-if="column.key === 'operation'">
            <a-space>
              <a-button type="default" size="small"  @click="handleDetail(record.id)">订单详情</a-button>

              <template v-if="record.status === 0">
                <a-button type="primary" size="small" @click="handlePay(record.id)">立即支付</a-button>
                <a-button danger size="small" @click="handleCancel(record.id)">取消</a-button>
              </template>

              <template v-if="record.status === 3">
                <a-button v-if="evaluationMap[record.id]" size="small" @click="handleViewEvaluation">查看评价</a-button>
                <a-button v-else type="primary" ghost size="small" @click="handleEvaluate(record)">去评价</a-button>
              </template>
            </a-space>
          </template>
        </template>
      </a-table>
    </a-card>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { message, Modal } from 'ant-design-vue'
import { useRouter } from 'vue-router'
import { ReloadOutlined } from '@ant-design/icons-vue'
import request from '@/utils/request'
import dayjs from 'dayjs'

const router = useRouter()
const loading = ref(false)
const orderList = ref([])
const vehicleMap = ref({})
const evaluationMap = ref({})

const searchForm = reactive({ status: null })
const queryParams = reactive({ pageNum: 1, pageSize: 10, status: null })

const pagination = reactive({
  current: 1,
  pageSize: 10,
  total: 0,
  showTotal: (total) => `共 ${total} 个订单`,
  onChange: (page, size) => {
    queryParams.pageNum = page
    queryParams.pageSize = size
    getList()
  }
})

const columns = [
  { title: '订单与车辆', key: 'orderInfo', width: 220, fixed: 'left' },
  { title: '订单状态', key: 'status', align: 'center', width: 100 },
  { title: '数量', dataIndex: 'number', align: 'center', width: 80 },
  { title: '实付款', key: 'amount', align: 'right', width: 130 },
  { title: '提车门店', dataIndex: 'storeLocation', ellipsis: true },
  { title: '下单时间', key: 'createTime', width: 170 },
  { title: '操作', key: 'operation', width: 180, fixed: 'right' }
]

const getStatusColor = (status) => {
  const colors = { 0: 'orange', 1: 'blue', 2: 'cyan', 3: 'green', 4: 'default' }
  return colors[status] || 'default'
}

const formatStatus = (s) => {
  return { 0: '待支付', 1: '已支付', 2: '待提车', 3: '已完成', 4: '已取消' }[s] || '未知'
}

const formatPrice = (p) => p ? `¥${Number(p).toLocaleString('zh-CN', { minimumFractionDigits: 2 })}` : '¥0.00'

const formatDateTime = (val) => val ? dayjs(val).format('YYYY-MM-DD HH:mm') : '-'

const getList = async () => {
  loading.value = true
  try {
    const res = await request({ url: '/carsale/order/my/page', params: queryParams })
    orderList.value = res.rows || res.data || []
    pagination.total = res.total || 0
    pagination.current = queryParams.pageNum
    await Promise.all([loadVehicleInfo(), loadEvaluationInfo()])
  } catch (error) {
    message.error('获取订单失败')
  } finally {
    loading.value = false
  }
}

const loadEvaluationInfo = async () => {
  try {
    const res = await request({ url: '/carsale/evaluation/my/list', params: { pageNum: 1, pageSize: 1000 } })
    const list = res.rows || res.data || []
    evaluationMap.value = {}
    list.forEach(e => { if (e.orderId) evaluationMap.value[e.orderId] = e })
  } catch (e) { console.error(e) }
}

const loadVehicleInfo = async () => {
  const ids = [...new Set(orderList.value.map(o => o.vehicleId))]
  if (ids.length === 0) return
  try {
    const res = await request({ url: '/carsale/vehicle/search', params: { pageNum: 1, pageSize: 100 } })
    res.rows?.forEach(v => { vehicleMap.value[v.id] = v })
  } catch (e) { console.error(e) }
}

const search = () => {
  queryParams.status = searchForm.status
  queryParams.pageNum = 1
  getList()
}

const handleDetail = (id) => router.push({ path: '/customer/order/detail', query: { id } })
const handlePay = (id) => router.push({ path: '/customer/order/pay', query: { id } })
const handleCancel = (id) => {
  Modal.confirm({
    title: '确定取消订单吗？',
    onOk: async () => {
      await request({ url: `/carsale/order/cancel/${id}`, method: 'put' })
      message.success('已取消')
      getList()
    }
  })
}
const handleEvaluate = (order) => router.push({
  path: '/customer/evaluation/create',
  query: { orderId: order.id, vehicleId: order.vehicleId }
})
const handleViewEvaluation = () => router.push({ path: '/customer/evaluation/my-list' })

onMounted(getList)
</script>

<style scoped>
.order-list-container {
  padding: 24px;
  background-color: #f0f2f5;
  min-height: 100vh;
}

.search-card {
  margin-bottom: 16px;
  border-radius: 8px;
}

.header-flex {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.status-tabs :deep(.ant-tabs-nav) {
  margin-bottom: 0;
}

.table-card {
  border-radius: 8px;
}

.order-id-text {
  font-size: 12px;
  color: #999;
}

.vehicle-name-text {
  font-weight: 600;
  color: #333;
}

.price-text {
  font-weight: 700;
  color: #ff4d4f;
}

.time-text {
  color: #666;
  font-size: 13px;
}

:deep(.ant-table-thead > tr > th) {
  background-color: #fafafa;
}
</style>
