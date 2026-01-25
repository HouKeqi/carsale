package com.ruoyi.carsale.service.impl;

import com.ruoyi.carsale.domain.Vehicle;
import com.ruoyi.carsale.mapper.AdminVehicleManageMapper;
import com.ruoyi.carsale.service.IInventoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 库存管理服务实现类
 *
 * @author ruoyi
 */
@Service
public class InventoryServiceImpl implements IInventoryService {

    @Autowired
    private AdminVehicleManageMapper vehicleMapper;

    @Override
    public List<Vehicle> selectLowStockVehicleList(Vehicle vehicle) {
        return vehicleMapper.selectStockWarningList(vehicle);
    }

    @Override
    public int countLowStockVehicles() {
        Vehicle vehicle = new Vehicle();
        List<Vehicle> list = vehicleMapper.selectStockWarningList(vehicle);
        return list != null ? list.size() : 0;
    }
}
