package com.ruoyi.carsale.service;

import com.ruoyi.carsale.domain.StockAlert;

/**
 * 库存提醒通知服务接口
 * 
 * @author ruoyi
 */
public interface IStockAlertNotifyService {
    
    /**
     * 通知用户库存已补货
     * 
     * @param stockAlert 库存提醒订阅
     * @param vehicleName 车辆名称
     */
    void notifyStockAvailable(StockAlert stockAlert, String vehicleName);
    
    /**
     * 检查并通知所有需要通知的订阅
     */
    void checkAndNotifyAll();
}
