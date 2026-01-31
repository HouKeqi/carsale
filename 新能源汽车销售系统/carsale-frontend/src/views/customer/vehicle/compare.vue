<template>
  <div class="compare-page">
    <div class="compare-header">
      <div class="header-left">
        <h2 class="page-title">
          车型对比
        </h2>
        <a-tag color="blue" class="compare-count-tag">
          已选择 {{ compareList.length }} 款车型
        </a-tag>
        <span class="max-hint">最多可对比 3 款车型</span>
      </div>
      <div class="header-actions">
        <a-button
            v-if="compareList.length < 3"
            type="primary"
            ghost
            @click="showAddModal = true"
            class="action-btn"
        >
          <template #icon><PlusOutlined /></template>
          添加车型
        </a-button>
        <a-button type="primary" danger @click="handleClear" :disabled="compareList.length === 0" class="action-btn">
          <template #icon><DeleteOutlined /></template>
          清空对比
        </a-button>
        <a-button type="link" @click="router.push('/customer/vehicle/list')" class="back-btn">
          <template #icon><ArrowLeftOutlined /></template>
          返回列表
        </a-button>
      </div>
    </div>

    <div v-if="compareList.length === 0" class="empty-state">
      <a-empty description="暂无对比车型，快去选择车型加入对比吧！">
        <a-button type="primary" size="large" @click="router.push('/customer/vehicle/list')">
          去选择车型
        </a-button>
      </a-empty>
    </div>

    <div v-else class="compare-content">
      <a-spin :spinning="loading">
        <div class="vehicles-row">
          <div
              v-for="(vehicle, index) in displayVehicles"
              :key="vehicle.id"
              class="vehicle-card"
          >
            <div class="card-header">
              <a-button
                  type="text"
                  danger
                  size="small"
                  class="remove-btn"
                  @click="handleRemove(vehicle.id)"
              >
                <template #icon><CloseOutlined /></template>
              </a-button>
            </div>
            <div class="card-image" @click="handleDetail(vehicle.id)">
              <img
                  :src="vehicle.imageUrl || '/default-vehicle.jpg'"
                  :alt="vehicle.name"
                  @error="handleImageError"
              />
            </div>
            <div class="card-info">
              <div class="vehicle-name">{{ vehicle.brand }} {{ vehicle.name }}</div>
              <div class="vehicle-price">¥{{ formatPrice(vehicle.price) }}</div>
            </div>
            <div class="card-actions">
              <a-button
                  type="primary"
                  block
                  @click="handleDetail(vehicle.id)"
                  class="detail-btn"
              >
                查看详情
              </a-button>
              <a-button
                  type="default"
                  block
                  @click="handleOrder(vehicle.id)"
                  class="order-btn"
              >
                立即下单
              </a-button>
            </div>
          </div>
        </div>

        <div class="compare-table-wrapper">
          <div class="table-header">
            <h3 class="table-title">详细参数对比</h3>
          </div>
          <div class="compare-table">
            <div
                v-for="row in tableData"
                :key="row.key"
                class="compare-row"
                :class="{ 'row-highlight': row.key === 'price' }"
            >
              <div class="row-label">
                <span class="label-icon">{{ getParameterIcon(row.key) }}</span>
                <strong>{{ row.parameter }}</strong>
              </div>
              <div class="row-values">
                <div
                    v-for="(vehicle, index) in displayVehicles"
                    :key="vehicle.id"
                    class="row-value"
                    :class="{ 'best-value': isBestValue(row, index) }"
                >
                  <span class="value-text">{{ getRowValue(row, index) }}</span>
                  <span v-if="isBestValue(row, index)" class="best-badge">最佳</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </a-spin>
    </div>

    <a-modal
        v-model:open="showAddModal"
        title="快速添加车型"
        :width="800"
        :footer="null"
    >
      <div class="add-vehicle-modal">
        <a-input-search
            v-model:value="searchKeyword"
            placeholder="搜索车型名称或品牌"
            enter-button="搜索"
            @search="searchVehicles"
            style="margin-bottom: 16px"
        />
        <a-spin :spinning="searchLoading">
          <div v-if="searchResults.length > 0" class="search-results">
            <div
                v-for="vehicle in searchResults"
                :key="vehicle.id"
                class="search-result-item"
                :class="{ 'is-in-compare': isInCompare(vehicle.id) }"
            >
              <div class="result-image">
                <img :src="vehicle.imageUrl || '/default-vehicle.jpg'" :alt="vehicle.name" />
              </div>
              <div class="result-info">
                <div class="result-name">{{ vehicle.brand }} {{ vehicle.name }}</div>
                <div class="result-price">¥{{ formatPrice(vehicle.price) }}</div>
              </div>
              <div class="result-actions">
                <a-button
                    v-if="!isInCompare(vehicle.id)"
                    type="primary"
                    :disabled="compareList.length >= 3"
                    @click="handleAddFromSearch(vehicle)"
                >
                  {{ compareList.length >= 3 ? '已满' : '加入' }}
                </a-button>
                <a-tag v-else color="success">已加入</a-tag>
              </div>
            </div>
          </div>
        </a-spin>
      </div>
    </a-modal>
  </div>
</template>

<script setup>
import { computed, ref, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import { message, Modal } from 'ant-design-vue'
import {
  PlusOutlined,
  DeleteOutlined,
  ArrowLeftOutlined,
  CloseOutlined
} from '@ant-design/icons-vue'
import { useCompareStore } from '@/stores/compare'
import request from '@/utils/request'

const router = useRouter()
const compareStore = useCompareStore()
const loading = ref(false)
const fullVehicleList = ref([])
const showAddModal = ref(false)
const searchKeyword = ref('')
const searchResults = ref([])
const searchLoading = ref(false)

const compareList = computed(() => compareStore.compareList)
const displayVehicles = computed(() => fullVehicleList.value.length > 0 ? fullVehicleList.value : compareList.value)

watch(compareList, async (newList) => {
  if (newList && newList.length > 0) {
    await loadFullVehicleData()
  } else {
    fullVehicleList.value = []
  }
}, { immediate: true })

const loadFullVehicleData = async () => {
  if (compareList.value.length === 0) return
  loading.value = true
  try {
    const vehicleIds = compareList.value.map(v => v.id)
    const promises = vehicleIds.map(id =>
        request({
          url: `/carsale/vehicle/${id}`,
          method: 'get'
        }).then(res => res.data?.vehicle || compareList.value.find(v => v.id === id))
            .catch(() => compareList.value.find(v => v.id === id))
    )
    const vehicles = await Promise.all(promises)
    fullVehicleList.value = vehicles.filter(v => v != null)
  } catch (error) {
    fullVehicleList.value = compareList.value
  } finally {
    loading.value = false
  }
}

const searchVehicles = async () => {
  if (!searchKeyword.value.trim()) return
  searchLoading.value = true
  try {
    const res = await request({
      url: '/carsale/vehicle/list',
      method: 'get',
      params: { keyword: searchKeyword.value }
    })
    searchResults.value = res.data?.list || []
  } finally {
    searchLoading.value = false
  }
}

const handleAddFromSearch = async (vehicle) => {
  const res = compareStore.addVehicle(vehicle)
  if (res.success) {
    message.success(res.message)
    // 刷新完整数据
    await loadFullVehicleData()
    // 关闭弹窗
    showAddModal.value = false
    // 清空搜索结果
    searchResults.value = []
    searchKeyword.value = ''
  } else {
    message.warning(res.message)
  }
}

const isInCompare = (id) => compareList.value.some(v => v.id === id)
const parseConfig = (json) => { try { return typeof json === 'string' ? JSON.parse(json) : json } catch { return {} } }
const formatBatteryType = (t) => ({ 0: '三元锂', 1: '磷酸铁锂', 2: '其他' }[t] || '未知')
const getParameterIcon = (k) => ({ price: '💰', rangeKm: '🔋', batteryType: '⚡', stock: '📦' }[k] || '📋')

const getRowValue = (row, index) => {
  const v = displayVehicles.value[index]
  if (!v) return '-'
  if (row.key === 'price') return `¥${formatPrice(v.price)}`
  if (row.key === 'rangeKm') return v.rangeKm ? `${v.rangeKm} km` : '-'
  if (row.key === 'batteryType') return formatBatteryType(v.batteryType)
  const config = parseConfig(v.configJson)
  if (row.key === 'fastCharge') return config.fast_charge || '-'
  if (row.key === 'aiLevel') return config.ai_level || '-'
  return v[row.key] || '-'
}

const isBestValue = (row, index) => {
  const vs = displayVehicles.value
  if (vs.length < 2) return false
  const nums = vs.map(v => Number(v[row.key]) || 0)
  if (row.key === 'price') {
    const prices = vs.map(v => Number(v.price) || Infinity)
    return prices[index] === Math.min(...prices)
  }
  if (row.key === 'rangeKm') return nums[index] === Math.max(...nums) && nums[index] > 0
  return false
}

const tableData = computed(() => {
  if (displayVehicles.value.length === 0) return []
  return [
    { parameter: '品牌', key: 'brand' },
    { parameter: '车型', key: 'name' },
    { parameter: '指导价', key: 'price' },
    { parameter: '续航', key: 'rangeKm' },
    { parameter: '电池', key: 'batteryType' },
    { parameter: '快充', key: 'fastCharge' },
    { parameter: '智驾', key: 'aiLevel' }
  ]
})

const formatPrice = (p) => p ? Number(p).toLocaleString('zh-CN', { minimumFractionDigits: 2 }) : '0.00'
const handleImageError = (e) => { e.target.src = '/default-vehicle.jpg' }
const handleDetail = (id) => router.push(`/customer/vehicle/detail?id=${id}`)
const handleOrder = (id) => router.push(`/customer/order/create?vehicleId=${id}`)
const handleRemove = (id) => {
  const res = compareStore.removeVehicle(id)
  if (res.success) message.success(res.message)
}
const handleClear = () => {
  Modal.confirm({
    title: '确认清空',
    onOk: () => {
      compareStore.clearCompare()
      fullVehicleList.value = []
    }
  })
}
</script>

<style scoped>
.compare-page {
  padding: 24px;
  background: #f5f7fa;
  min-height: 100vh;
}

.compare-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  padding: 20px 24px;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
}

.page-title { margin: 0; font-size: 22px; font-weight: 600; }

/* 车型卡片区域布局优化 */
.vehicles-row {
  display: flex;
  justify-content: flex-start;
  gap: 20px;
  margin-bottom: 32px;
  overflow-x: auto;
  padding-bottom: 8px;
}

.vehicle-card {
  flex: 0 0 320px; /* 固定宽度，防止车型少时拉伸过大 */
  background: #fff;
  border: 1px solid #f0f0f0;
  border-radius: 12px;
  padding: 16px;
  transition: all 0.3s ease;
  position: relative;
}

.vehicle-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 24px rgba(0,0,0,0.08);
}

/* --- 图片展示核心修改 --- */
.card-image {
  width: 100%;
  aspect-ratio: 16 / 9; /* 锁定 16:9 比例 */
  background: radial-gradient(circle, #ffffff 0%, #f7f8fa 100%);
  border-radius: 8px;
  margin-bottom: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  cursor: pointer;
  border: 1px solid #f5f5f5;
}

.card-image img {
  width: 90%; /* 留出一点边距，显得更精致 */
  height: 90%;
  object-fit: contain; /* 保证车身完整，绝不裁切 */
  transition: transform 0.5s ease;
}

.vehicle-card:hover .card-image img {
  transform: scale(1.1); /* 悬停缩放效果 */
}
/* ----------------------- */

.vehicle-name {
  font-size: 16px;
  font-weight: 600;
  height: 44px; /* 保证两行高度一致 */
  overflow: hidden;
  margin-bottom: 8px;
}

.vehicle-price {
  font-size: 20px;
  font-weight: 700;
  color: #ff4d4f;
  margin-bottom: 16px;
}

.card-actions {
  display: flex;
  gap: 10px;
}

.card-header { position: absolute; top: 8px; right: 8px; z-index: 5; }

/* 表格样式 */
.compare-table-wrapper { background: #fff; border-radius: 12px; padding: 24px; }
.compare-row { display: flex; border-bottom: 1px solid #f5f5f5; }
.row-label { width: 140px; padding: 16px; background: #fafafa; display: flex; align-items: center; gap: 8px; }
.row-values { flex: 1; display: flex; }
.row-value { flex: 1; padding: 16px; text-align: center; border-left: 1px solid #f5f5f5; position: relative; min-width: 200px; }
.best-value { background: #e6f7ff33; }
.best-badge { position: absolute; top: 4px; right: 4px; font-size: 10px; background: #52c41a; color: #fff; padding: 0 6px; border-radius: 4px; }

/* 搜索弹窗图片优化 */
.result-image {
  width: 100px;
  height: 60px;
  background: #f5f5f5;
  border-radius: 4px;
  margin-right: 12px;
  overflow: hidden;
}
.result-image img { width: 100%; height: 100%; object-fit: contain; }

.search-result-item {
  display: flex;
  align-items: center;
  padding: 12px;
  border-bottom: 1px solid #f0f0f0;
}

@media (max-width: 768px) {
  .vehicle-card { flex: 0 0 280px; }
  .card-actions { flex-direction: column; }
}
</style>
