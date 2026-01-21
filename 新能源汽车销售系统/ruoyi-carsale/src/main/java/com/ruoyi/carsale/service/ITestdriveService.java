package com.ruoyi.carsale.service;
import com.ruoyi.carsale.domain.Testdrive;

import java.util.List;

public interface ITestdriveService {
    /* 新增用户试驾 */
    public int insertTestdrive(Testdrive testdrive);

    /* 修改用户试驾 */
    public int updateTestdrive(Testdrive testdrive);

    /* 删除用户试驾 */
    public int deleteTestdriveById(Long id);

    /* 批量删除用户试驾 */
    public int deleteTestdriveByIds(Long[] ids);

    /* 通过ID,查询用户试驾 */
    public Testdrive selectTestdriveById(Long id);

    /* 查询用户试驾列表 */
    public List<Testdrive> selectTestdriveList(Testdrive testdrive);
}
