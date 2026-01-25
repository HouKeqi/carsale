import request from '@/utils/request'

// 获取销量TOP5车型
export function getTop5Vehicles(startTime, endTime) {
  return request({
    url: '/carsale/admin/statistics/top5-vehicles',
    method: 'get',
    params: { startTime, endTime }
  })
}

// 获取销售额
export function getSalesAmount(startTime, endTime) {
  return request({
    url: '/carsale/admin/statistics/sales-amount',
    method: 'get',
    params: { startTime, endTime }
  })
}

// 获取新增用户数
export function getNewUsersCount(startTime, endTime) {
  return request({
    url: '/carsale/admin/statistics/new-users',
    method: 'get',
    params: { startTime, endTime }
  })
}

// 获取品牌销售占比
export function getBrandDistribution(startTime, endTime) {
  return request({
    url: '/carsale/admin/statistics/brand-distribution',
    method: 'get',
    params: { startTime, endTime }
  })
}

// 获取续航里程销售占比
export function getRangeDistribution(startTime, endTime) {
  return request({
    url: '/carsale/admin/statistics/range-distribution',
    method: 'get',
    params: { startTime, endTime }
  })
}
