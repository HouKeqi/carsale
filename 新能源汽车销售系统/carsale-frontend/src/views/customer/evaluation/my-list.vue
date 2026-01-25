<template>
  <a-card class="main-page">
    <a-table
      class="table"
      :columns="columns"
      :data-source="evaluationList"
      :pagination="pagination"
      :loading="loading"
      bordered
    >
      <template #bodyCell="{ column, record }">
        <template v-if="column.key === 'index'">
          {{ (pagination.current - 1) * pagination.pageSize + evaluationList.indexOf(record) + 1 }}
        </template>
        <template v-if="column.key === 'score'">
          <a-rate :value="record.score" disabled />
        </template>
        <template v-if="column.key === 'images'">
          <a-image
            v-if="record.images"
            v-for="(img, index) in getImageList(record.images)"
            :key="index"
            :src="img"
            :width="60"
            :height="60"
            style="margin-right: 5px"
            :preview="{ src: img }"
          />
        </template>
        <template v-if="column.key === 'createTime'">
          {{ formatDateTime(record.create_Time) }}
        </template>
        <template v-if="column.key === 'operation'">
          <a @click="handleViewOrder(record.orderId)" style="color: #1890ff; margin-right: 8px">查看订单</a>
          <a @click="handleDelete(record.id)" style="color: #ff4d4f">删除</a>
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
const evaluationList = ref([])
const orderMap = ref({}) // 存储订单ID对应的订单信息

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10
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
    dataIndex: 'orderId',
    key: 'orderId',
    width: 180
  },
  {
    title: '订单信息',
    key: 'orderInfo',
    width: 250,
    customRender: ({ record }) => {
      const order = orderMap.value[record.orderId]
      if (order) {
        return `${order.vehicleName || '未知车型'} x${order.number || 1} - ¥${formatPrice(order.amount)}`
      }
      return '-'
    }
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
    title: '图片',
    key: 'images',
    width: 200
  },
  {
    title: '评价时间',
    key: 'createTime',
    width: 180
  },
  {
    title: '操作',
    key: 'operation',
    align: 'center',
    width: 100
  }
]

// 获取图片列表
const getImageList = (images) => {
  if (!images) return []
  try {
    return JSON.parse(images)
  } catch (e) {
    return images.split(',').filter(img => img)
  }
}

// 格式化日期时间
const formatDateTime = (dateTime) => {
  if (!dateTime) return '-'
  return dayjs(dateTime).format('YYYY-MM-DD HH:mm:ss')
}

// 格式化价格
const formatPrice = (price) => {
  if (!price) return '0.00'
  return Number(price).toLocaleString('zh-CN', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2
  })
}

// 查询列表
const getList = async () => {
  loading.value = true
  try {
    const res = await request({
      url: '/carsale/evaluation/my/list',
      method: 'get',
      params: queryParams
    })
    evaluationList.value = res.rows || res.data || []
    pagination.total = res.total || 0
    // 加载订单信息
    await loadOrderInfo()
  } catch (error) {
    message.error('获取评价列表失败')
  } finally {
    loading.value = false
  }
}

// 加载订单信息
const loadOrderInfo = async () => {
  const orderIds = [...new Set(evaluationList.value.map(e => e.orderId).filter(id => id))]
  if (orderIds.length === 0) return

  try {
    // 批量获取订单信息
    for (const orderId of orderIds) {
      try {
        const res = await request({
          url: '/carsale/order/detail/' + orderId,
          method: 'get'
        })
        const order = res.data
        if (order) {
          // 获取车辆信息
          if (order.vehicleId) {
            try {
              const vehicleRes = await request({
                url: '/carsale/vehicle/' + order.vehicleId,
                method: 'get'
              })
              const vehicle = vehicleRes.data?.vehicle
              orderMap.value[orderId] = {
                ...order,
                vehicleName: vehicle ? `${vehicle.brand} ${vehicle.name}` : '未知车型'
              }
            } catch (e) {
              orderMap.value[orderId] = {
                ...order,
                vehicleName: '未知车型'
              }
            }
          } else {
            orderMap.value[orderId] = order
          }
        }
      } catch (error) {
        console.error(`获取订单${orderId}信息失败`, error)
      }
    }
  } catch (error) {
    console.error('加载订单信息失败', error)
  }
}

// 查看订单
const handleViewOrder = (orderId) => {
  router.push({
    path: '/customer/order/detail',
    query: { id: orderId }
  })
}

// 删除
const handleDelete = (id) => {
  Modal.confirm({
    title: '提示',
    content: '确定要删除该评价吗？',
    okText: '确定',
    cancelText: '取消',
    onOk: async () => {
      try {
        await request({
          url: '/carsale/evaluation/delete/' + id,
          method: 'delete'
        })
        message.success('删除成功')
        getList()
      } catch (error) {
        message.error('删除失败')
      }
    }
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
