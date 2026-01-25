<template>
  <a-card class="main-page">
    <!-- 搜索区域 -->
    <div>
      <a-select
        v-model:value="searchForm.status"
        placeholder="审核状态"
        allowClear
        style="width: 150px; float: right; margin-bottom: 1rem; margin-left: 1rem"
        @change="search"
      >
        <a-select-option :value="0">待审核</a-select-option>
        <a-select-option :value="1">通过</a-select-option>
        <a-select-option :value="2">拒绝</a-select-option>
      </a-select>
    </div>

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
        <template v-if="column.key === 'user'">
          {{ getUserName(record.userId) }}
        </template>
        <template v-if="column.key === 'vehicle'">
          {{ getVehicleName(record.vehicleId) }}
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
          <span v-if="record.status === 0">
            <a @click="handleAudit(record, 1)" style="color: #52c41a">通过</a>
            <a-divider type="vertical" />
            <a @click="handleAudit(record, 2)" style="color: #ff4d4f">拒绝</a>
          </span>
          <span v-else>-</span>
        </template>
      </template>
    </a-table>

    <!-- 审核对话框 -->
    <a-modal
      v-model:open="auditDialogVisible"
      title="审核试驾预约"
      width="500px"
      @ok="submitAudit"
      @cancel="resetAuditForm"
    >
      <a-form
        ref="auditFormRef"
        :model="auditForm"
        :label-col="{ span: 6 }"
        :wrapper-col="{ span: 18 }"
      >
        <a-form-item label="审核结果">
          <a-radio-group v-model:value="auditForm.status">
            <a-radio :value="1">通过</a-radio>
            <a-radio :value="2">拒绝</a-radio>
          </a-radio-group>
        </a-form-item>
        <a-form-item label="审核备注">
          <a-textarea
            v-model:value="auditForm.auditRemark"
            :rows="3"
            placeholder="请输入审核备注"
          />
        </a-form-item>
      </a-form>
      <template #footer>
        <a-button @click="auditDialogVisible = false">取消</a-button>
        <a-button type="primary" @click="submitAudit">确定</a-button>
      </template>
    </a-modal>
  </a-card>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { message } from 'ant-design-vue'
import request from '@/utils/request'
import dayjs from 'dayjs'

const loading = ref(false)
const testdriveList = ref([])
const total = ref(0)
const auditDialogVisible = ref(false)
const auditFormRef = ref(null)
const userMap = ref({})
const vehicleMap = ref({})

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
    title: '预约编号',
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

const auditForm = reactive({
  id: null,
  status: 1,
  auditRemark: null
})

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
      url: '/carsale/admin/testdrive/list',
      method: 'get',
      params: queryParams
    })
    testdriveList.value = res.rows || res.data || []
    total.value = res.total || 0
    pagination.total = res.total || 0
  } catch (error) {
    message.error('获取试驾预约列表失败')
  } finally {
    loading.value = false
  }
}

// 搜索
const search = () => {
  queryParams.status = searchForm.status
  queryParams.pageNum = 1
  pagination.current = 1
  getList()
}

// 审核
const handleAudit = (row, status) => {
  auditForm.id = row.id
  auditForm.status = status
  auditForm.auditRemark = null
  auditDialogVisible.value = true
}

// 提交审核
const submitAudit = async () => {
  try {
    await request({
      url: '/carsale/admin/testdrive/' + auditForm.id + '/audit',
      method: 'put',
      data: {
        status: auditForm.status,
        auditRemark: auditForm.auditRemark,
        auditTime: dayjs().format('YYYY-MM-DD HH:mm:ss')
      }
    })
    message.success('审核成功')
    auditDialogVisible.value = false
    getList()
  } catch (error) {
    message.error('审核失败')
  }
}

// 重置审核表单
const resetAuditForm = () => {
  auditFormRef.value?.resetFields()
  Object.assign(auditForm, {
    id: null,
    status: 1,
    auditRemark: null
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
