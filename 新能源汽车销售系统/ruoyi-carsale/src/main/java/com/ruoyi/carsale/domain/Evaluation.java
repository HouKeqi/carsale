package com.ruoyi.carsale.domain;


import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 评价表
 *
 * CREATE TABLE `carsale_evaluation`  (
 *   `id` bigint NOT NULL AUTO_INCREMENT COMMENT '评价唯一标识',
 *   `order_id` bigint NOT NULL COMMENT '关联订单',
 *   `vehicle_id` bigint NOT NULL COMMENT '关联车型',
 *   `score` int NULL DEFAULT NULL COMMENT '评分(1-5星)',
 *   `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '文字评价内容',
 *   `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '晒单图片URL',
 *   `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '评价发布时间',
 *   PRIMARY KEY (`id`) USING BTREE,
 *   UNIQUE INDEX `uk_order_id`(`order_id` ASC) USING BTREE,
 *   INDEX `fk_eval_vehicle`(`vehicle_id` ASC) USING BTREE,
 *   CONSTRAINT `fk_eval_order` FOREIGN KEY (`order_id`) REFERENCES `carsale_orders` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
 *   CONSTRAINT `fk_eval_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `carsale_vehicle` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
 * ) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户评价表' ROW_FORMAT = Dynamic;
 *
 */


public class Evaluation extends BaseEntity {
    @Excel(name = "评价编号")
    private Long id;
    @Excel(name = "用户编号")
    private Long userId;
    @Excel(name = "订单编号")
    private Long orderId;
    @Excel(name = "车辆编号")
    private Long vehicleId;
    @Excel(name = "评分")
    private Integer score;
    @Excel(name = "评价内容")
    private String comment;
    @Excel(name = "图片")
    private String images;
    @Excel(name = "评价时间")
    private String create_Time;

    public String getCreate_Time() {
        return create_Time;
    }

    public void setCreate_Time(String create_Time) {
        this.create_Time = create_Time;
    }

    public String getImages() {
        return images;
    }

    public void setImages(String images) {
        this.images = images;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Integer getScore() {
        return score;
    }

    public void setScore(Integer score) {
        this.score = score;
    }

    public Long getVehicleId() {
        return vehicleId;
    }

    public void setVehicleId(Long vehicleId) {
        this.vehicleId = vehicleId;
    }

    public Long getOrderId() {
        return orderId;
    }

    public void setOrderId(Long orderId) {
        this.orderId = orderId;
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

}
