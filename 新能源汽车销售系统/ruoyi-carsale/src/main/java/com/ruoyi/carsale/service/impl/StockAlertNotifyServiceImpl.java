package com.ruoyi.carsale.service.impl;

import com.ruoyi.carsale.domain.StockAlert;
import com.ruoyi.carsale.domain.Vehicle;
import com.ruoyi.carsale.mapper.AdminVehicleManageMapper;
import com.ruoyi.carsale.service.IStockAlertNotifyService;
import com.ruoyi.carsale.service.IStockAlertService;
import com.ruoyi.carsale.websocket.StockAlertWebSocket;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 库存提醒通知服务实现类
 * 
 * @author ruoyi
 */
@Service
public class StockAlertNotifyServiceImpl implements IStockAlertNotifyService {

    private static final Logger log = LoggerFactory.getLogger(StockAlertNotifyServiceImpl.class);

    @Autowired
    private IStockAlertService stockAlertService;

    @Autowired
    private AdminVehicleManageMapper vehicleMapper;

    @Override
    public void notifyStockAvailable(StockAlert stockAlert, String vehicleName) {
        try {
            // 构建通知消息数据
            Map<String, Object> notificationData = new HashMap<>();
            notificationData.put("vehicleId", stockAlert.getVehicleId());
            notificationData.put("vehicleName", vehicleName);
            notificationData.put("alertId", stockAlert.getId());
            notificationData.put("title", "车辆补货提醒");
            notificationData.put("content", String.format("您关注的车型【%s】已有库存，可以下单了！", vehicleName));
            notificationData.put("timestamp", System.currentTimeMillis());

            // 创建 STOCK_REFILL 类型的消息
            StockAlertWebSocket.WebSocketMessage message = 
                new StockAlertWebSocket.WebSocketMessage("STOCK_REFILL", notificationData);

            // 通过WebSocket发送通知
            StockAlertWebSocket.sendMessageToUser(stockAlert.getUserId(), message);
            
            // 标记为已通知
            stockAlertService.markAsNotified(stockAlert.getId());
            
            log.info("已通知用户 {} 车型 {} 库存已补货", stockAlert.getUserId(), vehicleName);
        } catch (Exception e) {
            log.error("通知用户库存补货失败", e);
        }
    }

    @Override
    public void checkAndNotifyAll() {
        try {
            // 查询所有需要通知的订阅
            List<StockAlert> alerts = stockAlertService.selectAlertsToNotify();
            
            for (StockAlert alert : alerts) {
                // 查询车辆信息
                Vehicle vehicle = vehicleMapper.selectVehicleById(alert.getVehicleId());
                if (vehicle != null && vehicle.getStock() > 0) {
                    String vehicleName = vehicle.getBrand() + " " + vehicle.getName();
                    notifyStockAvailable(alert, vehicleName);
                }
            }
        } catch (Exception e) {
            log.error("检查并通知库存补货失败", e);
        }
    }
}
