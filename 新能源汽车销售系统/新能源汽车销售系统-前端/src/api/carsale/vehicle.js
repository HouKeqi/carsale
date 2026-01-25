import request from '@/utils/request'

// 搜索车辆（支持筛选和排序）
export function searchVehicle(query) {
  return request({
    url: '/carsale/vehicle/search',
    method: 'get',
    params: query
  })
}

// 获取车辆详情
export function getVehicleDetail(id) {
  return request({
    url: '/carsale/vehicle/' + id,
    method: 'get'
  })
}

// 获取车辆促销活动
export function getVehiclePromotions(id) {
  return request({
    url: '/carsale/vehicle/' + id + '/promotions',
    method: 'get'
  })
}

// 获取车辆评价列表
export function getVehicleEvaluations(id, query) {
  return request({
    url: '/carsale/vehicle/' + id + '/evaluations',
    method: 'get',
    params: query
  })
}
