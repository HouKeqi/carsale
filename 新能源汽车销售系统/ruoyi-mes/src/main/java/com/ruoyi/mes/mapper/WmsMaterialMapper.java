package com.ruoyi.mes.mapper;

import java.util.List;
import com.ruoyi.mes.domain.WmsMaterial;

/**
 * 物料档案Mapper接口
 *
 * @author ruoyi
 * @date 2024-07-02
 */
public interface WmsMaterialMapper {


    /**
     * 查询物料档案列表
     *
     *
     * @return 物料档案集合
     */
    public List<WmsMaterial> selectWmsMaterialList();

}
