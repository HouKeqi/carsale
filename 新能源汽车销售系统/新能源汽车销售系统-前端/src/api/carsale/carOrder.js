import request from '@/utils/request'



// 查询用户购车列表
export function getCarOrderList() {
  return request({
    url: '/carsale/carOrder/getCarOrderList',
    method: 'get',
  })
}
