<template>
  <div class="testdrive-list-container">
    <a-card :bordered="false" class="header-card">
      <div class="header-flex">
        <div class="title-area">
          <span class="main-title">我的试驾预约</span>
          <span class="sub-count">共 {{ pagination.total }} 条</span>
        </div>
      </div>
      <a-tabs v-model:activeKey="queryParams.status" @change="handleStatusChange" class="status-tabs">
        <a-tab-pane :key="null" tab="全部预约" />
        <a-tab-pane :key="0" tab="待审核" />
        <a-tab-pane :key="1" tab="已通过" />
        <a-tab-pane :key="2" tab="已拒绝" />
      </a-tabs>
    </a-card>

    <a-card :bordered="false" class="table-card">
      <a-table
          :columns="columns"
          :data-source="testdriveList"
          :pagination="pagination"
          :loading="loading"
          :scroll="{ x: 1000 }"
          row-key="id"
      >
        <template #bodyCell="{ column, record }">
          <template v-if="column.key === 'appointInfo'">
            <div class="id-label">预约号: {{ record.id }}</div>
            <div class="vehicle-label">
              {{ vehicleMap[record.vehicleId] ?
                `${vehicleMap[record.vehicleId].brand} ${vehicleMap[record.vehicleId].name}` :
                `车型ID: ${record.vehicleId}`
              }}
            </div>
          </template>

          <template v-if="column.key === 'status'">
            <a-badge :status="getStatusBadge(record.status)" :text="formatStatus(record.status)" />
          </template>

          <template v-if="column.key === 'appointTime'">
            <span class="time-text">{{ formatDateTime(record.appointTime) }}</span>
          </template>

          <template v-if="column.key === 'auditRemark'">
            <span :class="['remark-text', !record.auditRemark && 'empty-text']">
              {{ record.auditRemark || '暂无说明' }}
            </span>
          </template>

          <template v-if="column.key === 'operation'">
            <a-space v-if="record.status === 0">
              <a-popconfirm title="确定要取消这次预约吗？" @confirm="handleCancel(record.id)">
                <a-button type="link" danger size="small">取消预约</a-button>
              </a-popconfirm>
            </a-space>
            <span v-else class="done-text">-</span>
          </template>
        </template>
      </a-table>
    </a-card>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { message } from 'ant-design-vue'
import { ReloadOutlined } from '@ant-design/icons-vue'
import request from '@/utils/request'
import dayjs from 'dayjs'

const loading = ref(false)
const testdriveList = ref([])
const vehicleMap = ref({})

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  status: null
})

const pagination = reactive({
  current: 1,
  pageSize: 10,
  total: 0,
  showTotal: (total) => `共 ${total} 个预约`,
  onChange: (page, size) => {
    queryParams.pageNum = page
    queryParams.pageSize = size
    getList()
  }
})

const columns = [
  { title: '预约与车型', key: 'appointInfo', width: 220, fixed: 'left' },
  { title: '预约门店', dataIndex: 'storeName', width: 150, ellipsis: true },
  { title: '预约时间', key: 'appointTime', width: 170 },
  { title: '审核状态', key: 'status', align: 'center', width: 120 },
  { title: '审核备注', key: 'auditRemark', ellipsis: true },
]

const formatStatus = (s) => ({ 0: '待审核', 1: '通过', 2: '拒绝' }[s] || '未知')

const getStatusBadge = (s) => ({ 0: 'processing', 1: 'success', 2: 'error' }[s] || 'default')

const formatDateTime = (val) => val ? dayjs(val).format('YYYY-MM-DD HH:mm') : '-'

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
    pagination.current = queryParams.pageNum
    await loadVehicleInfo()
  } catch (error) {
    message.error('获取列表失败')
  } finally {
    loading.value = false
  }
}

const loadVehicleInfo = async () => {
  const ids = [...new Set(testdriveList.value.map(t => t.vehicleId))]
  if (ids.length === 0) return
  try {
    const res = await request({ url: '/carsale/vehicle/search', params: { pageNum: 1, pageSize: 100 } })
    res.rows?.forEach(v => { vehicleMap.value[v.id] = v })
  } catch (e) { console.error(e) }
}

const handleStatusChange = () => {
  queryParams.pageNum = 1
  getList()
}

const handleCancel = async (id) => {
  try {
    await request({ url: '/carsale/testdrive/cancel/' + id, method: 'delete' })
    message.success('已取消预约')
    getList()
  } catch (e) { message.error('操作失败') }
}

onMounted(getList)
</script>

<style scoped>
.testdrive-list-container {
  padding: 24px;
  background-color: #f0f2f5;
  min-height: 100vh;
}

.header-card {
  margin-bottom: 16px;
  border-radius: 8px;
}

.header-flex {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.main-title {
  font-size: 18px;
  font-weight: 600;
  color: #333;
  margin-right: 12px;
}

.sub-count {
  color: #999;
  font-size: 13px;
}

.status-tabs :deep(.ant-tabs-nav) {
  margin-bottom: 0;
}

.table-card {
  border-radius: 8px;
}

.id-label {
  font-size: 12px;
  color: #999;
}

.vehicle-label {
  font-weight: 600;
  color: #333;
}

.time-text {
  color: #666;
  font-size: 13px;
}

.remark-text {
  color: #595959;
}

.empty-text {
  color: #bfbfbf;
  font-style: italic;
}

.done-text {
  color: #d9d9d9;
}

:deep(.ant-table-thead > tr > th) {
  background-color: #fafafa;
}
</style>
