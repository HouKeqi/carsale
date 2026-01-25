import request from '@/utils/request'

// 获取库存不足列表
export function getLowStockList(query) {
  return request({
    url: '/carsale/admin/inventory/low-stock',
    method: 'get',
    params: query
  })
}

// 获取库存不足数量
export function getLowStockCount() {
  return request({
    url: '/carsale/admin/inventory/low-stock/count',
    method: 'get'
  })
}
