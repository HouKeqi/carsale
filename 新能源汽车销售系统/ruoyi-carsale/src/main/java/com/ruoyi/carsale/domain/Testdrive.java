package com.ruoyi.carsale.domain;

/*
* 测试表
* CREATE TABLE `carsale_test_drive`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '预约唯一标识',
  `user_id` bigint NOT NULL COMMENT '预约用户',
  `vehicle_id` bigint NOT NULL COMMENT '意向车型',
  `store_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '预约门店',
  `appoint_time` datetime NULL DEFAULT NULL COMMENT '用户选择的试驾时间',
  `status` int NULL DEFAULT 0 COMMENT '0-待审核, 1-通过, 2-拒绝',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_test_user`(`user_id` ASC) USING BTREE,
  INDEX `fk_test_vehicle`(`vehicle_id` ASC) USING BTREE,
  CONSTRAINT `fk_test_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_test_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `carsale_vehicle` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '试驾预约管理表' ROW_FORMAT = Dynamic;
* */


import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

public class Testdrive extends BaseEntity {
    @Excel(name = "预约编号")
    private Long id;
    @Excel(name = "用户编号")
    private Long userId;
    @Excel(name = "车辆编号")
    private Long vehicleId;
    @Excel(name = "门店名称")
    private String storeName;
    @Excel(name = "预约时间")
    private String appointTime;
    @Excel(name = "预约状态")
    private int status;

    public String getStoreName() {
        return storeName;
    }

    public void setStoreName(String storeName) {
        this.storeName = storeName;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getVehicleId() {
        return vehicleId;
    }

    public void setVehicleId(Long vehicleId) {
        this.vehicleId = vehicleId;
    }

    public String getAppointTime() {
        return appointTime;
    }

    public void setAppointTime(String appointTime) {
        this.appointTime = appointTime;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

}
