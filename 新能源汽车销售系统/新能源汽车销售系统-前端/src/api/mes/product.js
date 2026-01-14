import request from '@/utils/request'

// 查询产品建模列表
export function listProduct(query) {
  return request({
    url: '/mes/product/list',
    method: 'get',
    params: query
  })
}

// 查询产品建模详细
export function getProduct(id) {
  return request({
    url: '/mes/product/' + id,
    method: 'get'
  })
}

// 新增产品建模
export function addProduct(data) {
  return request({
    url: '/mes/product',
    method: 'post',
    data: data
  })
}

// 修改产品建模
export function updateProduct(data) {
  return request({
    url: '/mes/product',
    method: 'put',
    data: data
  })
}

// 删除产品建模
export function delProduct(id) {
  return request({
    url: '/mes/product/' + id,
    method: 'delete'
  })
}


