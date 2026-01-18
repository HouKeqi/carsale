package com.ruoyi.web.controller.carsale;

import com.ruoyi.carsale.domain.CarsaleCarOrder;
import com.ruoyi.carsale.service.ICarsaleCarOrderService;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.mes.domain.MesProject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
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

    // 新增用户购车
    // @RequestBody 参数注解，将 HTTP 请求体中的 JSON 数据自动转换为 CarsaleCarOrder 对象
    @PostMapping
    public AjaxResult addCarOrder(@RequestBody CarsaleCarOrder carsaleCarOrder) {

        return AjaxResult.success(carOrderService.insertCarsaleCarOrder(carsaleCarOrder));
    }

    // 修改用户购车
    @PutMapping
    public AjaxResult editCarOrder(@RequestBody CarsaleCarOrder carsaleCarOrder) {
        // 输出参数

        System.out.println(carsaleCarOrder.getIntroduce());
        System.out.println(carsaleCarOrder.getIntroduce());
        System.out.println(carsaleCarOrder.getIntroduce());
        System.out.println(carsaleCarOrder.getIntroduce());
        System.out.println(carsaleCarOrder.getIntroduce());
        System.out.println(carsaleCarOrder.getIntroduce());
        System.out.println(carsaleCarOrder.getIntroduce());
        System.out.println(carsaleCarOrder.getIntroduce());
        System.out.println(carsaleCarOrder.getIntroduce());


        return AjaxResult.success(carOrderService.updateCarsaleCarOrder(carsaleCarOrder));
    }

    // (批量/单个)删除用户购车
    // @PathVariable 获取路径中的参数,将 URL 路径中的变量映射到方法参数
    @DeleteMapping("/{ids}")
    public AjaxResult deleteCarOrder(@PathVariable("ids") Long[] ids) {
        return toAjax(carOrderService.deleteCarsaleCarOrderByIds(ids));
    }

    // 查询详情
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable Long id) {
        return AjaxResult.success(carOrderService.selectCarsaleCarOrderById(id));
    }

    /** 导出项目列表 */
    @PostMapping("/export")
    public void export(CarsaleCarOrder carsaleCarOrder, HttpServletResponse response){
        // 先查列表, 即需要导出的数据
        List<CarsaleCarOrder> carsaleCarOrders = carOrderService.selectCarsaleCarOrderList(carsaleCarOrder);

        ExcelUtil<CarsaleCarOrder> excelUtil = new ExcelUtil<>(CarsaleCarOrder.class);
        excelUtil.exportExcel(response,carsaleCarOrders, "用户购车列表");

    }

}

