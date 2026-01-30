-- ============================================
-- 新能源汽车销售系统 - 数据库变更脚本
-- 用于支持管理员和普通用户权限区分及功能完善
-- ============================================

USE `ry-vue`;

-- ============================================
-- 1. 添加字段
-- ============================================

-- 1.1 carsale_orders表 - 添加提车时间字段
# ALTER TABLE `carsale_orders`
# ADD COLUMN `pickup_time` datetime NULL DEFAULT NULL COMMENT '提车时间' AFTER `pay_time`;

-- 1.2 carsale_promotion表 - 添加活动状态字段
# ALTER TABLE `carsale_promotion`
# ADD COLUMN `status` int NULL DEFAULT 1 COMMENT '活动状态：0-下架，1-上架' AFTER `end_time`;
#
# -- 1.3 carsale_evaluation表 - 添加评价用户ID字段
# -- 注意：如果表中已有数据，需要先通过order_id关联更新user_id
# ALTER TABLE `carsale_evaluation`
# ADD COLUMN `user_id` bigint NULL COMMENT '评价用户ID' AFTER `id`;
#
# -- 更新已有数据的user_id（通过order_id关联）
# UPDATE `carsale_evaluation` e
# INNER JOIN `carsale_orders` o ON e.order_id = o.id
# SET e.user_id = o.user_id
# WHERE e.user_id IS NULL;
#
# -- 将user_id设置为NOT NULL并添加索引和外键
# ALTER TABLE `carsale_evaluation`
# MODIFY COLUMN `user_id` bigint NOT NULL COMMENT '评价用户ID',
# ADD INDEX `idx_user_id`(`user_id`) USING BTREE,
# ADD CONSTRAINT `fk_eval_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
#
# -- 1.4 carsale_test_drive表 - 添加审核相关字段
# ALTER TABLE `carsale_test_drive`
# ADD COLUMN `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间' AFTER `status`,
# ADD COLUMN `audit_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审核备注' AFTER `audit_time`;
#
# -- ============================================
# -- 2. 创建角色
# -- ============================================
#
# -- 2.1 创建普通用户角色（customer）
# -- 检查角色是否已存在，如果不存在则创建
# INSERT INTO `sys_role` (`role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `dept_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`, `remark`)
# SELECT '普通用户', 'customer', 4, '1', 0, 0, '0', '0', 'admin', NOW(), '购车客户角色'
# WHERE NOT EXISTS (SELECT 1 FROM `sys_role` WHERE `role_key` = 'customer');
#
# -- ============================================
# -- 3. 添加索引（优化查询性能）
# -- ============================================
#
# -- 3.1 carsale_vehicle表 - 添加搜索相关索引
# -- 注意：如果索引已存在，执行会报错，可以忽略或手动删除后重新执行
# ALTER TABLE `carsale_vehicle` ADD INDEX `idx_brand`(`brand`) USING BTREE;
# ALTER TABLE `carsale_vehicle` ADD INDEX `idx_price`(`price`) USING BTREE;
# ALTER TABLE `carsale_vehicle` ADD INDEX `idx_range_km`(`range_km`) USING BTREE;
# ALTER TABLE `carsale_vehicle` ADD INDEX `idx_battery_type`(`battery_type`) USING BTREE;
#
# -- 3.2 carsale_orders表 - 添加查询和统计相关索引
# -- 注意：如果索引已存在，执行会报错，可以忽略或手动删除后重新执行
# ALTER TABLE `carsale_orders` ADD INDEX `idx_status`(`status`) USING BTREE;
# ALTER TABLE `carsale_orders` ADD INDEX `idx_create_time`(`create_time`) USING BTREE;
#
# -- ============================================
# -- 4. 数据初始化（可选）
# -- ============================================
#
# -- 4.1 将现有促销活动状态设置为上架（如果status字段刚添加）
# UPDATE `carsale_promotion` SET `status` = 1 WHERE `status` IS NULL;

-- ============================================
-- 5. 促销活动表字段重构
-- ============================================

-- 5.1 添加新字段 discount_amount 和 description
ALTER TABLE `carsale_promotion` 
ADD COLUMN `discount_amount` decimal(12, 2) NULL DEFAULT NULL COMMENT '优惠金额（仅直降类型使用）' AFTER `discount_type`,
ADD COLUMN `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述文本（赠品和置换补贴使用）' AFTER `discount_amount`;

-- 5.2 数据迁移：将现有 discount_value 数据迁移到新字段
-- 如果 discount_type = 0（直降），则迁移到 discount_amount
UPDATE `carsale_promotion` 
SET `discount_amount` = `discount_value` 
WHERE `discount_type` = 0 AND `discount_value` IS NOT NULL;

-- 如果 discount_type = 1（赠品）或 2（置换补贴），则迁移到 description
UPDATE `carsale_promotion` 
SET `description` = CONCAT('价值 ¥', `discount_value`, ' 的', 
    CASE `discount_type` 
        WHEN 1 THEN '赠品' 
        WHEN 2 THEN '置换补贴' 
        ELSE '' 
    END)
WHERE (`discount_type` = 1 OR `discount_type` = 2) AND `discount_value` IS NOT NULL;

-- 5.3 删除旧字段 discount_value（可选，建议先保留一段时间用于兼容）
-- ALTER TABLE `carsale_promotion` DROP COLUMN `discount_value`;

-- ============================================
-- 6. 金融方案表
-- ============================================

DROP TABLE IF EXISTS `carsale_finance_plan`;
CREATE TABLE `carsale_finance_plan` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '金融方案ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '方案名称',
  `down_payment_rate` decimal(5, 2) NOT NULL COMMENT '首付比例（如30.00表示30%）',
  `periods` int NOT NULL COMMENT '分期期数（如12、24、36）',
  `interest_rate` decimal(5, 2) NOT NULL COMMENT '年利率（如3.50表示3.5%）',
  `status` int NULL DEFAULT 1 COMMENT '状态：0-停用，1-启用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '金融方案表' ROW_FORMAT = DYNAMIC;

-- 初始化金融方案数据
INSERT INTO `carsale_finance_plan` (`name`, `down_payment_rate`, `periods`, `interest_rate`, `status`) VALUES
('首付30%分12期', 30.00, 12, 3.50, 1),
('首付30%分24期', 30.00, 24, 4.00, 1),
('首付30%分36期', 30.00, 36, 4.50, 1),
('首付50%分12期', 50.00, 12, 3.00, 1),
('首付50%分24期', 50.00, 24, 3.50, 1),
('首付50%分36期', 50.00, 36, 4.00, 1),
('首付70%分12期', 70.00, 12, 2.50, 1),
('首付70%分24期', 70.00, 24, 3.00, 1),
('首付70%分36期', 70.00, 36, 3.50, 1);

-- ============================================
-- 7. 浏览记录表
-- ============================================

DROP TABLE IF EXISTS `carsale_browse_history`;
CREATE TABLE `carsale_browse_history` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '浏览记录ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `vehicle_id` bigint NOT NULL COMMENT '车辆ID',
  `browse_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '浏览时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_vehicle_id`(`vehicle_id`) USING BTREE,
  INDEX `idx_browse_time`(`browse_time`) USING BTREE,
  CONSTRAINT `fk_browse_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_browse_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `carsale_vehicle` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户浏览记录表' ROW_FORMAT = DYNAMIC;

-- ============================================
-- 8. 库存预警订阅表
-- ============================================

DROP TABLE IF EXISTS `carsale_stock_alert`;
CREATE TABLE `carsale_stock_alert` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订阅ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `vehicle_id` bigint NOT NULL COMMENT '车辆ID',
  `status` int NULL DEFAULT 1 COMMENT '状态：0-已取消，1-订阅中',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '订阅时间',
  `notify_time` datetime NULL DEFAULT NULL COMMENT '通知时间（库存补货后）',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_vehicle_id`(`vehicle_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  UNIQUE KEY `uk_user_vehicle` (`user_id`, `vehicle_id`),
  CONSTRAINT `fk_alert_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_alert_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `carsale_vehicle` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '库存预警订阅表' ROW_FORMAT = DYNAMIC;

-- ============================================
-- 执行完成提示
-- ============================================
SELECT '数据库变更完成！' AS message;
SELECT '请检查以下内容：' AS checklist;
SELECT '1. 所有字段已添加' AS item1;
SELECT '2. customer角色已创建' AS item2;
SELECT '3. 索引已添加' AS item3;
SELECT '4. 促销活动表字段已重构' AS item4;
SELECT '5. 请手动配置菜单权限（sys_menu和sys_role_menu表）' AS item5;
