package com.ruoyi.web.controller.carsale;

import com.ruoyi.carsale.domain.StockAlert;
import com.ruoyi.carsale.service.IStockAlertService;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 库存预警订阅Controller
 */
@RestController
@RequestMapping("/carsale")
public class StockAlertController extends BaseController {
    @Autowired
    private IStockAlertService stockAlertService;

    /**
     * 用户订阅库存预警
     */
    @PreAuthorize("@ss.hasRole('customer')")
    @PostMapping("/stock-alert/subscribe")
    @Log(title = "库存预警", businessType = BusinessType.INSERT)
    public AjaxResult subscribeStockAlert(@RequestParam("vehicleId") Long vehicleId) {
        try {
            StockAlert stockAlert = new StockAlert();
            stockAlert.setUserId(getUserId());
            stockAlert.setVehicleId(vehicleId);
            stockAlert.setStatus(1);
            stockAlertService.insertStockAlert(stockAlert);
            return AjaxResult.success("订阅成功，库存补货后将通知您");
        } catch (Exception e) {
            return AjaxResult.error("订阅失败：" + e.getMessage());
        }
    }

    /**
     * 用户取消订阅
     */
    @PreAuthorize("@ss.hasRole('customer')")
    @DeleteMapping("/stock-alert/unsubscribe/{id}")
    @Log(title = "库存预警", businessType = BusinessType.DELETE)
    public AjaxResult unsubscribeStockAlert(@PathVariable("id") Long id) {
        try {
            StockAlert alert = stockAlertService.selectStockAlertById(id);
            if (alert == null || !alert.getUserId().equals(getUserId())) {
                return AjaxResult.error("无权操作");
            }
            return toAjax(stockAlertService.deleteStockAlertById(id));
        } catch (Exception e) {
            return AjaxResult.error("取消订阅失败：" + e.getMessage());
        }
    }

    /**
     * 用户查询我的订阅列表
     */
    @PreAuthorize("@ss.hasRole('customer')")
    @GetMapping("/stock-alert/my-list")
    public TableDataInfo getMyStockAlertList() {
        startPage();
        StockAlert stockAlert = new StockAlert();
        stockAlert.setUserId(getUserId());
        List<StockAlert> list = stockAlertService.selectStockAlertList(stockAlert);
        return getDataTable(list);
    }

    /**
     * 检查用户是否已订阅某车型
     */
    @PreAuthorize("@ss.hasRole('customer')")
    @GetMapping("/stock-alert/check")
    public AjaxResult checkSubscription(@RequestParam("vehicleId") Long vehicleId) {
        StockAlert query = new StockAlert();
        query.setUserId(getUserId());
        query.setVehicleId(vehicleId);
        query.setStatus(1);
        List<StockAlert> list = stockAlertService.selectStockAlertList(query);
        boolean subscribed = !list.isEmpty();
        return AjaxResult.success(subscribed);
    }
}
