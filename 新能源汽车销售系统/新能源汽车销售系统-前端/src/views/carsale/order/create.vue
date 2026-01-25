<template>
  <div class="app-container">
    <el-card>
      <el-form ref="form" :model="form" :rules="rules" label-width="120px">
        <el-form-item label="选择车型" prop="vehicleId">
          <el-select v-model="form.vehicleId" placeholder="请选择车型" @change="handleVehicleChange" style="width: 100%">
            <el-option
              v-for="vehicle in vehicleList"
              :key="vehicle.id"
              :label="`${vehicle.brand} ${vehicle.name} - ¥${vehicle.price?.toLocaleString()}`"
              :value="vehicle.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="购车数量" prop="number">
          <el-input-number v-model="form.number" :min="1" :max="10" />
        </el-form-item>
        <el-form-item label="提车门店" prop="storeLocation">
          <el-input v-model="form.storeLocation" placeholder="请输入提车门店名称" />
        </el-form-item>
        <el-form-item label="联系方式" prop="phone">
          <el-input v-model="form.phone" placeholder="请输入联系方式" />
        </el-form-item>
        <el-form-item label="成交金额" prop="amount">
          <el-input-number v-model="form.amount" :min="0" :precision="2" style="width: 100%" />
          <span style="margin-left: 10px; color: #909399">（根据车型和数量自动计算，可手动调整）</span>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submitForm">提交订单</el-button>
          <el-button @click="cancel">取消</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import { createOrder } from '@/api/carsale/order'
import { searchVehicle } from '@/api/carsale/vehicle'

export default {
  name: 'OrderCreate',
  data() {
    return {
      form: {
        vehicleId: null,
        number: 1,
        storeLocation: null,
        phone: null,
        amount: null
      },
      vehicleList: [],
      selectedVehicle: null,
      rules: {
        vehicleId: [{ required: true, message: '请选择车型', trigger: 'change' }],
        number: [{ required: true, message: '请输入购车数量', trigger: 'blur' }],
        storeLocation: [{ required: true, message: '请输入提车门店', trigger: 'blur' }],
        phone: [{ required: true, message: '请输入联系方式', trigger: 'blur' }],
        amount: [{ required: true, message: '请输入成交金额', trigger: 'blur' }]
      }
    }
  },
  created() {
    const vehicleId = this.$route.query.vehicleId
    if (vehicleId) {
      this.form.vehicleId = parseInt(vehicleId)
    }
    this.getVehicleList()
  },
  methods: {
    getVehicleList() {
      searchVehicle({ pageNum: 1, pageSize: 100 }).then(response => {
        this.vehicleList = response.rows
        if (this.form.vehicleId) {
          this.handleVehicleChange(this.form.vehicleId)
        }
      })
    },
    handleVehicleChange(vehicleId) {
      this.selectedVehicle = this.vehicleList.find(v => v.id === vehicleId)
      if (this.selectedVehicle) {
        this.form.amount = this.selectedVehicle.price * this.form.number
      }
    },
    submitForm() {
      this.$refs['form'].validate(valid => {
        if (valid) {
          createOrder(this.form).then(() => {
            this.$modal.msgSuccess('订单创建成功')
            this.$router.push({ path: '/carsale/order/my-list' })
          })
        }
      })
    },
    cancel() {
      this.$router.back()
    }
  },
  watch: {
    'form.number'(newVal) {
      if (this.selectedVehicle) {
        this.form.amount = this.selectedVehicle.price * newVal
      }
    }
  }
}
</script>
