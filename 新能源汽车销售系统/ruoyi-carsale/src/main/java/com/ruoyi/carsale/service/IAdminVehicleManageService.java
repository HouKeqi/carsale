package com.ruoyi.carsale.service;

import java.util.List;
import com.ruoyi.carsale.domain.Vehicle;

/**
 * 车辆信息基础Service接口
 *
 * @author ruoyi
 * @date 2026-01-19
 */
public interface IAdminVehicleManageService
{
    /**
     * 查询车辆信息基础
     *
     * @param id 车辆信息基础主键
     * @return 车辆信息基础
     */
    public Vehicle selectVehicleById(Long id);

    /**
     * 查询车辆信息基础列表
     *
     * @param vehicle 车辆信息基础
     * @return 车辆信息基础集合
     */
    public List<Vehicle> selectVehicleList(Vehicle vehicle);

    /**
     * 新增车辆信息基础
     *
     * @param vehicle 车辆信息基础
     * @return 结果
     */
    public int insertVehicle(Vehicle vehicle);

    /**
     * 修改车辆信息基础
     *
     * @param vehicle 车辆信息基础
     * @return 结果
     */
    public int updateVehicle(Vehicle vehicle);

    /**
     * 批量删除车辆信息基础
     *
     * @param ids 需要删除的车辆信息基础主键集合
     * @return 结果
     */
    public int deleteVehicleByIds(Long[] ids);

    /**
     * 删除车辆信息基础信息
     *
     * @param id 车辆信息基础主键
     * @return 结果
     */
    public int deleteVehicleById(Long id);

    /**
     * 查询库存预警列表
     * @param vehicle
     * @return
     */
    public List<Vehicle> selectStockWarningList(Vehicle vehicle);
}
