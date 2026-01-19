package com.ruoyi.carsale.service.impl;

import com.ruoyi.carsale.domain.Vehicle;
import com.ruoyi.carsale.mapper.AdminVehicleManageMapper;
import com.ruoyi.carsale.service.IAdminVehicleManageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AdminVehicleManageServiceImpl implements IAdminVehicleManageService {

    @Autowired
    private AdminVehicleManageMapper adminVehicleManageMapper;

    @Override
    public Vehicle selectVehicleById(Long id) {
        return adminVehicleManageMapper.selectVehicleById(id);
    }

    @Override
    public List<Vehicle> selectVehicleList(Vehicle vehicle) {
        return adminVehicleManageMapper.selectVehicleList(vehicle);
    }

    @Override
    public int insertVehicle(Vehicle vehicle) {
        return adminVehicleManageMapper.insertVehicle(vehicle);
    }

    @Override
    public int updateVehicle(Vehicle vehicle) {
        return adminVehicleManageMapper.updateVehicle(vehicle);
    }

    @Override
    public int deleteVehicleByIds(Long[] ids) {
        return adminVehicleManageMapper.deleteVehicleByIds(ids);
    }

    @Override
    public int deleteVehicleById(Long id) {
        return adminVehicleManageMapper.deleteVehicleById(id);
    }

    @Override
    public List<Vehicle> selectStockWarningList(Vehicle vehicle) {
        return adminVehicleManageMapper.selectStockWarningList(vehicle);
    }
}
