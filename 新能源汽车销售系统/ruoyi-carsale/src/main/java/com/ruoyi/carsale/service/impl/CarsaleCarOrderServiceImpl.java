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
}
