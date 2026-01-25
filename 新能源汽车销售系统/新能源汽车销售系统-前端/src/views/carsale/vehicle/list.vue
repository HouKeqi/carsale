<template>
  <div class="app-container">
    <!-- 搜索表单 -->
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="品牌" prop="brand">
        <el-select v-model="queryParams.brand" placeholder="请选择品牌" clearable style="width: 200px">
          <el-option
            v-for="brand in brandOptions"
            :key="brand"
            :label="brand"
            :value="brand"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="价格区间">
        <el-input-number v-model="queryParams.minPrice" :min="0" :precision="0" placeholder="最低价" style="width: 120px" />
        <span style="margin: 0 10px">-</span>
        <el-input-number v-model="queryParams.maxPrice" :min="0" :precision="0" placeholder="最高价" style="width: 120px" />
      </el-form-item>
      <el-form-item label="续航里程">
        <el-input-number v-model="queryParams.minRangeKm" :min="0" :precision="0" placeholder="最低" style="width: 120px" />
        <span style="margin: 0 10px">-</span>
        <el-input-number v-model="queryParams.maxRangeKm" :min="0" :precision="0" placeholder="最高" style="width: 120px" />
      </el-form-item>
      <el-form-item label="电池类型" prop="batteryType">
        <el-select v-model="queryParams.batteryType" placeholder="请选择电池类型" clearable style="width: 200px">
          <el-option label="三元锂电池" :value="0" />
          <el-option label="磷酸铁锂电池" :value="1" />
          <el-option label="其他" :value="2" />
        </el-select>
      </el-form-item>
      <el-form-item label="排序方式">
        <el-select v-model="queryParams.orderByColumn" placeholder="排序字段" clearable style="width: 150px">
          <el-option label="价格" value="price" />
          <el-option label="续航里程" value="rangeKm" />
        </el-select>
        <el-select v-model="queryParams.isAsc" placeholder="排序方式" clearable style="width: 120px; margin-left: 10px">
          <el-option label="升序" value="ASC" />
          <el-option label="降序" value="DESC" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 车辆列表 -->
    <el-row :gutter="20" v-loading="loading">
      <el-col :span="6" v-for="vehicle in vehicleList" :key="vehicle.id" style="margin-bottom: 20px">
        <el-card :body-style="{ padding: '0px' }" @click.native="handleDetail(vehicle.id)" style="cursor: pointer">
          <img :src="vehicle.imageUrl || '/static/images/default-vehicle.jpg'" class="vehicle-image" />
          <div style="padding: 14px;">
            <div class="vehicle-name">{{ vehicle.brand }} {{ vehicle.name }}</div>
            <div class="vehicle-price">¥{{ vehicle.price?.toLocaleString() }}</div>
            <div class="vehicle-info">
              <span>续航：{{ vehicle.rangeKm }}km</span>
              <span style="margin-left: 10px">库存：{{ vehicle.stock }}</span>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 分页 -->
    <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />
  </div>
</template>

<script>
import { searchVehicle } from '@/api/carsale/vehicle'

export default {
  name: 'VehicleList',
  data() {
    return {
      loading: false,
      showSearch: true,
      total: 0,
      vehicleList: [],
      brandOptions: ['Tesla', 'BYD', 'Xiaomi', 'NIO', '理想', '小鹏'],
      queryParams: {
        pageNum: 1,
        pageSize: 12,
        brand: null,
        minPrice: null,
        maxPrice: null,
        minRangeKm: null,
        maxRangeKm: null,
        batteryType: null,
        orderByColumn: null,
        isAsc: null
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      searchVehicle(this.queryParams).then(response => {
        this.vehicleList = response.rows
        this.total = response.total
        this.loading = false
      })
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.resetForm('queryForm')
      this.handleQuery()
    },
    handleDetail(id) {
      this.$router.push({ path: '/carsale/vehicle/detail', query: { id: id } })
    }
  }
}
</script>

<style scoped lang="scss">
.vehicle-image {
  width: 100%;
  height: 200px;
  display: block;
  object-fit: cover;
}

.vehicle-name {
  font-size: 16px;
  font-weight: bold;
  margin-bottom: 8px;
}

.vehicle-price {
  font-size: 20px;
  color: #f56c6c;
  font-weight: bold;
  margin-bottom: 8px;
}

.vehicle-info {
  font-size: 14px;
  color: #909399;
}
</style>
