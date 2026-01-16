package com.ruoyi.carsale.domain;



/*
 * 用户购车实体类
 */

import com.ruoyi.common.core.domain.BaseEntity;

public class CarsaleCarOrder extends BaseEntity {
    private Long id;
    private String projectName;
    private String projectHeader;
    private String startDate;
    private String endDate;
    private Integer status;
    private String introduction;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getProjectName() {
        return projectName;
    }

    public void setProjectName(String projectName) {
        this.projectName = projectName;
    }

    public String getProjectHeader() {
        return projectHeader;
    }

    public void setProjectHeader(String projectHeader) {
        this.projectHeader = projectHeader;
    }

    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public String getIntroduction() {
        return introduction;
    }

    public void setIntroduction(String introduction) {
        this.introduction = introduction;
    }
}
