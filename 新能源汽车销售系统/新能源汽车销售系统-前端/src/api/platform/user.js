import request from '@/utils/request'

// 查询论文管理列表
export function listPaperManage(query) {
  return request({
    url: '/platform/paperManage/list',
    method: 'get',
    params: query
  })
}

// 查询论文管理详细
export function getPaperManage(id) {
  return request({
    url: '/platform/paperManage/' + id,
    method: 'get'
  })
}

// 新增论文管理
export function addPaperManage(data) {
  return request({
    url: '/platform/paperManage',
    method: 'post',
    data: data
  })
}

// 修改论文管理
export function updatePaperManage(data) {
  return request({
    url: '/platform/paperManage',
    method: 'put',
    data: data
  })
}

// 删除论文管理
export function delPaperManage(id) {
  return request({
    url: '/platform/paperManage/' + id,
    method: 'delete'
  })
}
