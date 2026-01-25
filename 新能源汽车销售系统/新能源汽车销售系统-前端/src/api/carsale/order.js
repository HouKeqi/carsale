import request from '@/utils/request'

// 创建订单
export function createOrder(data) {
  return request({
    url: '/carsale/order/create',
    method: 'post',
    data: data
  })
}

// 获取我的订单列表
export function getMyOrderList(query) {
  return request({
    url: '/carsale/order/my/page',
    method: 'get',
    params: query
  })
}

// 获取订单详情
export function getOrderDetail(id) {
  return request({
    url: '/carsale/order/detail/' + id,
    method: 'get'
  })
}

// 取消订单
export function cancelOrder(id) {
  return request({
    url: '/carsale/order/cancel/' + id,
    method: 'put'
  })
}

// 管理员获取订单列表
export function getAdminOrderList(query) {
  return request({
    url: '/carsale/admin/order/page',
    method: 'get',
    params: query
  })
}

// 管理员更新订单状态
export function updateOrderStatus(data) {
  return request({
    url: '/carsale/admin/order/status/update',
    method: 'put',
    data: data
  })
}
