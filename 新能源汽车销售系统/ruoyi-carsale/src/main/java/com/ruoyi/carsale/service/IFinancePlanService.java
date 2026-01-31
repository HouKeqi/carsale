package com.ruoyi.carsale.service;

import com.ruoyi.carsale.domain.FinancePlan;
import java.util.List;

public interface IFinancePlanService {
    /**
     * 查询金融方案
     */
    FinancePlan selectFinancePlanById(Long id);

    /**
     * 查询金融方案列表
     */
    List<FinancePlan> selectFinancePlanList(FinancePlan financePlan);

    /**
     * 新增金融方案
     */
    int insertFinancePlan(FinancePlan financePlan);

    /**
     * 修改金融方案
     */
    int updateFinancePlan(FinancePlan financePlan);

    /**
     * 批量删除金融方案
     */
    int deleteFinancePlanByIds(Long[] ids);

    /**
     * 删除金融方案信息
     */
    int deleteFinancePlanById(Long id);
}
