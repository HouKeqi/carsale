package com.ruoyi.web.controller.carsale;

import com.ruoyi.carsale.domain.Evaluation;
import com.ruoyi.carsale.domain.Promotion;
import com.ruoyi.carsale.domain.Vehicle;
import com.ruoyi.carsale.service.IAdminVehicleManageService;
import com.ruoyi.carsale.service.IEvaluationService;
import com.ruoyi.carsale.service.IPromotionService;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 车辆信息Controller（普通用户访问）
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/carsale")
public class VehicleController extends BaseController {
    @Autowired
    private IAdminVehicleManageService vehicleService;
    
    @Autowired
    private IPromotionService promotionService;
    
    @Autowired
    private IEvaluationService evaluationService;

    /**
     * 普通用户搜索车辆（支持品牌、价格区间、续航里程、电池类型筛选和排序）
     */
    @GetMapping("/vehicle/search")
    public TableDataInfo searchVehicle(Vehicle vehicle) {
        startPage();
        List<Vehicle> list = vehicleService.selectVehicleList(vehicle);
        return getDataTable(list);
    }

    /**
     * 获取车辆详情（包含促销活动、评价列表）
     */
    @GetMapping("/vehicle/{id}")
    public AjaxResult getVehicleDetail(@PathVariable("id") Long id) {
        Vehicle vehicle = vehicleService.selectVehicleById(id);
        if (vehicle == null) {
            return AjaxResult.error("车辆不存在");
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("vehicle", vehicle);
        
        // 查询关联的促销活动（只查询上架且未过期的）
        Promotion promotionQuery = new Promotion();
        promotionQuery.setVehicleId(id);
        promotionQuery.setStatus(1); // 只查询上架的活动
        List<Promotion> promotions = promotionService.selectPromotionList(promotionQuery);
        // 过滤已过期的活动
        Date now = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd");
        promotions.removeIf(p -> {
            String endTimeStr = p.getEndTime();
            if (endTimeStr != null && !endTimeStr.trim().isEmpty()) {
                try {
                    Date endDate;
                    // 尝试解析 datetime 格式 (yyyy-MM-dd HH:mm:ss)
                    if (endTimeStr.length() > 10) {
                        endDate = sdf.parse(endTimeStr);
                    } else {
                        // 解析 date 格式 (yyyy-MM-dd)
                        endDate = sdfDate.parse(endTimeStr);
                    }
                    return endDate.before(now);
                } catch (ParseException e) {
                    // 日期格式错误，跳过该促销活动
                    return true;
                }
            }
            return false;
        });
        result.put("promotions", promotions);
        
        // 查询车辆评价列表
        Evaluation evalQuery = new Evaluation();
        evalQuery.setVehicleId(id);
        List<Evaluation> evaluations = evaluationService.selectEvaluationList(evalQuery);
        result.put("evaluations", evaluations);
        
        return AjaxResult.success(result);
    }

    /**
     * 获取车辆关联的促销活动
     */
    @GetMapping("/vehicle/{id}/promotions")
    public AjaxResult getVehiclePromotions(@PathVariable("id") Long id) {
        Promotion promotion = new Promotion();
        promotion.setVehicleId(id);
        promotion.setStatus(1); // 只查询上架的活动
        List<Promotion> list = promotionService.selectPromotionList(promotion);
        // 过滤已过期的活动
        Date now = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd");
        list.removeIf(p -> {
            String endTimeStr = p.getEndTime();
            if (endTimeStr != null && !endTimeStr.trim().isEmpty()) {
                try {
                    Date endDate;
                    // 尝试解析 datetime 格式 (yyyy-MM-dd HH:mm:ss)
                    if (endTimeStr.length() > 10) {
                        endDate = sdf.parse(endTimeStr);
                    } else {
                        // 解析 date 格式 (yyyy-MM-dd)
                        endDate = sdfDate.parse(endTimeStr);
                    }
                    return endDate.before(now);
                } catch (ParseException e) {
                    // 日期格式错误，跳过该促销活动
                    return true;
                }
            }
            return false;
        });
        return AjaxResult.success(list);
    }

    /**
     * 获取车辆评价列表
     */
    @GetMapping("/vehicle/{id}/evaluations")
    public TableDataInfo getVehicleEvaluations(@PathVariable("id") Long id) {
        startPage();
        Evaluation evaluation = new Evaluation();
        evaluation.setVehicleId(id);
        List<Evaluation> list = evaluationService.selectEvaluationList(evaluation);
        return getDataTable(list);
    }
}
