<template>
  <a-card class="main-page">
    <!-- 搜索区域 -->
    <div>
      <a-input-search
        v-model:value="searchForm.title"
        placeholder="根据活动名称进行搜索"
        enter-button
        allowClear
        @search="search"
        style="width: 250px; float: right; margin-bottom: 1rem; margin-left: 1rem"
      />
      <a-button type="primary" style="float: right; margin-bottom: 1rem" @click="handleAdd">
        新增促销
      </a-button>
    </div>

    <a-table
      class="table"
      :columns="columns"
      :data-source="promotionList"
      :pagination="pagination"
      :loading="loading"
      bordered
    >
      <template #bodyCell="{ column, record }">
        <template v-if="column.key === 'index'">
          {{ (pagination.current - 1) * pagination.pageSize + promotionList.indexOf(record) + 1 }}
        </template>
        <template v-if="column.key === 'vehicle'">
          {{ getVehicleName(record.vehicleId) }}
        </template>
        <template v-if="column.key === 'discountType'">
          {{ formatDiscountType(record.discountType) }}
        </template>
        <template v-if="column.key === 'discountValue'">
          {{ formatDiscountValue(record) }}
        </template>
        <template v-if="column.key === 'startTime'">
          {{ formatDateTime(record.startTime) }}
        </template>
        <template v-if="column.key === 'endTime'">
          {{ formatDateTime(record.endTime) }}
        </template>
        <template v-if="column.key === 'operation'">
          <span>
            <a @click="handleView(record)">查看</a>
            <a-divider type="vertical" />
            <a @click="handleEdit(record)">编辑</a>
            <a-divider type="vertical" />
            <a @click="handleDelete(record)" style="color: #ff4d4f">删除</a>
          </span>
        </template>
      </template>
    </a-table>

    <!-- 查看/编辑对话框 -->
    <a-modal
      v-model:open="dialogVisible"
      :title="dialogTitle"
      width="600px"
      @ok="submitForm"
      @cancel="resetForm"
    >
      <a-form
        ref="formRef"
        :model="form"
        :rules="rules"
        :label-col="{ span: 6 }"
        :wrapper-col="{ span: 18 }"
      >
        <a-form-item label="活动名称" name="title">
          <a-input v-model:value="form.title" placeholder="请输入活动名称" :disabled="!isEdit && dialogTitle === '查看促销详情'" />
        </a-form-item>
        <a-form-item label="关联车型" name="vehicleId">
          <a-select
            v-model:value="form.vehicleId"
            placeholder="请选择关联车型"
            style="width: 100%"
            :disabled="!isEdit && dialogTitle === '查看促销详情'"
            :options="vehicleOptions"
            :field-names="{ label: 'name', value: 'id' }"
          />
        </a-form-item>
        <a-form-item label="优惠类型" name="discountType">
          <a-select
            v-model:value="form.discountType"
            placeholder="请选择优惠类型"
            :disabled="!isEdit && dialogTitle === '查看促销详情'"
            @change="handleDiscountTypeChange"
          >
            <a-select-option :value="0">直降</a-select-option>
            <a-select-option :value="1">赠品</a-select-option>
            <a-select-option :value="2">置换补贴</a-select-option>
          </a-select>
        </a-form-item>
        <a-form-item 
          v-if="form.discountType === 0" 
          label="优惠金额" 
          name="discountAmount"
        >
          <a-input-number
            v-model:value="form.discountAmount"
            :precision="2"
            :min="0"
            style="width: 100%"
            placeholder="请输入优惠金额"
            :disabled="!isEdit && dialogTitle === '查看促销详情'"
          />
        </a-form-item>
        <a-form-item 
          v-if="form.discountType === 1 || form.discountType === 2" 
          label="描述文本" 
          name="description"
        >
          <a-textarea
            v-model:value="form.description"
            :rows="3"
            placeholder="请输入描述文本（如：价值3000元的充电桩、置换补贴5000元等）"
            :disabled="!isEdit && dialogTitle === '查看促销详情'"
          />
        </a-form-item>
        <a-form-item label="开始时间" name="startTime">
          <a-date-picker
            v-model:value="form.startTime"
            placeholder="选择开始时间"
            style="width: 100%"
            show-time
            format="YYYY-MM-DD HH:mm:ss"
            value-format="YYYY-MM-DD HH:mm:ss"
            :disabled="!isEdit && dialogTitle === '查看促销详情'"
          />
        </a-form-item>
        <a-form-item label="结束时间" name="endTime">
          <a-date-picker
            v-model:value="form.endTime"
            placeholder="选择结束时间"
            style="width: 100%"
            show-time
            format="YYYY-MM-DD HH:mm:ss"
            value-format="YYYY-MM-DD HH:mm:ss"
            :disabled="!isEdit && dialogTitle === '查看促销详情'"
          />
        </a-form-item>
        <a-form-item label="活动状态" name="status">
          <a-radio-group v-model:value="form.status" :disabled="!isEdit && dialogTitle === '查看促销详情'">
            <a-radio :value="0">下架</a-radio>
            <a-radio :value="1">上架</a-radio>
          </a-radio-group>
        </a-form-item>
      </a-form>
      <template #footer>
        <a-button @click="dialogVisible = false">取消</a-button>
        <a-button v-if="isEdit || dialogTitle === '新增促销'" type="primary" @click="submitForm">确定</a-button>
      </template>
    </a-modal>
  </a-card>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { message, Modal } from 'ant-design-vue'
import request from '@/utils/request'
import dayjs from 'dayjs'

const loading = ref(false)
const promotionList = ref([])
const total = ref(0)
const dialogVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref(null)
const isEdit = ref(false)
const vehicleMap = ref({})
const vehicleOptions = ref([])

const searchForm = reactive({
  title: ''
})

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  title: ''
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
    title: '活动名称',
    dataIndex: 'title',
    key: 'title',
    width: 200
  },
  {
    title: '关联车型',
    key: 'vehicle',
    width: 200
  },
  {
    title: '优惠类型',
    key: 'discountType',
    align: 'center',
    width: 120
  },
  {
    title: '优惠金额',
    key: 'discountValue',
    align: 'right',
    width: 120
  },
  {
    title: '开始时间',
    key: 'startTime',
    width: 180
  },
  {
    title: '结束时间',
    key: 'endTime',
    width: 180
  },
  {
    title: '活动状态',
    dataIndex: 'status',
    key: 'status',
    align: 'center',
    width: 100,
    customRender: ({ record }) => {
      return record.status === 1 ? '上架' : '下架'
    }
  },
  {
    title: '操作',
    key: 'operation',
    align: 'center',
    width: 200,
    fixed: 'right'
  }
]

const form = reactive({
  id: null,
  title: '',
  vehicleId: null,
  discountType: null,
  discountValue: 0,
  startTime: null,
  endTime: null,
  status: 1
})

const rules = {
  title: [{ required: true, message: '活动名称不能为空', trigger: 'blur' }],
  vehicleId: [{ required: true, message: '关联车型ID不能为空', trigger: 'blur' }],
  discountType: [{ required: true, message: '优惠类型不能为空', trigger: 'change' }],
  discountAmount: [
    { 
      required: true, 
      message: '优惠金额不能为空', 
      trigger: 'blur',
      validator: (rule, value) => {
        if (form.discountType === 0 && (!value || value <= 0)) {
          return Promise.reject('直降类型必须填写优惠金额')
        }
        return Promise.resolve()
      }
    }
  ],
  description: [
    { 
      required: true, 
      message: '描述文本不能为空', 
      trigger: 'blur',
      validator: (rule, value) => {
        if ((form.discountType === 1 || form.discountType === 2) && (!value || value.trim() === '')) {
          return Promise.reject('赠品或置换补贴类型必须填写描述文本')
        }
        return Promise.resolve()
      }
    }
  ],
  startTime: [{ required: true, message: '开始时间不能为空', trigger: 'change' }],
  endTime: [{ required: true, message: '结束时间不能为空', trigger: 'change' }]
}

// 格式化优惠类型
const formatDiscountType = (type) => {
  if (type === null || type === undefined) return '未选择'
  const typeMap = {
    0: '直降',
    1: '赠品',
    2: '置换补贴'
  }
  return typeMap[type] || '未知'
}

// 格式化优惠金额
const formatDiscountValue = (record) => {
  if (!record) return '-'
  // 直降类型显示优惠金额
  if (record.discountType === 0) {
    return record.discountAmount ? `¥${Number(record.discountAmount).toFixed(2)}` : '-'
  }
  // 赠品或置换补贴类型显示描述文本
  if (record.discountType === 1 || record.discountType === 2) {
    return record.description || '-'
  }
  return '-'
}

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

// 获取车型列表
const getVehicleList = async () => {
  try {
    const res = await request({
      url: '/carsale/admin/vehicle/list',
      method: 'get',
      params: { pageNum: 1, pageSize: 1000 }
    })
    const vehicles = res.rows || res.data || []
    vehicleMap.value = {}
    vehicleOptions.value = vehicles.map(v => ({
      id: v.id,
      name: `${v.brand} ${v.name}`,
      brand: v.brand
    }))
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
      url: '/carsale/admin/promotion/page',
      method: 'get',
      params: queryParams
    })
    promotionList.value = res.rows || res.data || []
    total.value = res.total || 0
    pagination.total = res.total || 0
  } catch (error) {
    message.error('获取促销列表失败')
  } finally {
    loading.value = false
  }
}

// 搜索
const search = () => {
  queryParams.title = searchForm.title
  queryParams.pageNum = 1
  pagination.current = 1
  getList()
}

// 重置
const resetQuery = () => {
  searchForm.title = ''
  queryParams.title = ''
  search()
}

// 新增
const handleAdd = () => {
  isEdit.value = true
  dialogTitle.value = '新增促销'
  dialogVisible.value = true
  resetForm()
}

// 查看
const handleView = async (row) => {
  isEdit.value = false
  dialogTitle.value = '查看促销详情'
  dialogVisible.value = true
  try {
    const res = await request({
      url: '/carsale/admin/promotion/detail/' + row.id,
      method: 'get'
    })
    Object.assign(form, res.data)
    // 处理日期时间
    if (form.startTime) {
      form.startTime = dayjs(form.startTime)
    }
    if (form.endTime) {
      form.endTime = dayjs(form.endTime)
    }
  } catch (error) {
    message.error('获取促销详情失败')
  }
}

// 编辑
const handleEdit = async (row) => {
  isEdit.value = true
  dialogTitle.value = '编辑促销'
  dialogVisible.value = true
  try {
    const res = await request({
      url: '/carsale/admin/promotion/detail/' + row.id,
      method: 'get'
    })
    Object.assign(form, res.data)
    // 处理日期时间
    if (form.startTime) {
      form.startTime = dayjs(form.startTime)
    }
    if (form.endTime) {
      form.endTime = dayjs(form.endTime)
    }
  } catch (error) {
    message.error('获取促销详情失败')
  }
}

// 删除
const handleDelete = (row) => {
  Modal.confirm({
    title: '提示',
    content: '确定要删除该促销活动吗？',
    okText: '确定',
    cancelText: '取消',
    onOk: async () => {
      try {
        // 注意：删除接口需要通过body传递id对象
        await request({
          url: '/carsale/admin/promotion/delete/' + row.id,
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

// 提交表单
const submitForm = () => {
  formRef.value.validate().then(async () => {
    try {
      const submitData = { ...form }
      
      // 处理日期时间 - 确保格式正确
      if (submitData.startTime) {
        if (dayjs.isDayjs(submitData.startTime)) {
          submitData.startTime = submitData.startTime.format('YYYY-MM-DD HH:mm:ss')
        } else if (typeof submitData.startTime === 'string') {
          // 如果已经是字符串，确保格式正确
          submitData.startTime = submitData.startTime
        } else {
          submitData.startTime = null
        }
      } else {
        submitData.startTime = null
      }
      
      if (submitData.endTime) {
        if (dayjs.isDayjs(submitData.endTime)) {
          submitData.endTime = submitData.endTime.format('YYYY-MM-DD HH:mm:ss')
        } else if (typeof submitData.endTime === 'string') {
          // 如果已经是字符串，确保格式正确
          submitData.endTime = submitData.endTime
        } else {
          submitData.endTime = null
        }
      } else {
        submitData.endTime = null
      }

      // 确保 vehicleId 是数字类型
      if (submitData.vehicleId !== null && submitData.vehicleId !== undefined) {
        submitData.vehicleId = Number(submitData.vehicleId)
      }
      
      // 确保 discountType 是数字类型
      if (submitData.discountType !== null && submitData.discountType !== undefined) {
        submitData.discountType = Number(submitData.discountType)
      }
      
      // 确保 discountAmount 是数字类型（直降类型）
      if (submitData.discountType === 0) {
        if (submitData.discountAmount !== null && submitData.discountAmount !== undefined) {
          submitData.discountAmount = Number(submitData.discountAmount)
        } else {
          submitData.discountAmount = 0
        }
        submitData.description = null
      } else {
        // 赠品或置换补贴类型，清空 discountAmount
        submitData.discountAmount = null
        if (!submitData.description) {
          submitData.description = ''
        }
      }
      
      // 保留 discountValue 用于兼容（可选）
      if (submitData.discountValue !== null && submitData.discountValue !== undefined) {
        submitData.discountValue = Number(submitData.discountValue)
      } else {
        submitData.discountValue = 0
      }
      
      // 确保 status 是数字类型
      if (submitData.status !== null && submitData.status !== undefined) {
        submitData.status = Number(submitData.status)
      } else {
        submitData.status = 1
      }
      
      // 新增时移除 id
      if (!isEdit.value || !form.id) {
        delete submitData.id
      }

      if (isEdit.value && form.id) {
        await request({
          url: '/carsale/admin/promotion/update',
          method: 'put',
          data: submitData
        })
        message.success('更新成功')
      } else {
        await request({
          url: '/carsale/admin/promotion/add',
          method: 'post',
          data: submitData
        })
        message.success('新增成功')
      }
      dialogVisible.value = false
      getList()
    } catch (error) {
      console.error('提交失败:', error)
      const errorMsg = error.response?.data?.msg || error.response?.data?.message || error.message || '操作失败'
      message.error(errorMsg)
    }
  }).catch((error) => {
    // 验证失败
    console.error('表单验证失败:', error)
    if (error.errorFields) {
      message.error('请填写完整的表单信息')
    }
  })
}

// 重置表单
const resetForm = () => {
  formRef.value?.resetFields()
  Object.assign(form, {
    id: null,
    title: '',
    vehicleId: null,
    discountType: null,
    discountAmount: 0,
    description: '',
    discountValue: 0,
    startTime: null,
    endTime: null,
    status: 1
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
  height: 90vh;
  overflow-y: auto;
}
</style>
