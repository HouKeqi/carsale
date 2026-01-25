<template>
  <div class="app-container">
    <a-layout class="layout-wrapper">
      <!-- 侧边栏 -->
      <a-layout-sider class="sidebar" :width="240" :collapsed="false">
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
        <a-menu
          v-model:selectedKeys="selectedKeys"
          class="sidebar-menu"
          mode="inline"
          :items="menuItems"
          @click="handleMenuClick"
        />
      </a-layout-sider>

      <!-- 主内容区 -->
      <a-layout class="main-container">
        <!-- 顶部导航栏 -->
        <a-layout-header class="header">
          <div class="header-left">
            <a-breadcrumb>
              <a-breadcrumb-item>
                <router-link to="/">首页</router-link>
              </a-breadcrumb-item>
              <a-breadcrumb-item>{{ currentRouteName }}</a-breadcrumb-item>
            </a-breadcrumb>
          </div>
          <div class="header-right">
            <div class="user-info">
              <a-avatar :size="36" class="user-avatar">
                {{ authStore.name?.charAt(0) || 'U' }}
              </a-avatar>
              <span class="username">{{ authStore.name }}</span>
              <a-dropdown>
                <template #overlay>
                  <a-menu @click="handleCommand">
                    <a-menu-item key="logout">退出登录</a-menu-item>
                  </a-menu>
                </template>
                <DownOutlined class="dropdown-icon" />
              </a-dropdown>
            </div>
          </div>
        </a-layout-header>

        <!-- 主内容 -->
        <a-layout-content class="main-content">
          <router-view />
        </a-layout-content>
      </a-layout>
    </a-layout>
  </div>
</template>

<script setup>
import { computed, ref, watch, h } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { message } from 'ant-design-vue'
import { HomeOutlined, DownOutlined } from '@ant-design/icons-vue'

const authStore = useAuthStore()
const router = useRouter()
const route = useRoute()

// 根据路径获取对应的菜单key（用于高亮）
const getMenuKeyFromPath = (path) => {
  // 如果是详情页面，高亮对应的列表页面菜单项
  if (path === '/customer/vehicle/detail') {
    return '/customer/vehicle/list'
  } else if (path === '/customer/order/create' || path === '/customer/order/detail') {
    return '/customer/order/my-list'
  } else if (path === '/customer/evaluation/create') {
    return '/customer/evaluation/my-list'
  } else if (path === '/customer/testdrive/create' || path === '/customer/testdrive/detail') {
    return '/customer/testdrive/my-list'
  }
  return path
}

const selectedKeys = ref([getMenuKeyFromPath(route.path)])

const currentRouteName = computed(() => {
  const routeMap = {
    '/admin/vehicle': '车辆管理',
    '/promotion': '促销管理',
    '/admin/inventory': '库存管理',
    '/admin/order': '订单管理',
    '/admin/user': '用户管理',
    '/admin/statistics': '数据统计',
    '/admin/testdrive': '试驾审核',
    '/admin/store': '门店管理',
    '/customer/vehicle/list': '车辆浏览',
    '/customer/order/my-list': '我的订单',
    '/customer/evaluation/my-list': '我的评价',
    '/customer/testdrive/my-list': '我的预约',
    '/customer/profile': '个人中心'
  }
  return routeMap[route.path] || '首页'
})

// 根据用户角色显示菜单（这里简化处理，实际应该从后端获取）
const menuItems = computed(() => {
  // 假设从authStore获取用户角色，这里先显示所有菜单
  // 实际应该根据用户角色动态生成
  const isAdmin = authStore.roles?.includes('admin') || false
  const isCustomer = authStore.roles?.includes('customer') || false
  
  const items = []
  
  if (isAdmin) {
    items.push(
      { key: '/admin/vehicle', icon: () => h(HomeOutlined), label: '车辆管理' },
      { key: '/admin/inventory', icon: () => h(HomeOutlined), label: '库存管理' },
      { key: '/admin/order', icon: () => h(HomeOutlined), label: '订单管理' },
      { key: '/admin/user', icon: () => h(HomeOutlined), label: '用户管理' },
      { key: '/promotion', icon: () => h(HomeOutlined), label: '促销管理' },
      { key: '/admin/statistics', icon: () => h(HomeOutlined), label: '数据统计' },
      { key: '/admin/testdrive', icon: () => h(HomeOutlined), label: '试驾审核' }
    )
  }
  
  if (isCustomer) {
    items.push(
      { key: '/customer/vehicle/list', icon: () => h(HomeOutlined), label: '车辆浏览' },
      { key: '/customer/order/my-list', icon: () => h(HomeOutlined), label: '我的订单' },
      { key: '/customer/evaluation/my-list', icon: () => h(HomeOutlined), label: '我的评价' },
      { key: '/customer/testdrive/my-list', icon: () => h(HomeOutlined), label: '我的预约' },
      { key: '/customer/profile', icon: () => h(HomeOutlined), label: '个人中心' }
    )
  }
  
  // 如果没有角色信息，默认显示所有菜单（开发阶段）
  if (items.length === 0) {
    return [
      { key: '/vehicle', icon: () => h(HomeOutlined), label: '车辆管理' },
      { key: '/admin/inventory', icon: () => h(HomeOutlined), label: '库存管理' },
      { key: '/admin/order', icon: () => h(HomeOutlined), label: '订单管理' },
      { key: '/admin/user', icon: () => h(HomeOutlined), label: '用户管理' },
      { key: '/promotion', icon: () => h(HomeOutlined), label: '促销管理' },
      { key: '/admin/statistics', icon: () => h(HomeOutlined), label: '数据统计' },
      { key: '/admin/testdrive', icon: () => h(HomeOutlined), label: '试驾审核' },
      { key: '/admin/store', icon: () => h(HomeOutlined), label: '门店管理' },
      { key: '/customer/vehicle/list', icon: () => h(HomeOutlined), label: '车辆浏览' },
      { key: '/customer/order/my-list', icon: () => h(HomeOutlined), label: '我的订单' },
      { key: '/customer/evaluation/my-list', icon: () => h(HomeOutlined), label: '我的评价' },
      { key: '/customer/testdrive/my-list', icon: () => h(HomeOutlined), label: '我的预约' },
      { key: '/customer/profile', icon: () => h(HomeOutlined), label: '个人中心' }
    ]
  }
  
  return items
})

watch(() => route.path, (newPath) => {
  selectedKeys.value = [getMenuKeyFromPath(newPath)]
})

const handleMenuClick = ({ key }) => {
  router.push(key)
}

const handleCommand = async ({ key }) => {
  if (key === 'logout') {
    try {
      await authStore.logout()
      message.success('退出登录成功')
      router.push('/login')
    } catch (error) {
      message.error('退出登录失败')
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

.layout-wrapper {
  height: 100vh;
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
  background: transparent;
  
  :deep(.ant-menu-item) {
    height: 48px;
    line-height: 48px;
    margin: 4px 12px;
    border-radius: $radius-md;
    transition: all 0.3s ease;
    
    &:hover {
      background: $primary-bg;
      color: $primary-color;
    }
    
    &.ant-menu-item-selected {
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
  
  :deep(.ant-breadcrumb) {
    font-size: 14px;
    
    .ant-breadcrumb-link {
      color: $text-secondary;
      font-weight: 400;
      
      a {
        color: $text-secondary;
        
        &:hover {
          color: $primary-color;
        }
      }
    }
    
    .ant-breadcrumb-separator {
      color: $text-secondary;
    }
    
    .ant-breadcrumb-link:last-child {
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
