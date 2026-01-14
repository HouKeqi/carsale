package com.ruoyi.web.controller.mes;

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
import com.ruoyi.mes.domain.WmsMaterial;
import com.ruoyi.mes.service.IWmsMaterialService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 物料档案Controller
 *
 * @author ruoyi
 * @date 2024-07-02
 */
@RestController
@RequestMapping("/mes/material")
public class WmsMaterialController extends BaseController
{
    @Autowired
    private IWmsMaterialService wmsMaterialService;

    /**
     * 查询物料档案列表
     */
    @PreAuthorize("@ss.hasPermi('mes:material:list')")
    @GetMapping("/list")
    public TableDataInfo list()
    {
        startPage();
        List<WmsMaterial> list = wmsMaterialService.selectWmsMaterialList();
        return getDataTable(list);
    }

}
