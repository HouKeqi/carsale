<template>
  <div class="app-container">
    <el-container>
      <!-- 侧边栏 -->
      <el-aside width="240px" class="sidebar">
        <div class="logo-container">
          <div class="logo">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M12 2L2 7L12 12L22 7L12 2Z" fill="currentColor"/>
              <path d="M2 17L12 22L22 17" stroke="currentColor" stroke-width="2" fill="none"/>
              <path d="M2 12L12 17L22 12" stroke="currentColor" stroke-width="2" fill="none"/>
            </svg>
          </div>
          <h1 class="logo-text">新能源销售</h1>
        </div>
        <el-menu
          :default-active="activeMenu"
          class="sidebar-menu"
          router
          background-color="transparent"
          text-color="#6b7280"
          active-text-color="#3b82f6"
        >
          <el-menu-item index="/">
            <el-icon><House /></el-icon>
            <span>车辆管理</span>
          </el-menu-item>
        </el-menu>
      </el-aside>

      <!-- 主内容区 -->
      <el-container class="main-container">
        <!-- 顶部导航栏 -->
        <el-header class="header">
          <div class="header-left">
            <el-breadcrumb separator="/">
              <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
              <el-breadcrumb-item>{{ currentRouteName }}</el-breadcrumb-item>
            </el-breadcrumb>
          </div>
          <div class="header-right">
            <div class="user-info">
              <el-avatar :size="36" class="user-avatar">
                {{ authStore.name?.charAt(0) || 'U' }}
              </el-avatar>
              <span class="username">{{ authStore.name }}</span>
              <el-dropdown @command="handleCommand">
                <el-icon class="dropdown-icon"><ArrowDown /></el-icon>
                <template #dropdown>
                  <el-dropdown-menu>
                    <el-dropdown-item command="logout">退出登录</el-dropdown-item>
                  </el-dropdown-menu>
                </template>
              </el-dropdown>
            </div>
          </div>
        </el-header>

        <!-- 主内容 -->
        <el-main class="main-content">
          <router-view />
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { ElMessage } from 'element-plus'
import { House, ArrowDown } from '@element-plus/icons-vue'

const authStore = useAuthStore()
const router = useRouter()
const route = useRoute()

const activeMenu = computed(() => route.path)
const currentRouteName = computed(() => {
  const routeMap = {
    '/': '车辆管理'
  }
  return routeMap[route.path] || '首页'
})

const handleCommand = async (command) => {
  if (command === 'logout') {
    try {
      await authStore.logout()
      ElMessage.success('退出登录成功')
      router.push('/login')
    } catch (error) {
      ElMessage.error('退出登录失败')
    }
  }
}
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.app-container {
  height: 100vh;
  display: flex;
  background: $bg-color;
}

// 侧边栏样式
.sidebar {
  background: $bg-white;
  border-right: 1px solid $border-color;
  box-shadow: $shadow-sm;
  height: 100vh;
  overflow-y: auto;
  position: fixed;
  left: 0;
  top: 0;
  z-index: 100;
}

.logo-container {
  display: flex;
  align-items: center;
  padding: 24px 20px;
  border-bottom: 1px solid $border-color;
  gap: 12px;
  background: $primary-bg;
  
  .logo {
    width: 40px;
    height: 40px;
    background: $primary-color;
    border-radius: $radius-md;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    flex-shrink: 0;
    
    svg {
      width: 24px;
      height: 24px;
    }
  }
  
  .logo-text {
    font-size: 18px;
    font-weight: 600;
    color: $primary-color;
    margin: 0;
  }
}

.sidebar-menu {
  border: none;
  padding: 16px 0;
  
  :deep(.el-menu-item) {
    height: 48px;
    line-height: 48px;
    margin: 4px 12px;
    border-radius: $radius-md;
    transition: all 0.3s ease;
    
    &:hover {
      background: $primary-bg;
      color: $primary-color;
    }
    
    &.is-active {
      background: $primary-bg;
      color: $primary-color;
      font-weight: 500;
      
      &::before {
        content: '';
        position: absolute;
        left: 0;
        top: 50%;
        transform: translateY(-50%);
        width: 3px;
        height: 24px;
        background: $primary-color;
        border-radius: 0 3px 3px 0;
      }
    }
    
    .el-icon {
      font-size: 20px;
      margin-right: 12px;
    }
  }
}

// 主容器
.main-container {
  margin-left: 240px;
  width: calc(100% - 240px);
  display: flex;
  flex-direction: column;
}

// 顶部导航栏
.header {
  height: 64px;
  background: $bg-white;
  border-bottom: 1px solid $border-color;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24px;
  box-shadow: $shadow-sm;
  position: sticky;
  top: 0;
  z-index: 10;
}

.header-left {
  flex: 1;
  
  :deep(.el-breadcrumb) {
    font-size: 14px;
    
    .el-breadcrumb__inner {
      color: $text-secondary;
      font-weight: 400;
      
      &.is-link {
        color: $text-secondary;
        
        &:hover {
          color: $primary-color;
        }
      }
    }
    
    .el-breadcrumb__item:last-child .el-breadcrumb__inner {
      color: $text-primary;
      font-weight: 500;
    }
  }
}

.header-right {
  display: flex;
  align-items: center;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 8px 16px;
  border-radius: $radius-lg;
  transition: background 0.3s;
  cursor: pointer;
  
  &:hover {
    background: $bg-color;
  }
}

.user-avatar {
  background: $primary-color;
  color: white;
  font-weight: 600;
  flex-shrink: 0;
}

.username {
  font-size: 14px;
  color: $text-primary;
  font-weight: 500;
  min-width: 60px;
}

.dropdown-icon {
  color: $text-secondary;
  font-size: 16px;
  cursor: pointer;
  transition: color 0.3s;
  
  &:hover {
    color: $primary-color;
  }
}

// 主内容区
.main-content {
  padding: 24px;
  background: $bg-color;
  min-height: calc(100vh - 64px);
  overflow-y: auto;
}

// 响应式设计
@media (max-width: 768px) {
  .sidebar {
    width: 200px;
  }
  
  .main-container {
    margin-left: 200px;
    width: calc(100% - 200px);
  }
  
  .logo-text {
    display: none;
  }
}
</style>
