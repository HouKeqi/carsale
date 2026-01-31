<template>
  <a-card class="main-page">
    <template #title>
      <span>我的库存提醒</span>
    </template>

    <a-table
      :columns="columns"
      :data-source="alertList"
      :pagination="pagination"
      :loading="loading"
      bordered
    >
      <template #bodyCell="{ column, record }">
        <template v-if="column.key === 'vehicle'">
          <div style="display: flex; align-items: center; gap: 12px">
            <img
              :src="getVehicleImage(record.vehicleId) || '/default-vehicle.jpg'"
              style="width: 60px; height: 40px; object-fit: cover; border-radius: 4px"
            />
            <div>
              <div style="font-weight: 500">{{ getVehicleName(record.vehicleId) }}</div>
              <a-button 
                type="link" 
                size="small" 
                style="padding: 0; height: auto"
                @click="handleViewVehicle(record.vehicleId)"
              >
                查看详情
              </a-button>
            </div>
          </div>
        </template>
        <template v-if="column.key === 'status'">
          <a-tag :color="record.status === 1 ? 'green' : 'default'">
            {{ record.status === 1 ? '订阅中' : '已取消' }}
          </a-tag>
        </template>
        <template v-if="column.key === 'notifyTime'">
          <div v-if="record.notifyTime" style="color: #52c41a; font-weight: 500">
            <a-icon type="check-circle" style="margin-right: 4px" />
            {{ formatDateTime(record.notifyTime) }}
          </div>
          <span v-else style="color: #999">待通知</span>
        </template>
        <template v-if="column.key === 'operation'">
          <a-space>
            <a-button 
              type="link" 
              @click="handleViewVehicle(record.vehicleId)"
            >
              查看车型
            </a-button>
            <a-button 
              type="link" 
              danger 
              @click="handleUnsubscribe(record)"
              :disabled="record.status !== 1"
            >
              取消订阅
            </a-button>
          </a-space>
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
const alertList = ref([])
const vehicleMap = ref({})

const pagination = reactive({
  current: 1,
  pageSize: 10,
  total: 0,
  showTotal: (total) => `共 ${total} 条`,
  showSizeChanger: true,
  pageSizeOptions: ['10', '20', '50'],
  onChange: (page, size) => {
    pagination.current = page
    pagination.pageSize = size
    getList()
  },
  onShowSizeChange: (current, size) => {
    pagination.current = 1
    pagination.pageSize = size
    getList()
  }
})

const columns = [
  {
    title: '车型',
    key: 'vehicle',
    width: 250
  },
  {
    title: '订阅状态',
    key: 'status',
    align: 'center',
    width: 100
  },
  {
    title: '订阅时间',
    dataIndex: 'createTime',
    key: 'createTime',
    width: 180
  },
  {
    title: '通知时间',
    key: 'notifyTime',
    width: 200
  },
  {
    title: '操作',
    key: 'operation',
    align: 'center',
    width: 180
  }
]

// 格式化日期时间
const formatDateTime = (dateTime) => {
  if (!dateTime) return '-'
  return dayjs(dateTime).format('YYYY-MM-DD HH:mm:ss')
}

// 获取车型名称
const getVehicleName = (vehicleId) => {
  const vehicle = vehicleMap.value[vehicleId]
  return vehicle ? `${vehicle.brand} ${vehicle.name}` : `车型ID: ${vehicleId}`
}

// 获取车型图片
const getVehicleImage = (vehicleId) => {
  const vehicle = vehicleMap.value[vehicleId]
  return vehicle?.imageUrl
}

// 查看车型详情
const handleViewVehicle = (vehicleId) => {
  router.push({ path: '/customer/vehicle/detail', query: { id: vehicleId } })
}

// 获取车型列表
const getVehicleList = async () => {
  try {
    const res = await request({
      url: '/carsale/vehicle/search',
      method: 'get',
      params: { pageNum: 1, pageSize: 1000 }
    })
    const vehicles = res.rows || res.data || []
    vehicleMap.value = {}
    vehicles.forEach(v => {
      vehicleMap.value[v.id] = v
    })
  } catch (error) {
    console.error('获取车型列表失败', error)
  }
}

// 查询列表
const getList = async () => {
  loading.value = true
  try {
    const res = await request({
      url: '/carsale/stock-alert/my-list',
      method: 'get',
      params: {
        pageNum: pagination.current,
        pageSize: pagination.pageSize
      }
    })
    alertList.value = res.rows || res.data || []
    pagination.total = res.total || 0
  } catch (error) {
    message.error('获取订阅列表失败')
  } finally {
    loading.value = false
  }
}

// 取消订阅
const handleUnsubscribe = (record) => {
  Modal.confirm({
    title: '确认取消',
    content: '确定要取消该库存提醒订阅吗？',
    onOk: async () => {
      try {
        await request({
          url: '/carsale/stock-alert/unsubscribe/' + record.id,
          method: 'delete'
        })
        message.success('已取消订阅')
        getList()
      } catch (error) {
        message.error('取消订阅失败')
      }
    }
  })
}

onMounted(() => {
  getList()
  getVehicleList()
})
</script>

<style scoped>
.main-page {
  padding: 2%;
  margin-top: 2vh;
  min-height: 90vh;
  overflow-y: auto;
}
</style>
