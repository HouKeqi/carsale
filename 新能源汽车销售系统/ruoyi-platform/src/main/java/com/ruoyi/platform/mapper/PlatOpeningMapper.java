package com.ruoyi.platform.mapper;

import java.util.List;
import com.ruoyi.platform.domain.PlatOpening;

/**
 * 开题报告Mapper接口
 *
 * @author ruoyi
 * @date 2024-07-06
 */
public interface PlatOpeningMapper
{
    /**
     * 查询开题报告
     *
     * @param id 开题报告主键
     * @return 开题报告
     */
    public PlatOpening selectPlatOpeningById(Long id);

    /**
     * 查询开题报告列表
     *
     * @param platOpening 开题报告
     * @return 开题报告集合
     */
    public List<PlatOpening> selectPlatOpeningList(PlatOpening platOpening);

    /**
     * 新增开题报告
     *
     * @param platOpening 开题报告
     * @return 结果
     */
    public int insertPlatOpening(PlatOpening platOpening);

    /**
     * 修改开题报告
     *
     * @param platOpening 开题报告
     * @return 结果
     */
    public int updatePlatOpening(PlatOpening platOpening);

    /**
     * 删除开题报告
     *
     * @param id 开题报告主键
     * @return 结果
     */
    public int deletePlatOpeningById(Long id);

    /**
     * 批量删除开题报告
     *
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deletePlatOpeningByIds(Long[] ids);

    /** 通过学生ID查询论文 */
    public PlatOpening selectPlatOpeningByStudentId(String studentId);
}
