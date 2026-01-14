package com.ruoyi.platform.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.platform.mapper.PlatUserMapper;
import com.ruoyi.platform.domain.PlatUser;
import com.ruoyi.platform.service.IPlatUserService;

/**
 * 用户信息Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-07-03
 */
@Service
public class PlatUserServiceImpl implements IPlatUserService 
{
    @Autowired
    private PlatUserMapper platUserMapper;

    /**
     * 查询用户信息
     * 
     * @param id 用户信息主键
     * @return 用户信息
     */
    @Override
    public PlatUser selectPlatUserById(Long id)
    {
        return platUserMapper.selectPlatUserById(id);
    }

    /**
     * 查询用户信息列表
     * 
     * @param platUser 用户信息
     * @return 用户信息
     */
    @Override
    public List<PlatUser> selectPlatUserList(PlatUser platUser)
    {
        return platUserMapper.selectPlatUserList(platUser);
    }

    /**
     * 新增用户信息
     * 
     * @param platUser 用户信息
     * @return 结果
     */
    @Override
    public int insertPlatUser(PlatUser platUser)
    {
        return platUserMapper.insertPlatUser(platUser);
    }

    /**
     * 修改用户信息
     * 
     * @param platUser 用户信息
     * @return 结果
     */
    @Override
    public int updatePlatUser(PlatUser platUser)
    {
        return platUserMapper.updatePlatUser(platUser);
    }

    /**
     * 批量删除用户信息
     * 
     * @param ids 需要删除的用户信息主键
     * @return 结果
     */
    @Override
    public int deletePlatUserByIds(Long[] ids)
    {
        return platUserMapper.deletePlatUserByIds(ids);
    }

    /**
     * 删除用户信息信息
     * 
     * @param id 用户信息主键
     * @return 结果
     */
    @Override
    public int deletePlatUserById(Long id)
    {
        return platUserMapper.deletePlatUserById(id);
    }
}
