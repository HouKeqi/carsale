<template>
  <div class="vehicle-list-container">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>车辆信息管理</span>
          <el-button type="primary" @click="handleAdd">新增车辆</el-button>
        </div>
      </template>

      <!-- 搜索表单 -->
      <el-form :inline="true" :model="queryParams" class="search-form">
        <el-form-item label="车型名称">
          <el-input
            v-model="queryParams.name"
            placeholder="请输入车型名称"
            clearable
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="品牌名称">
          <el-input
            v-model="queryParams.brand"
            placeholder="请输入品牌名称"
            clearable
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
          <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>

      <!-- 数据表格 -->
      <el-table
        v-loading="loading"
        :data="vehicleList"
        border
        style="width: 100%"
      >
        <el-table-column type="index" label="序号" width="60" align="center" />
        <el-table-column prop="name" label="车型名称" width="150" />
        <el-table-column prop="brand" label="品牌" width="120" />
        <el-table-column prop="price" label="指导价(元)" width="120" align="right">
          <template #default="scope">
            {{ formatPrice(scope.row.price) }}
          </template>
        </el-table-column>
        <el-table-column prop="batteryType" label="电池类型" width="100" />
        <el-table-column prop="rangeKm" label="续航里程(km)" width="120" align="center" />
        <el-table-column prop="stock" label="库存" width="100" align="center" />
        <el-table-column prop="launchDate" label="上市时间" width="120" />
        <el-table-column label="操作" width="200" align="center" fixed="right">
          <template #default="scope">
            <el-button
              type="primary"
              link
              size="small"
              @click="handleView(scope.row)"
            >
              查看
            </el-button>
            <el-button
              type="primary"
              link
              size="small"
              @click="handleEdit(scope.row)"
            >
              编辑
            </el-button>
            <el-button
              type="danger"
              link
              size="small"
              @click="handleDelete(scope.row)"
            >
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination-container">
        <el-pagination
          v-model:current-page="queryParams.pageNum"
          v-model:page-size="queryParams.pageSize"
          :page-sizes="[10, 20, 50, 100]"
          :total="total"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleQuery"
          @current-change="handleQuery"
        />
      </div>
    </el-card>

    <!-- 查看/编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="600px"
      @close="resetForm"
    >
      <el-form
        ref="formRef"
        :model="form"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="车型名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入车型名称" />
        </el-form-item>
        <el-form-item label="品牌名称" prop="brand">
          <el-input v-model="form.brand" placeholder="请输入品牌名称" />
        </el-form-item>
        <el-form-item label="指导价" prop="price">
          <el-input-number
            v-model="form.price"
            :precision="2"
            :min="0"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="电池类型" prop="batteryType">
          <el-input-number
            v-model="form.batteryType"
            :min="0"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="续航里程" prop="rangeKm">
          <el-input-number
            v-model="form.rangeKm"
            :min="0"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="库存数量" prop="stock">
          <el-input-number
            v-model="form.stock"
            :min="0"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="上市时间" prop="launchDate">
          <el-date-picker
            v-model="form.launchDate"
            type="date"
            placeholder="选择日期"
            style="width: 100%"
            value-format="YYYY-MM-DD"
          />
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input
            v-model="form.description"
            type="textarea"
            :rows="4"
            placeholder="请输入车辆描述"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  getVehicleList,
  getVehicleDetail,
  addVehicle,
  updateVehicle,
  deleteVehicle
} from '@/api/vehicle'

const loading = ref(false)
const vehicleList = ref([])
const total = ref(0)
const dialogVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref(null)
const isEdit = ref(false)

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  name: '',
  brand: ''
})

const form = reactive({
  id: null,
  name: '',
  brand: '',
  price: 0,
  batteryType: 0,
  rangeKm: 0,
  stock: 0,
  launchDate: '',
  description: ''
})

const rules = {
  name: [{ required: true, message: '车型名称不能为空', trigger: 'blur' }],
  brand: [{ required: true, message: '品牌名称不能为空', trigger: 'blur' }],
  price: [{ required: true, message: '指导价不能为空', trigger: 'blur' }]
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
    const res = await getVehicleList(queryParams)
    vehicleList.value = res.rows || res.data || []
    total.value = res.total || 0
  } catch (error) {
    ElMessage.error('获取车辆列表失败')
  } finally {
    loading.value = false
  }
}

// 搜索
const handleQuery = () => {
  queryParams.pageNum = 1
  getList()
}

// 重置
const resetQuery = () => {
  queryParams.name = ''
  queryParams.brand = ''
  handleQuery()
}

// 新增
const handleAdd = () => {
  isEdit.value = false
  dialogTitle.value = '新增车辆'
  dialogVisible.value = true
  resetForm()
}

// 查看
const handleView = async (row) => {
  isEdit.value = false
  dialogTitle.value = '查看车辆详情'
  dialogVisible.value = true
  try {
    const res = await getVehicleDetail(row.id)
    Object.assign(form, res.data)
  } catch (error) {
    ElMessage.error('获取车辆详情失败')
  }
}

// 编辑
const handleEdit = async (row) => {
  isEdit.value = true
  dialogTitle.value = '编辑车辆'
  dialogVisible.value = true
  try {
    const res = await getVehicleDetail(row.id)
    Object.assign(form, res.data)
  } catch (error) {
    ElMessage.error('获取车辆详情失败')
  }
}

// 删除
const handleDelete = (row) => {
  ElMessageBox.confirm('确定要删除该车辆信息吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  })
    .then(async () => {
      try {
        await deleteVehicle(row.id)
        ElMessage.success('删除成功')
        getList()
      } catch (error) {
        ElMessage.error('删除失败')
      }
    })
    .catch(() => {})
}

// 提交表单
const submitForm = () => {
  formRef.value.validate(async (valid) => {
    if (valid) {
      try {
        if (isEdit.value) {
          await updateVehicle(form)
          ElMessage.success('更新成功')
        } else {
          await addVehicle(form)
          ElMessage.success('新增成功')
        }
        dialogVisible.value = false
        getList()
      } catch (error) {
        ElMessage.error(isEdit.value ? '更新失败' : '新增失败')
      }
    }
  })
}

// 重置表单
const resetForm = () => {
  formRef.value?.resetFields()
  Object.assign(form, {
    id: null,
    name: '',
    brand: '',
    price: 0,
    batteryType: 0,
    rangeKm: 0,
    stock: 0,
    launchDate: '',
    description: ''
  })
}

onMounted(() => {
  getList()
})
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.vehicle-list-container {
  padding: 0;
}

:deep(.el-card) {
  border: none;
  border-radius: $radius-xl;
  box-shadow: $shadow-md;
  overflow: hidden;
  background: $bg-white;
  
  .el-card__header {
    background: $primary-bg;
    border-bottom: 1px solid $border-color;
    padding: 20px 24px;
  }
  
  .el-card__body {
    padding: 24px;
  }
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  
  span {
    font-size: 18px;
    font-weight: 600;
    color: $primary-color;
  }
  
  :deep(.el-button--primary) {
    background: $primary-color;
    border: none;
    border-radius: $radius-md;
    padding: 10px 20px;
    font-weight: 500;
    box-shadow: $shadow-sm;
    transition: all 0.3s ease;
    
    &:hover {
      background: $primary-hover;
      transform: translateY(-2px);
      box-shadow: $shadow-md;
    }
  }
}

.search-form {
  margin-bottom: 24px;
  padding: 20px;
  background: $bg-white;
  border-radius: $radius-lg;
  box-shadow: $shadow-sm;
  
  :deep(.el-form-item) {
    margin-bottom: 0;
  }
  
    :deep(.el-input__wrapper) {
    border-radius: $radius-md;
    box-shadow: $shadow-sm;
    transition: all 0.3s ease;
    
    &:hover {
      box-shadow: $shadow-md;
    }
  }
  
  :deep(.el-button) {
    border-radius: $radius-md;
    padding: 10px 20px;
    font-weight: 500;
    transition: all 0.3s ease;
    
    &.el-button--primary {
      background: $primary-color;
      border: none;
      box-shadow: $shadow-sm;
      
      &:hover {
        background: $primary-hover;
        transform: translateY(-2px);
        box-shadow: $shadow-md;
      }
    }
    
    &:not(.el-button--primary) {
      border-color: $border-color;
      color: $text-secondary;
      
      &:hover {
        border-color: $primary-color;
        color: $primary-color;
      }
    }
  }
}

:deep(.el-table) {
  border-radius: $radius-lg;
  overflow: hidden;
  
  .el-table__header {
    th {
      background: $bg-color;
      color: $text-primary;
      font-weight: 600;
      border-bottom: 2px solid $border-color;
      padding: 16px 0;
    }
  }
  
  .el-table__body {
    tr {
      transition: all 0.2s ease;
      
      &:hover {
        background: $primary-bg;
        transform: scale(1.01);
      }
    }
    
    td {
      border-bottom: 1px solid $border-color;
      padding: 16px 0;
      color: $text-primary;
    }
  }
  
  .el-table__border {
    border: 1px solid $border-color;
  }
}

:deep(.el-button--link) {
  padding: 4px 8px;
  font-weight: 500;
  border-radius: $radius-sm;
  transition: all 0.2s ease;
  
  &.el-button--primary {
    color: $primary-color;
    
    &:hover {
      background: $primary-bg;
      color: $primary-hover;
    }
  }
  
  &.el-button--danger {
    color: $danger-color;
    
    &:hover {
      background: rgba(239, 68, 68, 0.1);
      color: darken($danger-color, 10%);
    }
  }
}

.pagination-container {
  margin-top: 24px;
  display: flex;
  justify-content: flex-end;
  padding: 20px;
  background: $bg-white;
  border-radius: $radius-lg;
  box-shadow: $shadow-sm;
  
  :deep(.el-pagination) {
    .el-pagination__total,
    .el-pagination__sizes,
    .el-pagination__jump {
      color: $text-secondary;
      font-weight: 400;
    }
    
    .el-pager li {
      border-radius: $radius-sm;
      margin: 0 4px;
      transition: all 0.2s ease;
      
      &:hover {
        color: $primary-color;
        background: $primary-bg;
      }
      
      &.is-active {
        background: $primary-color;
        color: white;
        font-weight: 600;
      }
    }
    
    .btn-prev,
    .btn-next {
      border-radius: $radius-sm;
      transition: all 0.2s ease;
      
      &:hover {
        color: $primary-color;
        background: $primary-bg;
      }
    }
  }
}

:deep(.el-dialog) {
  border-radius: $radius-xl;
  overflow: hidden;
  
  .el-dialog__header {
    background: $primary-bg;
    padding: 20px 24px;
    border-bottom: 1px solid $border-color;
    
    .el-dialog__title {
      font-size: 18px;
      font-weight: 600;
      color: $primary-color;
    }
  }
  
  .el-dialog__body {
    padding: 24px;
  }
  
  .el-dialog__footer {
    padding: 16px 24px;
    border-top: 1px solid $border-color;
    background: $bg-color;
  }
}

:deep(.el-form-item) {
  margin-bottom: 20px;
  
  .el-form-item__label {
    color: $text-primary;
    font-weight: 500;
  }
  
  .el-input__wrapper {
    border-radius: $radius-md;
    transition: all 0.3s ease;
    
    &:hover {
      box-shadow: $shadow-md;
    }
  }
  
  .el-input__wrapper.is-focus {
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
  }
}

:deep(.el-button) {
  border-radius: $radius-md;
  font-weight: 500;
  transition: all 0.3s ease;
  
  &.el-button--primary {
    background: $primary-color;
    border: none;
    box-shadow: $shadow-sm;
    
    &:hover {
      background: $primary-hover;
      transform: translateY(-2px);
      box-shadow: $shadow-md;
    }
  }
}
</style>
