package com.ruoyi.platform.service;

import java.util.List;
import com.ruoyi.platform.domain.PlatUser;

/**
 * 用户信息Service接口
 * 
 * @author ruoyi
 * @date 2024-07-03
 */
public interface IPlatUserService 
{
    /**
     * 查询用户信息
     * 
     * @param id 用户信息主键
     * @return 用户信息
     */
    public PlatUser selectPlatUserById(Long id);

    /**
     * 查询用户信息列表
     * 
     * @param platUser 用户信息
     * @return 用户信息集合
     */
    public List<PlatUser> selectPlatUserList(PlatUser platUser);

    /**
     * 新增用户信息
     * 
     * @param platUser 用户信息
     * @return 结果
     */
    public int insertPlatUser(PlatUser platUser);

    /**
     * 修改用户信息
     * 
     * @param platUser 用户信息
     * @return 结果
     */
    public int updatePlatUser(PlatUser platUser);

    /**
     * 批量删除用户信息
     * 
     * @param ids 需要删除的用户信息主键集合
     * @return 结果
     */
    public int deletePlatUserByIds(Long[] ids);

    /**
     * 删除用户信息信息
     * 
     * @param id 用户信息主键
     * @return 结果
     */
    public int deletePlatUserById(Long id);
}
