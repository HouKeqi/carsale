package com.ruoyi.carsale.service;

import com.ruoyi.carsale.domain.Orders;

import java.util.List;

public interface IOrdersService {

    /**
     * 新增用户购车
     * @param orders
     * @return
     */
    public int insertOrders(Orders orders);

    /**
     * 修改用户购车
     * @param orders
     * @return
     */
    public int updateOrders(Orders orders);

    /**
     * 删除用户购车
     * @param id
     * @return
     */
    public int deleteOrdersById(Long id);

    /**
     * 批量删除用户购车
     * @param ids
     * @return
     */
    public int deleteOrdersByIds(Long[] ids);

    /**
     * 通过ID,查询用户购车
     * @param id
     * @return
     */
    public Orders selectOrdersById(Long id);

    /**
     * 查询用户购车列表
     * @param orders
     * @return
     */
    public List<Orders> selectOrdersList(Orders orders);


}
