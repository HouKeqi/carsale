package com.ruoyi.carsale.mapper;

import com.ruoyi.carsale.domain.CarsaleCarOrder;

import java.util.List;

/**
 * 用户购车Mapper接口
 */

public interface CarsaleCarOrderMapper {
    /*  查询用户购车列表   */
    public List<CarsaleCarOrder> selectCarsaleCarOrderList(CarsaleCarOrder carsaleCarOrder);

}
