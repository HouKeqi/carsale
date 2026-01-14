package com.ruoyi.mes.service.impl;

import java.util.Collections;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.mes.mapper.WmsMaterialMapper;
import com.ruoyi.mes.domain.WmsMaterial;
import com.ruoyi.mes.service.IWmsMaterialService;

import javax.annotation.Resource;

/**
 * 物料档案Service业务层处理
 *
 * @author ruoyi
 * @date 2024-07-02
 */
@Service
public class WmsMaterialServiceImpl implements IWmsMaterialService
{
    @Resource
    private WmsMaterialMapper wmsMaterialMapper;

    /**
     * 查询物料表
     * @return
     */
    @Override
    public List<WmsMaterial> selectWmsMaterialList() {
        return wmsMaterialMapper.selectWmsMaterialList();
    }
}
