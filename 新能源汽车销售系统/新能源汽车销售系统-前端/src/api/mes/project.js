import request  from '@/utils/request'

// 查询 项目维护列表
export function getMesProjectList(params) {
  return request({
    url: '/mes/project',
    method: 'get',
    params: params
  })
}

// 查询 单个项目维护
export function getMesProject(id) {
  return request({
    url: '/mes/project/'+id,
    method: 'get',
  })
}


// 新增 项目维护列表
export function addMesProject(data) {
  return request({
    url: '/mes/project',
    method: 'post',
    data: data
  })
}

// 修改 项目维护列表
export function editMesProject(data) {
  return request({
    url: '/mes/project',
    method: 'put',
    data: data
  })
}

// 删除 项目维护列表
export function deleteMesProject(ids) {
  return request({
    url: '/mes/project/'+ids,
    method: 'delete',
  })
}
