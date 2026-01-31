/**
 * WebSocket工具类
 */
class WebSocketClient {
  constructor(url, options = {}) {
    this.url = url
    this.options = options
    this.ws = null
    this.reconnectTimer = null
    this.reconnectCount = 0
    this.maxReconnectCount = options.maxReconnectCount || 5
    this.reconnectInterval = options.reconnectInterval || 3000
    this.onMessageCallbacks = []
    this.onErrorCallbacks = []
    this.onOpenCallbacks = []
    this.onCloseCallbacks = []
  }

  connect() {
    try {
      this.ws = new WebSocket(this.url)
      this.ws.onopen = (event) => {
        console.log('WebSocket连接成功', event)
        this.reconnectCount = 0
        this.onOpenCallbacks.forEach(callback => callback(event))
      }

      this.ws.onmessage = (event) => {
        try {
          const data = JSON.parse(event.data)
          this.onMessageCallbacks.forEach(callback => callback(data))
        } catch (error) {
          console.error('解析WebSocket消息失败', error)
        }
      }

      this.ws.onerror = (error) => {
        console.error('WebSocket错误', error)
        this.onErrorCallbacks.forEach(callback => callback(error))
      }

      this.ws.onclose = (event) => {
        console.log('❌ WebSocket连接关闭', {
          code: event.code,
          reason: event.reason,
          wasClean: event.wasClean
        })
        this.onCloseCallbacks.forEach(callback => callback(event))
        // 自动重连
        if (this.reconnectCount < this.maxReconnectCount) {
          this.reconnectTimer = setTimeout(() => {
            this.reconnectCount++
            console.log(`尝试重连 (${this.reconnectCount}/${this.maxReconnectCount})`)
            this.connect()
          }, this.reconnectInterval)
        }
      }
    } catch (error) {
      console.error('WebSocket连接失败', error)
    }
  }

  send(data) {
    if (this.ws && this.ws.readyState === WebSocket.OPEN) {
      this.ws.send(typeof data === 'string' ? data : JSON.stringify(data))
    } else {
      console.warn('WebSocket未连接，无法发送消息')
    }
  }

  onMessage(callback) {
    this.onMessageCallbacks.push(callback)
  }

  onError(callback) {
    this.onErrorCallbacks.push(callback)
  }

  onOpen(callback) {
    this.onOpenCallbacks.push(callback)
  }

  onClose(callback) {
    this.onCloseCallbacks.push(callback)
  }

  close() {
    if (this.reconnectTimer) {
      clearTimeout(this.reconnectTimer)
      this.reconnectTimer = null
    }
    // 重置重连计数，防止手动关闭后仍然尝试重连
    this.reconnectCount = this.maxReconnectCount
    if (this.ws) {
      this.ws.close()
      this.ws = null
    }
  }

  isConnected() {
    return this.ws && this.ws.readyState === WebSocket.OPEN
  }
}

/**
 * 创建库存提醒WebSocket连接
 * @param {number} userId 用户ID
 * @returns {WebSocketClient}
 */
export function createStockAlertWebSocket(userId) {
  // 根据当前环境确定WebSocket URL
  const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:'
  
  // 开发环境：连接到后端服务器 (localhost:8080)
  // 生产环境：使用当前域名
  let wsHost
  if (import.meta.env.DEV) {
    // 开发环境，连接到后端服务器
    wsHost = 'localhost:8080'
  } else {
    // 生产环境，使用当前域名
    wsHost = window.location.host
  }
  
  const wsUrl = `${protocol}//${wsHost}/websocket/stock-alert/${userId}`
  
  console.log('WebSocket URL:', wsUrl)
  
  return new WebSocketClient(wsUrl, {
    maxReconnectCount: 10,
    reconnectInterval: 3000
  })
}

export default WebSocketClient
