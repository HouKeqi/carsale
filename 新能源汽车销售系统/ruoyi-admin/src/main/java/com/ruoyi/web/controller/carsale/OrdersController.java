package com.ruoyi.web.controller.carsale;

import com.ruoyi.carsale.domain.CarsaleCarOrder;
import com.ruoyi.carsale.domain.Vehicle;
import com.ruoyi.carsale.service.IAdminVehicleManageService;
import com.ruoyi.carsale.service.impl.OrdersServiceImpl;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import org.springframework.beans.factory.annotation.Autowired;
import java.util.List;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.carsale.domain.Orders;


/**
 * 车辆信息基础Controller
 *
 * @author ruoyi
 * @date 2026-01-19
 */
@RestController
@RequestMapping("/carsale")
public class OrdersController extends BaseController
{
    @Autowired
    private OrdersServiceImpl OrdersService;

    // 添加
    @PostMapping("/order/create")
    public AjaxResult addOrder(@RequestBody Orders orders) {
        return AjaxResult.success(OrdersService.insertOrders(orders));
    }

    // 查询
    @GetMapping({"/order/detail", "/admin/order/page","/admin/order/detail","/order/my/page"})
    public TableDataInfo getOrderList(Orders orders) {

        // 开启分页，其实调用的是父类方法，即 super.startPage();
        startPage();

        // 注意这里返回列表，所以我命名为 carsaleCarOrders，加了“s"
        List<Orders> ordersList = this.OrdersService.selectOrdersList(orders);

        return getDataTable(ordersList);
    }

    // 修改
    @PutMapping("/admin/order/status/update")
    public AjaxResult updateOrder(@RequestBody Orders orders) {
        return AjaxResult.success(OrdersService.updateOrders(orders));
    }

    // 删除
    @DeleteMapping("/order/cancel")
    public AjaxResult deleteOrder(@RequestBody Orders orders) {
        return AjaxResult.success(OrdersService.deleteOrdersById(orders.getId()));
    }

//

}



