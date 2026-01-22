package com.ruoyi.web.controller.carsale;
import com.ruoyi.carsale.domain.CarsaleCarOrder;
import com.ruoyi.carsale.domain.Testdrive;
import com.ruoyi.carsale.domain.Vehicle;
import com.ruoyi.carsale.service.IAdminVehicleManageService;
import com.ruoyi.carsale.service.impl.OrdersServiceImpl;
import com.ruoyi.carsale.service.impl.TestdriveServiceImpl;
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


/**
 * 车辆信息基础Controller
 *
 * @author ruoyi
 * @date 2026-01-19
 */
@RestController
@RequestMapping("/carsale")
public class TestdriveController extends BaseController{
    @Autowired
    private TestdriveServiceImpl TestdriveService;

    // 添加
    @PostMapping("/test-drive/apply")
    public AjaxResult addTestdrive(@RequestBody Testdrive testdrive) {
        return AjaxResult.success(TestdriveService.insertTestdrive(testdrive));
    }

    // 查询
    @GetMapping({"/admin/test-drive/page","/admin/test-drive/detail","/test-drive/my/page"})
    public TableDataInfo getTestdriveList(Testdrive testdrive) {

        // 开启分页，其实调用的是父类方法，即 super.startPage();
        startPage();

        // 注意这里返回列表，所以我命名为 carsaleCarOrders，加了“s"
        List<Testdrive> testdriveList = this.TestdriveService.selectTestdriveList(testdrive);

        return getDataTable(testdriveList);
    }

    // 修改
    @PutMapping("/admin/test-drive/audit")
    public AjaxResult updateTestdrive(@RequestBody Testdrive testdrive) {
        return AjaxResult.success(TestdriveService.updateTestdrive(testdrive));
    }

    // 删除
    @DeleteMapping("/test-drive/cancel/{id}")
    public AjaxResult deleteTestdrive(@PathVariable("id") Long id) {
        return AjaxResult.success(TestdriveService.deleteTestdriveById(id));
    }



}

