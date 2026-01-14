package com.ruoyi.platform.service;

import java.util.List;

import com.ruoyi.platform.domain.PlatPaper;
import com.ruoyi.platform.domain.PlatSelectPaper;

/**
 * 学生选择的3个课题号Service接口
 *
 * @author ruoyi
 * @date 2024-07-04
 */
public interface IPlatSelectPaperService
{

    /** 查询学生选择的3个课题的论文内容详情 */
    public List<PlatPaper> getSelectPaperList();

    /**
     * 查询学生选择的3个课题号列表
     *
     * @param platSelectPaper 学生选择的3个课题号
     * @return 学生选择的3个课题号集合
     */
    public List<PlatSelectPaper> selectPlatSelectPaperList(PlatSelectPaper platSelectPaper);

    /**
     * 新增学生选择的3个课题号
     *
     * @param platSelectPaper 学生选择的3个课题号
     * @return 结果
     */
    public int insertPlatSelectPaper(PlatSelectPaper platSelectPaper);

    /**
     * 修改学生选择的3个课题号
     *
     * @param platSelectPaper 学生选择的3个课题号
     * @return 结果
     */
    public int updatePlatSelectPaper(PlatSelectPaper platSelectPaper);

    /**
     * 批量删除学生选择的3个课题号
     *
     * @param ids 需要删除的学生选择的3个课题号主键集合
     * @return 结果
     */
    public int deletePlatSelectPaperByIds(Long[] ids);

    /**
     * 删除学生选择的3个课题号信息
     *
     * @param id 学生选择的3个课题号主键
     * @return 结果
     */
    public int deletePlatSelectPaperById(Long id);

    /**
     * 根据userId查询学生选择的3个课题号
     * @param userId
     * @return
     */
    public PlatSelectPaper selectPlatSelectPaperByUserId(Long userId);

    /**
     * 根据userId更新学生选择的3个课题号
     */
    public int updatePlatSelectPaperByUserId(PlatSelectPaper platSelectPaper);

    /** 学生选择的3个课题号 */
    public int selectPaper(PlatSelectPaper platSelectPaper);


    /** 根据paperId删除选择的课题 */
    public int deletePlatSelectPaperByPaperId(Long paperId);




}
