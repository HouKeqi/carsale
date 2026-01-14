package com.ruoyi.mes.domain.vo;

import com.ruoyi.mes.domain.MesProduct;

public class MesProductVo extends MesProduct {
    /** 产品名称 */
    private String materialName;

    /** 产品型号 */
    private String materialModel;

    /** 产品规格 */
    private String materialSpecifications;

    /** 产品单位 */
    private String materialUnit;





    public String getMaterialUnit() {
        return materialUnit;
    }

    public void setMaterialUnit(String materialUnit) {
        this.materialUnit = materialUnit;
    }

    public String getMaterialSpecifications() {
        return materialSpecifications;
    }

    public void setMaterialSpecifications(String materialSpecifications) {
        this.materialSpecifications = materialSpecifications;
    }

    public String getMaterialModel() {
        return materialModel;
    }

    public void setMaterialModel(String materialModel) {
        this.materialModel = materialModel;
    }

    public String getMaterialName() {
        return materialName;
    }

    public void setMaterialName(String materialName) {
        this.materialName = materialName;
    }





}
