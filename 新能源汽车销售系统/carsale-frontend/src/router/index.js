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
    // 不设置默认重定向，由路由守卫根据用户角色动态处理
    children: [
      {
        path: 'admin/vehicle',
        name: 'AdminVehicle',
        component: () => import('@/views/admin/vehicle/index.vue'),
        meta: { title: '车辆管理', requiresAuth: true, roles: ['admin'] }
      },
      {
        path: 'promotion',
        name: 'PromotionList',
        component: () => import('@/views/promotion/index.vue'),
        meta: { title: '促销管理', requiresAuth: true }
      },
      // 管理员页面
      {
        path: 'admin/inventory',
        name: 'AdminInventory',
        component: () => import('@/views/admin/inventory/index.vue'),
        meta: { title: '库存管理', requiresAuth: true }
      },
      {
        path: 'admin/order',
        name: 'AdminOrder',
        component: () => import('@/views/admin/order/index.vue'),
        meta: { title: '订单管理', requiresAuth: true }
      },
      {
        path: 'admin/order/detail',
        name: 'AdminOrderDetail',
        component: () => import('@/views/admin/order/detail.vue'),
        meta: { title: '订单详情', requiresAuth: true }
      },
      {
        path: 'admin/user',
        name: 'AdminUser',
        component: () => import('@/views/admin/user/index.vue'),
        meta: { title: '用户管理', requiresAuth: true }
      },
      {
        path: 'admin/statistics',
        name: 'AdminStatistics',
        component: () => import('@/views/admin/statistics/index.vue'),
        meta: { title: '数据统计', requiresAuth: true }
      },
      {
        path: 'admin/testdrive',
        name: 'AdminTestdrive',
        component: () => import('@/views/admin/testdrive/index.vue'),
        meta: { title: '试驾审核', requiresAuth: true }
      },
      {
        path: 'admin/store',
        name: 'AdminStore',
        component: () => import('@/views/admin/store/index.vue'),
        meta: { title: '门店管理', requiresAuth: true }
      },
      // 普通用户页面
      {
        path: 'customer/vehicle/list',
        name: 'CustomerVehicleList',
        component: () => import('@/views/customer/vehicle/list.vue'),
        meta: { title: '车辆浏览', requiresAuth: true }
      },
      {
        path: 'customer/vehicle/detail',
        name: 'CustomerVehicleDetail',
        component: () => import('@/views/customer/vehicle/detail.vue'),
        meta: { title: '车辆详情', requiresAuth: true }
      },
      {
        path: 'customer/vehicle/compare',
        name: 'CustomerVehicleCompare',
        component: () => import('@/views/customer/vehicle/compare.vue'),
        meta: { title: '车辆对比', requiresAuth: true }
      },
      {
        path: 'customer/order/create',
        name: 'CustomerOrderCreate',
        component: () => import('@/views/customer/order/create.vue'),
        meta: { title: '创建订单', requiresAuth: true }
      },
      {
        path: 'customer/order/my-list',
        name: 'CustomerOrderMyList',
        component: () => import('@/views/customer/order/my-list.vue'),
        meta: { title: '我的订单', requiresAuth: true }
      },
      {
        path: 'customer/order/pay',
        name: 'CustomerOrderPay',
        component: () => import('@/views/customer/order/pay.vue'),
        meta: { title: '订单支付', requiresAuth: true }
      },
      {
        path: 'customer/order/detail',
        name: 'CustomerOrderDetail',
        component: () => import('@/views/customer/order/detail.vue'),
        meta: { title: '订单详情', requiresAuth: true }
      },
      {
        path: 'customer/evaluation/create',
        name: 'CustomerEvaluationCreate',
        component: () => import('@/views/customer/evaluation/create.vue'),
        meta: { title: '创建评价', requiresAuth: true }
      },
      {
        path: 'customer/evaluation/my-list',
        name: 'CustomerEvaluationMyList',
        component: () => import('@/views/customer/evaluation/my-list.vue'),
        meta: { title: '我的评价', requiresAuth: true }
      },
      {
        path: 'customer/testdrive/create',
        name: 'CustomerTestdriveCreate',
        component: () => import('@/views/customer/testdrive/create.vue'),
        meta: { title: '预约试驾', requiresAuth: true }
      },
      {
        path: 'customer/testdrive/my-list',
        name: 'CustomerTestdriveMyList',
        component: () => import('@/views/customer/testdrive/my-list.vue'),
        meta: { title: '我的预约', requiresAuth: true }
      },
      {
        path: 'customer/profile',
        name: 'CustomerProfile',
        component: () => import('@/views/customer/profile/index.vue'),
        meta: { title: '个人中心', requiresAuth: true }
      },
      {
        path: 'customer/stock-alert',
        name: 'CustomerStockAlert',
        component: () => import('@/views/customer/stock-alert/index.vue'),
        meta: { title: '我的库存提醒', requiresAuth: true }
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫
router.beforeEach(async (to, from, next) => {
  const authStore = useAuthStore()

  // 设置页面标题
  if (to.meta.title) {
    document.title = to.meta.title + ' - 新能源汽车销售系统'
  }

  // 检查是否需要登录
  if (to.meta.requiresAuth) {
    if (authStore.isLoggedIn) {
      // 如果已登录但用户信息为空，尝试获取用户信息
      if (!authStore.name || authStore.roles.length === 0) {
        try {
          await authStore.getUserInfo()
        } catch (error) {
          console.error('获取用户信息失败:', error)
        }
      }

      // 如果是根路径，根据用户角色重定向
      if (to.path === '/') {
        const isAdmin = authStore.roles?.includes('admin') || false
        const isCustomer = authStore.roles?.includes('customer') || false

        if (isAdmin) {
          next('/admin/vehicle')
        } else if (isCustomer) {
          next('/customer/vehicle/list')
        } else {
          // 如果没有角色信息，默认跳转到车辆浏览页面
          next('/customer/vehicle/list')
        }
        return
      }

      // 检查路由的角色权限要求
      if (to.meta.roles && to.meta.roles.length > 0) {
        const hasPermission = to.meta.roles.some(role => authStore.roles?.includes(role))
        if (!hasPermission) {
          // 没有权限，根据用户角色重定向到合适的页面
          const isAdmin = authStore.roles?.includes('admin') || false
          const isCustomer = authStore.roles?.includes('customer') || false

          if (isAdmin) {
            next('/admin/vehicle')
          } else if (isCustomer) {
            next('/customer/vehicle/list')
          } else {
            next('/customer/vehicle/list')
          }
          return
        }
      }

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
      // 如果已登录但用户信息为空，尝试获取用户信息
      if (!authStore.name || authStore.roles.length === 0) {
        try {
          await authStore.getUserInfo()
        } catch (error) {
          console.error('获取用户信息失败:', error)
        }
      }

      // 根据用户角色跳转
      const isAdmin = authStore.roles?.includes('admin') || false
      const isCustomer = authStore.roles?.includes('customer') || false

      if (isAdmin) {
        next('/admin/vehicle')
      } else if (isCustomer) {
        next('/customer/vehicle/list')
      } else {
        next('/customer/vehicle/list')
      }
    } else {
      next()
    }
  }
})

export default router
