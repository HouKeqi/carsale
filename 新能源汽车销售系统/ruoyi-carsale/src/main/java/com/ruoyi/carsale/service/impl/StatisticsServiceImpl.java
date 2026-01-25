package com.ruoyi.carsale.service.impl;

import com.ruoyi.carsale.mapper.StatisticsMapper;
import com.ruoyi.carsale.service.IStatisticsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 数据统计服务实现类
 *
 * @author ruoyi
 */
@Service
public class StatisticsServiceImpl implements IStatisticsService {

    @Autowired
    private StatisticsMapper statisticsMapper;

    @Override
    public List<Map<String, Object>> selectTop5Vehicles(String startTime, String endTime) {
        Map<String, Object> params = new HashMap<>();
        params.put("startTime", startTime);
        params.put("endTime", endTime);
        return statisticsMapper.selectTop5Vehicles(params);
    }

    @Override
    public Double getSalesAmount(String startTime, String endTime) {
        Map<String, Object> params = new HashMap<>();
        params.put("startTime", startTime);
        params.put("endTime", endTime);
        return statisticsMapper.getSalesAmount(params);
    }

    @Override
    public Integer getNewUsersCount(String startTime, String endTime) {
        Map<String, Object> params = new HashMap<>();
        params.put("startTime", startTime);
        params.put("endTime", endTime);
        return statisticsMapper.getNewUsersCount(params);
    }

    @Override
    public List<Map<String, Object>> getBrandDistribution(String startTime, String endTime) {
        Map<String, Object> params = new HashMap<>();
        params.put("startTime", startTime);
        params.put("endTime", endTime);
        return statisticsMapper.getBrandDistribution(params);
    }

    @Override
    public List<Map<String, Object>> getRangeDistribution(String startTime, String endTime) {
        Map<String, Object> params = new HashMap<>();
        params.put("startTime", startTime);
        params.put("endTime", endTime);
        return statisticsMapper.getRangeDistribution(params);
    }
}
