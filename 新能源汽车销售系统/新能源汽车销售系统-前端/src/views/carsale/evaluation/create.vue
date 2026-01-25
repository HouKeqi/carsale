<template>
  <div class="app-container">
    <el-card>
      <el-form ref="form" :model="form" :rules="rules" label-width="120px">
        <el-form-item label="订单编号" prop="orderId">
          <el-input v-model="form.orderId" disabled />
        </el-form-item>
        <el-form-item label="评分" prop="score">
          <el-rate v-model="form.score" :max="5" show-text />
        </el-form-item>
        <el-form-item label="评价内容" prop="comment">
          <el-input
            v-model="form.comment"
            type="textarea"
            :rows="5"
            placeholder="请输入评价内容"
            maxlength="500"
            show-word-limit
          />
        </el-form-item>
        <el-form-item label="上传图片">
          <el-upload
            action="#"
            list-type="picture-card"
            :file-list="fileList"
            :on-preview="handlePictureCardPreview"
            :on-remove="handleRemove"
            :on-success="handleUploadSuccess"
            :before-upload="beforeUpload"
            :http-request="handleUpload"
          >
            <i class="el-icon-plus"></i>
          </el-upload>
          <el-dialog :visible.sync="dialogVisible">
            <img width="100%" :src="dialogImageUrl" alt="" />
          </el-dialog>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submitForm">提交评价</el-button>
          <el-button @click="cancel">取消</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import { createEvaluation } from '@/api/carsale/evaluation'
import { upload } from '@/utils/upload'
import { parseTime } from '@/utils/ruoyi'

export default {
  name: 'EvaluationCreate',
  data() {
    return {
      form: {
        orderId: null,
        vehicleId: null,
        score: 5,
        comment: null,
        images: null
      },
      fileList: [],
      dialogVisible: false,
      dialogImageUrl: '',
      imageUrls: [],
      rules: {
        score: [{ required: true, message: '请选择评分', trigger: 'change' }],
        comment: [{ required: true, message: '请输入评价内容', trigger: 'blur' }]
      }
    }
  },
  created() {
    const orderId = this.$route.query.orderId
    const vehicleId = this.$route.query.vehicleId
    if (orderId) {
      this.form.orderId = parseInt(orderId)
    }
    if (vehicleId) {
      this.form.vehicleId = parseInt(vehicleId)
    }
  },
  methods: {
    handleUpload(option) {
      upload(option).then(response => {
        if (response.code === 200) {
          this.imageUrls.push(response.url)
          this.form.images = JSON.stringify(this.imageUrls)
          option.onSuccess()
        } else {
          option.onError()
          this.$modal.msgError('上传失败')
        }
      }).catch(() => {
        option.onError()
        this.$modal.msgError('上传失败')
      })
    },
    handleUploadSuccess(response, file, fileList) {
      this.fileList = fileList
    },
    beforeUpload(file) {
      const isJPG = file.type === 'image/jpeg' || file.type === 'image/png'
      const isLt2M = file.size / 1024 / 1024 < 2
      if (!isJPG) {
        this.$modal.msgError('上传图片只能是 JPG/PNG 格式!')
      }
      if (!isLt2M) {
        this.$modal.msgError('上传图片大小不能超过 2MB!')
      }
      return isJPG && isLt2M
    },
    handleRemove(file, fileList) {
      this.fileList = fileList
      this.imageUrls = fileList.map(f => f.url).filter(url => url)
      this.form.images = JSON.stringify(this.imageUrls)
    },
    handlePictureCardPreview(file) {
      this.dialogImageUrl = file.url
      this.dialogVisible = true
    },
    submitForm() {
      this.$refs['form'].validate(valid => {
        if (valid) {
          createEvaluation(this.form).then(() => {
            this.$modal.msgSuccess('评价提交成功')
            this.$router.push({ path: '/carsale/evaluation/my-list' })
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
