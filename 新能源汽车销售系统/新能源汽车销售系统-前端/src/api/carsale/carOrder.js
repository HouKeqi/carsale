import request from '@/utils/request'



// 查询用户购车列表
export function getCarOrderList(query) {
  return request({
    url: '/carsale/carOrder/getCarOrderList',
    method: 'get',
    params: query
  })
}

// 新增用户购车数据
export function addCarOrder(data) {
  return request({
    url: '/carsale/carOrder',
    method: 'post',
    data: data
  })
}


// 查询 单个项目维护
export function getCarOrder(id) {
  return request({
    url: '/carsale/carOrder/'+id,
    method: 'get',
  })
}

// 修改 项目维护列表
export function editCarOrder(data) {
  return request({
    url: '/carsale/carOrder',
    method: 'put',
    data: data
  })
}

// 删除 项目维护列表
export function deleteCarOrder(ids) {
  return request({
    url: '/carsale/carOrder/'+ids,
    method: 'delete',
  })
}

