package com.ruoyi.carsale.domain;

/*
-- --------------------------------------------------
-- 4. 订单表 (orders)
-- --------------------------------------------------
CREATE TABLE `orders` (
  `id` BIGINT NOT NULL COMMENT '订单编号(建议雪花算法)',
  `user_id` BIGINT NOT NULL COMMENT '关联购车用户',
  `vehicle_id` BIGINT NOT NULL COMMENT '关联购车车型',
  `status` INT DEFAULT 0 COMMENT '0-待付, 1-已付, 2-待提, 3-完成, 4-取消',
  `amount` DECIMAL(12,2) NOT NULL COMMENT '实际成交金额',
  `number` INT NOT NULL COMMENT '购车数量',
  `phone` VARCHAR(20) NOT NULL COMMENT '联系方式', -- 核心修正：补充 COMMENT 关键字
  `store_location` VARCHAR(100) DEFAULT NULL COMMENT '提车门店名称',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '下单时间',
  `pay_time` DATETIME DEFAULT NULL COMMENT '支付完成时间',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_order_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`),
  CONSTRAINT `fk_order_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicle` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='销售订单表';
 */

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

public class Orders extends BaseEntity {
    @Excel(name = "订单编号")
    private Long id;
    @Excel(name = "用户编号")
    private Long userId;
    @Excel(name = "车辆编号")
    private Long vehicleId;
    @Excel(name = "订单状态")
    private Integer status;
    @Excel(name = "成交金额")
    private Double amount;
    @Excel(name = "购车数量")
    private Integer number;
    @Excel(name = "联系方式")
    private String phone;
    @Excel(name = "提车门店")
    private String storeLocation;
    @Excel(name = "下单时间")
    private String create_Time;
    @Excel(name = "支付完成时间")
    private String payTime;
    @Excel(name = "提车时间")
    private String pickupTime;

    public String getPickupTime() {
        return pickupTime;
    }

    public void setPickupTime(String pickupTime) {
        this.pickupTime = pickupTime;
    }

    public String getCreate_Time() {
        return create_Time;
    }

    public void setCreate_Time(String create_Time) {
        this.create_Time = create_Time;
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

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Double getAmount() {
        return amount;
    }

    public void setAmount(Double amount) {
        this.amount = amount;
    }

    public Integer getNumber() {
        return number;
    }

    public void setNumber(Integer number) {
        this.number = number;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getStoreLocation() {
        return storeLocation;
    }

    public void setStoreLocation(String storeLocation) {
        this.storeLocation = storeLocation;
    }


    public String getPayTime() {
        return payTime;
    }

    public void setPayTime(String payTime) {
        this.payTime = payTime;
    }
}
