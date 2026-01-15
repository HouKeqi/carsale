package com.ruoyi.web.controller.carsale;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

// 用户购车
@RestController
@RequestMapping("/carsale/carOrder")
public class CarOrderController extends BaseController {

    @GetMapping("/getCarOrderList")
    public AjaxResult list() {
        //return AjaxResult.success("success","用户购车数据列表");
        return success("用户购车数据列表");

        // 如果是要用分页
        // return getDataTable(....);
    }
}

