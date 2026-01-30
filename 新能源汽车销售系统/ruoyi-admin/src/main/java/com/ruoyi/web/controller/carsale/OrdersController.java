package com.ruoyi.web.controller.carsale;

import com.ruoyi.carsale.domain.Orders;
import com.ruoyi.carsale.domain.Vehicle;
import com.ruoyi.carsale.service.IOrdersService;
import com.ruoyi.carsale.service.IAdminVehicleManageService;
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
 * 订单管理Controller
 *
 * @author ruoyi
 * @date 2026-01-19
 */
@RestController
@RequestMapping("/carsale")
public class OrdersController extends BaseController
{
    @Autowired
    private IOrdersService ordersService;
    
    @Autowired
    private IAdminVehicleManageService vehicleService;

    /**
     * 普通用户创建订单
     */
    @PreAuthorize("@ss.hasRole('customer')")
    @PostMapping("/order/create")
    @Log(title = "订单管理", businessType = BusinessType.INSERT)
    public AjaxResult addOrder(@RequestBody Orders orders) {
        // 自动设置当前登录用户ID
        orders.setUserId(getUserId());
        // 设置订单状态为待支付
        if (orders.getStatus() == null) {
            orders.setStatus(0);
        }
        // 生成订单ID（使用时间戳+随机数）
        if (orders.getId() == null) {
            orders.setId(System.currentTimeMillis());
        }
        
        // 金融方案相关字段已经从前端传入，包括：
        // - financePlanId: 金融方案ID
        // - originalPrice: 原价
        // - discountAmount: 折扣金额
        // - downPayment: 首付金额
        // 这些字段会自动保存到数据库
        
        int result = ordersService.insertOrders(orders);
        if (result > 0) {
            // 返回订单对象，包含订单ID
            return AjaxResult.success(orders);
        }
        return AjaxResult.error("订单创建失败");
    }

    /**
     * 管理员查看所有订单列表
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @GetMapping("/admin/order/page")
    public TableDataInfo getAdminOrderList(Orders orders) {
        startPage();
        List<Orders> ordersList = ordersService.selectOrdersList(orders);
        return getDataTable(ordersList);
    }

    /**
     * 管理员查看订单详情
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @GetMapping("/admin/order/detail/{id}")
    public AjaxResult getAdminOrderDetail(@PathVariable("id") Long id) {
        return AjaxResult.success(ordersService.selectOrdersById(id));
    }

    /**
     * 普通用户查看我的订单列表
     */
    @PreAuthorize("@ss.hasRole('customer')")
    @GetMapping("/order/my/page")
    public TableDataInfo getMyOrderList(Orders orders) {
        startPage();
        // 只查询当前用户的订单
        orders.setUserId(getUserId());
        List<Orders> ordersList = ordersService.selectOrdersList(orders);
        return getDataTable(ordersList);
    }

    /**
     * 普通用户查看订单详情
     */
    @PreAuthorize("@ss.hasRole('customer')")
    @GetMapping("/order/detail/{id}")
    public AjaxResult getOrderDetail(@PathVariable("id") Long id) {
        Orders order = ordersService.selectOrdersById(id);
        // 验证订单是否属于当前用户
        if (order != null && !order.getUserId().equals(getUserId())) {
            return AjaxResult.error("无权访问该订单");
        }
        return AjaxResult.success(order);
    }

    /**
     * 管理员更新订单状态（确认订单/准备就绪、标记提车等）
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @PutMapping("/admin/order/status/update")
    @Log(title = "订单管理", businessType = BusinessType.UPDATE)
    public AjaxResult updateOrderStatus(@RequestBody Orders orders) {
        Orders existingOrder = ordersService.selectOrdersById(orders.getId());
        if (existingOrder == null) {
            return AjaxResult.error("订单不存在");
        }
        
        Integer newStatus = orders.getStatus();
        Integer currentStatus = existingOrder.getStatus();
        
        // 管理员只能执行以下状态流转：
        // 1. 从已支付(1)变为待提车(2) - 确认订单/准备就绪
        // 2. 从待提车(2)变为已完成(3) - 标记提车
        
        if (newStatus != null) {
            if (newStatus == 2) {
                // 确认订单/准备就绪：从已支付(1)变为待提车(2)
                if (currentStatus == null || currentStatus != 1) {
                    return AjaxResult.error("只能将已支付的订单标记为待提车");
                }
                // 待提车状态不需要设置pickupTime，提车时间应该在标记提车时设置
            } else if (newStatus == 3) {
                // 标记提车：从待提车(2)变为已完成(3)
                if (currentStatus == null || currentStatus != 2) {
                    return AjaxResult.error("只能将待提车的订单标记为已完成");
                }
                // 设置提车时间
                if (orders.getPickupTime() == null || orders.getPickupTime().isEmpty()) {
                    orders.setPickupTime(DateUtils.getTime());
                }
            } else {
                // 管理员不能将订单改为其他状态
                return AjaxResult.error("无效的状态流转操作");
            }
        }
        
        return toAjax(ordersService.updateOrders(orders));
    }

    /**
     * 普通用户支付订单
     */
    @PreAuthorize("@ss.hasRole('customer')")
    @PutMapping("/order/pay/{id}")
    @Log(title = "订单管理", businessType = BusinessType.UPDATE)
    public AjaxResult payOrder(@PathVariable("id") Long id) {
        Orders order = ordersService.selectOrdersById(id);
        if (order == null) {
            return AjaxResult.error("订单不存在");
        }
        // 验证订单是否属于当前用户
        if (!order.getUserId().equals(getUserId())) {
            return AjaxResult.error("无权操作该订单");
        }
        // 只能支付待支付状态的订单
        if (order.getStatus() == null || order.getStatus() != 0) {
            return AjaxResult.error("只能支付待支付状态的订单");
        }
        
        // 检查库存并扣减
        Vehicle vehicle = vehicleService.selectVehicleById(order.getVehicleId());
        if (vehicle == null) {
            return AjaxResult.error("车辆信息不存在");
        }
        if (vehicle.getStock() == null || vehicle.getStock() < order.getNumber()) {
            return AjaxResult.error("库存不足，无法完成支付");
        }
        
        // 扣减库存
        vehicle.setStock(vehicle.getStock() - order.getNumber());
        int stockUpdateResult = vehicleService.updateVehicle(vehicle);
        if (stockUpdateResult <= 0) {
            return AjaxResult.error("库存扣减失败");
        }
        
        // 更新订单状态为已支付
        order.setStatus(1);
        // 记录支付时间（使用标准格式：yyyy-MM-dd HH:mm:ss）
        order.setPayTime(DateUtils.getTime());
        return toAjax(ordersService.updateOrders(order));
    }

    /**
     * 普通用户取消订单（仅未支付订单）
     */
    @PreAuthorize("@ss.hasRole('customer')")
    @PutMapping("/order/cancel/{id}")
    @Log(title = "订单管理", businessType = BusinessType.UPDATE)
    public AjaxResult cancelOrder(@PathVariable("id") Long id) {
        Orders order = ordersService.selectOrdersById(id);
        if (order == null) {
            return AjaxResult.error("订单不存在");
        }
        // 验证订单是否属于当前用户
        if (!order.getUserId().equals(getUserId())) {
            return AjaxResult.error("无权操作该订单");
        }
        // 只能取消未支付订单
        if (order.getStatus() != null && order.getStatus() != 0) {
            return AjaxResult.error("只能取消未支付的订单");
        }
        // 设置订单状态为取消
        order.setStatus(4);
        return toAjax(ordersService.updateOrders(order));
    }
}
