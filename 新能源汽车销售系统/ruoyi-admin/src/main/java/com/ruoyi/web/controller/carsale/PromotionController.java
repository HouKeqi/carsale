package com.ruoyi.web.controller.carsale;

import com.ruoyi.carsale.domain.Evaluation;
import com.ruoyi.carsale.domain.Promotion;
import com.ruoyi.carsale.service.impl.PromotionIServiceImpl;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/carsale")
public class PromotionController extends BaseController {
    @Autowired
    private PromotionIServiceImpl promotionService;

    // 添加评价
    @PostMapping("/admin/promotion/add")
    public AjaxResult addPromotion(@RequestBody Promotion promotion) {
        return AjaxResult.success(promotionService.insertPromotion(promotion));
    }

    // 修改评价
    @PutMapping("/admin/promotion/update")
    public AjaxResult updatePromotion(@RequestBody Promotion promotion) {
        return AjaxResult.success(promotionService.updatePromotion(promotion));
    }

    // 删除评价
    @DeleteMapping("/admin/promotion/delete")
    public AjaxResult deletePromotion(@RequestBody Promotion promotion) {
        return AjaxResult.success(promotionService.deletePromotionById(promotion.getId()));
    }

    // 批量删除评价
    @DeleteMapping("/admin/promotion/deleteByIds/{ids}")
    public AjaxResult deletePromotionByIds(@PathVariable("ids") Long[] ids) {
        return AjaxResult.success(promotionService.deletePromotionByIds(ids));
    }

    // 通过id查询评价
    @GetMapping("/admin/promotion/detail")
    public AjaxResult selectPromotionById(@RequestBody Promotion promotion) {
        return AjaxResult.success(promotionService.selectPromotionById(promotion.getId()));
    }

    // 查询评价列表
    @GetMapping("/admin/promotion/page")
    public AjaxResult selectPromotionList(@RequestBody Promotion promotion) {
        return AjaxResult.success(promotionService.selectPromotionList(promotion));
    }


}
