<template>
  <a-card class="main-page">
    <template #title>
      <span style="font-size: 18px; font-weight: bold">车辆管理</span>
    </template>

    <!-- 搜索区域 -->
    <a-form layout="inline" :model="queryParams" style="margin-bottom: 16px">
      <a-form-item label="车型名称">
        <a-input
          v-model:value="queryParams.name"
          placeholder="请输入车型名称"
          allowClear
          style="width: 200px"
          @pressEnter="handleQuery"
        />
      </a-form-item>
      <a-form-item label="品牌">
        <a-select
          v-model:value="queryParams.brand"
          placeholder="请选择品牌"
          allowClear
          style="width: 150px"
        >
          <a-select-option v-for="brand in brandOptions" :key="brand" :value="brand">
            {{ brand }}
          </a-select-option>
        </a-select>
      </a-form-item>
      <a-form-item label="价格范围">
        <a-input-number
          v-model:value="queryParams.minPrice"
          :min="0"
          :precision="0"
          placeholder="最低价"
          style="width: 120px"
        />
        <span style="margin: 0 8px">-</span>
        <a-input-number
          v-model:value="queryParams.maxPrice"
          :min="0"
          :precision="0"
          placeholder="最高价"
          style="width: 120px"
        />
      </a-form-item>
      <a-form-item label="续航里程">
        <a-input-number
          v-model:value="queryParams.minRangeKm"
          :min="0"
          placeholder="最小"
          style="width: 100px"
        />
        <span style="margin: 0 8px">-</span>
        <a-input-number
          v-model:value="queryParams.maxRangeKm"
          :min="0"
          placeholder="最大"
          style="width: 100px"
        />
        <span style="margin-left: 8px">km</span>
      </a-form-item>
      <a-form-item label="电池类型">
        <a-select
          v-model:value="queryParams.batteryType"
          placeholder="请选择"
          allowClear
          style="width: 150px"
        >
          <a-select-option :value="0">三元锂电池</a-select-option>
          <a-select-option :value="1">磷酸铁锂电池</a-select-option>
          <a-select-option :value="2">其他</a-select-option>
        </a-select>
      </a-form-item>
      <a-form-item label="库存状态">
        <a-select
          v-model:value="queryParams.stockStatus"
          placeholder="请选择"
          allowClear
          style="width: 120px"
        >
          <a-select-option value="sufficient">充足</a-select-option>
          <a-select-option value="warning">预警(≤5)</a-select-option>
          <a-select-option value="out">缺货(=0)</a-select-option>
        </a-select>
      </a-form-item>
      <a-form-item>
        <a-button type="primary" @click="handleQuery">
          <template #icon><SearchOutlined /></template>
          搜索
        </a-button>
        <a-button style="margin-left: 8px" @click="resetQuery">
          <template #icon><ReloadOutlined /></template>
          重置
        </a-button>
      </a-form-item>
    </a-form>

    <!-- 操作按钮 -->
    <div style="margin-bottom: 16px">
      <a-button type="primary" @click="handleAdd">
        <template #icon><PlusOutlined /></template>
        新增
      </a-button>
      <a-button
        type="primary"
        danger
        :disabled="!hasSelected"
        style="margin-left: 8px"
        @click="handleBatchDelete"
      >
        <template #icon><DeleteOutlined /></template>
        批量删除
      </a-button>
    </div>

    <!-- 表格 -->
    <a-table
      :columns="columns"
      :data-source="vehicleList"
      :loading="loading"
      :pagination="pagination"
      :row-selection="{ selectedRowKeys: selectedRowKeys, onChange: onSelectChange }"
      row-key="id"
      @change="handleTableChange"
    >
      <template #bodyCell="{ column, record }">
        <template v-if="column.dataIndex === 'price'">
          <span style="color: #f56c6c; font-weight: bold">
            ¥{{ formatPrice(record.price) }}
          </span>
        </template>
        <template v-else-if="column.dataIndex === 'batteryType'">
          <a-tag v-if="record.batteryType === 0" color="success">三元锂电池</a-tag>
          <a-tag v-else-if="record.batteryType === 1" color="warning">磷酸铁锂电池</a-tag>
          <a-tag v-else-if="record.batteryType === 2" color="default">其他</a-tag>
          <span v-else>-</span>
        </template>
        <template v-else-if="column.dataIndex === 'rangeKm'">
          <span style="color: #409eff">{{ record.rangeKm }}km</span>
        </template>
        <template v-else-if="column.dataIndex === 'stock'">
          <span v-if="record.stock === 0" >缺货</span>
          <span v-else-if="record.stock <= 5">{{ record.stock }}</span>
          <span v-else >{{ record.stock }}</span>
        </template>
        <template v-else-if="column.key === 'action'">
          <a-button type="link" size="small" @click="handleView(record)">查看</a-button>
          <a-button type="link" size="small" @click="handleUpdate(record)">修改</a-button>
          <a-button type="link" size="small" danger @click="handleDelete(record)">删除</a-button>
        </template>
      </template>
    </a-table>

    <!-- 新增/修改对话框 -->
    <a-modal
      v-model:open="modalVisible"
      :title="modalTitle"
      :width="800"
      @ok="handleSubmit"
      @cancel="handleCancel"
    >
      <a-form
        ref="formRef"
        :model="form"
        :rules="rules"
        :label-col="{ span: 6 }"
        :wrapper-col="{ span: 18 }"
      >
        <a-form-item label="车型名称" name="name">
          <a-input v-model:value="form.name" placeholder="请输入车型名称" />
        </a-form-item>
        <a-form-item label="品牌" name="brand">
          <a-input v-model:value="form.brand" placeholder="请输入品牌" />
        </a-form-item>
        <a-form-item label="指导价" name="price">
          <a-input-number
            v-model:value="form.price"
            :min="0"
            :precision="2"
            style="width: 100%"
            placeholder="请输入指导价"
          />
        </a-form-item>
        <a-form-item label="电池类型" name="batteryType">
          <a-select v-model:value="form.batteryType" placeholder="请选择电池类型" style="width: 100%">
            <a-select-option :value="0">三元锂电池</a-select-option>
            <a-select-option :value="1">磷酸铁锂电池</a-select-option>
            <a-select-option :value="2">其他</a-select-option>
          </a-select>
        </a-form-item>
        <a-form-item label="续航里程(km)" name="rangeKm">
          <a-input-number
            v-model:value="form.rangeKm"
            :min="0"
            style="width: 100%"
            placeholder="请输入续航里程"
          />
        </a-form-item>
        <a-form-item label="库存数量" name="stock">
          <a-input-number
            v-model:value="form.stock"
            :min="0"
            style="width: 100%"
            placeholder="请输入库存数量"
          />
        </a-form-item>
        <a-form-item label="上市时间" name="launchDate">
          <a-date-picker
            v-model:value="form.launchDate"
            format="YYYY-MM-DD"
            style="width: 100%"
            placeholder="选择上市时间"
          />
        </a-form-item>
        <a-form-item label="快充时间" name="fastCharge">
          <a-input
            v-model:value="form.fastCharge"
            placeholder="请输入快充时间，如：0.5h"
          />
        </a-form-item>
        <a-form-item label="智能驾驶等级" name="aiLevel">
          <a-input
            v-model:value="form.aiLevel"
            placeholder="请输入智能驾驶等级，如：L2"
          />
        </a-form-item>
        <a-form-item label="车辆描述" name="description">
          <a-textarea
            v-model:value="form.description"
            :rows="4"
            placeholder="请输入车辆描述信息"
            :maxlength="500"
            show-count
          />
        </a-form-item>
        <a-form-item label="车辆图片" name="imageUrl">
          <a-upload
            :file-list="imageFileList"
            list-type="picture-card"
            :before-upload="beforeUpload"
            @preview="handleImagePreview"
            @remove="handleImageRemove"
          >
            <div v-if="imageFileList.length < 1">
              <PlusOutlined />
              <div style="margin-top: 8px">上传</div>
            </div>
          </a-upload>
          <a-modal :open="previewVisible" :footer="null" @cancel="previewVisible = false">
            <img alt="预览" style="width: 100%" :src="previewImage" />
          </a-modal>
          <div style="color: #909399; font-size: 12px; margin-top: 5px">
            支持格式：PNG、JPG、JPEG，大小不超过5MB
          </div>
        </a-form-item>
      </a-form>
    </a-modal>

    <!-- 查看详情对话框 -->
    <a-modal
      v-model:open="viewModalVisible"
      title="车辆详细信息"
      :width="600"
      :footer="null"
    >
      <a-descriptions :column="1" bordered>
        <a-descriptions-item label="车辆编号">{{ viewData.id }}</a-descriptions-item>
        <a-descriptions-item label="车型名称">{{ viewData.name || '-' }}</a-descriptions-item>
        <a-descriptions-item label="品牌">{{ viewData.brand || '-' }}</a-descriptions-item>
        <a-descriptions-item label="指导价">
          ¥{{ formatPrice(viewData.price) }}
        </a-descriptions-item>
        <a-descriptions-item label="电池类型">
          <a-tag v-if="viewData.batteryType === 0" color="success">三元锂电池</a-tag>
          <a-tag v-else-if="viewData.batteryType === 1" color="warning">磷酸铁锂电池</a-tag>
          <a-tag v-else-if="viewData.batteryType === 2" color="default">其他</a-tag>
          <span v-else>-</span>
        </a-descriptions-item>
        <a-descriptions-item label="续航里程">{{ viewData.rangeKm || '-' }}km</a-descriptions-item>
        <a-descriptions-item label="库存数量">
          <a-tag v-if="viewData.stock === 0" color="red">缺货</a-tag>
          <a-tag v-else-if="viewData.stock <= 5" color="orange">{{ viewData.stock }}</a-tag>
          <a-tag v-else color="green">{{ viewData.stock }}</a-tag>
        </a-descriptions-item>
        <a-descriptions-item label="上市时间">{{ viewData.launchDate || '-' }}</a-descriptions-item>
        <a-descriptions-item label="配置参数">{{ viewData.configJson || '-' }}</a-descriptions-item>
        <a-descriptions-item label="车辆描述">{{ viewData.description || '-' }}</a-descriptions-item>
        <a-descriptions-item label="车辆图片" v-if="viewData.imageUrl">
          <img :src="viewData.imageUrl" style="max-width: 300px; max-height: 200px" />
        </a-descriptions-item>
      </a-descriptions>
    </a-modal>
  </a-card>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { message, Modal } from 'ant-design-vue'
import {
  SearchOutlined,
  ReloadOutlined,
  PlusOutlined,
  DeleteOutlined
} from '@ant-design/icons-vue'
import request from '@/utils/request'
import dayjs from 'dayjs'
import {
  getAdminVehicleList,
  getAdminVehicleDetail,
  addVehicle,
  updateVehicle,
  deleteVehicle
} from '@/api/vehicle'

const loading = ref(false)
const vehicleList = ref([])
const brandOptions = ref([])
const selectedRowKeys = ref([])
const hasSelected = ref(false)
const modalVisible = ref(false)
const viewModalVisible = ref(false)
const modalTitle = ref('新增车辆')
const formRef = ref(null)
const viewData = ref({})
const imageFileList = ref([])
const previewVisible = ref(false)
const previewImage = ref('')

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  name: null,
  brand: null,
  minPrice: null,
  maxPrice: null,
  minRangeKm: null,
  maxRangeKm: null,
  batteryType: null,
  stockStatus: null,
  orderByColumn: null,
  isAsc: null
})

const pagination = reactive({
  current: 1,
  pageSize: 10,
  total: 0,
  showSizeChanger: true,
  showTotal: (total) => `共 ${total} 条`,
  pageSizeOptions: ['10', '20', '50', '100']
})

const form = reactive({
  id: null,
  name: null,
  brand: null,
  price: null,
  batteryType: null,
  rangeKm: null,
  stock: null,
  launchDate: null,
  configJson: null,
  fastCharge: null,
  aiLevel: null,
  description: null,
  imageUrl: null
})

const rules = {
  name: [{ required: true, message: '车型名称不能为空', trigger: 'blur' }],
  brand: [{ required: true, message: '品牌不能为空', trigger: 'blur' }],
  price: [{ required: true, message: '指导价不能为空', trigger: 'blur' }],
  batteryType: [{ required: true, message: '电池类型不能为空', trigger: 'change' }],
  rangeKm: [{ required: true, message: '续航里程不能为空', trigger: 'blur' }],
  stock: [{ required: true, message: '库存数量不能为空', trigger: 'blur' }]
}

const columns = [
  {
    title: '车辆编号',
    dataIndex: 'id',
    key: 'id',
    width: 100,
    sorter: true
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
    title: '指导价',
    dataIndex: 'price',
    key: 'price',
    width: 130,
    sorter: true
  },
  {
    title: '电池类型',
    dataIndex: 'batteryType',
    key: 'batteryType',
    width: 120
  },
  {
    title: '续航里程',
    dataIndex: 'rangeKm',
    key: 'rangeKm',
    width: 120,
    sorter: true
  },
  {
    title: '库存数量',
    dataIndex: 'stock',
    key: 'stock',
    width: 120,
    sorter: true
  },
  {
    title: '上市时间',
    dataIndex: 'launchDate',
    key: 'launchDate',
    width: 120
  },
  {
    title: '操作',
    key: 'action',
    width: 180,
    fixed: 'right'
  }
]

// 格式化价格
const formatPrice = (price) => {
  if (!price) return '0.00'
  return Number(price).toLocaleString('zh-CN', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2
  })
}

// 提取品牌列表
const extractBrands = async () => {
  try {
    const res = await getAdminVehicleList({ pageNum: 1, pageSize: 1000 })
    const allVehicles = res.rows || res.data || []
    const brands = [...new Set(allVehicles.map(v => v.brand).filter(b => b))].sort()
    brandOptions.value = brands
  } catch (error) {
    console.error('获取品牌列表失败', error)
  }
}

// 查询列表
const getList = async () => {
  loading.value = true
  try {
    const params = { ...queryParams }
    // 处理库存状态筛选
    if (params.stockStatus === 'out') {
      params.stock = 0
      params.stockStatus = null
    } else if (params.stockStatus) {
      params.stockStatus = null
    }

    const res = await getAdminVehicleList(params)
    let list = res.rows || res.data || []

    // 前端过滤库存状态（如果后端不支持）
    if (queryParams.stockStatus === 'warning') {
      list = list.filter(item => item.stock > 0 && item.stock <= 5)
    } else if (queryParams.stockStatus === 'sufficient') {
      list = list.filter(item => item.stock > 5)
    }

    vehicleList.value = list
    pagination.total = res.total || list.length
    
    // 更新品牌列表
    extractBrands()
  } catch (error) {
    message.error('获取车辆列表失败')
  } finally {
    loading.value = false
  }
}

// 搜索
const handleQuery = () => {
  queryParams.pageNum = 1
  pagination.current = 1
  getList()
}

// 重置
const resetQuery = () => {
  Object.assign(queryParams, {
    pageNum: 1,
    pageSize: 10,
    name: null,
    brand: null,
    minPrice: null,
    maxPrice: null,
    minRangeKm: null,
    maxRangeKm: null,
    batteryType: null,
    stockStatus: null,
    orderByColumn: null,
    isAsc: null
  })
  pagination.current = 1
  handleQuery()
}

// 表格变化（分页、排序）
const handleTableChange = (pag, filters, sorter) => {
  pagination.current = pag.current
  pagination.pageSize = pag.pageSize
  queryParams.pageNum = pag.current
  queryParams.pageSize = pag.pageSize

  if (sorter.field) {
    queryParams.orderByColumn = sorter.field
    queryParams.isAsc = sorter.order === 'ascend' ? 'ASC' : 'DESC'
  }

  getList()
}

// 选择变化
const onSelectChange = (keys) => {
  selectedRowKeys.value = keys
  hasSelected.value = keys.length > 0
}

// 新增
const handleAdd = () => {
  modalTitle.value = '新增车辆'
  modalVisible.value = true
  resetForm()
}

// 修改
const handleUpdate = async (record) => {
  modalTitle.value = '修改车辆'
  modalVisible.value = true
  resetForm()

  try {
    const res = await getAdminVehicleDetail(record.id)
    const data = res.data || res
    // 解析配置参数JSON
    let fastCharge = null
    let aiLevel = null
    if (data.configJson) {
      try {
        const config = JSON.parse(data.configJson)
        fastCharge = config.fast_charge || null
        aiLevel = config.ai_level || null
      } catch (e) {
        console.error('解析配置参数失败', e)
      }
    }
    Object.assign(form, {
      id: data.id,
      name: data.name,
      brand: data.brand,
      price: data.price,
      batteryType: data.batteryType,
      rangeKm: data.rangeKm,
      stock: data.stock,
      launchDate: data.launchDate ? dayjs(data.launchDate) : null,
      configJson: data.configJson,
      fastCharge: fastCharge,
      aiLevel: aiLevel,
      description: data.description,
      imageUrl: data.imageUrl
    })
    // 初始化图片列表
    if (data.imageUrl) {
      imageFileList.value = [{
        uid: '-1',
        name: 'image',
        status: 'done',
        url: data.imageUrl
      }]
    } else {
      imageFileList.value = []
    }
  } catch (error) {
    message.error('获取车辆详情失败')
  }
}

// 查看
const handleView = async (record) => {
  viewModalVisible.value = true
  try {
    const res = await getAdminVehicleDetail(record.id)
    viewData.value = res.data || res
  } catch (error) {
    message.error('获取车辆详情失败')
  }
}

// 删除
const handleDelete = (record) => {
  Modal.confirm({
    title: '确认删除',
    content: `是否确认删除车辆编号为"${record.id}"的数据项？`,
    onOk: async () => {
      try {
        await deleteVehicle(record.id)
        message.success('删除成功')
        getList()
      } catch (error) {
        message.error('删除失败')
      }
    }
  })
}

// 批量删除
const handleBatchDelete = () => {
  if (selectedRowKeys.value.length === 0) {
    message.warning('请选择要删除的数据')
    return
  }

  Modal.confirm({
    title: '确认删除',
    content: `是否确认删除选中的 ${selectedRowKeys.value.length} 条数据？`,
    onOk: async () => {
      try {
        await deleteVehicle(selectedRowKeys.value.join(','))
        message.success('删除成功')
        selectedRowKeys.value = []
        hasSelected.value = false
        getList()
      } catch (error) {
        message.error('删除失败')
      }
    }
  })
}

// 提交表单
const handleSubmit = async () => {
  try {
    await formRef.value.validate()

    // 将配置参数转换为JSON格式
    const configJsonObj = {}
    if (form.fastCharge && form.fastCharge.trim()) {
      configJsonObj.fast_charge = form.fastCharge.trim()
    }
    if (form.aiLevel && form.aiLevel.trim()) {
      configJsonObj.ai_level = form.aiLevel.trim()
    }
    const configJson = Object.keys(configJsonObj).length > 0 ? JSON.stringify(configJsonObj) : null

    // 验证价格和库存
    if (form.price < 0) {
      message.error('价格不能为负数')
      return
    }
    if (form.stock < 0) {
      message.error('库存数量不能为负数')
      return
    }

    const submitData = {
      ...form,
      configJson: configJson,
      launchDate: form.launchDate ? dayjs(form.launchDate).format('YYYY-MM-DD') : null
    }
    // 移除临时字段，不提交到后端
    delete submitData.fastCharge
    delete submitData.aiLevel

    if (form.id) {
      await updateVehicle(submitData)
      message.success('修改成功')
    } else {
      await addVehicle(submitData)
      message.success('新增成功')
    }

    modalVisible.value = false
    getList()
    // 刷新品牌列表
    extractBrands()
  } catch (error) {
    if (error.errorFields) {
      return
    }
    message.error(form.id ? '修改失败' : '新增失败')
  }
}

// 取消
const handleCancel = () => {
  modalVisible.value = false
  resetForm()
}

// 重置表单
const resetForm = () => {
  Object.assign(form, {
    id: null,
    name: null,
    brand: null,
    price: null,
    batteryType: null,
    rangeKm: null,
    stock: null,
    launchDate: null,
    configJson: null,
    fastCharge: null,
    aiLevel: null,
    description: null,
    imageUrl: null
  })
  imageFileList.value = []
  formRef.value?.resetFields()
}

// 图片上传前检查
const beforeUpload = (file) => {
  const isJPG = file.type === 'image/jpeg' || file.type === 'image/png' || file.type === 'image/jpg'
  if (!isJPG) {
    message.error('只能上传 JPG/PNG 格式的图片!')
    return false
  }
  const isLt5M = file.size / 1024 / 1024 < 5
  if (!isLt5M) {
    message.error('图片大小不能超过 5MB!')
    return false
  }
  if (isJPG && isLt5M) {
    // 上传图片
    uploadImage(file)
  }
  return false
}

// 上传图片
const uploadImage = async (file) => {
  const formData = new FormData()
  formData.append('file', file)
  try {
    const res = await request({
      url: '/common/upload',
      method: 'post',
      data: formData
    })
    if (res.url) {
      imageFileList.value = [{
        uid: file.uid,
        name: file.name,
        status: 'done',
        url: res.url
      }]
      form.imageUrl = res.url
    }
  } catch (error) {
    message.error('上传失败')
  }
}

// 预览图片
const handleImagePreview = (file) => {
  previewImage.value = file.url || file.preview
  previewVisible.value = true
}

// 删除图片
const handleImageRemove = () => {
  imageFileList.value = []
  form.imageUrl = null
}

onMounted(() => {
  getList()
  extractBrands()
})
</script>

<style scoped>
.main-page {
  padding: 24px;
}
</style>
