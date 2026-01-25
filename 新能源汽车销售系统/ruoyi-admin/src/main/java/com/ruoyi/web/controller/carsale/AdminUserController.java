package com.ruoyi.web.controller.carsale;

import com.ruoyi.carsale.domain.Orders;
import com.ruoyi.carsale.domain.Evaluation;
import com.ruoyi.carsale.service.IOrdersService;
import com.ruoyi.carsale.service.IEvaluationService;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.service.ISysRoleService;
import com.ruoyi.system.service.ISysUserService;
import org.apache.commons.lang3.ArrayUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 管理员用户管理Controller
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/carsale")
public class AdminUserController extends BaseController {
    @Autowired
    private ISysUserService userService;
    
    @Autowired
    private ISysRoleService roleService;
    
    @Autowired
    private IOrdersService ordersService;
    
    @Autowired
    private IEvaluationService evaluationService;

    /**
     * 管理员查询用户列表
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @GetMapping("/admin/user/list")
    public TableDataInfo getUserList(SysUser user) {
        startPage();
        List<SysUser> list = userService.selectUserList(user);
        return getDataTable(list);
    }

    /**
     * 管理员查看用户购车记录
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @GetMapping("/admin/user/{userId}/orders")
    public TableDataInfo getUserOrders(@PathVariable("userId") Long userId) {
        startPage();
        Orders orders = new Orders();
        orders.setUserId(userId);
        List<Orders> list = ordersService.selectOrdersList(orders);
        return getDataTable(list);
    }

    /**
     * 管理员查看用户浏览偏好（基于订单和评价）
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @GetMapping("/admin/user/{userId}/preferences")
    public AjaxResult getUserPreferences(@PathVariable("userId") Long userId) {
        Map<String, Object> result = new HashMap<>();
        
        // 查询用户的订单，分析偏好的品牌和价格区间
        Orders orderQuery = new Orders();
        orderQuery.setUserId(userId);
        List<Orders> orders = ordersService.selectOrdersList(orderQuery);
        
        // 查询用户的评价
        Evaluation evalQuery = new Evaluation();
        evalQuery.setUserId(userId);
        List<Evaluation> evaluations = evaluationService.selectEvaluationList(evalQuery);
        
        result.put("orders", orders);
        result.put("evaluations", evaluations);
        result.put("orderCount", orders != null ? orders.size() : 0);
        result.put("evaluationCount", evaluations != null ? evaluations.size() : 0);
        
        return AjaxResult.success(result);
    }

    /**
     * 管理员获取用户详细信息（用于编辑）
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @GetMapping("/admin/user/detail/{userId}")
    public AjaxResult getUserDetail(@PathVariable("userId") Long userId) {
        userService.checkUserDataScope(userId);
        SysUser user = userService.selectUserById(userId);
        AjaxResult ajax = AjaxResult.success();
        ajax.put(AjaxResult.DATA_TAG, user);
        ajax.put("roleIds", user.getRoles().stream().map(SysRole::getRoleId).collect(Collectors.toList()));
        return ajax;
    }

    /**
     * 管理员获取角色列表（用于下拉选择）
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @GetMapping("/admin/user/roles")
    public AjaxResult getRoles() {
        List<SysRole> roles = roleService.selectRoleAll();
        // 只返回管理员和普通用户角色
        List<SysRole> filteredRoles = roles.stream()
                .filter(r -> "admin".equals(r.getRoleKey()) || "customer".equals(r.getRoleKey()))
                .collect(Collectors.toList());
        return AjaxResult.success(filteredRoles);
    }

    /**
     * 管理员新增用户
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @Log(title = "用户管理", businessType = BusinessType.INSERT)
    @PostMapping("/admin/user/add")
    public AjaxResult addUser(@Validated @RequestBody SysUser user) {
        roleService.checkRoleDataScope(user.getRoleIds());
        if (!userService.checkUserNameUnique(user)) {
            return error("新增用户'" + user.getUserName() + "'失败，登录账号已存在");
        } else if (StringUtils.isNotEmpty(user.getPhonenumber()) && !userService.checkPhoneUnique(user)) {
            return error("新增用户'" + user.getUserName() + "'失败，手机号码已存在");
        } else if (StringUtils.isNotEmpty(user.getEmail()) && !userService.checkEmailUnique(user)) {
            return error("新增用户'" + user.getUserName() + "'失败，邮箱账号已存在");
        }
        user.setCreateBy(getUsername());
        // 如果密码为空，设置默认密码
        if (StringUtils.isEmpty(user.getPassword())) {
            user.setPassword("123456");
        }
        user.setPassword(SecurityUtils.encryptPassword(user.getPassword()));
        return toAjax(userService.insertUser(user));
    }

    /**
     * 管理员修改用户
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @Log(title = "用户管理", businessType = BusinessType.UPDATE)
    @PutMapping("/admin/user/edit")
    public AjaxResult editUser(@Validated @RequestBody SysUser user) {
        userService.checkUserAllowed(user);
        userService.checkUserDataScope(user.getUserId());
        roleService.checkRoleDataScope(user.getRoleIds());
        if (!userService.checkUserNameUnique(user)) {
            return error("修改用户'" + user.getUserName() + "'失败，登录账号已存在");
        } else if (StringUtils.isNotEmpty(user.getPhonenumber()) && !userService.checkPhoneUnique(user)) {
            return error("修改用户'" + user.getUserName() + "'失败，手机号码已存在");
        } else if (StringUtils.isNotEmpty(user.getEmail()) && !userService.checkEmailUnique(user)) {
            return error("修改用户'" + user.getUserName() + "'失败，邮箱账号已存在");
        }
        user.setUpdateBy(getUsername());
        // 如果密码不为空，则加密密码
        if (StringUtils.isNotEmpty(user.getPassword())) {
            user.setPassword(SecurityUtils.encryptPassword(user.getPassword()));
        }
        return toAjax(userService.updateUser(user));
    }

    /**
     * 管理员删除用户
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @Log(title = "用户管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/admin/user/delete/{userIds}")
    public AjaxResult deleteUser(@PathVariable Long[] userIds) {
        if (ArrayUtils.contains(userIds, getUserId())) {
            return error("当前用户不能删除");
        }
        return toAjax(userService.deleteUserByIds(userIds));
    }

    /**
     * 管理员分配角色
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @Log(title = "用户管理", businessType = BusinessType.GRANT)
    @PutMapping("/admin/user/assign-role")
    public AjaxResult assignRole(@RequestBody Map<String, Object> params) {
        Long userId = Long.valueOf(params.get("userId").toString());
        @SuppressWarnings("unchecked")
        List<Long> roleIds = (List<Long>) params.get("roleIds");
        Long[] roleIdArray = roleIds != null ? roleIds.toArray(new Long[0]) : new Long[0];
        
        userService.checkUserDataScope(userId);
        roleService.checkRoleDataScope(roleIdArray);
        userService.insertUserAuth(userId, roleIdArray);
        return success();
    }
}
