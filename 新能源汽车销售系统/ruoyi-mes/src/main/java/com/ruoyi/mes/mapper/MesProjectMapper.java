package com.ruoyi.mes.mapper;

// 项目维护Mapper接口

import com.ruoyi.mes.domain.MesProject;

import java.util.List;

public interface MesProjectMapper {

    /**
     * 查询项目维护列表
     * @param mesProject
     * @return
     */
    public List<MesProject> selectMesProjectList(MesProject mesProject);

    /**
     * 新增项目维护
     *
     */
    public int insertMesProject(MesProject mesProject);

    /**
     * 修改项目维护
     *
     */
    public int updateMesProject(MesProject mesProject);

    /**
     * 删除项目维护
     *
     */
    public int deleteMesProjectById(Long id);

    /**
     * 批量删除项目维护
     *
     */
    public int deleteMesProjectByIds(Long[] ids);

    /**
     * 根据id查询项目维护
     */
    public MesProject selectMesProjectById(Long id);



}
