<template>
  <a-card class="main-page">
    <!-- 搜索区域 -->
    <a-form layout="inline" :model="searchForm" style="margin-bottom: 20px">
      <a-form-item label="车型名称">
        <a-input-search
          v-model:value="searchForm.name"
          placeholder="根据车型名称进行搜索"
          enter-button
          allowClear
          @search="search"
          style="width: 250px"
        />
      </a-form-item>
      <a-form-item label="品牌">
        <a-select
          v-model:value="searchForm.brand"
          placeholder="请选择品牌"
          allowClear
          style="width: 150px"
          @change="search"
        >
          <a-select-option value="Tesla">Tesla</a-select-option>
          <a-select-option value="BYD">BYD</a-select-option>
          <a-select-option value="Xiaomi">Xiaomi</a-select-option>
          <a-select-option value="NIO">NIO</a-select-option>
        </a-select>
      </a-form-item>
      <a-form-item label="排序字段">
        <a-select
          v-model:value="searchForm.orderByColumn"
          placeholder="请选择排序字段"
          allowClear
          style="width: 120px"
          @change="search"
        >
          <a-select-option value="price">价格</a-select-option>
          <a-select-option value="rangeKm">续航里程</a-select-option>
        </a-select>
      </a-form-item>
      <a-form-item label="排序方式">
        <a-select
          v-model:value="searchForm.isAsc"
          placeholder="请选择排序方式"
          allowClear
          style="width: 120px"
          @change="search"
        >
          <a-select-option value="ASC">升序</a-select-option>
          <a-select-option value="DESC">降序</a-select-option>
        </a-select>
      </a-form-item>
    </a-form>

    <!-- 车辆卡片列表 -->
    <a-row :gutter="[16, 16]">
      <a-col :span="6" v-for="vehicle in vehicleList" :key="vehicle.id">
        <a-card
            hoverable
            :style="{ cursor: 'pointer' }"
            @click="handleDetail(vehicle.id)"
        >
          <template #cover>
            <img
                :alt="vehicle.name"
                :src="vehicle.imageUrl || '/default-vehicle.jpg'"
                style="width: 100%; height: 200px; object-fit: cover"
            />
          </template>
          <a-card-meta>
            <template #title>
              <div style="font-size: 16px; font-weight: bold">
                {{ vehicle.brand }} {{ vehicle.name }}
              </div>
            </template>
            <template #description>
              <div style="margin-top: 10px">
                <div style="color: #ff4d4f; font-size: 20px; font-weight: bold">
                  ¥{{ formatPrice(vehicle.price) }}
                </div>
                <div style="margin-top: 8px; color: #666">
                  续航：{{ vehicle.rangeKm }}km | 库存：{{ vehicle.stock }}
                </div>
              </div>
            </template>
          </a-card-meta>
        </a-card>
      </a-col>
    </a-row>

    <!-- 分页 -->
    <a-pagination
        v-model:current="pagination.current"
        v-model:page-size="pagination.pageSize"
        :total="pagination.total"
        :show-total="(total) => `共 ${total} 条`"
        :show-size-changer="true"
        :page-size-options="['12', '24', '48', '96']"
        style="margin-top: 20px; text-align: right"
        @change="handlePageChange"
        @showSizeChange="handlePageSizeChange"
    />
  </a-card>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { message } from 'ant-design-vue'
import { useRouter } from 'vue-router'
import request from '@/utils/request'

const router = useRouter()
const loading = ref(false)
const vehicleList = ref([])

const searchForm = reactive({
  name: '',
  brand: null,
  orderByColumn: null,
  isAsc: null
})

const queryParams = reactive({
  pageNum: 1,
  pageSize: 12,
  name: '',
  brand: null,
  orderByColumn: null,
  isAsc: null
})

const pagination = reactive({
  current: 1,
  pageSize: 12,
  total: 0
})

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
    const res = await request({
      url: '/carsale/vehicle/search',
      method: 'get',
      params: queryParams
    })
    vehicleList.value = res.rows || res.data || []
    pagination.total = res.total || 0
  } catch (error) {
    message.error('获取车辆列表失败')
  } finally {
    loading.value = false
  }
}

// 搜索
const search = () => {
  queryParams.name = searchForm.name
  queryParams.brand = searchForm.brand
  queryParams.orderByColumn = searchForm.orderByColumn
  queryParams.isAsc = searchForm.isAsc
  queryParams.pageNum = 1
  pagination.current = 1
  getList()
}

// 分页变化
const handlePageChange = (page, size) => {
  queryParams.pageNum = page
  queryParams.pageSize = size
  pagination.current = page
  pagination.pageSize = size
  getList()
}

// 每页条数变化
const handlePageSizeChange = (current, size) => {
  queryParams.pageNum = 1
  queryParams.pageSize = size
  pagination.current = 1
  pagination.pageSize = size
  getList()
}

// 查看详情
const handleDetail = (id) => {
  router.push({ path: '/customer/vehicle/detail', query: { id } })
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
