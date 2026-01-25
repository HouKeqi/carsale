package com.ruoyi.carsale.service;

import com.ruoyi.carsale.domain.Vehicle;
import java.util.List;

/**
 * 库存管理服务接口
 *
 * @author ruoyi
 */
public interface IInventoryService {
    /**
     * 查询库存不足的车型列表（库存≤5）
     *
     * @param vehicle 查询条件
     * @return 库存不足的车型列表
     */
    List<Vehicle> selectLowStockVehicleList(Vehicle vehicle);

    /**
     * 统计库存不足的车型数量
     *
     * @return 库存不足的车型数量
     */
    int countLowStockVehicles();
}
