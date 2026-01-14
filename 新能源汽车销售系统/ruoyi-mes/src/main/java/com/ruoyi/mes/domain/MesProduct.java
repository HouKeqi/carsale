package com.ruoyi.mes.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 产品建模对象 mes_product
 * 
 * @author ruoyi
 * @date 2024-07-02
 */
public class MesProduct extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 模型编号 */
    @Excel(name = "模型编号")
    private Long id;

    /** 模型名称 */
    @Excel(name = "模型名称")
    private String modeName;

    /** 产品ID */
    @Excel(name = "产品ID")
    private Long materialId;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setModeName(String modeName) 
    {
        this.modeName = modeName;
    }

    public String getModeName() 
    {
        return modeName;
    }
    public void setMaterialId(Long materialId) 
    {
        this.materialId = materialId;
    }

    public Long getMaterialId() 
    {
        return materialId;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("modeName", getModeName())
            .append("materialId", getMaterialId())
            .append("remark", getRemark())
            .toString();
    }
}
