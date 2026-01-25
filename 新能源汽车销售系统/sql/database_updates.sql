-- ============================================
-- 新能源汽车销售系统 - 数据库变更脚本
-- 用于支持管理员和普通用户权限区分及功能完善
-- ============================================

USE `ry-vue`;

-- ============================================
-- 1. 添加字段
-- ============================================

-- 1.1 carsale_orders表 - 添加提车时间字段
ALTER TABLE `carsale_orders` 
ADD COLUMN `pickup_time` datetime NULL DEFAULT NULL COMMENT '提车时间' AFTER `pay_time`;

-- 1.2 carsale_promotion表 - 添加活动状态字段
ALTER TABLE `carsale_promotion` 
ADD COLUMN `status` int NULL DEFAULT 1 COMMENT '活动状态：0-下架，1-上架' AFTER `end_time`;

-- 1.3 carsale_evaluation表 - 添加评价用户ID字段
-- 注意：如果表中已有数据，需要先通过order_id关联更新user_id
ALTER TABLE `carsale_evaluation` 
ADD COLUMN `user_id` bigint NULL COMMENT '评价用户ID' AFTER `id`;

-- 更新已有数据的user_id（通过order_id关联）
UPDATE `carsale_evaluation` e
INNER JOIN `carsale_orders` o ON e.order_id = o.id
SET e.user_id = o.user_id
WHERE e.user_id IS NULL;

-- 将user_id设置为NOT NULL并添加索引和外键
ALTER TABLE `carsale_evaluation` 
MODIFY COLUMN `user_id` bigint NOT NULL COMMENT '评价用户ID',
ADD INDEX `idx_user_id`(`user_id`) USING BTREE,
ADD CONSTRAINT `fk_eval_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- 1.4 carsale_test_drive表 - 添加审核相关字段
ALTER TABLE `carsale_test_drive` 
ADD COLUMN `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间' AFTER `status`,
ADD COLUMN `audit_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审核备注' AFTER `audit_time`;

-- ============================================
-- 2. 创建角色
-- ============================================

-- 2.1 创建普通用户角色（customer）
-- 检查角色是否已存在，如果不存在则创建
INSERT INTO `sys_role` (`role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `dept_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`, `remark`) 
SELECT '普通用户', 'customer', 4, '1', 0, 0, '0', '0', 'admin', NOW(), '购车客户角色'
WHERE NOT EXISTS (SELECT 1 FROM `sys_role` WHERE `role_key` = 'customer');

-- ============================================
-- 3. 添加索引（优化查询性能）
-- ============================================

-- 3.1 carsale_vehicle表 - 添加搜索相关索引
-- 注意：如果索引已存在，执行会报错，可以忽略或手动删除后重新执行
ALTER TABLE `carsale_vehicle` ADD INDEX `idx_brand`(`brand`) USING BTREE;
ALTER TABLE `carsale_vehicle` ADD INDEX `idx_price`(`price`) USING BTREE;
ALTER TABLE `carsale_vehicle` ADD INDEX `idx_range_km`(`range_km`) USING BTREE;
ALTER TABLE `carsale_vehicle` ADD INDEX `idx_battery_type`(`battery_type`) USING BTREE;

-- 3.2 carsale_orders表 - 添加查询和统计相关索引
-- 注意：如果索引已存在，执行会报错，可以忽略或手动删除后重新执行
ALTER TABLE `carsale_orders` ADD INDEX `idx_status`(`status`) USING BTREE;
ALTER TABLE `carsale_orders` ADD INDEX `idx_create_time`(`create_time`) USING BTREE;

-- ============================================
-- 4. 数据初始化（可选）
-- ============================================

-- 4.1 将现有促销活动状态设置为上架（如果status字段刚添加）
UPDATE `carsale_promotion` SET `status` = 1 WHERE `status` IS NULL;

-- ============================================
-- 执行完成提示
-- ============================================
SELECT '数据库变更完成！' AS message;
SELECT '请检查以下内容：' AS checklist;
SELECT '1. 所有字段已添加' AS item1;
SELECT '2. customer角色已创建' AS item2;
SELECT '3. 索引已添加' AS item3;
SELECT '4. 请手动配置菜单权限（sys_menu和sys_role_menu表）' AS item4;
