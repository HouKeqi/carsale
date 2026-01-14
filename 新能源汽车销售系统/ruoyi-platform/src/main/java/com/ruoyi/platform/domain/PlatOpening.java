package com.ruoyi.platform.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 开题报告对象 plat_opening
 *
 * @author ruoyi
 * @date 2024-07-06
 */
public class PlatOpening extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键ID */
    private Long id;

    /** 开题报告 */
    @Excel(name = "开题报告")
    private String opening;

    /** 状态 */
    @Excel(name = "状态")
    private String status;

    /** 提交者姓名 */
    @Excel(name = "提交者姓名")
    private String name;

    /** 提交者学号 */
    @Excel(name = "提交者学号")
    private String studentId;

    public void setId(Long id)
    {
        this.id = id;
    }

    public Long getId()
    {
        return id;
    }
    public void setOpening(String opening)
    {
        this.opening = opening;
    }

    public String getOpening()
    {
        return opening;
    }
    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getStatus()
    {
        return status;
    }
    public void setName(String name)
    {
        this.name = name;
    }

    public String getName()
    {
        return name;
    }
    public void setStudentId(String studentId)
    {
        this.studentId = studentId;
    }

    public String getStudentId()
    {
        return studentId;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("opening", getOpening())
            .append("status", getStatus())
            .append("name", getName())
            .append("studentId", getStudentId())
            .toString();
    }
}
