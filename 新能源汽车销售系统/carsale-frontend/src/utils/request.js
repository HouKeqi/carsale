import axios from 'axios'
import { message, Modal } from 'ant-design-vue'
import { getToken, removeToken } from './auth'

// 构建完整URL
const buildFullUrl = (config) => {
  let url = config.url || ''
  const baseURL = config.baseURL || ''
  
  if (baseURL && !url.startsWith('http://') && !url.startsWith('https://')) {
    url = baseURL.replace(/\/+$/, '') + '/' + url.replace(/^\/+/, '')
  }
  
  // 处理params（查询参数）
  if (config.params) {
    const params = new URLSearchParams()
    Object.keys(config.params).forEach(key => {
      if (config.params[key] !== undefined && config.params[key] !== null) {
        params.append(key, config.params[key])
      }
    })
    const queryString = params.toString()
    if (queryString) {
      url += (url.includes('?') ? '&' : '?') + queryString
    }
  }
  
  return url
}

// 自定义adapter，支持GET请求发送请求体
const customAdapter = (config) => {
  // 如果是GET请求且有data，使用XMLHttpRequest手动发送（确保body被发送）
  if ((config.method === 'get' || config.method === 'GET') && config.data) {
    return new Promise((resolve, reject) => {
      const url = buildFullUrl(config)
      const xhr = new XMLHttpRequest()
      
      // 准备请求体
      const body = typeof config.data === 'string' 
        ? config.data 
        : JSON.stringify(config.data)
      
      // 准备请求头
      const headers = config.headers || {}
      if (!headers['Content-Type'] && !headers['content-type']) {
        headers['Content-Type'] = 'application/json'
      }
      
      // 调试日志
      console.log('发送GET请求（带body）:', {
        url,
        method: 'GET',
        headers: headers,
        body: body,
        bodyLength: body.length
      })
      
      // 必须在open之前设置onload等事件处理器
      xhr.onload = () => {
        let responseData
        try {
          responseData = xhr.responseText ? JSON.parse(xhr.responseText) : {}
        } catch (e) {
          responseData = xhr.responseText || {}
        }
        
        const response = {
          data: responseData,
          status: xhr.status,
          statusText: xhr.statusText,
          headers: xhr.getAllResponseHeaders(),
          config: config,
          request: xhr
        }
        resolve(response)
      }
      
      xhr.onerror = () => {
        reject(new Error('Network Error'))
      }
      
      xhr.ontimeout = () => {
        reject(new Error('timeout'))
      }
      
      // 打开请求
      xhr.open('GET', url, true)
      xhr.timeout = config.timeout || 10000
      xhr.responseType = 'text'
      
      // 设置请求头（必须在open之后）
      Object.keys(headers).forEach(key => {
        if (headers[key] !== undefined && headers[key] !== null) {
          xhr.setRequestHeader(key, headers[key])
        }
      })
      
      // 发送请求体（关键：必须在设置完所有header之后）
      xhr.send(body)
    })
  }
  
  // 其他请求使用axios默认adapter
  // 使用axios的默认适配器（xhr adapter）
  return new Promise((resolve, reject) => {
    const xhr = new XMLHttpRequest()
    const url = buildFullUrl(config)
    
    xhr.open((config.method || 'get').toUpperCase(), url, true)
    xhr.timeout = config.timeout || 10000
    xhr.responseType = config.responseType || 'json'
    
    // 设置请求头
    const headers = config.headers || {}
    // 如果是 FormData，不要手动设置 Content-Type，让浏览器自动设置（包含 boundary）
    const isFormData = config.data instanceof FormData
    Object.keys(headers).forEach(key => {
      // 如果是 FormData 且是 Content-Type，跳过（让浏览器自动设置）
      if (isFormData && (key.toLowerCase() === 'content-type')) {
        return
      }
      if (headers[key] !== undefined && headers[key] !== null) {
        xhr.setRequestHeader(key, headers[key])
      }
    })
    
    // 处理响应
    xhr.onload = () => {
      let responseData
      try {
        // 根据responseType获取响应数据
        if (xhr.responseType === 'json') {
          // responseType为json时，浏览器会自动解析，使用response
          responseData = xhr.response || {}
        } else if (xhr.responseType === 'text' || xhr.responseType === '') {
          // responseType为text或空时，使用responseText并手动解析JSON
          responseData = xhr.responseText ? JSON.parse(xhr.responseText) : {}
        } else {
          // 其他类型（blob、arraybuffer等）直接使用response
          responseData = xhr.response
        }
      } catch (e) {
        // 如果解析失败，尝试直接使用response或responseText
        responseData = xhr.response || xhr.responseText || {}
      }
      
      const response = {
        data: responseData,
        status: xhr.status,
        statusText: xhr.statusText,
        headers: xhr.getAllResponseHeaders(),
        config: config,
        request: xhr
      }
      resolve(response)
    }
    
    xhr.onerror = () => {
      reject(new Error('Network Error'))
    }
    
    xhr.ontimeout = () => {
      reject(new Error('timeout'))
    }
    
    // 发送请求（非GET请求或GET请求无data时，data为null）
    let sendData = null
    if (!((config.method === 'get' || config.method === 'GET') && !config.data)) {
      if (config.data instanceof FormData) {
        // FormData 直接发送，不要序列化
        sendData = config.data
      } else if (typeof config.data === 'string') {
        sendData = config.data
      } else {
        sendData = JSON.stringify(config.data || {})
      }
    }
    xhr.send(sendData)
  })
}

// 创建 axios 实例
const service = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || '/dev-api',
  timeout: 10000,
  adapter: customAdapter
})

// 请求拦截器
service.interceptors.request.use(
  config => {
    // 是否需要设置 token
    const isToken = (config.headers || {}).isToken === false
    if (getToken() && !isToken) {
      config.headers['Authorization'] = 'Bearer ' + getToken()
    }
    // 对于GET请求且有data的情况，确保Content-Type被设置
    if ((config.method === 'get' || config.method === 'GET') && config.data) {
      if (!config.headers['Content-Type']) {
        config.headers['Content-Type'] = 'application/json'
      }
    }
    return config
  },
  error => {
    console.error('请求错误:', error)
    return Promise.reject(error)
  }
)

// 响应拦截器
service.interceptors.response.use(
  res => {
    // 未设置状态码则默认成功状态
    const code = res.data.code || 200
    const msg = res.data.msg || '请求失败'

    // 二进制数据则直接返回
    if (res.request.responseType === 'blob' || res.request.responseType === 'arraybuffer') {
      return res.data
    }

    if (code === 401) {
      Modal.warning({
        title: '系统提示',
        content: '登录状态已过期，您可以继续留在该页面，或者重新登录',
        okText: '重新登录',
        cancelText: '取消',
        onOk() {
          removeToken()
          location.href = '/login'
        }
      })
      return Promise.reject('无效的会话，或者会话已过期，请重新登录。')
    } else if (code === 500) {
      message.error(msg)
      return Promise.reject(new Error(msg))
    } else if (code === 601) {
      message.warning(msg)
      return Promise.reject('error')
    } else if (code !== 200) {
      message.error(msg)
      return Promise.reject('error')
    } else {
      return res.data
    }
  },
  error => {
    console.error('响应错误:', error)
    let { message } = error
    if (message === 'Network Error') {
      message = '后端接口连接异常'
    } else if (message.includes('timeout')) {
      message = '系统接口请求超时'
    } else if (message.includes('Request failed with status code')) {
      message = '系统接口' + message.substr(message.length - 3) + '异常'
    }
    message.error(message)
    return Promise.reject(error)
  }
)

export default service
