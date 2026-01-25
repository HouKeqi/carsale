import request from '@/utils/request'

/**
 * 文件上传
 * @param {Object} option 上传选项
 * @returns {Promise}
 */
export function upload(option) {
  const formData = new FormData()
  formData.append('file', option.file)
  
  return request({
    url: '/common/upload',
    method: 'post',
    data: formData
  })
}
