package com.ruoyi.mes.service;

import com.ruoyi.mes.domain.MesProject;

import java.util.List;

public interface IMesProjectService {

    /**
     * 查询项目列表
     * @param mesProject
     * @return
     */
    public List<MesProject> selectMesProjectList(MesProject mesProject);

    /**
     * 添加项目
     */
    public int insertMesProject(MesProject mesProject);

    /**
     * 修改项目
     */
    public int updateMesProject(MesProject mesProject);


    /**
     * 删除项目
     */
    public int deleteMesProjectById(Long id);

    /**
     * 批量删除项目
     */
    public int deleteMesProjectByIds(Long[] ids);

    /**
     * 根据id查询项目
     */
    public MesProject selectMesProjectById(Long id);


}
