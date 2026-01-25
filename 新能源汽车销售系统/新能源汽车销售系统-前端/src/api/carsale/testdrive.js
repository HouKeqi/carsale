import request from '@/utils/request'

// 创建试驾预约
export function createTestdrive(data) {
  return request({
    url: '/carsale/testdrive/create',
    method: 'post',
    data: data
  })
}

// 获取我的试驾预约列表
export function getMyTestdriveList(query) {
  return request({
    url: '/carsale/testdrive/my/list',
    method: 'get',
    params: query
  })
}

// 取消试驾预约
export function cancelTestdrive(id) {
  return request({
    url: '/carsale/testdrive/cancel/' + id,
    method: 'delete'
  })
}

// 管理员获取试驾预约列表
export function getAdminTestdriveList(query) {
  return request({
    url: '/carsale/admin/testdrive/list',
    method: 'get',
    params: query
  })
}

// 管理员审核试驾预约
export function auditTestdrive(id, data) {
  return request({
    url: '/carsale/admin/testdrive/' + id + '/audit',
    method: 'put',
    data: data
  })
}
