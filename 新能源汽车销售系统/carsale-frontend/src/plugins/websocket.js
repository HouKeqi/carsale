import { useAuthStore } from '@/stores/auth'
import { createStockAlertWebSocket } from '@/utils/websocket'
import { notification } from 'ant-design-vue'
import router from '@/router'

let wsInitialized = false
let checkInterval = null

export function initWebSocket() {
  // 定期检查用户是否登录，如果登录了就初始化 WebSocket
  checkInterval = setInterval(() => {
    const authStore = useAuthStore()
    
    // 如果用户已登录且 WebSocket 未初始化
    if (authStore.userId && !wsInitialized) {
      console.log('🔍 检测到用户已登录，准备初始化 WebSocket')
      wsInitialized = true
      clearInterval(checkInterval)
      setupWebSocket(authStore)
    }
  }, 500) // 每 500ms 检查一次
}

function setupWebSocket(authStore) {
  console.log('🔌 正在创建 WebSocket 连接，用户ID:', authStore.userId)
  
  // 创建 WebSocket 连接
  const wsClient = createStockAlertWebSocket(authStore.userId)
  
  // 保存到 store
  authStore.wsClient = wsClient
  
  // 监听连接成功
  wsClient.onOpen(() => {
    console.log('✅ WebSocket 连接已建立')
  })

  // 监听消息
  wsClient.onMessage((data) => {
    console.log('🔔 收到 WebSocket 消息:', data)
    
    // 处理连接成功消息
    if (data.type === 'connected') {
      console.log('✅ WebSocket 已连接到服务器')
      return
    }
    
    // 处理补货通知
    if (data.type === 'STOCK_REFILL') {
      console.log('✅ 匹配到 STOCK_REFILL 类型，准备显示通知')
      const notificationData = data.data || {}
      
      try {
        notification.open({
          message: notificationData.title || '车辆补货提醒',
          description: notificationData.content || '您关注的车型已有库存',
          duration: 0, // 不自动关闭
          placement: 'topRight',
          onClick: () => {
            console.log('🖱️ 点击了通知')
            if (notificationData.vehicleId) {
              router.push({
                path: '/customer/vehicle/detail',
                query: { id: notificationData.vehicleId }
              })
            }
          },
          style: {
            width: '400px',
            backgroundColor: '#f6ffed',
            border: '1px solid #b7eb8f'
          }
        })
        console.log('✅ notification.open() 调用成功')
      } catch (error) {
        console.error('❌ 显示通知失败:', error)
      }
    }
  })

  // 监听错误
  wsClient.onError((error) => {
    console.error('❌ WebSocket 错误:', error)
  })

  // 监听关闭
  wsClient.onClose((event) => {
    console.log('❌ WebSocket 连接已关闭', {
      code: event.code,
      reason: event.reason
    })
    wsInitialized = false
  })

  // 建立连接
  wsClient.connect()
}
