package com.ruoyi.carsale.domain;

/*
* CREATE TABLE `carsale_promotion`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '活动唯一标识',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '活动名称',
  `vehicle_id` bigint NOT NULL COMMENT '关联特定车型',
  `discount_type` int NULL DEFAULT NULL COMMENT '0-直降, 1-赠品, 2-置换补贴',
  `discount_value` decimal(12, 2) NULL DEFAULT NULL COMMENT '优惠金额或价值描述',
  `start_time` datetime NULL DEFAULT NULL COMMENT '有效期开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '有效期结束时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_promotion_vehicle`(`vehicle_id` ASC) USING BTREE,
  CONSTRAINT `fk_promotion_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `carsale_vehicle` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '促销活动管理表' ROW_FORMAT = Dynamic;
*
* */

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

public class Promotion extends BaseEntity {
    @Excel(name = "活动编号")
    private Long id;
    @Excel(name = "活动名称")
    private String title;
    @Excel(name = "关联车型")
    private Long vehicleId;
    @Excel(name = "优惠类型")
    private int discountType;
    @Excel(name = "优惠金额")
    private double discountValue;
    @Excel(name = "有效期开始时间")
    private String startTime;
    @Excel(name = "有效期结束时间")
    private String endTime;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Long getVehicleId() {
        return vehicleId;
    }

    public void setVehicleId(Long vehicleId) {
        this.vehicleId = vehicleId;
    }

    public int getDiscountType() {
        return discountType;
    }

    public void setDiscountType(int discountType) {
        this.discountType = discountType;
    }

    public double getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(double discountValue) {
        this.discountValue = discountValue;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }
}
