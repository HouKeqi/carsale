package com.ruoyi.carsale.mapper;

import com.ruoyi.carsale.domain.CarsaleCarOrder;

import java.util.List;

/**
 * 用户购车Mapper接口
 */

public interface CarsaleCarOrderMapper {
    /*  查询用户购车列表   */
    public List<CarsaleCarOrder> selectCarsaleCarOrderList(CarsaleCarOrder carsaleCarOrder);

    /*  新增用户购车   */
    public int insertCarsaleCarOrder(CarsaleCarOrder carsaleCarOrder);

    /*  修改用户购车   */
    public int updateCarsaleCarOrder(CarsaleCarOrder carsaleCarOrder);

    /*  通过ID,删除用户购车，删一个   */
    public int deleteCarsaleCarOrderById(Long id);

    /*  通过ID,批量删除用户购车，删一批   */
    public int deleteCarsaleCarOrderByIds(Long[] ids);

    /*  通过ID,查询用户购车   */
    public CarsaleCarOrder selectCarsaleCarOrderById(Long id);

}
