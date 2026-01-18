package com.ruoyi.carsale.service.impl;

import com.ruoyi.carsale.domain.CarsaleCarOrder;
import com.ruoyi.carsale.mapper.CarsaleCarOrderMapper;
import com.ruoyi.carsale.service.ICarsaleCarOrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
public class CarsaleCarOrderServiceImpl implements ICarsaleCarOrderService {

    @Autowired
    private CarsaleCarOrderMapper carsaleCarOrderMapper;

    @Override
    public List<CarsaleCarOrder> selectCarsaleCarOrderList(CarsaleCarOrder carsaleCarOrder) {
        return carsaleCarOrderMapper.selectCarsaleCarOrderList(carsaleCarOrder);
    }

    @Override
    public int insertCarsaleCarOrder(CarsaleCarOrder carsaleCarOrder) {
        return carsaleCarOrderMapper.insertCarsaleCarOrder(carsaleCarOrder);
    }

    @Override
    public int updateCarsaleCarOrder(CarsaleCarOrder carsaleCarOrder) {
        return carsaleCarOrderMapper.updateCarsaleCarOrder(carsaleCarOrder);
    }

    @Override
    public int deleteCarsaleCarOrderById(Long id) {
        return carsaleCarOrderMapper.deleteCarsaleCarOrderById(id);
    }

    @Override
    public int deleteCarsaleCarOrderByIds(Long[] ids) {
        return carsaleCarOrderMapper.deleteCarsaleCarOrderByIds(ids);
    }

    @Override
    public CarsaleCarOrder selectCarsaleCarOrderById(Long id) {
        return carsaleCarOrderMapper.selectCarsaleCarOrderById(id);
    }
}
