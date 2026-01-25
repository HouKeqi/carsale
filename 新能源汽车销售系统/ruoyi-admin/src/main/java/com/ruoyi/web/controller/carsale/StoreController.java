package com.ruoyi.web.controller.carsale;

import com.ruoyi.carsale.domain.Store;
import com.ruoyi.carsale.service.IStoreService;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 门店管理Controller
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/carsale")
public class StoreController extends BaseController {

    @Autowired
    private IStoreService storeService;

    /**
     * 查询门店列表（管理员）
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @GetMapping("/admin/store/list")
    public TableDataInfo getStoreList(Store store) {
        startPage();
        List<Store> list = storeService.selectStoreList(store);
        return getDataTable(list);
    }

    /**
     * 查询所有启用的门店列表（普通用户和管理员都可访问）
     */
    @GetMapping("/store/list")
    public AjaxResult getEnabledStoreList() {
        Store store = new Store();
        store.setStatus(1); // 只查询启用的门店
        List<Store> list = storeService.selectStoreList(store);
        return AjaxResult.success(list);
    }

    /**
     * 根据ID获取门店详情
     */
    @GetMapping("/store/{id}")
    public AjaxResult getStoreById(@PathVariable("id") Long id) {
        Store store = storeService.selectStoreById(id);
        if (store == null) {
            return AjaxResult.error("门店不存在");
        }
        return AjaxResult.success(store);
    }

    /**
     * 新增门店（管理员）
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @PostMapping("/admin/store/add")
    @Log(title = "门店管理", businessType = BusinessType.INSERT)
    public AjaxResult addStore(@RequestBody Store store) {
        // 默认状态为启用
        if (store.getStatus() == null) {
            store.setStatus(1);
        }
        return toAjax(storeService.insertStore(store));
    }

    /**
     * 修改门店（管理员）
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @PutMapping("/admin/store/update")
    @Log(title = "门店管理", businessType = BusinessType.UPDATE)
    public AjaxResult updateStore(@RequestBody Store store) {
        return toAjax(storeService.updateStore(store));
    }

    /**
     * 删除门店（管理员）
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @DeleteMapping("/admin/store/delete/{ids}")
    @Log(title = "门店管理", businessType = BusinessType.DELETE)
    public AjaxResult deleteStore(@PathVariable Long[] ids) {
        return toAjax(storeService.deleteStoreByIds(ids));
    }
}
