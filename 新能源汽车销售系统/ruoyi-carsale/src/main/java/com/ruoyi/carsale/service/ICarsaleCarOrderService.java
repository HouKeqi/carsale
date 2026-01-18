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

    /**
     * 新增用户购车
     * @param carsaleCarOrder
     * @return
     */
    public int insertCarsaleCarOrder(CarsaleCarOrder carsaleCarOrder);

    /**
     * 修改用户购车
     * @param carsaleCarOrder
     * @return
     */
    public int updateCarsaleCarOrder(CarsaleCarOrder carsaleCarOrder);

    /**
     * 删除用户购车
     * @param id
     * @return
     */
    public int deleteCarsaleCarOrderById(Long id);

    /**
     * 批量删除用户购车
     * @param ids
     * @return
     */
    public int deleteCarsaleCarOrderByIds(Long[] ids);

    /**
     * 通过ID,查询用户购车
     * @param id
     * @return
     */
    public CarsaleCarOrder selectCarsaleCarOrderById(Long id);


}
