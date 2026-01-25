<template>
  <div class="login-container">
    <a-form
      ref="loginFormRef"
      :model="loginForm"
      :rules="loginRules"
      class="login-form"
      @finish="handleLogin"
    >
      <div class="title-container">
        <h3 class="title">新能源汽车销售系统</h3>
      </div>

      <a-form-item name="username">
        <a-input
          v-model:value="loginForm.username"
          placeholder="用户名"
          size="large"
        >
          <template #prefix>
            <UserOutlined />
          </template>
        </a-input>
      </a-form-item>

      <a-form-item name="password">
        <a-input-password
          v-model:value="loginForm.password"
          placeholder="密码"
          size="large"
          @keyup.enter="handleLogin"
        >
          <template #prefix>
            <LockOutlined />
          </template>
        </a-input-password>
      </a-form-item>

      <a-form-item name="code">
        <a-input-group compact>
          <a-input
            v-model:value="loginForm.code"
            placeholder="验证码"
            size="large"
            style="width: calc(100% - 120px)"
            @keyup.enter="handleLogin"
          >
            <template #prefix>
              <KeyOutlined />
            </template>
          </a-input>
          <div class="login-code">
            <img :src="codeUrl" class="login-code-img" @click="getCode" />
          </div>
        </a-input-group>
      </a-form-item>

      <a-form-item>
        <a-button
          :loading="loading"
          type="primary"
          html-type="submit"
          size="large"
          block
        >
          登录
        </a-button>
      </a-form-item>
    </a-form>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { getCodeImg } from '@/api/auth'
import { message } from 'ant-design-vue'
import { UserOutlined, LockOutlined, KeyOutlined } from '@ant-design/icons-vue'

const router = useRouter()
const authStore = useAuthStore()

const loginFormRef = ref(null)
const loading = ref(false)
const codeUrl = ref('')
const loginForm = reactive({
  username: 'admin',
  password: 'admin123',
  code: '',
  uuid: ''
})

const loginRules = {
  username: [{ required: true, trigger: 'blur', message: '用户名不能为空' }],
  password: [{ required: true, trigger: 'blur', message: '密码不能为空' }],
  code: [{ required: true, trigger: 'change', message: '验证码不能为空' }]
}

const getCode = async () => {
  try {
    const res = await getCodeImg()
    if (res && res.img) {
      codeUrl.value = 'data:image/gif;base64,' + res.img
      loginForm.uuid = res.uuid
    } else {
      message.error('获取验证码失败：响应数据格式错误')
      console.error('验证码响应:', res)
    }
  } catch (error) {
    message.error('获取验证码失败：' + (error.message || '网络错误'))
    console.error('获取验证码错误:', error)
  }
}

const handleLogin = () => {
  loginFormRef.value.validate().then(async () => {
    loading.value = true
    try {
      await authStore.login(loginForm)
      await authStore.getUserInfo()
      message.success('登录成功')
      
      // 根据用户角色跳转到对应页面
      const isAdmin = authStore.roles?.includes('admin') || false
      const isCustomer = authStore.roles?.includes('customer') || false
      
      if (isAdmin) {
        // 管理员跳转到车辆管理页面
        router.push('/admin/vehicle')
      } else if (isCustomer) {
        // 普通用户跳转到车辆查看页面
        router.push('/customer/vehicle/list')
      } else {
        // 如果没有角色信息，默认跳转到车辆浏览页面
        router.push('/customer/vehicle/list')
      }
    } catch (error) {
      loading.value = false
      // 刷新验证码
      getCode()
    }
  }).catch(() => {
    // 验证失败
  })
}

onMounted(() => {
  getCode()
})
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.login-container {
  min-height: 100vh;
  width: 100%;
  background: $gradient-light-blue;
  position: relative;
  overflow: hidden;
  display: flex;
  justify-content: center;
  align-items: center;
  
  // 添加装饰性背景元素 - 浅蓝色
  &::before {
    content: '';
    position: absolute;
    width: 500px;
    height: 500px;
    border-radius: 50%;
    background: rgba(59, 130, 246, 0.08);
    top: -250px;
    right: -250px;
    animation: float 20s ease-in-out infinite;
  }
  
  &::after {
    content: '';
    position: absolute;
    width: 400px;
    height: 400px;
    border-radius: 50%;
    background: rgba(147, 197, 253, 0.1);
    bottom: -200px;
    left: -200px;
    animation: float 15s ease-in-out infinite reverse;
  }

  .login-form {
    position: relative;
    width: 480px;
    max-width: 90%;
    padding: 48px 40px;
    margin: 0 auto;
    background: $bg-white;
    border-radius: $radius-xl;
    box-shadow: $shadow-xl;
    border: 1px solid rgba(59, 130, 246, 0.1);
    z-index: 1;
    animation: slideUp 0.5s ease-out;
  }

  .title-container {
    position: relative;
    margin-bottom: 40px;

    .title {
      font-size: 28px;
      color: $primary-color;
      margin: 0;
      text-align: center;
      font-weight: 600;
      letter-spacing: 0.5px;
    }
  }

  .login-code {
    width: 120px;
    height: 40px;
    border-radius: $radius-md;
    overflow: hidden;
    display: inline-block;

    .login-code-img {
      height: 40px;
      width: 100%;
      cursor: pointer;
      transition: transform 0.2s;
      
      &:hover {
        transform: scale(1.05);
      }
    }
  }
}

@keyframes float {
  0%, 100% {
    transform: translate(0, 0) rotate(0deg);
  }
  50% {
    transform: translate(30px, 30px) rotate(180deg);
  }
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

:deep(.ant-input-affix-wrapper) {
  border-radius: $radius-md;
  transition: all 0.3s ease;
  
  &:hover {
    border-color: $primary-light;
  }
}

:deep(.ant-input-affix-wrapper-focused) {
  border-color: $primary-color;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

:deep(.ant-btn-primary) {
  background: $primary-color;
  border: none;
  border-radius: $radius-md;
  transition: all 0.3s ease;
  box-shadow: $shadow-md;
  
  &:hover {
    background: $primary-hover;
    transform: translateY(-2px);
    box-shadow: $shadow-lg;
  }
  
  &:active {
    transform: translateY(0);
  }
}
</style>
