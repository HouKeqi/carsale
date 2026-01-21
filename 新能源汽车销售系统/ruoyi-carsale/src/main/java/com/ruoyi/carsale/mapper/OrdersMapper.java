package com.ruoyi.carsale.mapper;

import com.ruoyi.carsale.domain.Orders;

import java.util.List;

public interface OrdersMapper {
    /*  新增用户购车   */
    public int insertOrders(Orders  orders);

    /*  修改用户购车   */
    public int updateOrders(Orders  orders);

    /*  通过ID,删除用户购车，删一个   */
    public int deleteOrdersById(Long id);

    /*  通过ID,批量删除用户购车，删一批   */
    public int deleteOrdersByIds(Long[] ids);

    /*  通过ID,查询用户购车   */
    public Orders selectOrdersById(Long id);

    /*  查询用户购车列表   */
    public List<Orders> selectOrdersList(Orders  orders);

}
