package com.ruoyi.web.controller.carsale;

import java.util.List;
import javax.servlet.http.HttpServletResponse;
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
import com.ruoyi.common.utils.poi.ExcelUtil;
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
     * 查询车辆信息基础列表
     */
    @GetMapping({"/admin/vehicle/detail","/vehicle/search","/vehicle/evaluations","/vehicle/brand/list","/vehicle/battery-type/list"})
    public TableDataInfo getVehicleList(Vehicle vehicle)
    {
        startPage();
        List<Vehicle> list = vehicleService.selectVehicleList(vehicle);
        return getDataTable(list);
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
     * 获取车辆信息基础详细信息
     */
    @GetMapping(value = {"/admin/vehicle/detail/{id}","/vehicle/detail/{id}"})
    public AjaxResult getVehicleDetailInfo(@PathVariable("id") Long id)
    {
        return success(vehicleService.selectVehicleById(id));
    }

    /**
     * 新增车辆信息基础
     */
    @PostMapping("/admin/vehicle/add")
    public AjaxResult addVehicle(@RequestBody Vehicle vehicle)
    {
        return toAjax(vehicleService.insertVehicle(vehicle));
    }

    /**
     * 修改车辆信息基础
     */
    @PutMapping("/admin/vehicle/update")
    public AjaxResult updateVehicle(@RequestBody Vehicle vehicle)
    {
        return toAjax(vehicleService.updateVehicle(vehicle));
    }

    /**
     * 删除车辆信息基础
     */
    @DeleteMapping("/admin/vehicle/delete/{ids}")
    public AjaxResult deleteVehicle(@PathVariable Long[] ids)
    {
        return toAjax(vehicleService.deleteVehicleByIds(ids));
    }

    @GetMapping("/admin/vehicle/stock/warning")
    public TableDataInfo getStockWarningList(Vehicle vehicle) {
        startPage();
        List<Vehicle> list = vehicleService.selectStockWarningList(vehicle);
        return getDataTable(list);
    }

    /**
     * 调整库存数量
     */
    @PutMapping("/admin/vehicle/stock/update")
    public AjaxResult updateStock(@RequestBody Vehicle vehicle) {
        return toAjax(vehicleService.updateVehicle(vehicle));
    }



}
