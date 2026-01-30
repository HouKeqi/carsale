<template>
  <div class="vehicle-market-container">
    <div class="header-action-bar">
      <div class="search-left">
        <a-input-search
            v-model:value="searchForm.name"
            placeholder="搜索车型名称..."
            enter-button
            allow-clear
            @search="search"
            style="width: 320px"
        />
        <a-select
            v-model:value="searchForm.brand"
            placeholder="所有品牌"
            allow-clear
            class="brand-select"
            @change="search"
        >
          <a-select-option v-for="brand in brandOptions" :key="brand" :value="brand">
            {{ brand }}
          </a-select-option>
        </a-select>
      </div>

      <div class="search-right">
        <a-space>
          <span class="sort-label">排序:</span>
          <a-radio-group v-model:value="searchForm.orderByColumn" button-style="solid" @change="search">
            <a-radio-button value="price">价格</a-radio-button>
            <a-radio-button value="rangeKm">续航</a-radio-button>
          </a-radio-group>
          <a-button @click="toggleSortOrder">
            <template #icon>
              <sort-ascending-outlined v-if="searchForm.isAsc === 'ASC'" />
              <sort-descending-outlined v-else />
            </template>
          </a-button>
        </a-space>
      </div>
    </div>

    <div class="content-scroll-area">
      <a-spin :spinning="loading">
        <a-row :gutter="[20, 20]">
          <a-col :xs="24" :sm="12" :md="8" :lg="6" v-for="vehicle in vehicleList" :key="vehicle.id">
            <a-card hoverable class="vehicle-card" @click="handleDetail(vehicle.id)">
              <template #cover>
                <div class="img-wrapper">
                  <img :src="vehicle.imageUrl || '/default-vehicle.jpg'" :alt="vehicle.name" />
                  <div class="range-tag">{{ vehicle.rangeKm }}km 续航</div>
                </div>
              </template>

              <div class="card-body">
                <div class="brand-text">{{ vehicle.brand }}</div>
                <h3 class="vehicle-name">{{ vehicle.name }}</h3>

                <div class="price-section">
                  <span class="price-unit">¥</span>
                  <span class="price-value">{{ formatPrice(vehicle.price) }}</span>
                </div>

                <div class="card-footer">
                  <span class="stock-text">库存: {{ vehicle.stock }}</span>
                  <a-button
                      :type="isInCompare(vehicle.id) ? 'primary' : 'default'"
                      size="small"
                      shape="round"
                      @click.stop="handleAddToCompare(vehicle)"
                  >
                    <template #icon>
                      <check-outlined v-if="isInCompare(vehicle.id)" />
                      <plus-outlined v-else />
                    </template>
                    {{ isInCompare(vehicle.id) ? '已加入' : '对比' }}
                  </a-button>
                </div>
              </div>
            </a-card>
          </a-col>
        </a-row>

        <a-empty v-if="!loading && vehicleList.length === 0" style="margin-top: 60px" />
      </a-spin>

      <div class="pagination-container">
        <a-pagination
            v-model:current="pagination.current"
            v-model:page-size="pagination.pageSize"
            :total="pagination.total"
            :show-total="(total) => `共 ${total} 款车型`"
            @change="handlePageChange"
        />
      </div>
    </div>

    <transition name="slide-fade">
      <div v-if="compareStore.compareList.length > 0" class="compare-float-dock">
        <div class="dock-header">
          <span class="dock-title">
            车型对比 <span class="count">({{ compareStore.compareList.length }}/{{ compareStore.maxCompareCount }})</span>
          </span>
          <a-button type="link" size="small" @click="router.push('/customer/vehicle/compare')">查看详情</a-button>
        </div>

        <div class="dock-body">
          <div v-for="item in compareStore.compareList" :key="item.id" class="dock-item">
            <a-avatar :src="item.imageUrl" :size="32" shape="square" />
            <span class="item-name">{{ item.name }}</span>
            <close-circle-outlined class="remove-icon" @click.stop="compareStore.removeVehicle(item.id)" />
          </div>
        </div>

        <div class="dock-footer">
          <a-button type="primary" block @click="router.push('/customer/vehicle/compare')">
            立即对比
          </a-button>
        </div>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, h } from 'vue'
import { message, Modal } from 'ant-design-vue'
import { useRouter } from 'vue-router'
import request from '@/utils/request'
import { useCompareStore } from '@/stores/compare'
import {
  SortAscendingOutlined,
  SortDescendingOutlined,
  PlusOutlined,
  CheckOutlined,
  CloseCircleOutlined,
  SwapOutlined
} from '@ant-design/icons-vue'

const router = useRouter()
const loading = ref(false)
const vehicleList = ref([])
const brandOptions = ref([])
const compareStore = useCompareStore()

const searchForm = reactive({
  name: '',
  brand: null,
  orderByColumn: 'price',
  isAsc: 'ASC'
})

const queryParams = reactive({
  pageNum: 1,
  pageSize: 12,
  name: '',
  brand: null,
  orderByColumn: 'price',
  isAsc: 'ASC'
})

const pagination = reactive({
  current: 1,
  pageSize: 12,
  total: 0
})

// 价格格式化（去掉无意义的 .00）
const formatPrice = (price) => {
  if (!price) return '0'
  return parseFloat(price).toLocaleString()
}

const toggleSortOrder = () => {
  searchForm.isAsc = searchForm.isAsc === 'ASC' ? 'DESC' : 'ASC'
  search()
}

// 获取品牌（优化为从列表聚合）
const extractBrands = async () => {
  try {
    const res = await request({ url: '/carsale/vehicle/search', method: 'get', params: { pageNum: 1, pageSize: 500 } })
    const brands = [...new Set((res.rows || []).map(v => v.brand).filter(Boolean))].sort()
    brandOptions.value = brands
  } catch (e) { console.error(e) }
}

const getList = async () => {
  loading.value = true
  try {
    const res = await request({
      url: '/carsale/vehicle/search',
      method: 'get',
      params: queryParams
    })
    vehicleList.value = res.rows || []
    pagination.total = res.total || 0
  } catch (error) {
    message.error('数据加载失败')
  } finally {
    loading.value = false
  }
}

const search = () => {
  Object.assign(queryParams, searchForm)
  queryParams.pageNum = 1
  pagination.current = 1
  getList()
}

const handlePageChange = (page, size) => {
  queryParams.pageNum = page
  queryParams.pageSize = size
  pagination.current = page
  getList()
}

const handleDetail = (id) => {
  router.push({ path: '/customer/vehicle/detail', query: { id } })
}

const handleAddToCompare = (vehicle) => {
  const result = compareStore.addVehicle(vehicle)
  if (result.success) {
    message.success(`${vehicle.name} 已加入对比`)
  } else if (result.needReplace) {
    // 替换逻辑 UI 增强
    Modal.confirm({
      title: '对比位已满',
      icon: h(SwapOutlined),
      content: '对比列表最多支持 4 款车型，请选择一款进行替换。',
      okText: '去替换',
      cancelText: '取消',
      onOk: () => {
        router.push('/customer/vehicle/compare')
      }
    })
  } else {
    message.warning(result.message)
  }
}

const isInCompare = (id) => compareStore.isInCompare(id)

onMounted(() => {
  getList()
  extractBrands()
})
</script>

<style scoped>
/* 容器布局 */
.vehicle-market-container {
  background-color: #f0f2f5;
  min-height: 100vh;
  padding: 24px;
  position: relative;
}

/* 顶部操作栏 */
.header-action-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 24px;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.05);
  margin-bottom: 24px;
}

.search-left {
  display: flex;
  gap: 16px;
}

.brand-select {
  width: 160px;
}

.sort-label {
  color: #8c8c8c;
  margin-right: 8px;
}

/* 车辆卡片 */
.vehicle-card {
  border-radius: 12px;
  overflow: hidden;
  border: none;
  transition: all 0.3s;
}

.vehicle-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 10px 25px rgba(0,0,0,0.1);
}

.img-wrapper {
  height: 180px;
  position: relative;
  background: #f5f5f5;
}

.img-wrapper img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.range-tag {
  position: absolute;
  bottom: 12px;
  left: 12px;
  background: rgba(0,0,0,0.6);
  color: #fff;
  padding: 2px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.card-body {
  padding: 16px;
}

.brand-text {
  color: #1890ff;
  font-size: 12px;
  text-transform: uppercase;
  font-weight: 600;
}

.vehicle-name {
  font-size: 16px;
  font-weight: 700;
  margin: 4px 0 12px 0;
  color: #262626;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.price-section {
  margin-bottom: 16px;
}

.price-unit {
  color: #ff4d4f;
  font-size: 14px;
  margin-right: 2px;
}

.price-value {
  color: #ff4d4f;
  font-size: 24px;
  font-weight: 800;
}

.card-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-top: 1px solid #f0f0f0;
  padding-top: 12px;
}

.stock-text {
  color: #8c8c8c;
  font-size: 12px;
}

/* 分页 */
.pagination-container {
  margin-top: 40px;
  text-align: center;
  padding-bottom: 40px;
}

/* 悬浮对比框 */
.compare-float-dock {
  position: fixed;
  right: 24px;
  bottom: 40px;
  width: 260px;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 12px 32px rgba(0,0,0,0.15);
  z-index: 1000;
  overflow: hidden;
  border: 1px solid #e8e8e8;
}

.dock-header {
  padding: 12px 16px;
  background: #fafafa;
  border-bottom: 1px solid #f0f0f0;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.dock-title {
  font-weight: 600;
  font-size: 14px;
}

.dock-title .count {
  color: #1890ff;
}

.dock-body {
  padding: 8px 16px;
  max-height: 240px;
  overflow-y: auto;
}

.dock-item {
  display: flex;
  align-items: center;
  padding: 8px 0;
  border-bottom: 1px dashed #f0f0f0;
}

.dock-item:last-child {
  border-bottom: none;
}

.item-name {
  margin: 0 8px;
  flex: 1;
  font-size: 13px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.remove-icon {
  color: #bfbfbf;
  cursor: pointer;
  transition: color 0.3s;
}

.remove-icon:hover {
  color: #ff4d4f;
}

.dock-footer {
  padding: 12px 16px;
}

/* 动画 */
.slide-fade-enter-active, .slide-fade-leave-active {
  transition: all 0.3s ease-out;
}
.slide-fade-enter-from, .slide-fade-leave-to {
  transform: translateX(20px);
  opacity: 0;
}
</style>
