package com.ruoyi.carsale.service;
import com.ruoyi.carsale.domain.Evaluation;


public interface IEvaluationService {

    // 添加评价
    public int insertEvaluation(Evaluation evaluation);

    // 通过ID,删除评价
    public int deleteEvaluationById(Long id);

}
