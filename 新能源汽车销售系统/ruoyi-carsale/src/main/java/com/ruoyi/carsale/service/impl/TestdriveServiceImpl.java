package com.ruoyi.carsale.service.impl;

import com.ruoyi.carsale.domain.Testdrive;
import com.ruoyi.carsale.mapper.TestdriveMapper;
import com.ruoyi.carsale.service.ITestdriveService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TestdriveServiceImpl implements ITestdriveService {
    @Autowired
    private TestdriveMapper testdriveMapper;

    @Override
    public int insertTestdrive(Testdrive testdrive) {
        return testdriveMapper.insertTestdrive(testdrive);
    }

    @Override
    public int updateTestdrive(Testdrive testdrive) {
        return testdriveMapper.updateTestdrive(testdrive);
    }

    @Override
    public int deleteTestdriveById(Long id) {
        return testdriveMapper.deleteTestdriveById(id);
    }

    @Override
    public int deleteTestdriveByIds(Long[] ids) {
        return testdriveMapper.deleteTestdriveByIds(ids);
    }

    @Override
    public Testdrive selectTestdriveById(Long id) {
        return testdriveMapper.selectTestdriveById(id);
    }

    @Override
    public List<Testdrive> selectTestdriveList(Testdrive testdrive) {
        return testdriveMapper.selectTestdriveList(testdrive);
    }



}
