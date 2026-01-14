package com.ruoyi.web.controller.platform;

import java.util.List;
import javax.servlet.http.HttpServletResponse;

import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.utils.SecurityUtils;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.platform.domain.PlatPaper;
import com.ruoyi.platform.service.IPlatPaperService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 论文管理Controller
 *
 * @author ruoyi
 * @date 2024-07-03
 */
@RestController
@RequestMapping("/platform/paperManage")
public class PlatPaperController extends BaseController {
    @Autowired
    private IPlatPaperService platPaperService;

    /**
     * 查询论文管理列表
     */
//    @PreAuthorize("@ss.hasPermi('platform:topic:list')")
    @GetMapping("/list")
    public TableDataInfo list(PlatPaper platPaper) {
        startPage();
        Long userId = SecurityUtils.getLoginUser().getUser().getUserId();
        if (userId != 108) {
            platPaper.setTeacher_id(userId);
        }
        List<PlatPaper> list = platPaperService.selectPlatPaperList(platPaper);
        return getDataTable(list);
    }


    /**
     * 导出论文管理列表
     */
    @PreAuthorize("@ss.hasPermi('platform:topic:export')")
    @Log(title = "论文管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, PlatPaper platPaper) {
        List<PlatPaper> list = platPaperService.selectPlatPaperList(platPaper);
        ExcelUtil<PlatPaper> util = new ExcelUtil<PlatPaper>(PlatPaper.class);
        util.exportExcel(response, list, "论文管理数据");
    }

    /**
     * 获取论文管理详细信息
     */
    @PreAuthorize("@ss.hasPermi('platform:topic:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        return success(platPaperService.selectPlatPaperById(id));
    }

    /**
     * 新增论文管理
     */
    @PreAuthorize("@ss.hasPermi('platform:topic:add')")
    @Log(title = "论文管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody PlatPaper platPaper) {
        platPaper.setTeacher_id(SecurityUtils.getLoginUser().getUser().getUserId());
        platPaper.setTeacherName(SecurityUtils.getUsername());
        return toAjax(platPaperService.insertPlatPaper(platPaper));
    }

    /**
     * 修改论文管理
     */
//    @PreAuthorize("@ss.hasPermi('platform:topic:edit')")
    @Log(title = "论文管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody PlatPaper platPaper) {
        Long userId = SecurityUtils.getLoginUser().getUser().getUserId();
        if (userId != 108) {
            platPaper.setTeacher_id(userId);
            platPaper.setTeacherName(SecurityUtils.getUsername());
        }
        return toAjax(platPaperService.updatePlatPaper(platPaper));
    }

    /**
     * 删除论文管理
     */
    @PreAuthorize("@ss.hasPermi('platform:topic:remove')")
    @Log(title = "论文管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids) {
        return toAjax(platPaperService.deletePlatPaperByIds(ids));
    }


    /**
     * 查询学生已经和老师绑定了的课题
     */
    @PreAuthorize("@ss.hasPermi('platform:topicSelect:list')")
    @GetMapping("/getSelectBondPaper")
    public TableDataInfo getSelectBondPaper() {

        List<PlatPaper> list = platPaperService.getSelectBondPaper();
        return getDataTable(list);
    }

    /**
     * 学生查询没有被自己选择的课题
     */
    @PreAuthorize("@ss.hasPermi('platform:topicSelect:list')")
    @GetMapping("/UnselectPaperList")
    public TableDataInfo UnselectPaperList(PlatPaper platPaper) {
        startPage();
        List<PlatPaper> list = platPaperService.UnselectPaperList(platPaper);
        return getDataTable(list);
    }


    /**
     * 教师查看选择了自己课题的课题 + 学生信息
     * 教师id--paperid---学生userid---学生信息
     */
    @PreAuthorize("@ss.hasPermi('platform:topic:list')")
    @GetMapping("/getPaperManageForTeacher")
    public TableDataInfo getPaperManageForTeacher() {
        List<PlatPaper> list = platPaperService.getPaperManageForTeacher();
        return getDataTable(list);
    }


    /**
     * 老师审核学生选题，绑定
     */
//    @PreAuthorize("@ss.hasPermi('platform:topic:edit')")
    @Log(title = "论文管理", businessType = BusinessType.UPDATE)
    @PutMapping("/updatePaperManageBondInfoByTeacher")
    public AjaxResult updatePaperManageBondInfoByTeacher(@RequestBody PlatPaper platPaper) {
        return toAjax(platPaperService.updatePaperManageBondInfoByTeacher(platPaper));
    }

    /**
     * 查询论文管理列表
     */
//    @PreAuthorize("@ss.hasPermi('platform:topic:list')")
    @GetMapping("/getGradeListForTeacher")
    public TableDataInfo getGradeListForTeacher() {
        startPage();

        List<PlatPaper> list = platPaperService.getGradeListForTeacher();
        return getDataTable(list);
    }

    /**
     * 查询论文管理列表
     */
    @PreAuthorize("@ss.hasPermi('platform:gradeCheck:list')")
    @GetMapping("/getGradeListForStudent")
    public AjaxResult getGradeListForStudent() {

        return success(platPaperService.getGradeListForStudent());
    }

}

