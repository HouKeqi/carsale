package com.ruoyi.carsale.mapper;

import com.ruoyi.carsale.domain.Testdrive;

import java.util.List;

public interface TestdriveMapper {
    /*  查询预约列表   */
    public List<Testdrive> selectTestdriveList(Testdrive  testdrive);

    /*  通过ID,查询预约   */
    public Testdrive selectTestdriveById(Long id);

    /*  新增预约   */
    public int insertTestdrive(Testdrive  testdrive);

    /*  修改预约   */
    public int updateTestdrive(Testdrive testdrive);

    /*  通过ID,删除预约   */
    public int deleteTestdriveById(Long id);

    /*  通过ID,批量删除预约   */
    public int deleteTestdriveByIds(Long[] ids);
}
