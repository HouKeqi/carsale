package com.ruoyi.mes.mapper;

import java.util.List;
import com.ruoyi.mes.domain.MesProduct;
import com.ruoyi.mes.domain.vo.MesProductVo;

/**
 * 产品建模Mapper接口
 *
 * @author ruoyi
 * @date 2024-07-02
 */
public interface MesProductMapper
{
    /**
     * 查询产品建模
     *
     * @param id 产品建模主键
     * @return 产品建模
     */
    public MesProduct selectMesProductById(Long id);

    /**
     * 查询产品建模列表
     *
     * @param mesProduct 产品建模
     * @return 产品建模集合
     */
    public List<MesProductVo> selectMesProductList(MesProduct mesProduct);

    /**
     * 新增产品建模
     *
     * @param mesProduct 产品建模
     * @return 结果
     */
    public int insertMesProduct(MesProduct mesProduct);

    /**
     * 修改产品建模
     *
     * @param mesProduct 产品建模
     * @return 结果
     */
    public int updateMesProduct(MesProduct mesProduct);

    /**
     * 删除产品建模
     *
     * @param id 产品建模主键
     * @return 结果
     */
    public int deleteMesProductById(Long id);

    /**
     * 批量删除产品建模
     *
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteMesProductByIds(Long[] ids);
}
