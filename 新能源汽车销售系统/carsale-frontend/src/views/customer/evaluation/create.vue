<template>
  <a-card class="main-page">
    <a-form
      ref="formRef"
      :model="form"
      :rules="rules"
      :label-col="{ span: 6 }"
      :wrapper-col="{ span: 18 }"
    >
      <a-form-item label="订单编号">
        <a-input v-model:value="form.orderId" disabled />
      </a-form-item>
      <a-form-item label="评分" name="score">
        <a-rate v-model:value="form.score" :count="5" />
      </a-form-item>
      <a-form-item label="评价内容" name="comment">
        <a-textarea
          v-model:value="form.comment"
          :rows="5"
          placeholder="请输入评价内容"
          :maxlength="500"
          show-count
        />
      </a-form-item>
      <a-form-item label="上传图片">
        <a-upload
          :file-list="fileList"
          list-type="picture-card"
          :before-upload="beforeUpload"
          @preview="handlePreview"
          @remove="handleRemove"
        >
          <div v-if="fileList.length < 5">
            <PlusOutlined />
            <div style="margin-top: 8px">上传</div>
          </div>
        </a-upload>
        <a-modal :open="previewVisible" :footer="null" @cancel="previewVisible = false">
          <img alt="example" style="width: 100%" :src="previewImage" />
        </a-modal>
      </a-form-item>
      <a-form-item>
        <a-button type="primary" @click="submitForm">提交评价</a-button>
        <a-button @click="handleCancel" style="margin-left: 10px">取消</a-button>
      </a-form-item>
    </a-form>
  </a-card>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { message } from 'ant-design-vue'
import { useRouter, useRoute } from 'vue-router'
import { PlusOutlined } from '@ant-design/icons-vue'
import { h } from 'vue'
import request from '@/utils/request'

const router = useRouter()
const route = useRoute()
const formRef = ref(null)
const fileList = ref([])
const previewVisible = ref(false)
const previewImage = ref('')

const form = reactive({
  orderId: null,
  vehicleId: null,
  score: 5,
  comment: null,
  images: null
})

const rules = {
  score: [{ required: true, message: '请选择评分', trigger: 'change' }],
  comment: [{ required: true, message: '请输入评价内容', trigger: 'blur' }]
}

// 上传前检查
const beforeUpload = (file) => {
  const isJPG = file.type === 'image/jpeg' || file.type === 'image/png'
  if (!isJPG) {
    message.error('只能上传 JPG/PNG 格式的图片!')
  }
  const isLt2M = file.size / 1024 / 1024 < 2
  if (!isLt2M) {
    message.error('图片大小不能超过 2MB!')
  }
  if (isJPG && isLt2M) {
    // 上传图片
    uploadImage(file)
  }
  return false
}

// 上传图片
const uploadImage = async (file) => {
  const formData = new FormData()
  formData.append('file', file)
  try {
    const res = await request({
      url: '/common/upload',
      method: 'post',
      data: formData
    })
    if (res.url) {
      fileList.value.push({
        uid: file.uid,
        name: file.name,
        status: 'done',
        url: res.url
      })
      updateImages()
    }
  } catch (error) {
    message.error('上传失败')
  }
}

// 更新图片列表
const updateImages = () => {
  const urls = fileList.value.map(file => file.url).filter(url => url)
  form.images = JSON.stringify(urls)
}

// 预览
const handlePreview = (file) => {
  previewImage.value = file.url || file.preview
  previewVisible.value = true
}

// 删除
const handleRemove = () => {
  updateImages()
}

// 提交表单
const submitForm = () => {
  formRef.value.validate().then(async () => {
    try {
      await request({
        url: '/carsale/evaluation/create',
        method: 'post',
        data: form
      })
      message.success('评价提交成功')
      router.push({ path: '/customer/evaluation/my-list' })
    } catch (error) {
      message.error('评价提交失败')
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
  const orderId = route.query.orderId
  const vehicleId = route.query.vehicleId
  if (orderId) {
    form.orderId = parseInt(orderId)
  }
  if (vehicleId) {
    form.vehicleId = parseInt(vehicleId)
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
