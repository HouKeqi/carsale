package com.ruoyi.carsale.service;
import com.ruoyi.carsale.domain.Evaluation;
import java.util.List;

public interface IEvaluationService {

    // 添加评价
    public int insertEvaluation(Evaluation evaluation);

    // 通过ID,删除评价
    public int deleteEvaluationById(Long id);

    // 根据id查询评价
    public Evaluation selectEvaluationById(Long id);

    // 查询评价列表
    public List<Evaluation> selectEvaluationList(Evaluation evaluation);
}
