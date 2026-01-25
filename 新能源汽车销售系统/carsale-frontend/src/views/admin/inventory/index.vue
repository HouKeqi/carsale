<template>
  <a-card class="main-page">
    <!-- 搜索区域 -->
    <div>
      <a-alert
        message="库存预警"
        :description="`当前有 ${lowStockCount} 款车型库存不足（≤5）`"
        type="warning"
        show-icon
        :closable="false"
        style="margin-bottom: 1rem"
      />
    </div>

    <a-table
      class="table"
      :columns="columns"
      :data-source="vehicleList"
      :pagination="pagination"
      :loading="loading"
      bordered
    >
      <template #bodyCell="{ column, record }">
        <template v-if="column.key === 'index'">
          {{ (pagination.current - 1) * pagination.pageSize + vehicleList.indexOf(record) + 1 }}
        </template>
        <template v-if="column.key === 'price'">
          {{ formatPrice(record.price) }}
        </template>
        <template v-if="column.key === 'stock'">
          <span :style="{ color: record.stock <= 5 ? '#ff4d4f' : '' }">
            {{ record.stock }}
          </span>
        </template>
        <template v-if="column.key === 'operation'">
          <a @click="handleUpdateStock(record)">调整库存</a>
        </template>
      </template>
    </a-table>

    <!-- 调整库存对话框 -->
    <a-modal
      v-model:open="stockDialogVisible"
      title="调整库存"
      width="400px"
      @ok="submitStockForm"
      @cancel="resetStockForm"
    >
      <a-form
        ref="stockFormRef"
        :model="stockForm"
        :rules="stockRules"
        :label-col="{ span: 8 }"
        :wrapper-col="{ span: 16 }"
      >
        <a-form-item label="车型名称">
          <a-input v-model:value="stockForm.name" disabled />
        </a-form-item>
        <a-form-item label="当前库存">
          <a-input-number v-model:value="stockForm.stock" :min="0" style="width: 100%" disabled />
        </a-form-item>
        <a-form-item label="调整后库存" name="newStock">
          <a-input-number v-model:value="stockForm.newStock" :min="0" style="width: 100%" />
        </a-form-item>
      </a-form>
      <template #footer>
        <a-button @click="stockDialogVisible = false">取消</a-button>
        <a-button type="primary" @click="submitStockForm">确定</a-button>
      </template>
    </a-modal>
  </a-card>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { message } from 'ant-design-vue'
import request from '@/utils/request'
import { getAdminVehicleList } from '@/api/vehicle'

const loading = ref(false)
const vehicleList = ref([])
const total = ref(0)
const lowStockCount = ref(0)
const stockDialogVisible = ref(false)
const stockFormRef = ref(null)

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
    title: '车型名称',
    dataIndex: 'name',
    key: 'name',
    width: 150
  },
  {
    title: '品牌',
    dataIndex: 'brand',
    key: 'brand',
    width: 120
  },
  {
    title: '指导价(元)',
    key: 'price',
    align: 'right',
    width: 120
  },
  {
    title: '当前库存',
    key: 'stock',
    align: 'center',
    width: 100
  },
  {
    title: '操作',
    key: 'operation',
    align: 'center',
    width: 150
  }
]

const stockForm = reactive({
  id: null,
  name: '',
  stock: null,
  newStock: null
})

const stockRules = {
  newStock: [{ required: true, message: '请输入调整后库存', trigger: 'blur' }]
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
    // 使用与车辆管理相同的API，确保数据一致性
    const res = await getAdminVehicleList(queryParams)
    vehicleList.value = res.rows || res.data || []
    total.value = res.total || 0
    pagination.total = res.total || 0
  } catch (error) {
    message.error('获取库存列表失败')
  } finally {
    loading.value = false
  }
}

// 获取库存不足数量
const getLowStockCount = async () => {
  try {
    const res = await request({
      url: '/carsale/admin/inventory/low-stock/count',
      method: 'get'
    })
    lowStockCount.value = res.data?.count || 0
  } catch (error) {
    console.error('获取库存不足数量失败', error)
  }
}

// 调整库存
const handleUpdateStock = (row) => {
  stockForm.id = row.id
  stockForm.name = row.name
  stockForm.stock = row.stock
  stockForm.newStock = row.stock
  stockDialogVisible.value = true
}

// 提交库存调整
const submitStockForm = () => {
  stockFormRef.value.validate().then(async () => {
    try {
      await request({
        url: '/carsale/admin/vehicle/stock/update',
        method: 'put',
        data: {
          id: stockForm.id,
          stock: stockForm.newStock
        }
      })
      message.success('库存调整成功')
      stockDialogVisible.value = false
      getList()
      getLowStockCount()
    } catch (error) {
      message.error('库存调整失败')
    }
  }).catch(() => {
    // 验证失败
  })
}

// 重置库存表单
const resetStockForm = () => {
  stockFormRef.value?.resetFields()
  Object.assign(stockForm, {
    id: null,
    name: '',
    stock: null,
    newStock: null
  })
}

onMounted(() => {
  getList()
  getLowStockCount()
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
