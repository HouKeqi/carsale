package com.ruoyi.platform.service.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Objects;

import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.platform.domain.PlatPaper;
import com.ruoyi.platform.mapper.PlatPaperMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.platform.mapper.PlatSelectPaperMapper;
import com.ruoyi.platform.domain.PlatSelectPaper;
import com.ruoyi.platform.service.IPlatSelectPaperService;

/**
 * 学生选择的3个课题号Service业务层处理
 *
 * @author ruoyi
 * @date 2024-07-04
 */
@Service
public class PlatSelectPaperServiceImpl implements IPlatSelectPaperService
{
    @Autowired
    private PlatSelectPaperMapper platSelectPaperMapper;
    @Autowired
    private PlatPaperServiceImpl platPaperServiceImpl;


    /** 查询学生选择的3个课题的论文内容详情 */
    @Override
    public List<PlatPaper> getSelectPaperList() {
        Long userId = SecurityUtils.getUserId();
        PlatSelectPaper m_platSelectPaper = new PlatSelectPaper();
        List<PlatPaper> platPapersList = new ArrayList<>();

        if(platSelectPaperMapper.selectPlatSelectPaperByUserId(userId)!=null)
        {
            m_platSelectPaper = platSelectPaperMapper.selectPlatSelectPaperByUserId(userId);



            List<Long> paperIdList = new ArrayList<>();

            if(m_platSelectPaper.getSelectId1()!=null && m_platSelectPaper.getSelectId1()!=0){
                paperIdList.add(m_platSelectPaper.getSelectId1());
            }
            if(m_platSelectPaper.getSelectId2()!=null && m_platSelectPaper.getSelectId2()!=0){
                paperIdList.add(m_platSelectPaper.getSelectId2());
            }
            if(m_platSelectPaper.getSelectId3()!=null && m_platSelectPaper.getSelectId3()!=0){
                paperIdList.add(m_platSelectPaper.getSelectId3());
            }

            // 通过paperIdList查询出对应的论文内容
            for (Long paperId : paperIdList)
            {
                platPapersList.add(platPaperServiceImpl.selectPlatPaperById(paperId));
            }

        }

        return platPapersList;
    }

    /**
     * 查询学生选择的3个课题号列表
     *
     * @param platSelectPaper 学生选择的3个课题号
     * @return 学生选择的3个课题号
     */
    @Override
    public List<PlatSelectPaper> selectPlatSelectPaperList(PlatSelectPaper platSelectPaper)
    {
        return platSelectPaperMapper.selectPlatSelectPaperList(platSelectPaper);
    }

    /**
     * 新增学生选择的3个课题号
     *
     * @param platSelectPaper 学生选择的3个课题号
     * @return 结果
     */
    @Override
    public int insertPlatSelectPaper(PlatSelectPaper platSelectPaper)
    {
        return platSelectPaperMapper.insertPlatSelectPaper(platSelectPaper);
    }

    /**
     * 修改学生选择的3个课题号
     *
     * @param platSelectPaper 学生选择的3个课题号
     * @return 结果
     */
    @Override
    public int updatePlatSelectPaper(PlatSelectPaper platSelectPaper)
    {

        return platSelectPaperMapper.updatePlatSelectPaper(platSelectPaper);
    }

    /**
     * 批量删除学生选择的3个课题号
     *
     * @param ids 需要删除的学生选择的3个课题号主键
     * @return 结果
     */
    @Override
    public int deletePlatSelectPaperByIds(Long[] ids)
    {
        return platSelectPaperMapper.deletePlatSelectPaperByIds(ids);
    }

    /**
     * 删除学生选择的3个课题号信息
     *
     * @param id 学生选择的3个课题号主键
     * @return 结果
     */
    @Override
    public int deletePlatSelectPaperById(Long id)
    {
        return platSelectPaperMapper.deletePlatSelectPaperById(id);
    }

    /**
     * 根据userId查询学生选择的3个课题号
     * @param userId
     * @return
     */
    @Override
    public PlatSelectPaper selectPlatSelectPaperByUserId(Long userId) {
        return platSelectPaperMapper.selectPlatSelectPaperByUserId(userId);
    }

    /** 根据userId更新学生选择的3个课题号 */
    @Override
    public int updatePlatSelectPaperByUserId(PlatSelectPaper platSelectPaper) {
        return platSelectPaperMapper.updatePlatSelectPaperByUserId(platSelectPaper);

    }

    @Override
    public int selectPaper(PlatSelectPaper platSelectPaper) {

        List<Long> selectIdList = new ArrayList<>();
        if (platSelectPaper.getSelectId1() != null) {
            selectIdList.add(platSelectPaper.getSelectId1());
        }
        if (platSelectPaper.getSelectId2() != null) {
            selectIdList.add(platSelectPaper.getSelectId2());
        }
        if (platSelectPaper.getSelectId3() != null) {
            selectIdList.add(platSelectPaper.getSelectId3());
        }
        Long userId = SecurityUtils.getUserId();
        PlatSelectPaper m_platSelectPaper = new PlatSelectPaper();

        if(platSelectPaperMapper.selectPlatSelectPaperByUserId(userId)==null)
        {
            m_platSelectPaper.setUserId(userId);
        }
        else
        {
            m_platSelectPaper = platSelectPaperMapper.selectPlatSelectPaperByUserId(userId);
        }

        for (Long selectId : selectIdList)
        {
            if(m_platSelectPaper.getSelectId1()==null || m_platSelectPaper.getSelectId1()==0){
                m_platSelectPaper.setSelectId1(selectId);}
            else if(m_platSelectPaper.getSelectId2()==null || m_platSelectPaper.getSelectId2()==0){
                m_platSelectPaper.setSelectId2(selectId);}
            else if(m_platSelectPaper.getSelectId3()==null || m_platSelectPaper.getSelectId3()==0){
                m_platSelectPaper.setSelectId3(selectId);}
            else {throw new RuntimeException("所选课题超出3个");}
        }
        if(m_platSelectPaper.getId()==null)
        {
            return platSelectPaperMapper.insertPlatSelectPaper(m_platSelectPaper);
        }
        else
        {
            return platSelectPaperMapper.updatePlatSelectPaperByUserId(m_platSelectPaper);
        }
    }

    @Override
    public int deletePlatSelectPaperByPaperId(Long paperId) {
        Long userId = SecurityUtils.getUserId();

        if(platSelectPaperMapper.selectPlatSelectPaperByUserId(userId)==null)
        {
            throw new RuntimeException("未选择课题");
        }

        PlatSelectPaper m_platSelectPaper = platSelectPaperMapper.selectPlatSelectPaperByUserId(userId);

        if(Objects.equals(m_platSelectPaper.getSelectId1(), paperId)) { m_platSelectPaper.setSelectId1(0L); }
        else if(Objects.equals(m_platSelectPaper.getSelectId2(), paperId)) { m_platSelectPaper.setSelectId2(0L); }
        else if(Objects.equals(m_platSelectPaper.getSelectId3(), paperId)) { m_platSelectPaper.setSelectId3(0L); }
        else { throw new RuntimeException("未选择该课题"); }
        return platSelectPaperMapper.updatePlatSelectPaperByUserId(m_platSelectPaper);
    }




}
