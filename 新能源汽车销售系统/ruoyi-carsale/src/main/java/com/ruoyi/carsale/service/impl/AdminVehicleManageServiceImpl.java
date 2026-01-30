package com.ruoyi.carsale.service.impl;

import com.ruoyi.carsale.domain.StockAlert;
import com.ruoyi.carsale.domain.Vehicle;
import com.ruoyi.carsale.mapper.AdminVehicleManageMapper;
import com.ruoyi.carsale.service.IAdminVehicleManageService;
import com.ruoyi.carsale.service.IStockAlertNotifyService;
import com.ruoyi.carsale.service.IStockAlertService;
import com.ruoyi.common.exception.ServiceException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AdminVehicleManageServiceImpl implements IAdminVehicleManageService {

    @Autowired
    private AdminVehicleManageMapper adminVehicleManageMapper;

    @Autowired
    private IStockAlertNotifyService stockAlertNotifyService;

    @Autowired
    private IStockAlertService stockAlertService;

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
        // 如果更新了库存，检查是否需要通知订阅用户
        if (vehicle.getId() > 0 && vehicle.getStock() != null) {
            // 获取更新前的车辆信息
            Vehicle oldVehicle = adminVehicleManageMapper.selectVehicleById((long) vehicle.getId());
            
            // 判断库存是否从 0 变为有货
            if (oldVehicle != null && oldVehicle.getStock() != null 
                && oldVehicle.getStock() == 0 && vehicle.getStock() > 0) {
                
                // 查询所有订阅了该车型的用户（状态为启用且未通知）
                StockAlert query = new StockAlert();
                query.setVehicleId((long) vehicle.getId());
                query.setStatus(1);  // 1表示启用状态
                List<StockAlert> alerts = stockAlertService.selectStockAlertList(query);
                
                // 构建车辆名称（使用旧车辆信息，确保有完整数据）
                String vehicleName = (oldVehicle.getBrand() != null ? oldVehicle.getBrand() : "") 
                                   + " " 
                                   + (oldVehicle.getName() != null ? oldVehicle.getName() : "");
                vehicleName = vehicleName.trim();
                
                // 遍历订阅列表，发送通知
                for (StockAlert alert : alerts) {
                    // 只通知未通知过的订阅
                    if (alert.getNotifyTime() == null) {
                        stockAlertNotifyService.notifyStockAvailable(alert, vehicleName);
                    }
                }
            }
        }
        
        // 执行更新操作
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
