package com.ruoyi.platform.service.impl;

import java.util.ArrayList;
import java.util.List;

import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.platform.mapper.PlatUserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.platform.mapper.PlatPaperMapper;
import com.ruoyi.platform.domain.PlatPaper;
import com.ruoyi.platform.service.IPlatPaperService;

/**
 * 论文管理Service业务层处理
 *
 * @author ruoyi
 * @date 2024-07-03
 */
@Service
public class PlatPaperServiceImpl implements IPlatPaperService {
    @Autowired
    private PlatPaperMapper platPaperMapper;


    @Autowired
    private PlatUserMapper platUserMapper;

    /**
     * 查询论文管理
     *
     * @param id 论文管理主键
     * @return 论文管理
     */
    @Override
    public PlatPaper selectPlatPaperById(Long id) {
        return platPaperMapper.selectPlatPaperById(id);
    }

    /**
     * 查询论文管理列表
     *
     * @param platPaper 论文管理
     * @return 论文管理
     */
    @Override
    public List<PlatPaper> selectPlatPaperList(PlatPaper platPaper) {
        return platPaperMapper.selectPlatPaperList(platPaper);
    }

    /**
     * 新增论文管理
     *
     * @param platPaper 论文管理
     * @return 结果
     */
    @Override
    public int insertPlatPaper(PlatPaper platPaper) {
        return platPaperMapper.insertPlatPaper(platPaper);
    }

    /**
     * 修改论文管理
     *
     * @param platPaper 论文管理
     * @return 结果
     */
    @Override
    public int updatePlatPaper(PlatPaper platPaper) {
        return platPaperMapper.updatePlatPaper(platPaper);
    }

    /**
     * 批量删除论文管理
     *
     * @param ids 需要删除的论文管理主键
     * @return 结果
     */
    @Override
    public int deletePlatPaperByIds(Long[] ids) {
        return platPaperMapper.deletePlatPaperByIds(ids);
    }

    /**
     * 删除论文管理信息
     *
     * @param id 论文管理主键
     * @return 结果
     */
    @Override
    public int deletePlatPaperById(Long id) {
        return platPaperMapper.deletePlatPaperById(id);
    }


    /** 查找Bond="userID"的 Paper */
    @Override
    public List<PlatPaper> getSelectBondPaper() {

        Long userId = SecurityUtils.getUserId();
        String studentId = platPaperMapper.getStudentIdByUserId(userId);
        return platPaperMapper.getSelectBondPaper(studentId);
    }


    /**
     * 学生查询没有被自己选择的课题
     *
     * @param platPaper 论文管理
     * @return 论文管理
     */
    @Override
    public List<PlatPaper> UnselectPaperList(PlatPaper platPaper) {
        platPaper.setUserId(SecurityUtils.getUserId());
        return platPaperMapper.slectUnslectPaperList(platPaper);
    }

    /**
     * 教师查看选择了自己课题的课题 + 学生信息
     * 教师id--paperid---学生userid---学生信息
     */
    @Override
    public List<PlatPaper> getPaperManageForTeacher() {
        // 获取教师id
        Long userId = SecurityUtils.getUserId();

        // 根据教师ID，找到论文id
        return platPaperMapper.getPaperManageForTeacher(userId);
    }

    /** 老师审核学生选题，绑定 */
    @Override
    public int updatePaperManageBondInfoByTeacher(PlatPaper platPaper) {

        // 按照3:3:4的比例计算总成绩
        if (platPaper.getGradeInstruct() != null && platPaper.getGradeDefence() != null
                && platPaper.getGradeReview() != null)
        {
            platPaper.setGrade(String.valueOf(Double.parseDouble(platPaper.getGradeInstruct()) * 0.3 +
                            Double.parseDouble(platPaper.getGradeDefence()) * 0.3 +
                            Double.parseDouble(platPaper.getGradeReview()) * 0.4));
        }


        return platPaperMapper.updatePaperManageBondInfoByTeacher(platPaper);
    }

    @Override
    public List<PlatPaper> getGradeListForTeacher() {
        Long userId = SecurityUtils.getUserId();
        List<String> bondList = platPaperMapper.selectbondListByTeacherId(userId);

        List<PlatPaper> paperList = new ArrayList<>();

        PlatPaper paper = new PlatPaper();
        for(String bond : bondList)
        {
            String name = platUserMapper.getNameByStudentId(bond);

            paper = platPaperMapper.getBondPaperByStudentId(bond);

            paper.setName(name);

            paperList.add(paper);
        }

        return paperList;
    }

    @Override
    public PlatPaper getGradeListForStudent() {
        Long userId = SecurityUtils.getUserId();
        // 通过userId获得studentid
        String studentId = platPaperMapper.getStudentIdByUserId(userId);
        return platPaperMapper.getBondPaperByStudentId(studentId);
    }


}
