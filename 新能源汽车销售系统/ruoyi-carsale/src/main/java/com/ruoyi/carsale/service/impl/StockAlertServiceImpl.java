package com.ruoyi.carsale.service.impl;

import com.ruoyi.carsale.domain.StockAlert;
import com.ruoyi.carsale.mapper.StockAlertMapper;
import com.ruoyi.carsale.service.IStockAlertService;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class StockAlertServiceImpl implements IStockAlertService {
    @Autowired
    private StockAlertMapper stockAlertMapper;

    @Override
    public int insertStockAlert(StockAlert stockAlert) {
        if (stockAlert.getStatus() == null) {
            stockAlert.setStatus(1);
        }
        return stockAlertMapper.insertStockAlert(stockAlert);
    }

    @Override
    public int updateStockAlert(StockAlert stockAlert) {
        return stockAlertMapper.updateStockAlert(stockAlert);
    }

    @Override
    public int deleteStockAlertById(Long id) {
        return stockAlertMapper.deleteStockAlertById(id);
    }

    @Override
    public StockAlert selectStockAlertById(Long id) {
        return stockAlertMapper.selectStockAlertById(id);
    }

    @Override
    public List<StockAlert> selectStockAlertList(StockAlert stockAlert) {
        return stockAlertMapper.selectStockAlertList(stockAlert);
    }

    @Override
    public List<StockAlert> selectAlertsToNotify() {
        return stockAlertMapper.selectAlertsToNotify();
    }

    @Override
    public int markAsNotified(Long id) {
        StockAlert alert = new StockAlert();
        alert.setId(id);
        alert.setNotifyTime(DateUtils.getTime());
        return stockAlertMapper.updateStockAlert(alert);
    }
}
