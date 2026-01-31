package com.ruoyi.carsale.service.impl;

import com.ruoyi.carsale.domain.BrowseHistory;
import com.ruoyi.carsale.mapper.BrowseHistoryMapper;
import com.ruoyi.carsale.service.IBrowseHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BrowseHistoryServiceImpl implements IBrowseHistoryService {
    @Autowired
    private BrowseHistoryMapper browseHistoryMapper;

    @Override
    public int insertBrowseHistory(BrowseHistory browseHistory) {
        return browseHistoryMapper.insertBrowseHistory(browseHistory);
    }

    @Override
    public List<BrowseHistory> selectBrowseHistoryList(BrowseHistory browseHistory) {
        return browseHistoryMapper.selectBrowseHistoryList(browseHistory);
    }

    @Override
    public List<Long> selectRecentVehicleIds(Long userId, int limit) {
        return browseHistoryMapper.selectRecentVehicleIds(userId, limit);
    }
}
