import request from '@/utils/request'

// 创建评价
export function createEvaluation(data) {
  return request({
    url: '/carsale/evaluation/create',
    method: 'post',
    data: data
  })
}

// 获取我的评价列表
export function getMyEvaluationList(query) {
  return request({
    url: '/carsale/evaluation/my/list',
    method: 'get',
    params: query
  })
}

// 获取车辆评价列表
export function getVehicleEvaluationList(vehicleId, query) {
  return request({
    url: '/carsale/evaluation/vehicle/' + vehicleId,
    method: 'get',
    params: query
  })
}

// 删除评价
export function deleteEvaluation(id) {
  return request({
    url: '/carsale/evaluation/delete/' + id,
    method: 'delete'
  })
}
