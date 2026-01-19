import request from '@/utils/request'

// 查询车辆信息列表
export function getVehicleList(query) {
  return request({
    url: '/carsale/admin/vehicle/detail',
    method: 'get',
    params: query
  })
}

// 获取车辆详细信息
export function getVehicleDetail(id) {
  return request({
    url: '/carsale/admin/vehicle/detail/' + id,
    method: 'get'
  })
}

// 新增车辆信息
export function addVehicle(data) {
  return request({
    url: '/carsale/admin/vehicle/add',
    method: 'post',
    data: data
  })
}

// 修改车辆信息
export function updateVehicle(data) {
  return request({
    url: '/carsale/admin/vehicle/update',
    method: 'put',
    data: data
  })
}

// 删除车辆信息
export function deleteVehicle(ids) {
  return request({
    url: '/carsale/admin/vehicle/delete/' + ids,
    method: 'delete'
  })
}

// 获取库存预警列表
export function getStockWarningList(query) {
  return request({
    url: '/carsale/admin/vehicle/stock/warning',
    method: 'get',
    params: query
  })
}

// 调整库存数量
export function updateStock(data) {
  return request({
    url: '/carsale/admin/vehicle/stock/update',
    method: 'put',
    data: data
  })
}
