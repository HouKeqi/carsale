package com.ruoyi.web.controller.carsale;

import com.ruoyi.carsale.domain.BrowseHistory;
import com.ruoyi.carsale.domain.Vehicle;
import com.ruoyi.carsale.service.IBrowseHistoryService;
import com.ruoyi.carsale.service.IAdminVehicleManageService;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 智能推荐Controller
 */
@RestController
@RequestMapping("/carsale")
public class RecommendController extends BaseController {
    @Autowired
    private IBrowseHistoryService browseHistoryService;
    
    @Autowired
    private IAdminVehicleManageService vehicleService;

    /**
     * 记录浏览历史
     */
    @PreAuthorize("@ss.hasRole('customer')")
    @PostMapping("/browse/record")
    public AjaxResult recordBrowse(@RequestParam("vehicleId") Long vehicleId) {
        try {
            BrowseHistory browseHistory = new BrowseHistory();
            browseHistory.setUserId(getUserId());
            browseHistory.setVehicleId(vehicleId);
            browseHistoryService.insertBrowseHistory(browseHistory);
            return AjaxResult.success("浏览记录已保存");
        } catch (Exception e) {
            return AjaxResult.error("记录浏览失败：" + e.getMessage());
        }
    }

    /**
     * 获取推荐车型（基于浏览记录）
     */
    @PreAuthorize("@ss.hasRole('customer')")
    @GetMapping("/recommend/vehicles")
    public AjaxResult getRecommendedVehicles(@RequestParam(value = "limit", defaultValue = "6") int limit) {
        try {
            Long userId = getUserId();
            
            // 获取用户最近浏览的车型ID
            List<Long> recentVehicleIds = browseHistoryService.selectRecentVehicleIds(userId, 10);
            
            if (recentVehicleIds.isEmpty()) {
                // 如果没有浏览记录，返回高性价比车型（价格/续航比最优）
                Vehicle query = new Vehicle();
                query.setStock(1); // 有库存的
                List<Vehicle> allVehicles = vehicleService.selectVehicleList(query);
                
                // 计算性价比（续航/价格），按性价比降序排序
                List<Vehicle> recommended = allVehicles.stream()
                    .filter(v -> v.getPrice() != null && v.getPrice() > 0 && v.getRangeKm() != null)
                    .sorted((v1, v2) -> {
                        double ratio1 = v1.getRangeKm().doubleValue() / v1.getPrice().doubleValue();
                        double ratio2 = v2.getRangeKm().doubleValue() / v2.getPrice().doubleValue();
                        return Double.compare(ratio2, ratio1); // 降序
                    })
                    .limit(limit)
                    .collect(Collectors.toList());
                
                return AjaxResult.success(recommended);
            }
            
            // 基于浏览记录推荐相似车型
            List<Vehicle> recommended = new ArrayList<>();
            
            // 获取用户浏览过的车型信息
            List<Vehicle> browsedVehicles = new ArrayList<>();
            for (Long vehicleId : recentVehicleIds) {
                Vehicle vehicle = vehicleService.selectVehicleById(vehicleId);
                if (vehicle != null) {
                    browsedVehicles.add(vehicle);
                }
            }
            
            if (browsedVehicles.isEmpty()) {
                return AjaxResult.success(new ArrayList<>());
            }
            
            // 计算用户偏好（平均价格、平均续航、品牌偏好）
            double avgPrice = browsedVehicles.stream()
                .mapToDouble(v -> v.getPrice() != null ? v.getPrice() : 0)
                .average()
                .orElse(0);
            
            int avgRange = (int) browsedVehicles.stream()
                .mapToInt(v -> v.getRangeKm() != null ? v.getRangeKm() : 0)
                .average()
                .orElse(0);
            
            // 获取所有车型
            Vehicle query = new Vehicle();
            query.setStock(1); // 有库存的
            List<Vehicle> allVehicles = vehicleService.selectVehicleList(query);
            
            // 过滤掉已浏览的车型
            List<Vehicle> candidateVehicles = allVehicles.stream()
                .filter(v -> !recentVehicleIds.contains((long) v.getId()))
                .collect(Collectors.toList());
            
            // 根据相似度推荐（价格区间、续航范围、品牌）
            recommended = candidateVehicles.stream()
                .map(v -> {
                    // 计算相似度分数
                    double score = 0;
                    
                    // 价格相似度（价格越接近，分数越高）
                    if (v.getPrice() != null && avgPrice > 0) {
                        double priceDiff = Math.abs(v.getPrice() - avgPrice) / avgPrice;
                        score += (1 - Math.min(priceDiff, 1)) * 0.4; // 价格权重40%
                    }
                    
                    // 续航相似度
                    if (v.getRangeKm() != null && avgRange > 0) {
                        double rangeDiff = Math.abs(v.getRangeKm() - avgRange) / (double) avgRange;
                        score += (1 - Math.min(rangeDiff, 1)) * 0.4; // 续航权重40%
                    }
                    
                    // 品牌偏好（如果浏览过同品牌，加分）
                    boolean sameBrand = browsedVehicles.stream()
                        .anyMatch(bv -> bv.getBrand() != null && bv.getBrand().equals(v.getBrand()));
                    if (sameBrand) {
                        score += 0.2; // 品牌权重20%
                    }
                    
                    return new VehicleScore(v, score);
                })
                .sorted((vs1, vs2) -> Double.compare(vs2.score, vs1.score))
                .limit(limit)
                .map(vs -> vs.vehicle)
                .collect(Collectors.toList());
            
            return AjaxResult.success(recommended);
        } catch (Exception e) {
            return AjaxResult.error("获取推荐失败：" + e.getMessage());
        }
    }
    
    /**
     * 车型和分数包装类
     */
    private static class VehicleScore {
        Vehicle vehicle;
        double score;
        
        VehicleScore(Vehicle vehicle, double score) {
            this.vehicle = vehicle;
            this.score = score;
        }
    }
}
