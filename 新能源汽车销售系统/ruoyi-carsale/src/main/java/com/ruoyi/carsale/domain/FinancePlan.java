package com.ruoyi.carsale.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

import java.math.BigDecimal;

public class FinancePlan extends BaseEntity {
    @Excel(name = "金融方案ID")
    private Long id;
    
    @Excel(name = "方案名称")
    private String name;
    
    @Excel(name = "首付比例")
    private BigDecimal downPaymentRate;
    
    @Excel(name = "分期期数")
    private Integer periods;
    
    @Excel(name = "年利率")
    private BigDecimal interestRate;
    
    @Excel(name = "状态")
    private Integer status;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public BigDecimal getDownPaymentRate() {
        return downPaymentRate;
    }

    public void setDownPaymentRate(BigDecimal downPaymentRate) {
        this.downPaymentRate = downPaymentRate;
    }

    public Integer getPeriods() {
        return periods;
    }

    public void setPeriods(Integer periods) {
        this.periods = periods;
    }

    public BigDecimal getInterestRate() {
        return interestRate;
    }

    public void setInterestRate(BigDecimal interestRate) {
        this.interestRate = interestRate;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }
}
