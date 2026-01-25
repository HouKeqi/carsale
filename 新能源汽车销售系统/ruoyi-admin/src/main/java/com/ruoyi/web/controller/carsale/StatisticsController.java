package com.ruoyi.web.controller.carsale;

import com.ruoyi.carsale.service.IStatisticsService;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 数据统计分析Controller
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/carsale")
public class StatisticsController extends BaseController {
    @Autowired
    private IStatisticsService statisticsService;

    /**
     * 查询销量TOP5车型
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @GetMapping("/admin/statistics/top5-vehicles")
    public AjaxResult getTop5Vehicles(
            @RequestParam(required = false) String startTime,
            @RequestParam(required = false) String endTime) {
        List<Map<String, Object>> list = statisticsService.selectTop5Vehicles(startTime, endTime);
        return AjaxResult.success(list);
    }

    /**
     * 统计销售额
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @GetMapping("/admin/statistics/sales-amount")
    public AjaxResult getSalesAmount(
            @RequestParam(required = false) String startTime,
            @RequestParam(required = false) String endTime) {
        Double amount = statisticsService.getSalesAmount(startTime, endTime);
        Map<String, Object> result = new HashMap<>();
        result.put("amount", amount);
        return AjaxResult.success(result);
    }

    /**
     * 统计新增用户数
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @GetMapping("/admin/statistics/new-users")
    public AjaxResult getNewUsersCount(
            @RequestParam(required = false) String startTime,
            @RequestParam(required = false) String endTime) {
        Integer count = statisticsService.getNewUsersCount(startTime, endTime);
        Map<String, Object> result = new HashMap<>();
        result.put("count", count);
        return AjaxResult.success(result);
    }

    /**
     * 统计品牌销售占比
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @GetMapping("/admin/statistics/brand-distribution")
    public AjaxResult getBrandDistribution(
            @RequestParam(required = false) String startTime,
            @RequestParam(required = false) String endTime) {
        List<Map<String, Object>> list = statisticsService.getBrandDistribution(startTime, endTime);
        return AjaxResult.success(list);
    }

    /**
     * 统计续航里程销售占比
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @GetMapping("/admin/statistics/range-distribution")
    public AjaxResult getRangeDistribution(
            @RequestParam(required = false) String startTime,
            @RequestParam(required = false) String endTime) {
        List<Map<String, Object>> list = statisticsService.getRangeDistribution(startTime, endTime);
        return AjaxResult.success(list);
    }
}
