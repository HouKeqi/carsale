package com.ruoyi.web.controller.carsale;

import com.ruoyi.carsale.domain.Testdrive;
import com.ruoyi.carsale.service.ITestdriveService;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 试驾预约管理Controller
 *
 * @author ruoyi
 * @date 2026-01-19
 */
@RestController
@RequestMapping("/carsale")
public class TestdriveController extends BaseController {
    @Autowired
    private ITestdriveService testdriveService;

    /**
     * 普通用户创建试驾预约
     */
    @PreAuthorize("@ss.hasRole('customer')")
    @PostMapping("/testdrive/create")
    @Log(title = "试驾预约", businessType = BusinessType.INSERT)
    public AjaxResult addTestdrive(@RequestBody Testdrive testdrive) {
        // 自动设置当前登录用户ID
        testdrive.setUserId(getUserId());
        // 设置状态为待审核
        if (testdrive.getStatus() == null) {
            testdrive.setStatus(0);
        }
        return toAjax(testdriveService.insertTestdrive(testdrive));
    }

    /**
     * 管理员查看所有试驾预约列表
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @GetMapping("/admin/testdrive/list")
    public TableDataInfo getAdminTestdriveList(Testdrive testdrive) {
        startPage();
        List<Testdrive> list = testdriveService.selectTestdriveList(testdrive);
        return getDataTable(list);
    }

    /**
     * 普通用户查看我的试驾预约列表
     */
    @PreAuthorize("@ss.hasRole('customer')")
    @GetMapping("/testdrive/my/list")
    public TableDataInfo getMyTestdriveList(Testdrive testdrive) {
        startPage();
        // 只查询当前用户的预约
        testdrive.setUserId(getUserId());
        List<Testdrive> list = testdriveService.selectTestdriveList(testdrive);
        return getDataTable(list);
    }

    /**
     * 管理员审核试驾预约
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @PutMapping("/admin/testdrive/{id}/audit")
    @Log(title = "试驾审核", businessType = BusinessType.UPDATE)
    public AjaxResult auditTestdrive(@PathVariable("id") Long id, @RequestBody Testdrive testdrive) {
        testdrive.setId(id);
        // 设置审核时间
        testdrive.setAuditTime(DateUtils.getTime());
        return toAjax(testdriveService.updateTestdrive(testdrive));
    }

    /**
     * 普通用户取消试驾预约（仅待审核状态）
     */
    @PreAuthorize("@ss.hasRole('customer')")
    @DeleteMapping("/testdrive/cancel/{id}")
    @Log(title = "试驾预约", businessType = BusinessType.DELETE)
    public AjaxResult cancelTestdrive(@PathVariable("id") Long id) {
        Testdrive testdrive = testdriveService.selectTestdriveById(id);
        if (testdrive == null) {
            return AjaxResult.error("预约不存在");
        }
        // 验证预约是否属于当前用户
        if (!testdrive.getUserId().equals(getUserId())) {
            return AjaxResult.error("无权操作该预约");
        }
        // 只能取消待审核的预约
        if (testdrive.getStatus() != null && testdrive.getStatus() != 0) {
            return AjaxResult.error("只能取消待审核的预约");
        }
        return toAjax(testdriveService.deleteTestdriveById(id));
    }
}
