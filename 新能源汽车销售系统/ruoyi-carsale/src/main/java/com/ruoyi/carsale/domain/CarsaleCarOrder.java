package com.ruoyi.carsale.domain;



/*
 * 用户购车实体类
 */

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

public class CarsaleCarOrder extends BaseEntity {
    @Excel(name = "项目编号")
    private Long id;
    @Excel(name = "项目名称")
    private String projectName;
    @Excel(name = "项目负责人")
    private String projectHeader;
    @Excel(name = "开始时间")
    private String startDate;
    @Excel(name = "结束时间")
    private String endDate;
    @Excel(name = "项目介绍")
    private Integer status;
    @Excel(name = "项目介绍")
    private String introduce;

    public String getIntroduce() {
        return introduce;
    }

    public void setIntroduce(String introduce) {
        this.introduce = introduce;
    }

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
}
