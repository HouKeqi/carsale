package com.ruoyi.mes.service.impl;

import java.util.List;

import com.ruoyi.mes.domain.vo.MesProductVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.mes.mapper.MesProductMapper;
import com.ruoyi.mes.domain.MesProduct;
import com.ruoyi.mes.service.IMesProductService;

/**
 * 产品建模Service业务层处理
 *
 * @author ruoyi
 * @date 2024-07-02
 */
@Service
public class MesProductServiceImpl implements IMesProductService
{
    @Autowired
    private MesProductMapper mesProductMapper;

    /**
     * 查询产品建模
     *
     * @param id 产品建模主键
     * @return 产品建模
     */
    @Override
    public MesProduct selectMesProductById(Long id)
    {
        return mesProductMapper.selectMesProductById(id);
    }

    /**
     * 查询产品建模列表
     *
     * @param mesProduct 产品建模
     * @return 产品建模
     */
    @Override
    public List<MesProductVo> selectMesProductList(MesProduct mesProduct)
    {
        return mesProductMapper.selectMesProductList(mesProduct);
    }

    /**
     * 新增产品建模
     *
     * @param mesProduct 产品建模
     * @return 结果
     */
    @Override
    public int insertMesProduct(MesProduct mesProduct)
    {
        return mesProductMapper.insertMesProduct(mesProduct);
    }

    /**
     * 修改产品建模
     *
     * @param mesProduct 产品建模
     * @return 结果
     */
    @Override
    public int updateMesProduct(MesProduct mesProduct)
    {
        return mesProductMapper.updateMesProduct(mesProduct);
    }

    /**
     * 批量删除产品建模
     *
     * @param ids 需要删除的产品建模主键
     * @return 结果
     */
    @Override
    public int deleteMesProductByIds(Long[] ids)
    {
        return mesProductMapper.deleteMesProductByIds(ids);
    }

    /**
     * 删除产品建模信息
     *
     * @param id 产品建模主键
     * @return 结果
     */
    @Override
    public int deleteMesProductById(Long id)
    {
        return mesProductMapper.deleteMesProductById(id);
    }
}
