import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue'),
    meta: { title: '登录' }
  },
  {
    path: '/',
    component: () => import('@/layout/index.vue'),
    redirect: '/vehicle',
    children: [
      {
        path: 'vehicle',
        name: 'VehicleList',
        component: () => import('@/views/VehicleList.vue'),
        meta: { title: '车辆管理', requiresAuth: true }
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫
router.beforeEach((to, from, next) => {
  const authStore = useAuthStore()
  
  // 设置页面标题
  if (to.meta.title) {
    document.title = to.meta.title + ' - 新能源汽车销售系统'
  }

  // 检查是否需要登录
  if (to.meta.requiresAuth) {
    if (authStore.isLoggedIn) {
      next()
    } else {
      next({
        path: '/login',
        query: { redirect: to.fullPath }
      })
    }
  } else {
    // 如果已登录，访问登录页则跳转到首页
    if (to.path === '/login' && authStore.isLoggedIn) {
      next('/')
    } else {
      next()
    }
  }
})

export default router
