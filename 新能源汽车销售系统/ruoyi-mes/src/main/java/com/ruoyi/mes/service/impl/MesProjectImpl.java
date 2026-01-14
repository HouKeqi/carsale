package com.ruoyi.mes.service.impl;


import com.ruoyi.mes.domain.MesProject;
import com.ruoyi.mes.mapper.MesProjectMapper;
import com.ruoyi.mes.service.IMesProjectService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Collections;
import java.util.List;

@Service
public class MesProjectImpl implements IMesProjectService {

    @Resource
    private MesProjectMapper mesProjectMapper;


    @Override
    public List<MesProject> selectMesProjectList(MesProject mesProject) {
        return mesProjectMapper.selectMesProjectList(mesProject);
    }

    @Override
    public int insertMesProject(MesProject mesProject) {
        return mesProjectMapper.insertMesProject(mesProject);
    }

    @Override
    public int updateMesProject(MesProject mesProject) {
        return mesProjectMapper.updateMesProject(mesProject);
    }

    @Override
    public int deleteMesProjectById(Long id) {
        return mesProjectMapper.deleteMesProjectById(id);
    }

    @Override
    public int deleteMesProjectByIds(Long[] ids) {
        return mesProjectMapper.deleteMesProjectByIds(ids);
    }

    @Override
    public MesProject selectMesProjectById(Long id) {
        return  mesProjectMapper.selectMesProjectById(id);
    }
}
