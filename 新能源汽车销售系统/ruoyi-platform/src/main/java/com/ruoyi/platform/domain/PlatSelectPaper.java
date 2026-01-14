package com.ruoyi.platform.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 学生选择的3个课题号对象 plat_select_paper
 * 
 * @author ruoyi
 * @date 2024-07-04
 */
public class PlatSelectPaper extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** $column.columnComment */
    private Long id;

    /** 学生学号 */
    @Excel(name = "学生学号")
    private Long userId;

    /** 学生选择的论文id1 */
    @Excel(name = "学生选择的论文id1")
    private Long selectId1;

    /** 学生选择的论文id2 */
    @Excel(name = "学生选择的论文id2")
    private Long selectId2;

    /** 学生选择的论文id3 */
    @Excel(name = "学生选择的论文id3")
    private Long selectId3;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setUserId(Long userId) 
    {
        this.userId = userId;
    }

    public Long getUserId() 
    {
        return userId;
    }
    public void setSelectId1(Long selectId1) 
    {
        this.selectId1 = selectId1;
    }

    public Long getSelectId1() 
    {
        return selectId1;
    }
    public void setSelectId2(Long selectId2) 
    {
        this.selectId2 = selectId2;
    }

    public Long getSelectId2() 
    {
        return selectId2;
    }
    public void setSelectId3(Long selectId3) 
    {
        this.selectId3 = selectId3;
    }

    public Long getSelectId3() 
    {
        return selectId3;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("userId", getUserId())
            .append("selectId1", getSelectId1())
            .append("selectId2", getSelectId2())
            .append("selectId3", getSelectId3())
            .toString();
    }
}
