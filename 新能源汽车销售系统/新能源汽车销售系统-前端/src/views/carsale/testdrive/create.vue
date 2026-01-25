<template>
  <div class="app-container">
    <el-card>
      <el-form ref="form" :model="form" :rules="rules" label-width="120px">
        <el-form-item label="选择车型" prop="vehicleId">
          <el-select v-model="form.vehicleId" placeholder="请选择车型" style="width: 100%">
            <el-option
              v-for="vehicle in vehicleList"
              :key="vehicle.id"
              :label="`${vehicle.brand} ${vehicle.name}`"
              :value="vehicle.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="预约门店" prop="storeName">
          <el-input v-model="form.storeName" placeholder="请输入预约门店名称" />
        </el-form-item>
        <el-form-item label="预约时间" prop="appointTime">
          <el-date-picker
            v-model="form.appointTime"
            type="datetime"
            placeholder="选择预约时间"
            style="width: 100%"
            value-format="yyyy-MM-dd HH:mm:ss"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submitForm">提交预约</el-button>
          <el-button @click="cancel">取消</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import { createTestdrive } from '@/api/carsale/testdrive'
import { searchVehicle } from '@/api/carsale/vehicle'

export default {
  name: 'TestdriveCreate',
  data() {
    return {
      form: {
        vehicleId: null,
        storeName: null,
        appointTime: null
      },
      vehicleList: [],
      rules: {
        vehicleId: [{ required: true, message: '请选择车型', trigger: 'change' }],
        storeName: [{ required: true, message: '请输入预约门店', trigger: 'blur' }],
        appointTime: [{ required: true, message: '请选择预约时间', trigger: 'change' }]
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
      })
    },
    submitForm() {
      this.$refs['form'].validate(valid => {
        if (valid) {
          createTestdrive(this.form).then(() => {
            this.$modal.msgSuccess('预约提交成功，等待审核')
            this.$router.push({ path: '/carsale/testdrive/my-list' })
          })
        }
      })
    },
    cancel() {
      this.$router.back()
    }
  }
}
</script>
