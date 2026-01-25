<template>
  <a-card class="main-page">
    <!-- 搜索区域 -->
    <div>
      <a-input-search
        v-model:value="searchForm.id"
        placeholder="根据订单编号进行搜索"
        enter-button
        allowClear
        @search="search"
        style="width: 250px; float: right; margin-bottom: 1rem; margin-left: 1rem"
      />
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
        <template v-if="column.key === 'user'">
          {{ getUserName(record.userId) }}
        </template>
        <template v-if="column.key === 'vehicle'">
          {{ getVehicleName(record.vehicleId) }}
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
            <a @click="handleView(record)">查看详情</a>
            <template v-if="record.status === 1">
              <a-divider type="vertical" />
              <a @click="handleConfirmOrder(record)" style="color: #52c41a">确认订单</a>
            </template>
            <template v-if="record.status === 2">
              <a-divider type="vertical" />
              <a @click="handleMarkPickup(record)" style="color: #1890ff">标记提车</a>
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
const total = ref(0)
const userMap = ref({})
const vehicleMap = ref({})

const searchForm = reactive({
  id: '',
  status: null
})

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  id: null,
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
    title: '用户名称',
    key: 'user',
    width: 150
  },
  {
    title: '车型',
    key: 'vehicle',
    width: 200
  },
  {
    title: '订单状态',
    key: 'status',
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
    title: '购车数量',
    dataIndex: 'number',
    key: 'number',
    align: 'center',
    width: 100
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

// 获取用户名称
const getUserName = (userId) => {
  const user = userMap.value[userId]
  return user ? (user.nickName || user.userName) : `用户ID: ${userId}`
}

// 获取车型名称
const getVehicleName = (vehicleId) => {
  const vehicle = vehicleMap.value[vehicleId]
  return vehicle ? `${vehicle.brand} ${vehicle.name}` : `车型ID: ${vehicleId}`
}

// 获取用户列表
const getUserList = async () => {
  try {
    const res = await request({
      url: '/carsale/admin/user/list',
      method: 'get',
      params: { pageNum: 1, pageSize: 1000 }
    })
    const users = res.rows || res.data || []
    userMap.value = {}
    users.forEach(u => {
      userMap.value[u.userId] = u
    })
  } catch (error) {
    console.error('获取用户列表失败', error)
  }
}

// 获取车型列表
const getVehicleList = async () => {
  try {
    const res = await request({
      url: '/carsale/admin/vehicle/list',
      method: 'get'
    })
    const vehicles = res.data || []
    vehicleMap.value = {}
    vehicles.forEach(v => {
      vehicleMap.value[v.id] = v
    })
  } catch (error) {
    console.error('获取车型列表失败', error)
    message.error('获取车型列表失败')
  }
}

// 查询列表
const getList = async () => {
  loading.value = true
  try {
    const res = await request({
      url: '/carsale/admin/order/page',
      method: 'get',
      params: queryParams
    })
    orderList.value = res.rows || res.data || []
    total.value = res.total || 0
    pagination.total = res.total || 0
  } catch (error) {
    message.error('获取订单列表失败')
  } finally {
    loading.value = false
  }
}

// 搜索
const search = () => {
  queryParams.id = searchForm.id || null
  queryParams.status = searchForm.status
  queryParams.pageNum = 1
  pagination.current = 1
  getList()
}

// 查看详情
const handleView = (row) => {
  router.push({ path: '/admin/order/detail', query: { id: row.id } })
}

// 确认订单/准备就绪
const handleConfirmOrder = (row) => {
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
            id: row.id,
            status: 2
          }
        })
        message.success('操作成功')
        getList()
      } catch (error) {
        message.error(error.response?.data?.msg || '操作失败')
      }
    }
  })
}

// 标记提车
const handleMarkPickup = (row) => {
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
            id: row.id,
            status: 3,
            pickupTime: dayjs().format('YYYY-MM-DD HH:mm:ss')
          }
        })
        message.success('操作成功')
        getList()
      } catch (error) {
        message.error(error.response?.data?.msg || '操作失败')
      }
    }
  })
}

onMounted(() => {
  getList()
  getUserList()
  getVehicleList()
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
