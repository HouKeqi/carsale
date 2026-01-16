package com.ruoyi.web.controller.carsale;

import com.ruoyi.carsale.domain.CarsaleCarOrder;
import com.ruoyi.carsale.service.ICarsaleCarOrderService;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

// 用户购车
@RestController
@RequestMapping("/carsale/carOrder")
public class CarOrderController extends BaseController {

    @Autowired
    private ICarsaleCarOrderService carOrderService;

    @GetMapping("/getCarOrderList")
    public TableDataInfo list(CarsaleCarOrder carsaleCarOrder) {

        // 开启分页，其实调用的是父类的方法，即 super.startPage();
        startPage();

        // 注意这里返回列表，所以我命名为 carsaleCarOrders，加了“s"
        List<CarsaleCarOrder> carsaleCarOrders = this.carOrderService.selectCarsaleCarOrderList(carsaleCarOrder);

        // 开启分页，返回的就是个 TableDataInfo，不再是AjaxResult类型了，因此返回值也要改一下
        // 也就是说，带分页，返回的是 TableDataInfo；不带分页，返回的是AjaxResult
        return getDataTable(carsaleCarOrders);

    }
}

