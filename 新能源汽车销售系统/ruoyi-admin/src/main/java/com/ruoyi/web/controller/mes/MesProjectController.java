package com.ruoyi.web.controller.mes;


import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.mes.domain.MesProject;
import com.ruoyi.mes.service.IMesProjectService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

// 生产项目维护
@RestController
@RequestMapping("/mes/project")
public class MesProjectController extends BaseController {

    @Resource
    private IMesProjectService mesProjectService;

    /** 查询项目列表 */
    @GetMapping
    public TableDataInfo getMesProjectList(MesProject mesProject){
        // 开启分页
        super.startPage();
        List<MesProject> list = mesProjectService.selectMesProjectList(mesProject);
        return super.getDataTable(list);
    }

    /**
     * 新增项目
     */
    @PostMapping
    public AjaxResult addMesProject(@RequestBody MesProject mesProject){
        return AjaxResult.success(mesProjectService.insertMesProject(mesProject));
    }

    /**
     * 修改项目
     */
    @PutMapping
    public AjaxResult edit(@RequestBody MesProject mesProject){
        return AjaxResult.success(mesProjectService.updateMesProject(mesProject));
    }

    /**
     * 查询项目
     */
    @GetMapping("/{id}")
    public AjaxResult getMesProjectById(@PathVariable("id") Long id){
        return AjaxResult.success(mesProjectService.selectMesProjectById(id));
    }

    /**
     * 删除项目
     */
    @DeleteMapping("/{ids}")
    public AjaxResult delete(@PathVariable("ids") Long[] ids){
        return toAjax(mesProjectService.deleteMesProjectByIds(ids));
    }


    /** 导出项目列表 */
    /** 查询项目列表 */
    @PostMapping("/export")
    public void export(MesProject mesProject, HttpServletResponse response){
        // 先查列表, 即需要导出的数据
        List<MesProject> mesProjects = mesProjectService.selectMesProjectList(mesProject);

        ExcelUtil<MesProject> excelUtil = new ExcelUtil<>(MesProject.class);
        excelUtil.exportExcel(response,mesProjects, "项目维护列表");

    }


}
