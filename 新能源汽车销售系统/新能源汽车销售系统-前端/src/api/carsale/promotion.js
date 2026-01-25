import request from '@/utils/request'

// 管理员获取促销活动列表
export function getAdminPromotionList(query) {
  return request({
    url: '/carsale/admin/promotion/page',
    method: 'get',
    params: query
  })
}

// 管理员获取促销活动详情
export function getAdminPromotionDetail(id) {
  return request({
    url: '/carsale/admin/promotion/detail/' + id,
    method: 'get'
  })
}

// 管理员新增促销活动
export function addPromotion(data) {
  return request({
    url: '/carsale/admin/promotion/add',
    method: 'post',
    data: data
  })
}

// 管理员修改促销活动
export function updatePromotion(data) {
  return request({
    url: '/carsale/admin/promotion/update',
    method: 'put',
    data: data
  })
}

// 管理员删除促销活动
export function deletePromotion(id) {
  return request({
    url: '/carsale/admin/promotion/delete/' + id,
    method: 'delete'
  })
}

// 管理员批量删除促销活动
export function deletePromotions(ids) {
  return request({
    url: '/carsale/admin/promotion/deleteByIds/' + ids,
    method: 'delete'
  })
}

// 获取车辆促销活动（公开接口）
export function getVehiclePromotions(vehicleId) {
  return request({
    url: '/carsale/promotion/vehicle/' + vehicleId,
    method: 'get'
  })
}
