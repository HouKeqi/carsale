package com.ruoyi.carsale.mapper;

import com.ruoyi.carsale.domain.BrowseHistory;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface BrowseHistoryMapper {
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
    List<Long> selectRecentVehicleIds(@Param("userId") Long userId, @Param("limit") int limit);
}
