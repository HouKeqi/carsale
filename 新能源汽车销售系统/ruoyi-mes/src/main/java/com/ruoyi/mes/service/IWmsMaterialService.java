package com.ruoyi.mes.service;

import java.util.List;
import com.ruoyi.mes.domain.WmsMaterial;

/**
 * 物料档案Service接口
 *
 * @author ruoyi
 * @date 2024-07-02
 */
public interface IWmsMaterialService
{

    /**
     * 查询物料档案列表
     *
     *
     * @return 物料档案集合
     */
    public List<WmsMaterial> selectWmsMaterialList();

}
