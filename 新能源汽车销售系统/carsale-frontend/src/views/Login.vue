<template>
  <div class="login-container">
    <el-form
      ref="loginFormRef"
      :model="loginForm"
      :rules="loginRules"
      class="login-form"
      auto-complete="on"
      label-position="left"
    >
      <div class="title-container">
        <h3 class="title">新能源汽车销售系统</h3>
      </div>

      <el-form-item prop="username">
        <el-input
          ref="username"
          v-model="loginForm.username"
          placeholder="用户名"
          name="username"
          type="text"
          tabindex="1"
          auto-complete="on"
        >
          <template #prefix>
            <el-icon><User /></el-icon>
          </template>
        </el-input>
      </el-form-item>

      <el-tooltip v-model:visible="capsTooltip" content="大写锁定已打开" placement="right" manual>
        <el-form-item prop="password">
          <el-input
            :key="passwordType"
            ref="passwordRef"
            v-model="loginForm.password"
            :type="passwordType"
            placeholder="密码"
            name="password"
            tabindex="2"
            auto-complete="on"
            @keyup="checkCapslock"
            @blur="capsTooltip = false"
            @keyup.enter="handleLogin"
          >
            <template #prefix>
              <el-icon><Lock /></el-icon>
            </template>
            <template #suffix>
              <el-icon class="show-pwd" @click="showPwd">
                <View v-if="passwordType === 'password'" />
                <Hide v-else />
              </el-icon>
            </template>
          </el-input>
        </el-form-item>
      </el-tooltip>

      <el-form-item prop="code">
        <el-input
          v-model="loginForm.code"
          auto-complete="off"
          placeholder="验证码"
          style="width: 63%"
          @keyup.enter="handleLogin"
        >
          <template #prefix>
            <el-icon><Key /></el-icon>
          </template>
        </el-input>
        <div class="login-code">
          <img :src="codeUrl" class="login-code-img" @click="getCode" />
        </div>
      </el-form-item>

      <el-button
        :loading="loading"
        type="primary"
        style="width: 100%; margin-bottom: 30px"
        @click.prevent="handleLogin"
      >
        登录
      </el-button>
    </el-form>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { getCodeImg } from '@/api/auth'
import { ElMessage } from 'element-plus'
import { View, Hide, User, Lock, Key } from '@element-plus/icons-vue'

const router = useRouter()
const authStore = useAuthStore()

const loginFormRef = ref(null)
const passwordRef = ref(null)
const passwordType = ref('password')
const capsTooltip = ref(false)
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

const showPwd = () => {
  if (passwordType.value === 'password') {
    passwordType.value = ''
  } else {
    passwordType.value = 'password'
  }
}

const checkCapslock = (e) => {
  const { key } = e
  capsTooltip.value = key && key.length === 1 && key >= 'A' && key <= 'Z'
}

const getCode = async () => {
  try {
    const res = await getCodeImg()
    if (res && res.img) {
      codeUrl.value = 'data:image/gif;base64,' + res.img
      loginForm.uuid = res.uuid
    } else {
      ElMessage.error('获取验证码失败：响应数据格式错误')
      console.error('验证码响应:', res)
    }
  } catch (error) {
    ElMessage.error('获取验证码失败：' + (error.message || '网络错误'))
    console.error('获取验证码错误:', error)
  }
}

const handleLogin = () => {
  loginFormRef.value.validate(async (valid) => {
    if (valid) {
      loading.value = true
      try {
        await authStore.login(loginForm)
        await authStore.getUserInfo()
        ElMessage.success('登录成功')
        router.push('/')
      } catch (error) {
        loading.value = false
        // 刷新验证码
        getCode()
      }
    } else {
      return false
    }
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

  .show-pwd {
    font-size: 18px;
    color: $text-secondary;
    cursor: pointer;
    user-select: none;
    transition: color 0.3s;
    
    &:hover {
      color: $primary-color;
    }
  }

  .login-code {
    width: 33%;
    height: 40px;
    float: right;
    border-radius: $radius-md;
    overflow: hidden;

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

:deep(.el-input) {
  display: inline-block;
  height: 48px;
  width: 100%;

  .el-input__wrapper {
    background: $bg-white !important;
    border: 1px solid $border-color !important;
    border-radius: $radius-md !important;
    box-shadow: $shadow-sm !important;
    transition: all 0.3s ease;
    
    &:hover {
      border-color: $primary-light !important;
      box-shadow: $shadow-md !important;
    }
  }

  input {
    background: transparent !important;
    border: 0 !important;
    padding: 12px 15px;
    color: $text-primary !important;
    height: 48px;
    caret-color: $primary-color;
    font-size: 14px;

    &::placeholder {
      color: $text-tertiary !important;
    }

    &:focus {
      color: $text-primary !important;
    }
  }
}

:deep(.el-form-item) {
  border: none;
  background: transparent;
  margin-bottom: 24px;
}

:deep(.el-input__wrapper.is-focus) {
  border-color: $primary-color !important;
  box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1) !important;
}

:deep(.el-input__prefix) {
  color: $text-secondary;
  padding-left: 12px;
}

:deep(.el-input__suffix) {
  color: $text-secondary;
  padding-right: 12px;
}

:deep(.el-button--primary) {
  background: $primary-color;
  border: none;
  height: 48px;
  font-size: 16px;
  font-weight: 500;
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
