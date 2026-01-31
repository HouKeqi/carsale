package com.ruoyi.carsale.service;

import com.ruoyi.carsale.domain.StockAlert;
import java.util.List;

public interface IStockAlertService {
    /**
     * 新增库存预警订阅
     */
    int insertStockAlert(StockAlert stockAlert);

    /**
     * 修改库存预警订阅
     */
    int updateStockAlert(StockAlert stockAlert);

    /**
     * 删除库存预警订阅
     */
    int deleteStockAlertById(Long id);

    /**
     * 查询库存预警订阅
     */
    StockAlert selectStockAlertById(Long id);

    /**
     * 查询库存预警订阅列表
     */
    List<StockAlert> selectStockAlertList(StockAlert stockAlert);

    /**
     * 查询需要通知的订阅
     */
    List<StockAlert> selectAlertsToNotify();

    /**
     * 标记已通知
     */
    int markAsNotified(Long id);
}
