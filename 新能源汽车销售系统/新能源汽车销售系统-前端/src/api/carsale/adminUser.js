import request from '@/utils/request'

// 获取用户列表
export function getUserList(query) {
  return request({
    url: '/carsale/admin/user/list',
    method: 'get',
    params: query
  })
}

// 获取用户购车记录
export function getUserOrders(userId, query) {
  return request({
    url: '/carsale/admin/user/' + userId + '/orders',
    method: 'get',
    params: query
  })
}

// 获取用户浏览偏好
export function getUserPreferences(userId) {
  return request({
    url: '/carsale/admin/user/' + userId + '/preferences',
    method: 'get'
  })
}
