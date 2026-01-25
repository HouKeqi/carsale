package com.ruoyi.web.controller.carsale;

import com.ruoyi.carsale.domain.Vehicle;
import com.ruoyi.carsale.service.IInventoryService;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 库存管理Controller
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/carsale")
public class InventoryController extends BaseController {
    @Autowired
    private IInventoryService inventoryService;

    /**
     * 管理员查询库存不足的车型列表（库存≤5）
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @GetMapping("/admin/inventory/low-stock")
    public TableDataInfo getLowStockList(Vehicle vehicle) {
        startPage();
        List<Vehicle> list = inventoryService.selectLowStockVehicleList(vehicle);
        return getDataTable(list);
    }

    /**
     * 管理员统计库存不足的车型数量
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @GetMapping("/admin/inventory/low-stock/count")
    public AjaxResult getLowStockCount() {
        int count = inventoryService.countLowStockVehicles();
        Map<String, Object> result = new HashMap<>();
        result.put("count", count);
        return AjaxResult.success(result);
    }
}
