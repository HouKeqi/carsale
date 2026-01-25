<template>
  <div class="app-container">
    <el-card v-loading="loading">
      <div v-if="vehicle">
        <el-row :gutter="20">
          <el-col :span="12">
            <img :src="vehicle.imageUrl || '/static/images/default-vehicle.jpg'" style="width: 100%; max-height: 500px; object-fit: contain" />
          </el-col>
          <el-col :span="12">
            <h2>{{ vehicle.brand }} {{ vehicle.name }}</h2>
            <div class="price-section">
              <span class="price">¥{{ vehicle.price?.toLocaleString() }}</span>
            </div>
            <el-divider />
            <el-descriptions :column="2" border>
              <el-descriptions-item label="品牌">{{ vehicle.brand }}</el-descriptions-item>
              <el-descriptions-item label="续航里程">{{ vehicle.rangeKm }}km</el-descriptions-item>
              <el-descriptions-item label="电池类型">
                <dict-tag :options="dict.type.carsale_battery_type" :value="vehicle.batteryType" />
              </el-descriptions-item>
              <el-descriptions-item label="库存数量">{{ vehicle.stock }}</el-descriptions-item>
              <el-descriptions-item label="上市时间">{{ vehicle.launchDate }}</el-descriptions-item>
            </el-descriptions>
            <el-divider />
            <!-- 促销活动 -->
            <div v-if="promotions && promotions.length > 0" style="margin-bottom: 20px">
              <h3>促销活动</h3>
              <el-tag v-for="promo in promotions" :key="promo.id" type="danger" style="margin-right: 10px; margin-bottom: 10px">
                {{ promo.title }}
              </el-tag>
            </div>
            <el-button type="primary" size="medium" @click="handleOrder">立即下单</el-button>
            <el-button type="success" size="medium" @click="handleTestDrive">预约试驾</el-button>
          </el-col>
        </el-row>
        <el-divider />
        <!-- 配置参数 -->
        <div v-if="vehicle.configJson">
          <h3>配置参数</h3>
          <el-descriptions :column="2" border>
            <el-descriptions-item v-for="(value, key) in configParams" :key="key" :label="getConfigLabel(key)">
              {{ value }}
            </el-descriptions-item>
          </el-descriptions>
        </div>
        <el-divider />
        <!-- 车辆描述 -->
        <div v-if="vehicle.description">
          <h3>车辆描述</h3>
          <p>{{ vehicle.description }}</p>
        </div>
        <el-divider />
        <!-- 用户评价 -->
        <div>
          <h3>用户评价</h3>
          <el-table :data="evaluationList" v-loading="evalLoading">
            <el-table-column label="评分" width="100">
              <template slot-scope="scope">
                <el-rate v-model="scope.row.score" disabled show-score text-color="#ff9900" />
              </template>
            </el-table-column>
            <el-table-column label="评价内容" prop="comment" />
            <el-table-column label="评价时间" prop="create_Time" width="180" />
            <el-table-column label="图片" width="150">
              <template slot-scope="scope">
                <el-image
                  v-if="scope.row.images"
                  v-for="(img, index) in getImageList(scope.row.images)"
                  :key="index"
                  :src="img"
                  style="width: 60px; height: 60px; margin-right: 5px"
                  :preview-src-list="getImageList(scope.row.images)"
                />
              </template>
            </el-table-column>
          </el-table>
          <pagination
            v-show="evalTotal > 0"
            :total="evalTotal"
            :page.sync="evalQueryParams.pageNum"
            :limit.sync="evalQueryParams.pageSize"
            @pagination="getEvaluationList"
          />
        </div>
      </div>
    </el-card>
  </div>
</template>

<script>
import { getVehicleDetail, getVehicleEvaluations } from '@/api/carsale/vehicle'
import { parseTime } from '@/utils/ruoyi'

export default {
  name: 'VehicleDetail',
  dicts: ['carsale_battery_type'],
  data() {
    return {
      loading: false,
      evalLoading: false,
      vehicle: null,
      promotions: [],
      evaluationList: [],
      evalTotal: 0,
      evalQueryParams: {
        pageNum: 1,
        pageSize: 10
      },
      configParams: {}
    }
  },
  created() {
    const id = this.$route.query.id
    if (id) {
      this.getDetail(id)
      this.getEvaluationList(id)
    }
  },
  methods: {
    getDetail(id) {
      this.loading = true
      getVehicleDetail(id).then(response => {
        this.vehicle = response.data.vehicle
        this.promotions = response.data.promotions || []
        if (this.vehicle.configJson) {
          try {
            this.configParams = JSON.parse(this.vehicle.configJson)
          } catch (e) {
            this.configParams = {}
          }
        }
        this.loading = false
      })
    },
    getEvaluationList(id) {
      this.evalLoading = true
      getVehicleEvaluations(id, this.evalQueryParams).then(response => {
        this.evaluationList = response.rows
        this.evalTotal = response.total
        this.evalLoading = false
      })
    },
    getConfigLabel(key) {
      const labels = {
        fast_charge: '快充时间',
        ai_level: '智能驾驶等级'
      }
      return labels[key] || key
    },
    getImageList(images) {
      if (!images) return []
      try {
        return JSON.parse(images)
      } catch (e) {
        return images.split(',').filter(img => img)
      }
    },
    handleOrder() {
      this.$router.push({ path: '/carsale/order/create', query: { vehicleId: this.vehicle.id } })
    },
    handleTestDrive() {
      this.$router.push({ path: '/carsale/testdrive/create', query: { vehicleId: this.vehicle.id } })
    }
  }
}
</script>

<style scoped lang="scss">
.price-section {
  margin: 20px 0;
}

.price {
  font-size: 32px;
  color: #f56c6c;
  font-weight: bold;
}
</style>
