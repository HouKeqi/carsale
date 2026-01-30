<template>
  <div class="evaluation-list-container">
    <a-card :bordered="false" class="header-card">
      <div class="header-flex">
        <div class="page-title-area">
          <span class="main-title">我的评价记录</span>
          <span class="sub-count">共 {{ pagination.total }} 条</span>
        </div>

      </div>
    </a-card>

    <div class="list-content">
      <a-spin :spinning="loading">
        <a-row :gutter="[16, 16]">
          <a-col :xs="24" :md="12" v-for="item in evaluationList" :key="item.id">
            <a-card :bordered="false" class="eval-item-card">
              <div class="card-header">
                <div class="order-tag-info">
                  <span class="order-id-label">订单 ID: {{ item.orderId }}</span>
                  <span class="time-label">{{ formatDateTime(item.create_Time) }}</span>
                </div>
                <div class="card-ops">
                  <a-space>
                    <a-button type="link" size="small" @click="handleViewOrder(item.orderId)">查看订单</a-button>
                    <a-divider type="vertical" />
                    <a-popconfirm title="确定删除此评价？" @confirm="handleDelete(item.id)">
                      <a-button type="link" danger size="small">删除</a-button>
                    </a-popconfirm>
                  </a-space>
                </div>
              </div>

              <div class="vehicle-context-bar" v-if="orderMap[item.orderId]">
                <div class="v-info">
                  <span class="v-brand">{{ orderMap[item.orderId].vehicleName }}</span>
                  <span class="v-price">成交金额: ¥{{ formatPrice(orderMap[item.orderId].amount) }}</span>
                </div>
              </div>

              <div class="eval-detail">
                <div class="score-line">
                  <a-rate :value="item.score" disabled style="font-size: 16px" />
                  <a-tag :color="item.score >= 4 ? 'green' : 'orange'" style="margin-left: 8px">
                    {{ getScoreText(item.score) }}
                  </a-tag>
                </div>

                <p class="comment-body">{{ item.comment }}</p>

                <div class="image-box" v-if="item.images">
                  <a-image-preview-group>
                    <a-image
                        v-for="(img, idx) in getImageList(item.images)"
                        :key="idx"
                        :src="img"
                        :width="72"
                        :height="72"
                        class="thumb-img"
                    />
                  </a-image-preview-group>
                </div>
              </div>
            </a-card>
          </a-col>
        </a-row>

        <div class="pagination-container">
          <a-pagination
              v-model:current="pagination.current"
              :total="pagination.total"
              :pageSize="pagination.pageSize"
              show-total
              @change="pagination.onChange"
          />
        </div>

        <a-empty v-if="!loading && evaluationList.length === 0" style="padding: 100px 0" />
      </a-spin>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { message } from 'ant-design-vue'
import { useRouter } from 'vue-router'
import { ReloadOutlined } from '@ant-design/icons-vue'
import request from '@/utils/request'
import dayjs from 'dayjs'

const router = useRouter()
const loading = ref(false)
const evaluationList = ref([])
const orderMap = ref({})

const queryParams = reactive({ pageNum: 1, pageSize: 8 })

const pagination = reactive({
  current: 1,
  pageSize: 8,
  total: 0,
  onChange: (page) => {
    queryParams.pageNum = page
    getList()
  }
})

const getScoreText = (s) => ['极差', '失望', '一般', '满意', '非常满意'][s - 1] || ''
const getImageList = (images) => {
  if (!images) return []
  try { return JSON.parse(images) } catch (e) { return images.split(',').filter(Boolean) }
}
const formatDateTime = (val) => val ? dayjs(val).format('YYYY-MM-DD HH:mm') : '-'
const formatPrice = (p) => Number(p || 0).toLocaleString('zh-CN', { minimumFractionDigits: 2 })

const getList = async () => {
  loading.value = true
  try {
    const res = await request({ url: '/carsale/evaluation/my/list', params: queryParams })
    evaluationList.value = res.rows || res.data || []
    pagination.total = res.total || 0
    pagination.current = queryParams.pageNum
    await loadOrderDataBatch()
  } catch (error) {
    message.error('获取列表失败')
  } finally {
    loading.value = false
  }
}

const loadOrderDataBatch = async () => {
  const ids = [...new Set(evaluationList.value.map(e => e.orderId))].filter(id => id && !orderMap.value[id])
  const promises = ids.map(async (id) => {
    try {
      const oRes = await request({ url: `/carsale/order/detail/${id}`, method: 'get' })
      const o = oRes.data
      if (o?.vehicleId) {
        const vRes = await request({ url: `/carsale/vehicle/${o.vehicleId}`, method: 'get' })
        const v = vRes.data?.vehicle
        orderMap.value[id] = { ...o, vehicleName: v ? `${v.brand} ${v.name}` : '未知车型' }
      }
    } catch (e) { console.error(e) }
  })
  await Promise.all(promises)
}

const handleViewOrder = (id) => router.push({ path: '/customer/order/detail', query: { id } })
const handleDelete = async (id) => {
  await request({ url: `/carsale/evaluation/delete/${id}`, method: 'delete' })
  message.success('已删除评价')
  getList()
}

onMounted(getList)
</script>

<style scoped>
.evaluation-list-container {
  padding: 24px;
  background-color: #f0f2f5; /* 统一背景底色 */
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

.list-content {
  max-width: 1400px; /* 稍微放宽一点，保持双栏平衡 */
  margin: 0 auto;
}

.eval-item-card {
  border-radius: 8px;
  transition: all 0.3s;
}

.eval-item-card:hover {
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 12px;
  border-bottom: 1px solid #f0f0f0;
  margin-bottom: 16px;
}

.order-id-label {
  font-size: 12px;
  color: #999;
  display: block;
}

.time-label {
  font-size: 12px;
  color: #bfbfbf;
}

.vehicle-context-bar {
  background-color: #fafafa; /* 与订单页表头背景统一 */
  padding: 8px 12px;
  border-radius: 4px;
  margin-bottom: 16px;
}

.v-brand {
  font-weight: 600;
  color: #434343;
  margin-right: 12px;
}

.v-price {
  font-size: 12px;
  color: #ff4d4f; /* 统一金额颜色 */
}

.score-line {
  margin-bottom: 12px;
  display: flex;
  align-items: center;
}

.comment-body {
  color: #595959;
  line-height: 1.6;
  margin-bottom: 16px;
  min-height: 48px;
}

.image-box {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.thumb-img {
  border-radius: 4px;
  border: 1px solid #f0f0f0;
  object-fit: cover;
}

.pagination-container {
  margin-top: 24px;
  text-align: right;
}

/* 适配中屏幕 */
@media (max-width: 992px) {
  .evaluation-list-container {
    padding: 12px;
  }
}
</style>
