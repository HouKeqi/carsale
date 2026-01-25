<template>
  <a-card class="main-page">
    <!-- 搜索区域 -->
    <div>
      <a-input-search
        v-model:value="searchForm.userName"
        placeholder="根据用户名称进行搜索"
        enter-button
        allowClear
        @search="search"
        style="width: 250px; float: right; margin-bottom: 1rem; margin-left: 1rem"
      />
      <a-input-search
        v-model:value="searchForm.phonenumber"
        placeholder="根据手机号码进行搜索"
        enter-button
        allowClear
        @search="search"
        style="width: 250px; float: right; margin-bottom: 1rem; margin-left: 1rem"
      />
      <a-button type="primary" style="float: right; margin-bottom: 1rem" @click="handleAdd">
        新增用户
      </a-button>
    </div>

    <a-table
      class="table"
      :columns="columns"
      :data-source="userList"
      :pagination="pagination"
      :loading="loading"
      :row-selection="{ selectedRowKeys: selectedRowKeys, onChange: onSelectChange }"
      bordered
    >
      <template #bodyCell="{ column, record }">
        <template v-if="column.key === 'index'">
          {{ (pagination.current - 1) * pagination.pageSize + userList.indexOf(record) + 1 }}
        </template>
        <template v-if="column.key === 'role'">
          {{ formatRole(record.roles) }}
        </template>
        <template v-if="column.key === 'createTime'">
          {{ formatDateTime(record.createTime) }}
        </template>
        <template v-if="column.key === 'operation'">
          <span>
            <a @click="handleEdit(record)">编辑</a>
            <a-divider type="vertical" />
            <a @click="handleAssignRole(record)">分配角色</a>
            <a-divider type="vertical" />
            <a @click="handleViewOrders(record.userId)">购车记录</a>
            <a-divider type="vertical" />
            <a @click="handleViewPreferences(record.userId)">浏览偏好</a>
            <a-divider type="vertical" />
            <a @click="handleDelete(record)" style="color: #ff4d4f">删除</a>
          </span>
        </template>
      </template>
    </a-table>

    <!-- 新增/编辑用户对话框 -->
    <a-modal
      v-model:open="userDialogVisible"
      :title="userDialogTitle"
      width="600px"
      @ok="submitUserForm"
      @cancel="resetUserForm"
    >
      <a-form
        ref="userFormRef"
        :model="userForm"
        :rules="userFormRules"
        :label-col="{ span: 6 }"
        :wrapper-col="{ span: 18 }"
      >
        <a-form-item label="用户名称" name="userName">
          <a-input v-model:value="userForm.userName" placeholder="请输入用户名称" />
        </a-form-item>
        <a-form-item label="真实姓名" name="nickName">
          <a-input v-model:value="userForm.nickName" placeholder="请输入真实姓名" />
        </a-form-item>
        <a-form-item label="手机号码" name="phonenumber">
          <a-input v-model:value="userForm.phonenumber" placeholder="请输入手机号码" />
        </a-form-item>
        <a-form-item label="身份证号" name="idCard">
          <a-input v-model:value="userForm.idCard" placeholder="请输入身份证号" />
        </a-form-item>
        <a-form-item label="地址" name="address">
          <a-input v-model:value="userForm.address" placeholder="请输入地址" />
        </a-form-item>
        <a-form-item label="角色" name="roleIds">
          <a-select
            v-model:value="userForm.roleIds"
            mode="multiple"
            placeholder="请选择角色"
            :options="roleOptions"
            :field-names="{ label: 'roleName', value: 'roleId' }"
          />
        </a-form-item>
        <a-form-item v-if="!userForm.userId" label="密码" name="password">
          <a-input-password v-model:value="userForm.password" placeholder="请输入密码（默认123456）" />
        </a-form-item>
      </a-form>
    </a-modal>

    <!-- 分配角色对话框 -->
    <a-modal
      v-model:open="roleDialogVisible"
      title="分配角色"
      width="500px"
      @ok="submitRoleForm"
      @cancel="resetRoleForm"
    >
      <a-form
        ref="roleFormRef"
        :model="roleForm"
        :rules="roleFormRules"
        :label-col="{ span: 6 }"
        :wrapper-col="{ span: 18 }"
      >
        <a-form-item label="用户名称">
          <a-input v-model:value="roleForm.userName" disabled />
        </a-form-item>
        <a-form-item label="角色" name="roleIds">
          <a-select
            v-model:value="roleForm.roleIds"
            mode="multiple"
            placeholder="请选择角色"
            :options="roleOptions"
            :field-names="{ label: 'roleName', value: 'roleId' }"
          />
        </a-form-item>
      </a-form>
    </a-modal>

    <!-- 购车记录对话框 -->
    <a-modal
      v-model:open="ordersDialogVisible"
      title="购车记录"
      width="1000px"
      :footer="null"
    >
      <a-table
        :columns="orderColumns"
        :data-source="userOrders"
        :loading="ordersLoading"
        :pagination="false"
        bordered
      >
        <template #bodyCell="{ column, record }">
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
        </template>
      </a-table>
    </a-modal>

    <!-- 浏览偏好对话框 -->
    <a-modal
      v-model:open="preferencesDialogVisible"
      title="浏览偏好"
      width="800px"
      :footer="null"
    >
      <a-descriptions :column="2" bordered>
        <a-descriptions-item label="订单数量">{{ preferences.orderCount || 0 }}</a-descriptions-item>
        <a-descriptions-item label="评价数量">{{ preferences.evaluationCount || 0 }}</a-descriptions-item>
      </a-descriptions>
      <a-divider />
      <h4>订单列表</h4>
      <a-table
        :columns="orderColumns"
        :data-source="preferences.orders || []"
        :pagination="false"
        style="margin-top: 10px"
        bordered
      >
        <template #bodyCell="{ column, record }">
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
        </template>
      </a-table>
    </a-modal>
  </a-card>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { message, Modal } from 'ant-design-vue'
import request from '@/utils/request'
import dayjs from 'dayjs'

const loading = ref(false)
const userList = ref([])
const total = ref(0)
const userOrders = ref([])
const ordersLoading = ref(false)
const ordersDialogVisible = ref(false)
const preferences = ref({})
const preferencesDialogVisible = ref(false)
const userDialogVisible = ref(false)
const userDialogTitle = ref('新增用户')
const roleDialogVisible = ref(false)
const selectedRowKeys = ref([])
const vehicleMap = ref({})
const roleOptions = ref([])

const searchForm = reactive({
  userName: '',
  phonenumber: ''
})

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  userName: null,
  phonenumber: null
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
    title: '用户名称',
    dataIndex: 'userName',
    key: 'userName',
    width: 120
  },
  {
    title: '真实姓名',
    dataIndex: 'nickName',
    key: 'nickName',
    width: 120
  },
  {
    title: '手机号码',
    dataIndex: 'phonenumber',
    key: 'phonenumber',
    width: 120
  },
  {
    title: '身份证号',
    dataIndex: 'idCard',
    key: 'idCard',
    width: 180
  },
  {
    title: '地址',
    dataIndex: 'address',
    key: 'address'
  },
  {
    title: '角色',
    key: 'role',
    width: 120
  },
  {
    title: '注册时间',
    key: 'createTime',
    width: 180
  },
  {
    title: '操作',
    key: 'operation',
    align: 'center',
    width: 300,
    fixed: 'right'
  }
]

const orderColumns = [
  {
    title: '订单编号',
    dataIndex: 'id',
    key: 'id',
    width: 180
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
    title: '下单时间',
    key: 'createTime',
    width: 180
  }
]

const userFormRef = ref(null)
const roleFormRef = ref(null)

const userForm = reactive({
  userId: null,
  userName: '',
  nickName: '',
  phonenumber: '',
  idCard: '',
  address: '',
  roleIds: [],
  password: ''
})

const userFormRules = {
  userName: [{ required: true, message: '请输入用户名称', trigger: 'blur' }],
  nickName: [{ required: true, message: '请输入真实姓名', trigger: 'blur' }],
  phonenumber: [
    { required: true, message: '请输入手机号码', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
  ],
  roleIds: [{ required: true, message: '请选择角色', trigger: 'change' }]
}

const roleForm = reactive({
  userId: null,
  userName: '',
  roleIds: []
})

const roleFormRules = {
  roleIds: [{ required: true, message: '请选择角色', trigger: 'change' }]
}

// 格式化角色
const formatRole = (roles) => {
  if (!roles || roles.length === 0) return '-'
  return roles.map(r => r.roleName || r.roleKey).join(', ')
}

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
    vehicles.forEach(v => {
      vehicleMap.value[v.id] = v
    })
  } catch (error) {
    console.error('获取车型列表失败', error)
  }
}

// 获取角色列表
const getRoleList = async () => {
  try {
    const res = await request({
      url: '/carsale/admin/user/roles',
      method: 'get'
    })
    roleOptions.value = res.data || []
  } catch (error) {
    message.error('获取角色列表失败')
  }
}

// 查询列表
const getList = async () => {
  loading.value = true
  try {
    const res = await request({
      url: '/carsale/admin/user/list',
      method: 'get',
      params: queryParams
    })
    userList.value = res.rows || res.data || []
    total.value = res.total || 0
    pagination.total = res.total || 0
  } catch (error) {
    message.error('获取用户列表失败')
  } finally {
    loading.value = false
  }
}

// 搜索
const search = () => {
  queryParams.userName = searchForm.userName || null
  queryParams.phonenumber = searchForm.phonenumber || null
  queryParams.pageNum = 1
  pagination.current = 1
  getList()
}

// 选择变化
const onSelectChange = (keys) => {
  selectedRowKeys.value = keys
}

// 新增用户
const handleAdd = () => {
  userDialogTitle.value = '新增用户'
  resetUserForm()
  userDialogVisible.value = true
}

// 编辑用户
const handleEdit = async (record) => {
  userDialogTitle.value = '编辑用户'
  try {
    const res = await request({
      url: '/carsale/admin/user/detail/' + record.userId,
      method: 'get'
    })
    const user = res.data
    Object.assign(userForm, {
      userId: user.userId,
      userName: user.userName,
      nickName: user.nickName || '',
      phonenumber: user.phonenumber || '',
      idCard: user.idCard || '',
      address: user.address || '',
      roleIds: res.roleIds || [],
      password: ''
    })
    userDialogVisible.value = true
  } catch (error) {
    message.error('获取用户信息失败')
  }
}

// 删除用户
const handleDelete = (record) => {
  Modal.confirm({
    title: '提示',
    content: `确定要删除用户"${record.userName}"吗？`,
    okText: '确定',
    cancelText: '取消',
    onOk: async () => {
      try {
        await request({
          url: '/carsale/admin/user/delete/' + record.userId,
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

// 分配角色
const handleAssignRole = async (record) => {
  try {
    const res = await request({
      url: '/carsale/admin/user/detail/' + record.userId,
      method: 'get'
    })
    Object.assign(roleForm, {
      userId: record.userId,
      userName: record.userName,
      roleIds: res.roleIds || []
    })
    roleDialogVisible.value = true
  } catch (error) {
    message.error('获取用户信息失败')
  }
}

// 提交用户表单
const submitUserForm = () => {
  userFormRef.value.validate().then(async () => {
    try {
      const url = userForm.userId
        ? '/carsale/admin/user/edit'
        : '/carsale/admin/user/add'
      const data = { ...userForm }
      if (!data.password && !userForm.userId) {
        data.password = '123456'
      }
      if (!data.password) {
        delete data.password
      }
      await request({
        url,
        method: userForm.userId ? 'put' : 'post',
        data
      })
      message.success(userForm.userId ? '修改成功' : '新增成功')
      userDialogVisible.value = false
      resetUserForm()
      getList()
    } catch (error) {
      message.error(userForm.userId ? '修改失败' : '新增失败')
    }
  }).catch(() => {
    // 验证失败
  })
}

// 提交角色表单
const submitRoleForm = () => {
  roleFormRef.value.validate().then(async () => {
    try {
      await request({
        url: '/carsale/admin/user/assign-role',
        method: 'put',
        data: {
          userId: roleForm.userId,
          roleIds: roleForm.roleIds
        }
      })
      message.success('分配角色成功')
      roleDialogVisible.value = false
      resetRoleForm()
      getList()
    } catch (error) {
      message.error('分配角色失败')
    }
  }).catch(() => {
    // 验证失败
  })
}

// 重置用户表单
const resetUserForm = () => {
  userFormRef.value?.resetFields()
  Object.assign(userForm, {
    userId: null,
    userName: '',
    nickName: '',
    phonenumber: '',
    idCard: '',
    address: '',
    roleIds: [],
    password: ''
  })
}

// 重置角色表单
const resetRoleForm = () => {
  roleFormRef.value?.resetFields()
  Object.assign(roleForm, {
    userId: null,
    userName: '',
    roleIds: []
  })
}

// 查看购车记录
const handleViewOrders = async (userId) => {
  ordersDialogVisible.value = true
  ordersLoading.value = true
  try {
    const res = await request({
      url: '/carsale/admin/user/' + userId + '/orders',
      method: 'get',
      params: { pageNum: 1, pageSize: 100 }
    })
    userOrders.value = res.rows || res.data || []
  } catch (error) {
    message.error('获取购车记录失败')
  } finally {
    ordersLoading.value = false
  }
}

// 查看浏览偏好
const handleViewPreferences = async (userId) => {
  preferencesDialogVisible.value = true
  try {
    const res = await request({
      url: '/carsale/admin/user/' + userId + '/preferences',
      method: 'get'
    })
    preferences.value = res.data || {}
  } catch (error) {
    message.error('获取浏览偏好失败')
  }
}

onMounted(() => {
  getList()
  getRoleList()
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
