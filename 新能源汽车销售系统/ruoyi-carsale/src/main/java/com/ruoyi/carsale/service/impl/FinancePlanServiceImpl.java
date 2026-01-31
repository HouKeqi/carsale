package com.ruoyi.carsale.service.impl;

import com.ruoyi.carsale.domain.FinancePlan;
import com.ruoyi.carsale.mapper.FinancePlanMapper;
import com.ruoyi.carsale.service.IFinancePlanService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FinancePlanServiceImpl implements IFinancePlanService {
    @Autowired
    private FinancePlanMapper financePlanMapper;

    @Override
    public FinancePlan selectFinancePlanById(Long id) {
        return financePlanMapper.selectFinancePlanById(id);
    }

    @Override
    public List<FinancePlan> selectFinancePlanList(FinancePlan financePlan) {
        return financePlanMapper.selectFinancePlanList(financePlan);
    }

    @Override
    public int insertFinancePlan(FinancePlan financePlan) {
        return financePlanMapper.insertFinancePlan(financePlan);
    }

    @Override
    public int updateFinancePlan(FinancePlan financePlan) {
        return financePlanMapper.updateFinancePlan(financePlan);
    }

    @Override
    public int deleteFinancePlanByIds(Long[] ids) {
        return financePlanMapper.deleteFinancePlanByIds(ids);
    }

    @Override
    public int deleteFinancePlanById(Long id) {
        return financePlanMapper.deleteFinancePlanById(id);
    }
}
