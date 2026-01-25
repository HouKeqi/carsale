package com.ruoyi.carsale.mapper;

import java.util.List;
import java.util.Map;

/**
 * 数据统计Mapper接口
 *
 * @author ruoyi
 */
public interface StatisticsMapper {
    /**
     * 查询销量TOP5车型
     */
    List<Map<String, Object>> selectTop5Vehicles(Map<String, Object> params);

    /**
     * 统计销售额
     */
    Double getSalesAmount(Map<String, Object> params);

    /**
     * 统计新增用户数
     */
    Integer getNewUsersCount(Map<String, Object> params);

    /**
     * 统计品牌销售占比
     */
    List<Map<String, Object>> getBrandDistribution(Map<String, Object> params);

    /**
     * 统计续航里程销售占比
     */
    List<Map<String, Object>> getRangeDistribution(Map<String, Object> params);
}
