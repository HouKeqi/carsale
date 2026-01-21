package com.ruoyi.web.controller.carsale;

import com.ruoyi.carsale.domain.Evaluation;
import com.ruoyi.carsale.service.impl.EvaluationServiceImpl;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/carsale")
public class EvaluationController extends BaseController{
    @Autowired
    private EvaluationServiceImpl evaluationService;

    // 添加评价
    @PostMapping("/evaluation/add")
    public AjaxResult addOrder(@RequestBody Evaluation evaluation) {
        return AjaxResult.success(evaluationService.insertEvaluation(evaluation));
    }

    // 根据id删除评价
    @PostMapping("/evaluation/delete")
    public AjaxResult deleteOrder(@RequestBody Evaluation evaluation) {
        return AjaxResult.success(evaluationService.deleteEvaluationById(evaluation.getId()));
    }


}