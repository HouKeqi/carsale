package com.ruoyi.web.controller.carsale;

import com.ruoyi.carsale.domain.FinancePlan;
import com.ruoyi.carsale.service.IFinancePlanService;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

/**
 * 金融方案管理Controller
 */
@RestController
@RequestMapping("/carsale")
public class FinancePlanController extends BaseController {
    @Autowired
    private IFinancePlanService financePlanService;

    /**
     * 查询所有启用的金融方案列表（公开接口）
     */
    @GetMapping("/finance/list")
    public AjaxResult getFinancePlanList() {
        FinancePlan financePlan = new FinancePlan();
        financePlan.setStatus(1); // 只查询启用的
        List<FinancePlan> list = financePlanService.selectFinancePlanList(financePlan);
        return AjaxResult.success(list);
    }

    /**
     * 计算月供
     */
    @PostMapping("/finance/calculate")
    public AjaxResult calculateMonthlyPayment(@RequestBody CalculateRequest request) {
        try {
            FinancePlan plan = financePlanService.selectFinancePlanById(request.getPlanId());
            if (plan == null || plan.getStatus() != 1) {
                return AjaxResult.error("金融方案不存在或已停用");
            }

            BigDecimal vehiclePrice = request.getVehiclePrice();
            BigDecimal downPaymentRate = plan.getDownPaymentRate().divide(new BigDecimal("100"), 4, RoundingMode.HALF_UP);
            BigDecimal loanAmount = vehiclePrice.multiply(BigDecimal.ONE.subtract(downPaymentRate));
            BigDecimal monthlyRate = plan.getInterestRate().divide(new BigDecimal("100"), 6, RoundingMode.HALF_UP)
                    .divide(new BigDecimal("12"), 6, RoundingMode.HALF_UP);
            int periods = plan.getPeriods();

            // 等额本息计算公式：月供 = 贷款本金 × [月利率×(1+月利率)^还款月数] / [(1+月利率)^还款月数 - 1]
            BigDecimal numerator = monthlyRate.multiply(
                BigDecimal.ONE.add(monthlyRate).pow(periods)
            );
            BigDecimal denominator = BigDecimal.ONE.add(monthlyRate).pow(periods).subtract(BigDecimal.ONE);
            BigDecimal monthlyPayment = loanAmount.multiply(numerator).divide(denominator, 2, RoundingMode.HALF_UP);

            CalculateResult result = new CalculateResult();
            result.setDownPayment(vehiclePrice.multiply(downPaymentRate).setScale(2, RoundingMode.HALF_UP));
            result.setLoanAmount(loanAmount.setScale(2, RoundingMode.HALF_UP));
            result.setMonthlyPayment(monthlyPayment);
            result.setTotalPayment(monthlyPayment.multiply(new BigDecimal(periods)).setScale(2, RoundingMode.HALF_UP));
            result.setTotalInterest(result.getTotalPayment().subtract(loanAmount).setScale(2, RoundingMode.HALF_UP));

            return AjaxResult.success(result);
        } catch (Exception e) {
            return AjaxResult.error("计算失败：" + e.getMessage());
        }
    }

    /**
     * 管理员查询金融方案列表
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @GetMapping("/admin/finance/list")
    public TableDataInfo getAdminFinancePlanList(FinancePlan financePlan) {
        startPage();
        List<FinancePlan> list = financePlanService.selectFinancePlanList(financePlan);
        return getDataTable(list);
    }

    /**
     * 管理员新增金融方案
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @PostMapping("/admin/finance/add")
    @Log(title = "金融方案管理", businessType = BusinessType.INSERT)
    public AjaxResult addFinancePlan(@RequestBody FinancePlan financePlan) {
        if (financePlan.getStatus() == null) {
            financePlan.setStatus(1);
        }
        return toAjax(financePlanService.insertFinancePlan(financePlan));
    }

    /**
     * 管理员修改金融方案
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @PutMapping("/admin/finance/update")
    @Log(title = "金融方案管理", businessType = BusinessType.UPDATE)
    public AjaxResult updateFinancePlan(@RequestBody FinancePlan financePlan) {
        return toAjax(financePlanService.updateFinancePlan(financePlan));
    }

    /**
     * 管理员删除金融方案
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @DeleteMapping("/admin/finance/delete/{id}")
    @Log(title = "金融方案管理", businessType = BusinessType.DELETE)
    public AjaxResult deleteFinancePlan(@PathVariable("id") Long id) {
        return toAjax(financePlanService.deleteFinancePlanById(id));
    }

    /**
     * 计算请求对象
     */
    public static class CalculateRequest {
        private Long planId;
        private BigDecimal vehiclePrice;

        public Long getPlanId() {
            return planId;
        }

        public void setPlanId(Long planId) {
            this.planId = planId;
        }

        public BigDecimal getVehiclePrice() {
            return vehiclePrice;
        }

        public void setVehiclePrice(BigDecimal vehiclePrice) {
            this.vehiclePrice = vehiclePrice;
        }
    }

    /**
     * 计算结果对象
     */
    public static class CalculateResult {
        private BigDecimal downPayment;      // 首付金额
        private BigDecimal loanAmount;       // 贷款金额
        private BigDecimal monthlyPayment;   // 月供
        private BigDecimal totalPayment;      // 总还款额
        private BigDecimal totalInterest;     // 总利息

        public BigDecimal getDownPayment() {
            return downPayment;
        }

        public void setDownPayment(BigDecimal downPayment) {
            this.downPayment = downPayment;
        }

        public BigDecimal getLoanAmount() {
            return loanAmount;
        }

        public void setLoanAmount(BigDecimal loanAmount) {
            this.loanAmount = loanAmount;
        }

        public BigDecimal getMonthlyPayment() {
            return monthlyPayment;
        }

        public void setMonthlyPayment(BigDecimal monthlyPayment) {
            this.monthlyPayment = monthlyPayment;
        }

        public BigDecimal getTotalPayment() {
            return totalPayment;
        }

        public void setTotalPayment(BigDecimal totalPayment) {
            this.totalPayment = totalPayment;
        }

        public BigDecimal getTotalInterest() {
            return totalInterest;
        }

        public void setTotalInterest(BigDecimal totalInterest) {
            this.totalInterest = totalInterest;
        }
    }
}
