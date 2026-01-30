<template>
  <div class="evaluation-container">
    <a-card :bordered="false" class="main-content-card">
      <a-page-header
          title="发表评价"
          sub-title="分享您的购车体验"
          @back="handleCancel"
          style="padding: 0 0 24px 0"
      />

      <a-row :gutter="40">
        <a-col :xs="24" :lg="8">
          <div class="product-brief">
            <a-card hoverable :bordered="false" class="brief-card">
              <template #cover>
                <img
                    alt="vehicle"
                    :src="vehicleInfo?.imageUrl || '/default-vehicle.jpg'"
                    class="brief-img"
                />
              </template>
              <a-card-meta :title="vehicleInfo?.brand + ' ' + vehicleInfo?.name">
                <template #description>
                  <p>订单编号：{{ form.orderId }}</p>
                </template>
              </a-card-meta>
              <a-divider />
              <div class="evaluation-tips">
                <h4>评价说明</h4>
                <p>• 请客观真实的评价您的购车过程</p>
                <p>• 最多可上传5张现场照片</p>
                <p>• 优质评价有机会获得积分奖励</p>
              </div>
            </a-card>
          </div>
        </a-col>

        <a-col :xs="24" :lg="16">
          <div class="form-wrapper">
            <a-form
                ref="formRef"
                :model="form"
                :rules="rules"
                layout="vertical"
            >
              <a-form-item label="总体评分" name="score">
                <a-rate v-model:value="form.score" :allow-half="false" style="font-size: 24px" />
                <span class="ant-rate-text">{{ scoreDesc[form.score - 1] }}</span>
              </a-form-item>

              <a-form-item label="评价详情" name="comment">
                <a-textarea
                    v-model:value="form.comment"
                    :rows="6"
                    placeholder="车子性能如何？门店服务周到吗？快来分享您的真实感受吧..."
                    :maxlength="500"
                    show-count
                />
              </a-form-item>

              <a-form-item label="晒单图片 (最多5张)">
                <a-upload
                    :file-list="fileList"
                    list-type="picture-card"
                    :before-upload="beforeUpload"
                    @preview="handlePreview"
                    @remove="handleRemove"
                >
                  <div v-if="fileList.length < 5">
                    <PlusOutlined />
                    <div style="margin-top: 8px">上传图片</div>
                  </div>
                </a-upload>
                <a-modal :open="previewVisible" :footer="null" @cancel="previewVisible = false">
                  <img alt="preview" style="width: 100%" :src="previewImage" />
                </a-modal>
              </a-form-item>

              <a-form-item class="form-actions">
                <a-space size="large">
                  <a-button type="primary" size="large" :loading="loading" @click="submitForm" style="width: 150px">
                    发布评价
                  </a-button>
                  <a-button size="large" @click="handleCancel">取消</a-button>
                </a-space>
              </a-form-item>
            </a-form>
          </div>
        </a-col>
      </a-row>
    </a-card>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { message } from 'ant-design-vue'
import { useRouter, useRoute } from 'vue-router'
import { PlusOutlined } from '@ant-design/icons-vue'
import request from '@/utils/request'

const router = useRouter()
const route = useRoute()
const formRef = ref(null)
const loading = ref(false)
const vehicleInfo = ref(null)
const fileList = ref([])
const previewVisible = ref(false)
const previewImage = ref('')

const scoreDesc = ['极差', '失望', '一般', '满意', '非常满意']

const form = reactive({
  orderId: null,
  vehicleId: null,
  score: 5,
  comment: '',
  images: null
})

const rules = {
  score: [{ required: true, message: '请给这次购车体验打个分吧', trigger: 'change' }],
  comment: [{ required: true, message: '评价内容不能为空', trigger: 'blur' }, { min: 10, message: '评价内容至少10个字', trigger: 'blur' }]
}

// 获取车辆简要信息
const getVehicleBrief = async (id) => {
  try {
    const res = await request({ url: `/carsale/vehicle/${id}`, method: 'get' })
    vehicleInfo.value = res.data?.vehicle
  } catch (e) { console.error(e) }
}

const beforeUpload = (file) => {
  const isTypeValid = file.type === 'image/jpeg' || file.type === 'image/png'
  if (!isTypeValid) message.error('只能上传 JPG/PNG 格式的图片!')
  const isLt2M = file.size / 1024 / 1024 < 2
  if (!isLt2M) message.error('图片大小不能超过 2MB!')

  if (isTypeValid && isLt2M) {
    uploadImage(file)
  }
  return false
}

const uploadImage = async (file) => {
  const formData = new FormData()
  formData.append('file', file)
  try {
    const res = await request({ url: '/common/upload', method: 'post', data: formData })
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
    message.error('图片上传失败')
  }
}

const updateImages = () => {
  const urls = fileList.value.map(file => file.url).filter(url => url)
  form.images = JSON.stringify(urls)
}

const handlePreview = (file) => {
  previewImage.value = file.url || file.preview
  previewVisible.value = true
}

const handleRemove = () => {
  setTimeout(updateImages, 100) // 延迟确保列表已更新
}

const submitForm = () => {
  formRef.value.validate().then(async () => {
    loading.value = true
    try {
      await request({
        url: '/carsale/evaluation/create',
        method: 'post',
        data: form
      })
      message.success('评价已发布，感谢您的分享！')
      router.push({ path: '/customer/evaluation/my-list' })
    } catch (error) {
      message.error('提交失败，请稍后重试')
    } finally {
      loading.value = false
    }
  })
}

const handleCancel = () => router.back()

onMounted(() => {
  const { orderId, vehicleId } = route.query
  if (orderId) form.orderId = parseInt(orderId)
  if (vehicleId) {
    form.vehicleId = parseInt(vehicleId)
    getVehicleBrief(vehicleId)
  }
})
</script>

<style scoped>
.evaluation-container {
  padding: 24px;
  background-color: #f0f2f5;
  min-height: 100vh;
}

.main-content-card {
  max-width: 1000px;
  margin: 0 auto;
  border-radius: 8px;
}

.product-brief {
  position: sticky;
  top: 24px;
}

.brief-card {
  background: #fafafa;
  border: 1px solid #f0f0f0;
}

.brief-img {
  height: 200px;
  object-fit: contain;
  padding: 20px;
  background: #fff;
}

.evaluation-tips {
  margin-top: 16px;
}

.evaluation-tips h4 {
  font-size: 14px;
  color: #333;
  margin-bottom: 8px;
}

.evaluation-tips p {
  font-size: 12px;
  color: #999;
  margin-bottom: 4px;
}

.form-wrapper {
  background: #fff;
  padding: 0 20px;
}

.ant-rate-text {
  margin-left: 12px;
  font-weight: 500;
  color: #faad14;
}

.form-actions {
  margin-top: 40px;
  padding-top: 24px;
  border-top: 1px solid #f0f0f0;
}

/* 适配移动端 */
@media (max-width: 768px) {
  .product-brief {
    margin-bottom: 24px;
  }
}
</style>
