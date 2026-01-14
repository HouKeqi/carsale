import request from '@/utils/request'

// 查询开题报告列表
export function listPaperUpload(query) {
  return request({
    url: '/platform/paperUpload/list',
    method: 'get',
    params: query
  })
}

// 查询开题报告详细
export function getPaperUpload(id) {
  return request({
    url: '/platform/paperUpload/' + id,
    method: 'get'
  })
}


// 新增开题报告
export function addPaperUpload(data) {
  return request({
    url: '/platform/paperUpload',
    method: 'post',
    data: data
  })
}

// 修改开题报告
export function updatePaperUpload(data) {
  return request({
    url: '/platform/paperUpload',
    method: 'put',
    data: data
  })
}

// 删除开题报告
export function delPaperUpload(id) {
  return request({
    url: '/platform/paperUpload/' + id,
    method: 'delete'
  })
}



// 上传文件
export function uploadFile(data) {
  return request({
    url: '/common/upload',
    method: 'post',
    data: data
  })
}


// 上传文件的文件名存入数据库
export function uploadFileToDB(data) {
  return request({
    url: '/platform/paperUpload',
    method: 'post',
    data: data
  })
}


// userID--strdentid--查询开题报告列表
export function getOpeningPaperList() {
  return request({
    url: '/platform/paperUpload/getOpeningPaperList',
    method: 'get',
  })
}


// 下载文件
export function downloadFile(resource) {
  return request({
    url: '/common/download/resource',
    method: 'get',
    params:resource
  })
}

// paper表中teacherid--bond(studentId)--opening表中studentId--查询开题报告列表
export function getOpeningPaperListForTeacher() {
  return request({
    url: '/platform/paperUpload/getOpeningPaperListForTeacher',
    method: 'get',
  })
}

// 修改开题报告,教师审核通过、不通过学生论文
export function updatePaperUploadFromTeacher(data) {
  return request({
    url: '/platform/paperUpload/updatePaperUploadFromTeacher',
    method: 'put',
    data: data
  })
}



