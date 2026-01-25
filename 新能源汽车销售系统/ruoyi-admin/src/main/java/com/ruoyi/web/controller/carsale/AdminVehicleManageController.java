package com.ruoyi.web.controller.carsale;

import java.util.List;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.carsale.domain.Vehicle;
import com.ruoyi.carsale.service.IAdminVehicleManageService;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 车辆信息基础Controller
 *
 * @author ruoyi
 * @date 2026-01-19
 */
@RestController
@RequestMapping("/carsale")
public class AdminVehicleManageController extends BaseController
{
    @Autowired
    private IAdminVehicleManageService vehicleService;



    /**
     * 管理员查询车辆信息列表（分页）
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @GetMapping("/admin/vehicle/detail")
    public TableDataInfo getAdminVehicleList(Vehicle vehicle)
    {
        startPage();
        List<Vehicle> list = vehicleService.selectVehicleList(vehicle);
        return getDataTable(list);
    }

    /**
     * 管理员查询所有车辆列表（不分页，用于下拉选择）
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @GetMapping("/admin/vehicle/list")
    public AjaxResult getAllVehicleList()
    {
        List<Vehicle> list = vehicleService.selectVehicleList(new Vehicle());
        return AjaxResult.success(list);
    }

    /**
     * 导出车辆信息基础列表
     */
//    @PostMapping("/export")
//    public void export(HttpServletResponse response, Vehicle vehicle)
//    {
//        List<Vehicle> list = vehicleService.selectVehicleList(vehicle);
//        ExcelUtil<Vehicle> util = new ExcelUtil<Vehicle>(Vehicle.class);
//        util.exportExcel(response, list, "车辆信息基础数据");
//    }

    /**
     * 获取车辆详细信息（管理员和普通用户都可访问）
     */
    @GetMapping(value = {"/admin/vehicle/detail/{id}","/vehicle/detail/{id}"})
    public AjaxResult getVehicleDetailInfo(@PathVariable("id") Long id)
    {
        return success(vehicleService.selectVehicleById(id));
    }

    /**
     * 管理员新增车辆信息
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @PostMapping("/admin/vehicle/add")
    @Log(title = "车辆管理", businessType = BusinessType.INSERT)
    public AjaxResult addVehicle(@RequestBody Vehicle vehicle)
    {
        // 数据验证
        if (vehicle.getName() == null || vehicle.getName().trim().isEmpty()) {
            return AjaxResult.error("车型名称不能为空");
        }
        if (vehicle.getBrand() == null || vehicle.getBrand().trim().isEmpty()) {
            return AjaxResult.error("品牌不能为空");
        }
        if (vehicle.getPrice() == null || vehicle.getPrice() < 0) {
            return AjaxResult.error("价格不能为空且必须大于等于0");
        }
        if (vehicle.getBatteryType() == null) {
            return AjaxResult.error("电池类型不能为空");
        }
        if (vehicle.getRangeKm() == null || vehicle.getRangeKm() < 0) {
            return AjaxResult.error("续航里程不能为空且必须大于等于0");
        }
        if (vehicle.getStock() == null || vehicle.getStock() < 0) {
            return AjaxResult.error("库存数量不能为空且必须大于等于0");
        }
        // 验证配置JSON格式
        if (vehicle.getConfigJson() != null && !vehicle.getConfigJson().trim().isEmpty()) {
            try {
                // 简单验证JSON格式（实际可以使用JSON库验证）
                String json = vehicle.getConfigJson().trim();
                if (!json.startsWith("{") || !json.endsWith("}")) {
                    return AjaxResult.error("配置参数必须是有效的JSON格式");
                }
            } catch (Exception e) {
                return AjaxResult.error("配置参数格式错误：" + e.getMessage());
            }
        }
        return toAjax(vehicleService.insertVehicle(vehicle));
    }

    /**
     * 管理员修改车辆信息
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @PutMapping("/admin/vehicle/update")
    @Log(title = "车辆管理", businessType = BusinessType.UPDATE)
    public AjaxResult updateVehicle(@RequestBody Vehicle vehicle)
    {
        // 数据验证
        if (vehicle.getId() <= 0) {
            return AjaxResult.error("车辆ID无效");
        }
        if (vehicle.getName() == null || vehicle.getName().trim().isEmpty()) {
            return AjaxResult.error("车型名称不能为空");
        }
        if (vehicle.getBrand() == null || vehicle.getBrand().trim().isEmpty()) {
            return AjaxResult.error("品牌不能为空");
        }
        if (vehicle.getPrice() == null || vehicle.getPrice() < 0) {
            return AjaxResult.error("价格不能为空且必须大于等于0");
        }
        if (vehicle.getBatteryType() == null) {
            return AjaxResult.error("电池类型不能为空");
        }
        if (vehicle.getRangeKm() == null || vehicle.getRangeKm() < 0) {
            return AjaxResult.error("续航里程不能为空且必须大于等于0");
        }
        if (vehicle.getStock() == null || vehicle.getStock() < 0) {
            return AjaxResult.error("库存数量不能为空且必须大于等于0");
        }
        // 验证配置JSON格式
        if (vehicle.getConfigJson() != null && !vehicle.getConfigJson().trim().isEmpty()) {
            try {
                String json = vehicle.getConfigJson().trim();
                if (!json.startsWith("{") || !json.endsWith("}")) {
                    return AjaxResult.error("配置参数必须是有效的JSON格式");
                }
            } catch (Exception e) {
                return AjaxResult.error("配置参数格式错误：" + e.getMessage());
            }
        }
        return toAjax(vehicleService.updateVehicle(vehicle));
    }

    /**
     * 管理员删除车辆信息
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @DeleteMapping("/admin/vehicle/delete/{ids}")
    @Log(title = "车辆管理", businessType = BusinessType.DELETE)
    public AjaxResult deleteVehicle(@PathVariable Long[] ids)
    {
        if (ids == null || ids.length == 0) {
            return AjaxResult.error("请选择要删除的车辆");
        }
        return toAjax(vehicleService.deleteVehicleByIds(ids));
    }

    /**
     * 管理员查询库存不足预警列表（库存≤5）
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @GetMapping("/admin/vehicle/stock/warning")
    public TableDataInfo getStockWarningList(Vehicle vehicle) {
        startPage();
        List<Vehicle> list = vehicleService.selectStockWarningList(vehicle);
        return getDataTable(list);
    }

    /**
     * 管理员调整库存数量
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @PutMapping("/admin/vehicle/stock/update")
    @Log(title = "库存管理", businessType = BusinessType.UPDATE)
    public AjaxResult updateStock(@RequestBody Vehicle vehicle) {
        return toAjax(vehicleService.updateVehicle(vehicle));
    }



}
