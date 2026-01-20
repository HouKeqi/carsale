package com.ruoyi.carsale.service.impl;

import com.ruoyi.carsale.domain.Evaluation;
import com.ruoyi.carsale.mapper.EvaluationMapper;
import com.ruoyi.carsale.service.IEvaluationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class EvaluationServiceImpl implements IEvaluationService {

    @Autowired
    private EvaluationMapper evaluationMapper;

    @Override
    public int insertEvaluation(Evaluation evaluation) {
        return evaluationMapper.insertEvaluation(evaluation);
    }

    @Override
    public int deleteEvaluationById(Long id) {
        return evaluationMapper.deleteEvaluationById(id);
    }
}
