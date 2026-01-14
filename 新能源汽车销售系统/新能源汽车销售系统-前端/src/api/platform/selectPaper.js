import request from '@/utils/request'

// 查询学生选择的3个课题号列表
export function listSelectPaper(query) {
  return request({
    url: '/platform/selectPaper/list',
    method: 'get',
    params: query
  })
}

// 查询学生选择的3个课题号详细
export function getSelectPaper() {
  return request({
    url: '/platform/selectPaper/getSelectPaperList',
    method: 'get'
  })
}

// 查询学生已经和老师绑定了的课题
export function getSelectBondPaper() {
  return request({
    url: '/platform/paperManage/getSelectBondPaper',
    method: 'get'
  })
}

// 新增学生选择的3个课题号
export function addSelectPaper(data) {
  return request({
    url: '/platform/selectPaper',
    method: 'post',
    data: data
  })
}

// 修改学生选择的3个课题号
export function updateSelectPaper(data) {
  return request({
    url: '/platform/selectPaper',
    method: 'put',
    data: data
  })
}

// 通过userId修改学生选择的3个课题号
export function updateSelectPaperByUserId(data) {
  return request({
    url: '/platform/selectPaper/updateByUserId',
    method: 'put',
    data: data
  })
}
// 删除学生选择的3个课题号,id=select_paper_id
export function delSelectPaper(id) {
  return request({
    url: '/platform/selectPaper/' + id,
    method: 'delete'
  })
}


// 批量选择课题
export function selectPaper(data) {
  return request({
    url: '/platform/selectPaper/selectPaper',
    method: 'put',
    data: data
  })
}

// 根据选择的paperid删除
export function delSelectPaperByPaperId(paperId) {
  return request({
    url: '/platform/selectPaper/delSelectPaperByPaperId/' + paperId,
    method: 'delete'
  })
}





