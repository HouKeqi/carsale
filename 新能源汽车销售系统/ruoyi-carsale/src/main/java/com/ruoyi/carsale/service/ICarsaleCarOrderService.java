package com.ruoyi.carsale.service;

import com.ruoyi.carsale.domain.CarsaleCarOrder;

import java.util.List;


public interface ICarsaleCarOrderService {
    /**
     * 查询用户购车列表
     * @param carsaleCarOrder
     * @return
     */
    public List<CarsaleCarOrder> selectCarsaleCarOrderList(CarsaleCarOrder carsaleCarOrder);

}
