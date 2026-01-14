package com.ruoyi.web.controller.platform;

import java.util.List;
import javax.servlet.http.HttpServletResponse;

import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.platform.domain.PlatPaper;
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
import com.ruoyi.platform.domain.PlatSelectPaper;
import com.ruoyi.platform.service.IPlatSelectPaperService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 学生选择的3个课题号Controller
 *
 * @author ruoyi
 * @date 2024-07-04
 */
@RestController
@RequestMapping("/platform/selectPaper")
public class PlatSelectPaperController extends BaseController
{
    @Autowired
    private IPlatSelectPaperService platSelectPaperService;

    /**
     * 查询学生选择的3个课题号列表
     */
    @PreAuthorize("@ss.hasPermi('platform:topicSelect:list')")
    @GetMapping("/list")
    public TableDataInfo list(PlatSelectPaper platSelectPaper)
    {
        startPage();
        List<PlatSelectPaper> list = platSelectPaperService.selectPlatSelectPaperList(platSelectPaper);
        return getDataTable(list);
    }

    /**
     * 导出学生选择的3个课题号列表
     */
    @PreAuthorize("@ss.hasPermi('platform:topicSelect:export')")
    @Log(title = "学生选择的3个课题号", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, PlatSelectPaper platSelectPaper)
    {
        List<PlatSelectPaper> list = platSelectPaperService.selectPlatSelectPaperList(platSelectPaper);
        ExcelUtil<PlatSelectPaper> util = new ExcelUtil<PlatSelectPaper>(PlatSelectPaper.class);
        util.exportExcel(response, list, "学生选择的3个课题号数据");
    }

    /**
     * 查询学生选择的3个课题的论文内容详情
     */
    @PreAuthorize("@ss.hasPermi('platform:topicSelect:list')")
    @GetMapping("/getSelectPaperList")
    public TableDataInfo getSelectPaperList()
    {
        List<PlatPaper> list = platSelectPaperService.getSelectPaperList();
        return getDataTable(list);
    }



    /**
     * 获取学生选择的3个课题号详细信息
     */
    @PreAuthorize("@ss.hasPermi('platform:topicSelect:query')")
    @GetMapping(value = "/{userId}")
    public AjaxResult getInfoByUserId(@PathVariable("userId") Long userId)
    {
        return success(platSelectPaperService.selectPlatSelectPaperByUserId(userId));
    }

    /**
     * 新增学生选择的3个课题号
     */
    @PreAuthorize("@ss.hasPermi('platform:topicSelect:add')")
    @Log(title = "学生选择的3个课题号", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody PlatSelectPaper platSelectPaper)
    {
//        Long m_userId = platSelectPaper.getUserId();
//
//        PlatSelectPaper m_platSelectPaper = platSelectPaperService.selectPlatSelectPaperByUserId(m_userId);
//        Long m_selectId1 = m_platSelectPaper.getSelectId1();
//        Long m_selectId2 = m_platSelectPaper.getSelectId2();
//        Long m_selectId3 = m_platSelectPaper.getSelectId3();
//
//        if(m_selectId1 == null && m_selectId2 == null && m_selectId3 == null)
//            return toAjax(platSelectPaperService.insertPlatSelectPaper(platSelectPaper));
//        else
//            return toAjax(platSelectPaperService.updatePlatSelectPaperByUserId(platSelectPaper));
        return toAjax(platSelectPaperService.insertPlatSelectPaper(platSelectPaper));
    }

    /**
     * 修改学生选择的3个课题号
     */
    @PreAuthorize("@ss.hasPermi('platform:topicSelect:edit')")
    @Log(title = "学生选择的3个课题号", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody PlatSelectPaper platSelectPaper)
    {
        return toAjax(platSelectPaperService.updatePlatSelectPaper(platSelectPaper));
    }

    /**
     * 删除学生选择的3个课题号
     */
    @PreAuthorize("@ss.hasPermi('platform:topicSelect:remove')")
    @Log(title = "学生选择的3个课题号", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(platSelectPaperService.deletePlatSelectPaperByIds(ids));
    }

    /**
     * 根据userId更新学生选择的3个课题号
     */
    @PreAuthorize("@ss.hasPermi('platform:topicSelect:edit')")
    @Log(title = "学生选择的3个课题号", businessType = BusinessType.UPDATE)
    @PutMapping("/updateByUserId")
    public AjaxResult updateByUserId(@RequestBody PlatSelectPaper platSelectPaper)
    {
        return toAjax(platSelectPaperService.updatePlatSelectPaperByUserId(platSelectPaper));
    }

    /**
     * 批量选择课题
     */
    @PreAuthorize("@ss.hasPermi('platform:topicSelect:edit')")
    @Log(title = "学生选择的3个课题号", businessType = BusinessType.UPDATE)
    @PutMapping("/selectPaper")
    public AjaxResult selectPaper(@RequestBody PlatSelectPaper platSelectPaper)
    {

        return toAjax(platSelectPaperService.selectPaper(platSelectPaper));
    }


    /**
     * 根据选择的paperID，删除学生选择的课题号
     */
    @PreAuthorize("@ss.hasPermi('platform:topicSelect:remove')")
    @Log(title = "学生选择的3个课题号", businessType = BusinessType.DELETE)
    @DeleteMapping("/delSelectPaperByPaperId/{paperId}")
    public AjaxResult delSelectPaperByPaperId(@PathVariable Long paperId)
    {
        return toAjax(platSelectPaperService.deletePlatSelectPaperByPaperId(paperId));
    }


}
