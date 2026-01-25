package com.ruoyi.carsale.service;

import java.util.List;
import java.util.Map;

/**
 * 数据统计服务接口
 *
 * @author ruoyi
 */
public interface IStatisticsService {
    /**
     * 查询销量TOP5车型（指定时间段）
     *
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 销量TOP5车型列表
     */
    List<Map<String, Object>> selectTop5Vehicles(String startTime, String endTime);

    /**
     * 统计销售额（指定时间段）
     *
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 销售额
     */
    Double getSalesAmount(String startTime, String endTime);

    /**
     * 统计新增用户数（指定时间段）
     *
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 新增用户数
     */
    Integer getNewUsersCount(String startTime, String endTime);

    /**
     * 统计品牌销售占比
     *
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 品牌销售占比列表
     */
    List<Map<String, Object>> getBrandDistribution(String startTime, String endTime);

    /**
     * 统计续航里程销售占比
     *
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 续航里程销售占比列表
     */
    List<Map<String, Object>> getRangeDistribution(String startTime, String endTime);
}
