package com.ruoyi.carsale.service.impl;

import com.ruoyi.carsale.domain.Vehicle;
import com.ruoyi.carsale.mapper.AdminVehicleManageMapper;
import com.ruoyi.carsale.service.IAdminVehicleManageService;
import com.ruoyi.common.exception.ServiceException;
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
        // 检查每个车辆是否有关联订单
        for (Long id : ids) {
            Vehicle vehicle = adminVehicleManageMapper.selectVehicleById(id);
            if (vehicle == null) {
                continue; // 如果车辆不存在，跳过
            }
            int orderCount = adminVehicleManageMapper.countOrdersByVehicleId(id);
            if (orderCount > 0) {
                throw new ServiceException(String.format("车辆【%s】存在 %d 个关联订单，无法删除。请先处理相关订单后再删除车辆。", vehicle.getName(), orderCount));
            }
        }
        return adminVehicleManageMapper.deleteVehicleByIds(ids);
    }

    @Override
    public int deleteVehicleById(Long id) {
        // 检查车辆是否有关联订单
        Vehicle vehicle = adminVehicleManageMapper.selectVehicleById(id);
        if (vehicle != null) {
            int orderCount = adminVehicleManageMapper.countOrdersByVehicleId(id);
            if (orderCount > 0) {
                throw new ServiceException(String.format("车辆【%s】存在 %d 个关联订单，无法删除。请先处理相关订单后再删除车辆。", vehicle.getName(), orderCount));
            }
        }
        return adminVehicleManageMapper.deleteVehicleById(id);
    }

    @Override
    public List<Vehicle> selectStockWarningList(Vehicle vehicle) {
        return adminVehicleManageMapper.selectStockWarningList(vehicle);
    }
}
