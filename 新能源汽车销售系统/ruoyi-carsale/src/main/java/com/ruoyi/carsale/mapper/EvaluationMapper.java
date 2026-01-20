package com.ruoyi.carsale.mapper;
import com.ruoyi.carsale.domain.Evaluation;

public interface EvaluationMapper {

    // 添加评价
    public int insertEvaluation(Evaluation evaluation);

    // 根据id删除评价
    public int deleteEvaluationById(Long id);
}
