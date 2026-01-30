<template>
  <div class="profile-container">
    <a-row :gutter="24">
      <a-col :xs="24" :md="8" :lg="6">
        <a-card :bordered="false" class="user-brief-card">
          <div class="avatar-section">
            <a-avatar :size="84" style="background-color: #1890ff">
              <template #icon><UserOutlined /></template>
            </a-avatar>
            <div class="user-name">{{ form.nickName || '未设置昵称' }}</div>
            <a-tag color="blue" class="role-tag">认证客户</a-tag>
          </div>

          <a-divider />

          <div class="nav-links">
            <div class="nav-item active">
              <span class="icon-text"><SettingOutlined /> 账号设置</span>
            </div>
            <div class="nav-item" @click="router.push('/customer/order/my-list')">
              <span class="icon-text"><OrderedListOutlined /> 我的订单</span>
              <RightOutlined class="arrow" />
            </div>
            <div class="nav-item" @click="router.push('/customer/evaluation/my-list')">
              <span class="icon-text"><CommentOutlined /> 我的评价</span>
              <RightOutlined class="arrow" />
            </div>
          </div>
        </a-card>
      </a-col>

      <a-col :xs="24" :md="16" :lg="18">
        <a-card :bordered="false" title="基本信息设置" class="info-edit-card">
          <a-form
              ref="formRef"
              :model="form"
              :rules="rules"
              layout="vertical"
              class="profile-form"
          >
            <a-row :gutter="32">
              <a-col :span="12">
                <a-form-item label="用户账号">
                  <a-input v-model:value="form.userName" disabled />
                </a-form-item>
              </a-col>
              <a-col :span="12">
                <a-form-item label="用户昵称" name="nickName">
                  <a-input v-model:value="form.nickName" placeholder="起个好听的昵称吧" />
                </a-form-item>
              </a-col>
              <a-col :span="12">
                <a-form-item label="真实姓名" name="realName">
                  <a-input v-model:value="form.realName" placeholder="用于购车合同" />
                </a-form-item>
              </a-col>
              <a-col :span="12">
                <a-form-item label="手机号码" name="phonenumber">
                  <a-input v-model:value="form.phonenumber" placeholder="接收试驾预约通知" />
                </a-form-item>
              </a-col>
              <a-col :span="24">
                <a-form-item label="身份证号" name="idCard">
                  <a-input v-model:value="form.idCard" placeholder="您的身份证信息将被严格加密" />
                </a-form-item>
              </a-col>
              <a-col :span="24">
                <a-form-item label="联系地址" name="address">
                  <a-textarea
                      v-model:value="form.address"
                      :rows="3"
                      placeholder="请输入详细的联系地址或车辆交付地址"
                  />
                </a-form-item>
              </a-col>
            </a-row>

            <div class="form-actions">
              <a-button type="primary" size="large" @click="submitForm" style="width: 120px">
                更新信息
              </a-button>
              <a-button size="large" @click="reset" style="margin-left: 12px">
                重置
              </a-button>
            </div>
          </a-form>
        </a-card>
      </a-col>
    </a-row>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { message } from 'ant-design-vue'
import { useRouter } from 'vue-router'
import {
  UserOutlined,
  SettingOutlined,
  OrderedListOutlined,
  CommentOutlined,
  RightOutlined
} from '@ant-design/icons-vue'
import request from '@/utils/request'

const router = useRouter()
const formRef = ref(null)

const form = reactive({
  userName: '',
  nickName: '',
  realName: '',
  phonenumber: '',
  idCard: '',
  address: ''
})

const rules = {
  nickName: [{ required: true, message: '用户昵称不能为空', trigger: 'blur' }],
  phonenumber: [
    { required: true, message: '手机号码不能为空', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
  ]
}

const getUserInfo = async () => {
  try {
    const res = await request({ url: '/getInfo', method: 'get' })
    if (res.user) {
      Object.assign(form, {
        userName: res.user.userName || '',
        nickName: res.user.nickName || '',
        realName: res.user.realName || '',
        phonenumber: res.user.phonenumber || '',
        idCard: res.user.idCard || '',
        address: res.user.address || ''
      })
    }
  } catch (e) { message.error('获取信息失败') }
}

const submitForm = () => {
  formRef.value.validate().then(async () => {
    try {
      await request({ url: '/system/user/profile', method: 'put', data: form })
      message.success('更新成功')
      getUserInfo()
    } catch (e) { message.error('更新失败') }
  })
}

const reset = () => getUserInfo()

onMounted(getUserInfo)
</script>

<style scoped>
.profile-container {
  padding: 24px;
  background-color: #f0f2f5;
  min-height: 100vh;
}

.user-brief-card {
  border-radius: 8px;
  text-align: center;
  padding: 10px 0;
}

.avatar-section {
  padding: 20px 0;
}

.user-name {
  margin-top: 16px;
  font-size: 18px;
  font-weight: 600;
  color: #262626;
}

.role-tag {
  margin-top: 8px;
}

.nav-links {
  margin-top: 20px;
  text-align: left;
}

.nav-item {
  padding: 12px 16px;
  margin-bottom: 4px;
  cursor: pointer;
  border-radius: 4px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: #595959;
  transition: all 0.3s;
}

.nav-item:hover {
  background-color: #f5f5f5;
  color: #1890ff;
}

.nav-item.active {
  background-color: #e6f7ff;
  color: #1890ff;
  font-weight: 500;
}

.icon-text span {
  margin-right: 8px;
}

.info-edit-card {
  border-radius: 8px;
  min-height: 500px;
}

.profile-form {
  padding: 20px 0;
}

.form-actions {
  margin-top: 24px;
  padding-top: 24px;
  border-top: 1px solid #f0f0f0;
}

/* 移动端适配 */
@media (max-width: 768px) {
  .user-brief-card {
    margin-bottom: 24px;
  }
}
</style>
