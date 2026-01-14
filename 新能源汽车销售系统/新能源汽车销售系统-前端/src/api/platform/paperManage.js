import request from '@/utils/request'
import { parseStrEmpty } from '@/utils/ruoyi'

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

// 学生查询没有被自己选择的课题
export function UnselectPaperList(query) {
  return request({
    url: '/platform/paperManage/UnselectPaperList',
    method: 'get',
    params: query
  })
}

// 教师查看选择了自己课题的课题 + 学生信息
export function getPaperManageForTeacher() {
  return request({
    url: '/platform/paperManage/getPaperManageForTeacher',
    method: 'get',
  })
}

// 老师审核学生选题，绑定
export function updatePaperManageBondInfoByTeacher(data) {
  return request({
    url: '/platform/paperManage/updatePaperManageBondInfoByTeacher',
    method: 'put',
    data: data
  })
}

export function getGradeListForTeacher() {
  return request({
    url: '/platform/paperManage/getGradeListForTeacher',
    method: 'get',
  })
}

export function getGradeListForStudent() {
  return request({
    url: '/platform/paperManage/getGradeListForStudent',
    method: 'get',
  })
}





