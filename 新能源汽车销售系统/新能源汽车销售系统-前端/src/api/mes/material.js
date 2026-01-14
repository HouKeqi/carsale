import request from '@/utils/request'

// 查询物料档案列表
export function listMaterial() {
  return request({
    url: '/mes/material/list',
    method: 'get',
  })
}
