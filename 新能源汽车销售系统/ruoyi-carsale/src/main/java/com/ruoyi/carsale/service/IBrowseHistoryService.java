package com.ruoyi.carsale.service;

import com.ruoyi.carsale.domain.BrowseHistory;
import java.util.List;

public interface IBrowseHistoryService {
    /**
     * 新增浏览记录
     */
    int insertBrowseHistory(BrowseHistory browseHistory);

    /**
     * 查询用户浏览记录列表
     */
    List<BrowseHistory> selectBrowseHistoryList(BrowseHistory browseHistory);

    /**
     * 查询用户最近浏览的车型ID列表
     */
    List<Long> selectRecentVehicleIds(Long userId, int limit);
}
