package com.ruoyi.web.controller.platform;

import java.util.List;
import javax.servlet.http.HttpServletResponse;
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
import com.ruoyi.platform.domain.PlatOpening;
import com.ruoyi.platform.service.IPlatOpeningService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 开题报告Controller
 *
 * @author ruoyi
 * @date 2024-07-06
 */
@RestController
@RequestMapping("/platform/paperUpload")
public class PlatOpeningController extends BaseController
{
    @Autowired
    private IPlatOpeningService platOpeningService;

    /**
     * 查询开题报告列表
     */
    @PreAuthorize("@ss.hasPermi('platform:paperUpload:list')")
    @GetMapping("/list")
    public TableDataInfo list(PlatOpening platOpening)
    {
        startPage();
        List<PlatOpening> list = platOpeningService.selectPlatOpeningList(platOpening);
        return getDataTable(list);
    }




    /**
     * 新增开题报告
     */
    @PreAuthorize("@ss.hasPermi('platform:paperUpload:add')")
    @Log(title = "开题报告", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody PlatOpening platOpening)
    {
        return toAjax(platOpeningService.insertPlatOpening(platOpening));
    }

    /**
     * 修改开题报告
     */
//    @PreAuthorize("@ss.hasPermi('platform:paperUpload:edit')")
    @Log(title = "开题报告", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody PlatOpening platOpening)
    {
        return toAjax(platOpeningService.updatePlatOpening(platOpening));
    }

    /**
     * 删除开题报告
     */
    @PreAuthorize("@ss.hasPermi('platform:paperUpload:remove')")
    @Log(title = "开题报告", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(platOpeningService.deletePlatOpeningByIds(ids));
    }

    /**
     * userID--strdentid--查询开题报告列表
     */
    @PreAuthorize("@ss.hasPermi('platform:paperUpload:list')")
    @GetMapping("/getOpeningPaperList")
    public AjaxResult getOpeningPaperList()
    {
        return success(platOpeningService.getOpeningPaperList());
    }

    /**
     * paper表中teacherid--bond(studentId)--opening表中studentId--查询开题报告列表
     */
//    @PreAuthorize("@ss.hasPermi('platform:paperUpload:list')")
    @GetMapping("/getOpeningPaperListForTeacher")
    public AjaxResult getOpeningPaperListForTeacher()
    {
        return success(platOpeningService.getOpeningPaperListForTeacher());
    }

    /**
     * 修改开题报告,教师审核通过、不通过学生论文
     */
//    @PreAuthorize("@ss.hasPermi('platform:paperUpload:edit')")
//    @Log(title = "开题报告", businessType = BusinessType.UPDATE)
//    @PutMapping("/updatePaperUploadFromTeacher")
//    public AjaxResult updatePaperUploadFromTeacher(@RequestBody String studentId)
//    {
//        return toAjax(platOpeningService.updatePaperUploadFromTeacher(studentId));
//    }

}
