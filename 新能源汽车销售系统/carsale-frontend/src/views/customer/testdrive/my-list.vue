<template>
  <a-card class="main-page">
    <a-table
      class="table"
      :columns="columns"
      :data-source="testdriveList"
      :pagination="pagination"
      :loading="loading"
      bordered
    >
      <template #bodyCell="{ column, record }">
        <template v-if="column.key === 'index'">
          {{ (pagination.current - 1) * pagination.pageSize + testdriveList.indexOf(record) + 1 }}
        </template>
        <template v-if="column.key === 'status'">
          {{ formatStatus(record.status) }}
        </template>
        <template v-if="column.key === 'appointTime'">
          {{ formatDateTime(record.appointTime) }}
        </template>
        <template v-if="column.key === 'auditTime'">
          {{ formatDateTime(record.auditTime) }}
        </template>
        <template v-if="column.key === 'operation'">
          <a
            v-if="record.status === 0"
            @click="handleCancel(record.id)"
            style="color: #ff4d4f"
          >取消预约</a>
          <span v-else>-</span>
        </template>
      </template>
    </a-table>
  </a-card>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { message, Modal } from 'ant-design-vue'
import request from '@/utils/request'
import dayjs from 'dayjs'

const loading = ref(false)
const testdriveList = ref([])
const vehicleMap = ref({})

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
    title: '预约编号',
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
    title: '预约门店',
    dataIndex: 'storeName',
    key: 'storeName',
    width: 150
  },
  {
    title: '预约时间',
    key: 'appointTime',
    width: 180
  },
  {
    title: '审核状态',
    key: 'status',
    align: 'center',
    width: 100
  },
  {
    title: '审核时间',
    key: 'auditTime',
    width: 180
  },
  {
    title: '审核备注',
    dataIndex: 'auditRemark',
    key: 'auditRemark'
  },
  {
    title: '操作',
    key: 'operation',
    align: 'center',
    width: 150
  }
]

// 格式化状态
const formatStatus = (status) => {
  const statusMap = {
    0: '待审核',
    1: '通过',
    2: '拒绝'
  }
  return statusMap[status] || '未知'
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
      url: '/carsale/testdrive/my/list',
      method: 'get',
      params: queryParams
    })
    testdriveList.value = res.rows || res.data || []
    pagination.total = res.total || 0
    loadVehicleInfo()
  } catch (error) {
    message.error('获取试驾预约列表失败')
  } finally {
    loading.value = false
  }
}

// 加载车辆信息
const loadVehicleInfo = async () => {
  const vehicleIds = [...new Set(testdriveList.value.map(t => t.vehicleId))]
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

// 取消预约
const handleCancel = (id) => {
  Modal.confirm({
    title: '提示',
    content: '确定要取消该预约吗？',
    okText: '确定',
    cancelText: '取消',
    onOk: async () => {
      try {
        await request({
          url: '/carsale/testdrive/cancel/' + id,
          method: 'delete'
        })
        message.success('取消成功')
        getList()
      } catch (error) {
        message.error('取消失败')
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
