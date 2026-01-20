package com.ruoyi.carsale.service.impl;

import com.ruoyi.carsale.domain.Orders;
import com.ruoyi.carsale.mapper.CarsaleCarOrderMapper;
import com.ruoyi.carsale.mapper.OrdersMapper;
import com.ruoyi.carsale.service.IOrdersService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class OrdersServiceImpl implements IOrdersService {

    @Autowired
    private OrdersMapper ordersMapper;
    @Override
    public int insertOrders(Orders orders) {
        return ordersMapper.insertOrders(orders);
    }

    @Override
    public int updateOrders(Orders orders) {
        return ordersMapper.updateOrders(orders);
    }

    @Override
    public int deleteOrdersById(Long id) {
        return ordersMapper.deleteOrdersById(id);
    }

    @Override
    public int deleteOrdersByIds(Long[] ids) {
        return ordersMapper.deleteOrdersByIds(ids);
    }

    @Override
    public Orders selectOrdersById(Long id) {
        return ordersMapper.selectOrdersById(id);
    }

    @Override
    public List<Orders> selectOrdersList(Orders orders) {
        return ordersMapper.selectOrdersList(orders);
    }

}
