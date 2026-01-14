package com.ruoyi.platform.service.impl;

import java.util.ArrayList;
import java.util.List;

import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.platform.domain.PlatUser;
import com.ruoyi.platform.mapper.PlatPaperMapper;
import com.ruoyi.platform.mapper.PlatUserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.platform.mapper.PlatOpeningMapper;
import com.ruoyi.platform.domain.PlatOpening;
import com.ruoyi.platform.service.IPlatOpeningService;

/**
 * 开题报告Service业务层处理
 *
 * @author ruoyi
 * @date 2024-07-06
 */
@Service
public class PlatOpeningServiceImpl implements IPlatOpeningService
{
    @Autowired
    private PlatOpeningMapper platOpeningMapper;

    @Autowired
    private PlatUserMapper platUserMapper;

    @Autowired
    private PlatPaperMapper platPaperMapper;



    /**
     * 查询开题报告
     *
     * @param id 开题报告主键
     * @return 开题报告
     */
    @Override
    public PlatOpening selectPlatOpeningById(Long id)
    {
        return platOpeningMapper.selectPlatOpeningById(id);
    }

    /**
     * 查询开题报告列表
     *
     * @param platOpening 开题报告
     * @return 开题报告
     */
    @Override
    public List<PlatOpening> selectPlatOpeningList(PlatOpening platOpening)
    {
        return platOpeningMapper.selectPlatOpeningList(platOpening);
    }

    /**
     * 新增开题报告
     *
     * @param platOpening 开题报告
     * @return 结果
     */
    @Override
    public int insertPlatOpening(PlatOpening platOpening)
    {
        Long userID = SecurityUtils.getUserId();
        // 通过userId找到userID
        PlatUser user = platUserMapper.selectPlatUserByUserId(userID);

        // 查询该学生是否已经上传过开题报告
        PlatOpening openingInfo = platOpeningMapper.selectPlatOpeningByStudentId(user.getStudentId());


        if(openingInfo == null)
        {
            platOpening.setName(user.getName());
            platOpening.setStudentId(user.getStudentId());
            platOpening.setStatus("未审核");
            return platOpeningMapper.insertPlatOpening(platOpening);
        }
        else
        {
            openingInfo.setOpening(platOpening.getOpening());
            openingInfo.setStatus("未审核");
            return platOpeningMapper.updatePlatOpening(openingInfo);

        }
    }

    /**
     * 修改开题报告
     *
     * @param platOpening 开题报告
     * @return 结果
     */
    @Override
    public int updatePlatOpening(PlatOpening platOpening)
    {
        return platOpeningMapper.updatePlatOpening(platOpening);
    }

    /**
     * 批量删除开题报告
     *
     * @param ids 需要删除的开题报告主键
     * @return 结果
     */
    @Override
    public int deletePlatOpeningByIds(Long[] ids)
    {
        return platOpeningMapper.deletePlatOpeningByIds(ids);
    }

    /**
     * 删除开题报告信息
     *
     * @param id 开题报告主键
     * @return 结果
     */
    @Override
    public int deletePlatOpeningById(Long id)
    {
        return platOpeningMapper.deletePlatOpeningById(id);
    }


    /** userID--strdentid--查询开题报告列表 */
    @Override
    public PlatOpening getOpeningPaperList(){
        Long userID = SecurityUtils.getUserId();
        // 通过userId找到user
        PlatUser user = platUserMapper.selectPlatUserByUserId(userID);
        // user--studentID--查询开题报告列表
        return platOpeningMapper.selectPlatOpeningByStudentId(user.getStudentId());
    }

    /** paper表中teacherid--bond(studentId)--opening表中studentId--查询开题报告列表 */
    public List<PlatOpening> getOpeningPaperListForTeacher(){
        Long userId = SecurityUtils.getUserId();
        List<String> bondList = platPaperMapper.selectbondListByTeacherId(userId);
        List<PlatOpening> openingList = new ArrayList<>();
        for (String bondId : bondList)
        {
            openingList.add(platOpeningMapper.selectPlatOpeningByStudentId(bondId));
        }
        return openingList;
    }


    /**
     * 修改开题报告,教师审核通过、不通过学生论文
     *
     * @param studentId 开题报告
     * @return 结果
     */
//    @Override
//    public int updatePaperUploadFromTeacher(String studentId)
//    {
//        return platOpeningMapper.updatePaperUploadFromTeacher(studentId);
//    }

}
