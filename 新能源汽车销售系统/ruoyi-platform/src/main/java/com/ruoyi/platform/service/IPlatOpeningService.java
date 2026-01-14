package com.ruoyi.platform.service;

import java.util.List;
import com.ruoyi.platform.domain.PlatOpening;

/**
 * 开题报告Service接口
 *
 * @author ruoyi
 * @date 2024-07-06
 */
public interface IPlatOpeningService
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
     * 批量删除开题报告
     *
     * @param ids 需要删除的开题报告主键集合
     * @return 结果
     */
    public int deletePlatOpeningByIds(Long[] ids);

    /**
     * 删除开题报告信息
     *
     * @param id 开题报告主键
     * @return 结果
     */
    public int deletePlatOpeningById(Long id);

    /** userID--strdentid--查询开题报告列表 */
    public PlatOpening getOpeningPaperList();


    /** paper表中teacherid--bond(studentId)--opening表中studentId--查询开题报告列表 */
    public List<PlatOpening> getOpeningPaperListForTeacher();

     /** 修改开题报告,教师审核通过、不通过学生论文   studentId-->status */
//    public int updatePaperUploadFromTeacher(String studentId);

}
