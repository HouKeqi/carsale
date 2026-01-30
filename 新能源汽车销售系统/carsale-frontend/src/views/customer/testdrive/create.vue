<template>
  <a-card class="main-page">
    <a-form
      ref="formRef"
      :model="form"
      :rules="rules"
      :label-col="{ span: 6 }"
      :wrapper-col="{ span: 18 }"
    >
      <a-form-item label="选择车型" name="vehicleId">
        <a-select
          v-model:value="form.vehicleId"
          placeholder="请选择车型"
          style="width: 100%"
        >
          <a-select-option
            v-for="vehicle in vehicleList"
            :key="vehicle.id"
            :value="vehicle.id"
          >
            {{ vehicle.brand }} {{ vehicle.name }}
          </a-select-option>
        </a-select>
      </a-form-item>
      <a-form-item label="预约门店" name="storeName">
        <a-select
          v-model:value="form.storeName"
          placeholder="请选择预约门店"
          style="width: 100%"
        >
          <a-select-option
            v-for="store in storeList"
            :key="store.id"
            :value="store.name"
          >
            {{ store.name }} - {{ store.address }}
          </a-select-option>
        </a-select>
      </a-form-item>
      <a-form-item label="预约时间" name="appointTime">
        <a-date-picker
          v-model:value="form.appointTime"
          show-time
          placeholder="选择预约时间"
          style="width: 100%"
          format="YYYY-MM-DD HH:mm:ss"
          value-format="YYYY-MM-DD HH:mm:ss"
        />
      </a-form-item>
      <a-form-item>
        <a-button type="primary" @click="submitForm">提交预约</a-button>
        <a-button @click="handleCancel" style="margin-left: 10px">取消</a-button>
      </a-form-item>
    </a-form>
  </a-card>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { message } from 'ant-design-vue'
import { useRouter, useRoute } from 'vue-router'
import request from '@/utils/request'

const router = useRouter()
const route = useRoute()
const formRef = ref(null)
const vehicleList = ref([])
const storeList = ref([])

const form = reactive({
  vehicleId: null,
  storeName: null,
  appointTime: null
})

const rules = {
  vehicleId: [{ required: true, message: '请选择车型', trigger: 'change' }],
  storeName: [{ required: true, message: '请输入预约门店', trigger: 'blur' }],
  appointTime: [{ required: true, message: '请选择预约时间', trigger: 'change' }]
}

// 获取车辆列表
const getVehicleList = async () => {
  try {
    const res = await request({
      url: '/carsale/vehicle/search',
      method: 'get',
      params: { pageNum: 1, pageSize: 100 }
    })
    vehicleList.value = res.rows || res.data || []
    const vehicleId = route.query.vehicleId
    if (vehicleId) {
      form.vehicleId = parseInt(vehicleId)
    }
  } catch (error) {
    message.error('获取车辆列表失败')
  }
}

// 获取门店列表
const getStoreList = async () => {
  try {
    const res = await request({
      url: '/carsale/store/list',
      method: 'get'
    })
    storeList.value = res.data || []
  } catch (error) {
    message.error('获取门店列表失败')
  }
}

// 提交表单
const submitForm = () => {
  formRef.value.validate().then(async () => {
    try {
      await request({
        url: '/carsale/testdrive/create',
        method: 'post',
        data: form
      })
      message.success('预约提交成功，等待审核')
      router.push({ path: '/customer/testdrive/my-list' })
    } catch (error) {
      message.error('预约提交失败')
    }
  }).catch(() => {
    // 验证失败
  })
}

// 取消
const handleCancel = () => {
  router.back()
}

onMounted(() => {
  getVehicleList()
  getStoreList()
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
