import request from '@/utils/request'

// 管理员获取车辆列表（分页）
export function getAdminVehicleList(params) {
  return request({
    url: '/carsale/admin/vehicle/detail',
    method: 'get',
    params
  })
}

// 管理员获取车辆详情
export function getAdminVehicleDetail(id) {
  return request({
    url: `/carsale/admin/vehicle/detail/${id}`,
    method: 'get'
  })
}

// 管理员新增车辆
export function addVehicle(data) {
  return request({
    url: '/carsale/admin/vehicle/add',
    method: 'post',
    data
  })
}

// 管理员修改车辆
export function updateVehicle(data) {
  return request({
    url: '/carsale/admin/vehicle/update',
    method: 'put',
    data
  })
}

// 管理员删除车辆
export function deleteVehicle(ids) {
  return request({
    url: `/carsale/admin/vehicle/delete/${ids}`,
    method: 'delete'
  })
}

// 管理员获取库存预警列表
export function getStockWarningList(params) {
  return request({
    url: '/carsale/admin/vehicle/stock/warning',
    method: 'get',
    params
  })
}

// 管理员更新库存
export function updateStock(data) {
  return request({
    url: '/carsale/admin/vehicle/stock/update',
    method: 'put',
    data
  })
}
