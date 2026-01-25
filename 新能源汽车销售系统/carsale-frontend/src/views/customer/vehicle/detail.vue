<template>
  <a-card class="main-page" v-loading="loading">
    <a-page-header
      title="车辆详情"
      @back="handleBack"
      style="margin-bottom: 20px; padding: 0"
    />
    <div v-if="vehicle">
      <a-row :gutter="20">
        <a-col :span="12">
          <img
            :src="vehicle.imageUrl || '/default-vehicle.jpg'"
            style="width: 100%; max-height: 500px; object-fit: contain"
          />
        </a-col>
        <a-col :span="12">
          <h2>{{ vehicle.brand }} {{ vehicle.name }}</h2>
          <div style="margin: 20px 0">
            <span style="font-size: 32px; color: #ff4d4f; font-weight: bold">
              ¥{{ formatPrice(vehicle.price) }}
            </span>
          </div>
          <a-divider />
          <a-descriptions :column="2" bordered>
            <a-descriptions-item label="品牌">{{ vehicle.brand }}</a-descriptions-item>
            <a-descriptions-item label="续航里程">{{ vehicle.rangeKm }}km</a-descriptions-item>
            <a-descriptions-item label="电池类型">{{ formatBatteryType(vehicle.batteryType) }}</a-descriptions-item>
            <a-descriptions-item label="库存数量">{{ vehicle.stock }}</a-descriptions-item>
            <a-descriptions-item label="上市时间">{{ vehicle.launchDate }}</a-descriptions-item>
          </a-descriptions>
          <a-divider />
          <!-- 促销活动 -->
          <div v-if="promotions && promotions.length > 0" style="margin-bottom: 20px">
            <h3>促销活动</h3>
            <a-card
              v-for="promo in promotions"
              :key="promo.id"
              :bordered="true"
              style="margin-bottom: 16px; border: 1px solid #ff4d4f"
            >
              <template #title>
                <span style="color: #ff4d4f; font-weight: bold; font-size: 16px">
                  {{ promo.title }}
                </span>
              </template>
              <a-descriptions :column="1" size="small" bordered>
                <a-descriptions-item label="优惠类型">
                  <a-tag :color="getDiscountTypeColor(promo.discountType)">
                    {{ formatDiscountType(promo.discountType) }}
                  </a-tag>
                </a-descriptions-item>
                <a-descriptions-item label="优惠金额">
                  <span style="color: #ff4d4f; font-weight: bold; font-size: 16px">
                    {{ formatDiscountValue(promo.discountType, promo.discountValue) }}
                  </span>
                </a-descriptions-item>
                <a-descriptions-item label="活动时间">
                  {{ formatDateTime(promo.startTime) }} 至 {{ formatDateTime(promo.endTime) }}
                </a-descriptions-item>
              </a-descriptions>
            </a-card>
          </div>
          <a-space>
            <a-button type="primary" size="large" @click="handleOrder">立即下单</a-button>
            <a-button type="default" size="large" @click="handleTestDrive">预约试驾</a-button>
          </a-space>
        </a-col>
      </a-row>
      <a-divider />
      <!-- 配置参数 -->
      <div v-if="configParams && Object.keys(configParams).length > 0">
        <h3>配置参数</h3>
        <a-descriptions :column="2" bordered>
          <a-descriptions-item
            v-for="(value, key) in configParams"
            :key="key"
            :label="getConfigLabel(key)"
          >
            {{ value }}
          </a-descriptions-item>
        </a-descriptions>
      </div>
      <a-divider />
      <!-- 车辆描述 -->
      <div v-if="vehicle.description">
        <h3>车辆描述</h3>
        <p>{{ vehicle.description }}</p>
      </div>
      <a-divider />
      <!-- 用户评价 -->
      <div>
        <h3>用户评价</h3>
        <a-table :data-source="evaluationList" :loading="evalLoading" :pagination="false" :columns="evalColumns" bordered>
          <template #bodyCell="{ column, record }">
            <template v-if="column.key === 'score'">
              <a-rate :value="record.score" disabled />
            </template>
            <template v-if="column.key === 'create_Time'">
              {{ formatDateTime(record.create_Time) }}
            </template>
            <template v-if="column.key === 'images'">
              <a-image
                v-if="record.images"
                v-for="(img, index) in getImageList(record.images)"
                :key="index"
                :src="img"
                :width="60"
                :height="60"
                style="margin-right: 5px"
                :preview="{ src: img }"
              />
            </template>
          </template>
        </a-table>
      </div>
    </div>
  </a-card>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { message } from 'ant-design-vue'
import { useRouter, useRoute } from 'vue-router'
import request from '@/utils/request'
import dayjs from 'dayjs'

const router = useRouter()
const route = useRoute()
const loading = ref(false)
const evalLoading = ref(false)
const vehicle = ref(null)
const promotions = ref([])
const evaluationList = ref([])
const configParams = ref({})

const evalColumns = [
  {
    title: '评分',
    key: 'score',
    width: 100
  },
  {
    title: '评价内容',
    dataIndex: 'comment',
    key: 'comment'
  },
  {
    title: '评价时间',
    dataIndex: 'create_Time',
    key: 'create_Time',
    width: 180
  },
  {
    title: '图片',
    key: 'images',
    width: 150
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

// 格式化电池类型
const formatBatteryType = (type) => {
  if (type === null || type === undefined) return '未选择'
  const typeMap = {
    0: '三元锂电池',
    1: '磷酸铁锂电池',
    2: '其他'
  }
  return typeMap[type] || '未知'
}

// 获取配置标签
const getConfigLabel = (key) => {
  const labels = {
    fast_charge: '快充时间',
    ai_level: '智能驾驶等级'
  }
  return labels[key] || key
}

// 获取图片列表
const getImageList = (images) => {
  if (!images) return []
  try {
    return JSON.parse(images)
  } catch (e) {
    return images.split(',').filter(img => img)
  }
}

// 格式化日期时间
const formatDateTime = (dateTime) => {
  if (!dateTime) return '-'
  return dayjs(dateTime).format('YYYY-MM-DD HH:mm:ss')
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

// 获取优惠类型对应的颜色
const getDiscountTypeColor = (type) => {
  const colorMap = {
    0: 'red',      // 直降 - 红色
    1: 'orange',   // 赠品 - 橙色
    2: 'blue'       // 置换补贴 - 蓝色
  }
  return colorMap[type] || 'default'
}

// 格式化优惠金额
const formatDiscountValue = (type, value) => {
  if (!value) return '0.00'
  const formattedValue = Number(value).toLocaleString('zh-CN', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2
  })
  // 根据优惠类型显示不同的格式
  if (type === 0) {
    // 直降：显示金额
    return `¥${formattedValue}`
  } else if (type === 1) {
    // 赠品：显示价值
    return `价值 ¥${formattedValue}`
  } else if (type === 2) {
    // 置换补贴：显示补贴金额
    return `补贴 ¥${formattedValue}`
  }
  return `¥${formattedValue}`
}

// 获取详情
const getDetail = async (id) => {
  loading.value = true
  try {
    const res = await request({
      url: '/carsale/vehicle/' + id,
      method: 'get'
    })
    vehicle.value = res.data?.vehicle
    promotions.value = res.data?.promotions || []
    if (vehicle.value?.configJson) {
      try {
        configParams.value = JSON.parse(vehicle.value.configJson)
      } catch (e) {
        configParams.value = {}
      }
    }
  } catch (error) {
    message.error('获取车辆详情失败')
  } finally {
    loading.value = false
  }
}

// 获取评价列表
const getEvaluationList = async (id) => {
  evalLoading.value = true
  try {
    const res = await request({
      url: '/carsale/vehicle/' + id + '/evaluations',
      method: 'get',
      params: { pageNum: 1, pageSize: 10 }
    })
    evaluationList.value = res.rows || res.data || []
  } catch (error) {
    console.error('获取评价列表失败', error)
  } finally {
    evalLoading.value = false
  }
}

// 立即下单
const handleOrder = () => {
  router.push({ path: '/customer/order/create', query: { vehicleId: vehicle.value.id } })
}

// 预约试驾
const handleTestDrive = () => {
  router.push({ path: '/customer/testdrive/create', query: { vehicleId: vehicle.value.id } })
}

// 返回上一页
const handleBack = () => {
  router.back()
}

onMounted(() => {
  const id = route.query.id
  if (id) {
    getDetail(id)
    getEvaluationList(id)
  }
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
