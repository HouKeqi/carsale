package com.ruoyi.web.controller.carsale;

import com.ruoyi.carsale.domain.Promotion;
import com.ruoyi.carsale.service.IPromotionService;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * 促销活动管理Controller
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/carsale")
public class PromotionController extends BaseController {
    @Autowired
    private IPromotionService promotionService;

    /**
     * 管理员新增促销活动
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @PostMapping("/admin/promotion/add")
    @Log(title = "促销活动管理", businessType = BusinessType.INSERT)
    public AjaxResult addPromotion(@RequestBody Promotion promotion) {
        // 验证有效期
        if (promotion.getStartTime() != null && promotion.getEndTime() != null) {
            try {
                Date startDate = parseDate(promotion.getStartTime());
                Date endDate = parseDate(promotion.getEndTime());
                if (startDate != null && endDate != null && startDate.after(endDate)) {
                    return AjaxResult.error("开始时间不能晚于结束时间");
                }
            } catch (Exception e) {
                return AjaxResult.error("日期格式错误：" + e.getMessage());
            }
        }
        // 默认状态为上架
        if (promotion.getStatus() == null) {
            promotion.setStatus(1);
        }
        return toAjax(promotionService.insertPromotion(promotion));
    }

    /**
     * 管理员修改促销活动
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @PutMapping("/admin/promotion/update")
    @Log(title = "促销活动管理", businessType = BusinessType.UPDATE)
    public AjaxResult updatePromotion(@RequestBody Promotion promotion) {
        // 验证有效期
        if (promotion.getStartTime() != null && promotion.getEndTime() != null) {
            try {
                Date startDate = parseDate(promotion.getStartTime());
                Date endDate = parseDate(promotion.getEndTime());
                if (startDate != null && endDate != null && startDate.after(endDate)) {
                    return AjaxResult.error("开始时间不能晚于结束时间");
                }
            } catch (Exception e) {
                return AjaxResult.error("日期格式错误：" + e.getMessage());
            }
        }
        return toAjax(promotionService.updatePromotion(promotion));
    }

    /**
     * 管理员删除促销活动
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @DeleteMapping("/admin/promotion/delete/{id}")
    @Log(title = "促销活动管理", businessType = BusinessType.DELETE)
    public AjaxResult deletePromotion(@PathVariable("id") Long id) {
        return toAjax(promotionService.deletePromotionById(id));
    }

    /**
     * 管理员批量删除促销活动
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @DeleteMapping("/admin/promotion/deleteByIds/{ids}")
    @Log(title = "促销活动管理", businessType = BusinessType.DELETE)
    public AjaxResult deletePromotionByIds(@PathVariable("ids") Long[] ids) {
        return toAjax(promotionService.deletePromotionByIds(ids));
    }

    /**
     * 管理员通过id查询促销活动
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @GetMapping("/admin/promotion/detail/{id}")
    public AjaxResult selectPromotionById(@PathVariable("id") Long id) {
        return AjaxResult.success(promotionService.selectPromotionById(id));
    }

    /**
     * 管理员查询促销活动列表
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @GetMapping("/admin/promotion/page")
    public TableDataInfo selectPromotionList(Promotion promotion) {
        startPage();
        List<Promotion> list = promotionService.selectPromotionList(promotion);
        return getDataTable(list);
    }

    /**
     * 根据车辆ID查询促销活动列表（公开接口，普通用户可访问）
     */
    @GetMapping("/promotion/vehicle/{vehicleId}")
    public AjaxResult getVehiclePromotions(@PathVariable("vehicleId") Long vehicleId) {
        Promotion promotion = new Promotion();
        promotion.setVehicleId(vehicleId);
        promotion.setStatus(1); // 只查询上架的活动
        List<Promotion> list = promotionService.selectPromotionList(promotion);
        // 过滤已过期的活动
        Date now = new Date();
        list.removeIf(p -> {
            if (p.getEndTime() != null) {
                try {
                    Date endDate = parseDate(p.getEndTime());
                    return endDate != null && endDate.before(now);
                } catch (Exception e) {
                    return false;
                }
            }
            return false;
        });
        return AjaxResult.success(list);
    }

    /**
     * 解析日期字符串，支持多种格式
     * @param dateStr 日期字符串
     * @return Date对象
     * @throws ParseException 解析异常
     */
    private Date parseDate(String dateStr) throws ParseException {
        if (dateStr == null || dateStr.trim().isEmpty()) {
            return null;
        }
        dateStr = dateStr.trim();
        
        // 尝试多种日期格式
        String[] patterns = {
            "yyyy-MM-dd HH:mm:ss",
            "yyyy-MM-dd HH:mm",
            "yyyy-MM-dd",
            "yyyy/MM/dd HH:mm:ss",
            "yyyy/MM/dd"
        };
        
        for (String pattern : patterns) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat(pattern);
                return sdf.parse(dateStr);
            } catch (ParseException e) {
                // 继续尝试下一个格式
            }
        }
        
        // 如果所有格式都失败，尝试使用 Date.valueOf（仅支持 yyyy-MM-dd）
        if (dateStr.length() == 10 && dateStr.matches("\\d{4}-\\d{2}-\\d{2}")) {
            try {
                return java.sql.Date.valueOf(dateStr);
            } catch (IllegalArgumentException e) {
                throw new ParseException("无法解析日期格式: " + dateStr, 0);
            }
        }
        
        throw new ParseException("无法解析日期格式: " + dateStr, 0);
    }
}
