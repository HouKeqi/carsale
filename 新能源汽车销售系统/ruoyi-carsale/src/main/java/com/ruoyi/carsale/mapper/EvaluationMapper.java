package com.ruoyi.carsale.mapper;
import com.ruoyi.carsale.domain.Evaluation;
import java.util.List;

public interface EvaluationMapper {

    // 添加评价
    public int insertEvaluation(Evaluation evaluation);

    // 根据id删除评价
    public int deleteEvaluationById(Long id);

    // 根据id查询评价
    public Evaluation selectEvaluationById(Long id);

    // 查询评价列表
    public List<Evaluation> selectEvaluationList(Evaluation evaluation);
}
