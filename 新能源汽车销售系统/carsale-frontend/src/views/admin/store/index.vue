<template>
  <a-card class="main-page">
    <!-- 搜索区域 -->
    <div>
      <a-input-search
        v-model:value="searchForm.name"
        placeholder="根据门店名称进行搜索"
        enter-button
        allowClear
        @search="search"
        style="width: 250px; float: right; margin-bottom: 1rem; margin-left: 1rem"
      />
      <a-select
        v-model:value="searchForm.status"
        placeholder="状态"
        allowClear
        style="width: 150px; float: right; margin-bottom: 1rem; margin-left: 1rem"
        @change="search"
      >
        <a-select-option :value="1">启用</a-select-option>
        <a-select-option :value="0">停用</a-select-option>
      </a-select>
      <a-button type="primary" style="float: right; margin-bottom: 1rem" @click="handleAdd">
        新增门店
      </a-button>
    </div>

    <a-table
      class="table"
      :columns="columns"
      :data-source="storeList"
      :pagination="pagination"
      :loading="loading"
      :row-selection="{ selectedRowKeys: selectedRowKeys, onChange: onSelectChange }"
      bordered
    >
      <template #bodyCell="{ column, record }">
        <template v-if="column.key === 'index'">
          {{ (pagination.current - 1) * pagination.pageSize + storeList.indexOf(record) + 1 }}
        </template>
        <template v-if="column.key === 'status'">
          <a-tag :color="record.status === 1 ? 'green' : 'red'">
            {{ record.status === 1 ? '启用' : '停用' }}
          </a-tag>
        </template>
        <template v-if="column.key === 'createTime'">
          {{ formatDateTime(record.createTime) }}
        </template>
        <template v-if="column.key === 'operation'">
          <span>
            <a @click="handleEdit(record)">编辑</a>
            <a-divider type="vertical" />
            <a @click="handleDelete(record)" style="color: #ff4d4f">删除</a>
          </span>
        </template>
      </template>
    </a-table>

    <!-- 新增/编辑门店对话框 -->
    <a-modal
      v-model:open="storeDialogVisible"
      :title="storeDialogTitle"
      width="600px"
      @ok="submitStoreForm"
      @cancel="resetStoreForm"
    >
      <a-form
        ref="storeFormRef"
        :model="storeForm"
        :rules="storeFormRules"
        :label-col="{ span: 6 }"
        :wrapper-col="{ span: 18 }"
      >
        <a-form-item label="门店名称" name="name">
          <a-input v-model:value="storeForm.name" placeholder="请输入门店名称" />
        </a-form-item>
        <a-form-item label="门店地址" name="address">
          <a-input v-model:value="storeForm.address" placeholder="请输入门店地址" />
        </a-form-item>
        <a-form-item label="联系电话" name="phone">
          <a-input v-model:value="storeForm.phone" placeholder="请输入联系电话" />
        </a-form-item>
        <a-form-item label="状态" name="status">
          <a-select v-model:value="storeForm.status" placeholder="请选择状态">
            <a-select-option :value="1">启用</a-select-option>
            <a-select-option :value="0">停用</a-select-option>
          </a-select>
        </a-form-item>
      </a-form>
      <template #footer>
        <a-button @click="storeDialogVisible = false">取消</a-button>
        <a-button type="primary" @click="submitStoreForm">确定</a-button>
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
const storeList = ref([])
const total = ref(0)
const storeDialogVisible = ref(false)
const storeDialogTitle = ref('')
const storeFormRef = ref(null)
const selectedRowKeys = ref([])
const isEdit = ref(false)

const searchForm = reactive({
  name: '',
  status: null
})

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  name: null,
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
    title: '门店名称',
    dataIndex: 'name',
    key: 'name',
    width: 200
  },
  {
    title: '门店地址',
    dataIndex: 'address',
    key: 'address',
    width: 300
  },
  {
    title: '联系电话',
    dataIndex: 'phone',
    key: 'phone',
    width: 150
  },
  {
    title: '状态',
    key: 'status',
    align: 'center',
    width: 100
  },
  {
    title: '创建时间',
    key: 'createTime',
    width: 180
  },
  {
    title: '操作',
    key: 'operation',
    align: 'center',
    width: 150,
    fixed: 'right'
  }
]

const storeForm = reactive({
  id: null,
  name: '',
  address: '',
  phone: '',
  status: 1
})

const storeFormRules = {
  name: [{ required: true, message: '门店名称不能为空', trigger: 'blur' }],
  phone: [
    { required: true, message: '联系电话不能为空', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$|^0\d{2,3}-?\d{7,8}$/, message: '请输入正确的联系电话', trigger: 'blur' }
  ],
  status: [{ required: true, message: '请选择状态', trigger: 'change' }]
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
      url: '/carsale/admin/store/list',
      method: 'get',
      params: queryParams
    })
    storeList.value = res.rows || res.data || []
    total.value = res.total || 0
    pagination.total = res.total || 0
  } catch (error) {
    message.error('获取门店列表失败')
  } finally {
    loading.value = false
  }
}

// 搜索
const search = () => {
  queryParams.name = searchForm.name || null
  queryParams.status = searchForm.status
  queryParams.pageNum = 1
  pagination.current = 1
  getList()
}

// 新增
const handleAdd = () => {
  isEdit.value = false
  storeDialogTitle.value = '新增门店'
  storeDialogVisible.value = true
  resetStoreForm()
}

// 编辑
const handleEdit = (row) => {
  isEdit.value = true
  storeDialogTitle.value = '编辑门店'
  storeDialogVisible.value = true
  Object.assign(storeForm, {
    id: row.id,
    name: row.name,
    address: row.address || '',
    phone: row.phone || '',
    status: row.status
  })
}

// 删除
const handleDelete = (row) => {
  Modal.confirm({
    title: '提示',
    content: '确定要删除该门店吗？',
    okText: '确定',
    cancelText: '取消',
    onOk: async () => {
      try {
        await request({
          url: '/carsale/admin/store/delete/' + row.id,
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
const submitStoreForm = () => {
  storeFormRef.value.validate().then(async () => {
    try {
      if (isEdit.value && storeForm.id) {
        await request({
          url: '/carsale/admin/store/update',
          method: 'put',
          data: storeForm
        })
        message.success('更新成功')
      } else {
        await request({
          url: '/carsale/admin/store/add',
          method: 'post',
          data: storeForm
        })
        message.success('新增成功')
      }
      storeDialogVisible.value = false
      getList()
    } catch (error) {
      message.error(isEdit.value ? '更新失败' : '新增失败')
    }
  }).catch(() => {
    // 验证失败
  })
}

// 重置表单
const resetStoreForm = () => {
  storeFormRef.value?.resetFields()
  Object.assign(storeForm, {
    id: null,
    name: '',
    address: '',
    phone: '',
    status: 1
  })
}

// 选择变化
const onSelectChange = (keys) => {
  selectedRowKeys.value = keys
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
