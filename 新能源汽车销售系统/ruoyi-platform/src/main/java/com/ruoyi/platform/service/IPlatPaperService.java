package com.ruoyi.platform.service;

import java.util.List;
import com.ruoyi.platform.domain.PlatPaper;

/**
 * 论文管理Service接口
 *
 * @author ruoyi
 * @date 2024-07-03
 */
public interface IPlatPaperService
{
    /**
     * 查询论文管理
     *
     * @param id 论文管理主键
     * @return 论文管理
     */
    public PlatPaper selectPlatPaperById(Long id);

    /**
     * 查询论文管理列表
     *
     * @param platPaper 论文管理
     * @return 论文管理集合
     */
    public List<PlatPaper> selectPlatPaperList(PlatPaper platPaper);

    /**
     * 新增论文管理
     *
     * @param platPaper 论文管理
     * @return 结果
     */
    public int insertPlatPaper(PlatPaper platPaper);

    /**
     * 修改论文管理
     *
     * @param platPaper 论文管理
     * @return 结果
     */
    public int updatePlatPaper(PlatPaper platPaper);


    /**
     * 批量删除论文管理
     *
     * @param ids 需要删除的论文管理主键集合
     * @return 结果
     */
    public int deletePlatPaperByIds(Long[] ids);

    /**
     * 删除论文管理信息
     *
     * @param id 论文管理主键
     * @return 结果
     */
    public int deletePlatPaperById(Long id);

    /** 查找Bond="userID"的 Paper */
    public List<PlatPaper> getSelectBondPaper();



    /**
     * 学生查询没有被自己选择的课题
     *
     * @param platPaper 论文管理
     * @return 论文管理集合
     */
    public List<PlatPaper> UnselectPaperList(PlatPaper platPaper);

    /**
     * 教师查看选择了自己课题的课题 + 学生信息
     * 教师id--paperid---学生userid---学生信息
     */
    public List<PlatPaper> getPaperManageForTeacher();




    /**
     * 老师审核学生选题，绑定
     *
     * @param platPaper 论文管理
     * @return 结果
     */
    public int updatePaperManageBondInfoByTeacher(PlatPaper platPaper);



    public List<PlatPaper> getGradeListForTeacher();


    public PlatPaper getGradeListForStudent();


}
