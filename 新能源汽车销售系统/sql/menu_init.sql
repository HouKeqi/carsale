-- ============================================
-- 新能源汽车销售系统 - 菜单初始化脚本
-- ============================================

USE `ry-vue`;

-- 管理员菜单
-- 车辆管理
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES ('车辆管理', 0, 1, 'vehicle', NULL, 1, 0, 'M', '0', '0', '', 'car', 'admin', NOW(), '', NULL, '车辆管理目录');

SET @vehicle_menu_id = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES ('车辆信息管理', @vehicle_menu_id, 1, 'admin/vehicle', 'carsale/admin/vehicle/index', 1, 0, 'C', '0', '0', 'carsale:vehicle:list', 'list', 'admin', NOW(), '', NULL, '');

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES ('车辆新增', @vehicle_menu_id, 2, '', '', 1, 0, 'F', '0', '0', 'carsale:vehicle:add', '#', 'admin', NOW(), '', NULL, '');

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES ('车辆修改', @vehicle_menu_id, 3, '', '', 1, 0, 'F', '0', '0', 'carsale:vehicle:edit', '#', 'admin', NOW(), '', NULL, '');

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES ('车辆删除', @vehicle_menu_id, 4, '', '', 1, 0, 'F', '0', '0', 'carsale:vehicle:remove', '#', 'admin', NOW(), '', NULL, '');

-- 库存管理
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES ('库存管理', 0, 2, 'inventory', NULL, 1, 0, 'M', '0', '0', '', 'shopping', 'admin', NOW(), '', NULL, '库存管理目录');

SET @inventory_menu_id = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES ('库存预警', @inventory_menu_id, 1, 'admin/inventory', 'carsale/admin/inventory/index', 1, 0, 'C', '0', '0', 'carsale:inventory:list', 'warning', 'admin', NOW(), '', NULL, '');

-- 订单管理
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES ('订单管理', 0, 3, 'order', NULL, 1, 0, 'M', '0', '0', '', 'shopping-cart', 'admin', NOW(), '', NULL, '订单管理目录');

SET @order_menu_id = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES ('订单列表', @order_menu_id, 1, 'admin/order', 'carsale/admin/order/index', 1, 0, 'C', '0', '0', 'carsale:order:list', 'list', 'admin', NOW(), '', NULL, '');

-- 用户管理
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES ('用户管理', 0, 4, 'user', NULL, 1, 0, 'M', '0', '0', '', 'user', 'admin', NOW(), '', NULL, '用户管理目录');

SET @user_menu_id = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES ('用户列表', @user_menu_id, 1, 'admin/user', 'carsale/admin/user/index', 1, 0, 'C', '0', '0', 'carsale:user:list', 'list', 'admin', NOW(), '', NULL, '');

-- 促销活动管理
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES ('促销活动管理', 0, 5, 'promotion', NULL, 1, 0, 'M', '0', '0', '', 'money', 'admin', NOW(), '', NULL, '促销活动管理目录');

SET @promotion_menu_id = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES ('活动列表', @promotion_menu_id, 1, 'admin/promotion', 'carsale/admin/promotion/index', 1, 0, 'C', '0', '0', 'carsale:promotion:list', 'list', 'admin', NOW(), '', NULL, '');

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES ('活动新增', @promotion_menu_id, 2, '', '', 1, 0, 'F', '0', '0', 'carsale:promotion:add', '#', 'admin', NOW(), '', NULL, '');

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES ('活动修改', @promotion_menu_id, 3, '', '', 1, 0, 'F', '0', '0', 'carsale:promotion:edit', '#', 'admin', NOW(), '', NULL, '');

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES ('活动删除', @promotion_menu_id, 4, '', '', 1, 0, 'F', '0', '0', 'carsale:promotion:remove', '#', 'admin', NOW(), '', NULL, '');

-- 数据统计
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES ('数据统计', 0, 6, 'statistics', 'carsale/admin/statistics/index', 1, 0, 'C', '0', '0', 'carsale:statistics:list', 'chart', 'admin', NOW(), '', NULL, '');

-- 试驾审核
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES ('试驾审核', 0, 7, 'testdrive', 'carsale/admin/testdrive/index', 1, 0, 'C', '0', '0', 'carsale:testdrive:list', 'guide', 'admin', NOW(), '', NULL, '');

-- 普通用户菜单
-- 车辆浏览
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES ('车辆浏览', 0, 10, 'vehicle/list', 'carsale/vehicle/list', 1, 0, 'C', '0', '0', '', 'car', 'admin', NOW(), '', NULL, '');

-- 我的订单
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES ('我的订单', 0, 11, 'order/my-list', 'carsale/order/my-list', 1, 0, 'C', '0', '0', '', 'shopping-cart', 'admin', NOW(), '', NULL, '');

-- 我的评价
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES ('我的评价', 0, 12, 'evaluation/my-list', 'carsale/evaluation/my-list', 1, 0, 'C', '0', '0', '', 'star', 'admin', NOW(), '', NULL, '');

-- 预约试驾
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES ('预约试驾', 0, 13, 'testdrive/my-list', 'carsale/testdrive/my-list', 1, 0, 'C', '0', '0', '', 'guide', 'admin', NOW(), '', NULL, '');

-- 个人中心
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES ('个人中心', 0, 14, 'user/profile', 'carsale/user/profile', 1, 0, 'C', '0', '0', '', 'user', 'admin', NOW(), '', NULL, '');

-- 将菜单分配给管理员角色（假设admin角色的role_id为1）
-- 注意：需要根据实际情况调整role_id
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1, menu_id FROM `sys_menu` WHERE `menu_name` IN ('车辆管理', '库存管理', '订单管理', '用户管理', '促销活动管理', '数据统计', '试驾审核')
   OR `parent_id` IN (SELECT menu_id FROM `sys_menu` WHERE `menu_name` IN ('车辆管理', '库存管理', '订单管理', '用户管理', '促销活动管理'));

-- 将菜单分配给普通用户角色（假设customer角色的role_id为4）
-- 注意：需要根据实际情况调整role_id
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 4, menu_id FROM `sys_menu` WHERE `menu_name` IN ('车辆浏览', '我的订单', '我的评价', '预约试驾', '个人中心');

SELECT '菜单初始化完成！' AS message;
SELECT '请检查以下内容：' AS checklist;
SELECT '1. 所有菜单已创建' AS item1;
SELECT '2. 菜单已分配给对应角色' AS item2;
SELECT '3. 请根据实际情况调整role_id' AS item3;
