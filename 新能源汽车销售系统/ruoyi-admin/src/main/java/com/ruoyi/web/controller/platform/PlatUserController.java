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
import com.ruoyi.platform.domain.PlatUser;
import com.ruoyi.platform.service.IPlatUserService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 用户信息Controller
 *
 * @author ruoyi
 * @date 2024-07-03
 */
@RestController
@RequestMapping("/platform/user")
public class PlatUserController extends BaseController
{
    @Autowired
    private IPlatUserService platUserService;

    /**
     * 查询用户信息列表
     */
    @PreAuthorize("@ss.hasPermi('platform:user:list')")
    @GetMapping("/list")
    public TableDataInfo list(PlatUser platUser)
    {
        startPage();
        List<PlatUser> list = platUserService.selectPlatUserList(platUser);
        return getDataTable(list);
    }

    /**
     * 导出用户信息列表
     */
    @PreAuthorize("@ss.hasPermi('platform:user:export')")
    @Log(title = "用户信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, PlatUser platUser)
    {
        List<PlatUser> list = platUserService.selectPlatUserList(platUser);
        ExcelUtil<PlatUser> util = new ExcelUtil<PlatUser>(PlatUser.class);
        util.exportExcel(response, list, "用户信息数据");
    }

    /**
     * 获取用户信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('platform:user:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(platUserService.selectPlatUserById(id));
    }

    /**
     * 新增用户信息
     */
    @PreAuthorize("@ss.hasPermi('platform:user:add')")
    @Log(title = "用户信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody PlatUser platUser)
    {
        return toAjax(platUserService.insertPlatUser(platUser));
    }

    /**
     * 修改用户信息
     */
    @PreAuthorize("@ss.hasPermi('platform:user:edit')")
    @Log(title = "用户信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody PlatUser platUser)
    {
        return toAjax(platUserService.updatePlatUser(platUser));
    }

    /**
     * 删除用户信息
     */
    @PreAuthorize("@ss.hasPermi('platform:user:remove')")
    @Log(title = "用户信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(platUserService.deletePlatUserByIds(ids));
    }
}
