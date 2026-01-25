package com.ruoyi.web.controller.carsale;

import com.ruoyi.carsale.domain.Evaluation;
import com.ruoyi.carsale.domain.Orders;
import com.ruoyi.carsale.service.IEvaluationService;
import com.ruoyi.carsale.service.IOrdersService;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 评价管理Controller
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/carsale")
public class EvaluationController extends BaseController {
    @Autowired
    private IEvaluationService evaluationService;
    
    @Autowired
    private IOrdersService ordersService;

    /**
     * 普通用户创建评价
     */
    @PreAuthorize("@ss.hasRole('customer')")
    @PostMapping("/evaluation/create")
    @Log(title = "评价管理", businessType = BusinessType.INSERT)
    public AjaxResult addEvaluation(@RequestBody Evaluation evaluation) {
        // 验证订单是否存在且属于当前用户
        Orders order = ordersService.selectOrdersById(evaluation.getOrderId());
        if (order == null) {
            return AjaxResult.error("订单不存在");
        }
        if (!order.getUserId().equals(getUserId())) {
            return AjaxResult.error("无权评价该订单");
        }
        // 验证订单状态是否为已完成（status=3）
        if (order.getStatus() == null || order.getStatus() != 3) {
            return AjaxResult.error("只能对已完成的订单进行评价");
        }
        // 检查是否已经评价过
        Evaluation existEval = new Evaluation();
        existEval.setOrderId(evaluation.getOrderId());
        List<Evaluation> existList = evaluationService.selectEvaluationList(existEval);
        if (existList != null && !existList.isEmpty()) {
            return AjaxResult.error("该订单已评价，不能重复评价");
        }
        // 设置用户ID和车辆ID
        evaluation.setUserId(getUserId());
        if (evaluation.getVehicleId() == null) {
            evaluation.setVehicleId(order.getVehicleId());
        }
        return toAjax(evaluationService.insertEvaluation(evaluation));
    }

    /**
     * 普通用户查看我的评价列表
     */
    @PreAuthorize("@ss.hasRole('customer')")
    @GetMapping("/evaluation/my/list")
    public TableDataInfo getMyEvaluationList(Evaluation evaluation) {
        startPage();
        // 只查询当前用户的评价
        evaluation.setUserId(getUserId());
        List<Evaluation> list = evaluationService.selectEvaluationList(evaluation);
        return getDataTable(list);
    }

    /**
     * 根据车辆ID查询评价列表（公开接口）
     */
    @GetMapping("/evaluation/vehicle/{vehicleId}")
    public TableDataInfo getVehicleEvaluationList(@PathVariable("vehicleId") Long vehicleId) {
        startPage();
        Evaluation evaluation = new Evaluation();
        evaluation.setVehicleId(vehicleId);
        List<Evaluation> list = evaluationService.selectEvaluationList(evaluation);
        return getDataTable(list);
    }

    /**
     * 根据id删除评价
     */
    @PreAuthorize("@ss.hasRole('customer')")
    @DeleteMapping("/evaluation/delete/{id}")
    @Log(title = "评价管理", businessType = BusinessType.DELETE)
    public AjaxResult deleteEvaluation(@PathVariable("id") Long id) {
        Evaluation evaluation = evaluationService.selectEvaluationById(id);
        if (evaluation == null) {
            return AjaxResult.error("评价不存在");
        }
        // 验证评价是否属于当前用户
        if (!evaluation.getUserId().equals(getUserId())) {
            return AjaxResult.error("无权删除该评价");
        }
        return toAjax(evaluationService.deleteEvaluationById(id));
    }
}
