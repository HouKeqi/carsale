/*
 Navicat Premium Dump SQL

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80032 (8.0.32)
 Source Host           : localhost:3306
 Source Schema         : ry-vue

 Target Server Type    : MySQL
 Target Server Version : 80032 (8.0.32)
 File Encoding         : 65001

 Date: 24/01/2026 20:28:11
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for carsale_evaluation
-- ----------------------------
DROP TABLE IF EXISTS `carsale_evaluation`;
CREATE TABLE `carsale_evaluation`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '评价唯一标识',
  `user_id` bigint NOT NULL COMMENT '评价用户ID',
  `order_id` bigint NOT NULL COMMENT '关联订单',
  `vehicle_id` bigint NOT NULL COMMENT '关联车型',
  `score` int NULL DEFAULT NULL COMMENT '评分(1-5星)',
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '文字评价内容',
  `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '晒单图片URL',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '评价发布时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_id`(`order_id` ASC) USING BTREE,
  INDEX `fk_eval_vehicle`(`vehicle_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_eval_order` FOREIGN KEY (`order_id`) REFERENCES `carsale_orders` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_eval_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_eval_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `carsale_vehicle` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户评价表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of carsale_evaluation
-- ----------------------------
INSERT INTO `carsale_evaluation` VALUES (1, 109, 1769221564341, 9, 5, '好', NULL, NULL);
INSERT INTO `carsale_evaluation` VALUES (2, 109, 1769224584373, 6, 5, '好好好', '[\"https://sky-bucket-for-zdp.oss-cn-beijing.aliyuncs.com/vehicle/2026/01/24/face_default_m_20260124112328A003.jpg\"]', NULL);
INSERT INTO `carsale_evaluation` VALUES (3, 109, 1769225278509, 6, 5, '非常好', '[\"https://sky-bucket-for-zdp.oss-cn-beijing.aliyuncs.com/vehicle/2026/01/24/微信图片_20211210175704_20260124112854A001.jpg\"]', '2026-01-24 11:28:58');

-- ----------------------------
-- Table structure for carsale_orders
-- ----------------------------
DROP TABLE IF EXISTS `carsale_orders`;
CREATE TABLE `carsale_orders`  (
  `id` bigint NOT NULL COMMENT '订单编号(建议雪花算法)',
  `user_id` bigint NOT NULL COMMENT '关联购车用户',
  `vehicle_id` bigint NOT NULL COMMENT '关联购车车型',
  `status` int NULL DEFAULT 0 COMMENT '0-待付, 1-已付, 2-待提, 3-完成, 4-取消',
  `amount` decimal(12, 2) NOT NULL COMMENT '实际成交金额',
  `number` int NOT NULL DEFAULT 1,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `store_location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '提车门店名称',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '下单时间',
  `pay_time` datetime NULL DEFAULT NULL COMMENT '支付完成时间',
  `pickup_time` datetime NULL DEFAULT NULL COMMENT '提车时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_order_user`(`user_id` ASC) USING BTREE,
  INDEX `fk_order_vehicle`(`vehicle_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE,
  CONSTRAINT `fk_order_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_order_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `carsale_vehicle` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '销售订单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of carsale_orders
-- ----------------------------
INSERT INTO `carsale_orders` VALUES (202601130001, 2, 1, 3, 258900.00, 1, NULL, '上海中心门店', '2026-01-19 23:19:14', NULL, '2026-01-24 16:23:59');
INSERT INTO `carsale_orders` VALUES (1769221564341, 109, 9, 3, 215900.00, 1, '13991245952', '门店1', NULL, '2026-01-24 10:47:41', '2026-01-24 11:08:18');
INSERT INTO `carsale_orders` VALUES (1769224584373, 109, 6, 3, 215900.00, 1, '13991245952', '上海中心门店', NULL, '2026-01-24 11:16:27', '2026-01-24 11:17:34');
INSERT INTO `carsale_orders` VALUES (1769225278509, 109, 6, 3, 215900.00, 1, '13991245952', '深圳南山门店', '2026-01-24 11:27:58', '2026-01-24 11:28:00', '2026-01-24 11:28:20');

-- ----------------------------
-- Table structure for carsale_promotion
-- ----------------------------
DROP TABLE IF EXISTS `carsale_promotion`;
CREATE TABLE `carsale_promotion`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '活动唯一标识',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '活动名称',
  `vehicle_id` bigint NOT NULL COMMENT '关联特定车型',
  `discount_type` int NULL DEFAULT NULL COMMENT '0-直降, 1-赠品, 2-置换补贴',
  `discount_value` decimal(12, 2) NULL DEFAULT NULL COMMENT '优惠金额或价值描述',
  `start_time` datetime NULL DEFAULT NULL COMMENT '有效期开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '有效期结束时间',
  `status` int NULL DEFAULT 1 COMMENT '活动状态：0-下架，1-上架',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_promotion_vehicle`(`vehicle_id` ASC) USING BTREE,
  CONSTRAINT `fk_promotion_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `carsale_vehicle` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '促销活动管理表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of carsale_promotion
-- ----------------------------
INSERT INTO `carsale_promotion` VALUES (1, '春季购车送桩', 1, 1, 3000.00, '2026-01-01 00:00:00', '2026-03-31 00:00:00', 1);
INSERT INTO `carsale_promotion` VALUES (2, '春季购车送桩', 1, 1, 3000.00, '2026-01-01 00:00:00', '2026-03-31 00:00:00', 1);
INSERT INTO `carsale_promotion` VALUES (3, '春季购车送桩', 1, 1, 3000.00, '2026-01-01 00:00:00', '2026-03-31 00:00:00', 1);
INSERT INTO `carsale_promotion` VALUES (4, '活动1', 10, 0, 1000.00, '2026-01-24 16:27:44', '2026-01-31 16:27:36', 1);

-- ----------------------------
-- Table structure for carsale_store
-- ----------------------------
DROP TABLE IF EXISTS `carsale_store`;
CREATE TABLE `carsale_store`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '门店ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '门店名称',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '门店地址',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `status` int NULL DEFAULT 1 COMMENT '状态：0-停用，1-启用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '门店表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of carsale_store
-- ----------------------------
INSERT INTO `carsale_store` VALUES (1, '上海中心门店', '上海市黄浦区南京东路100号', '021-12345678', 1, '2026-01-24 10:56:09', '2026-01-24 10:56:09');
INSERT INTO `carsale_store` VALUES (2, '北京朝阳门店', '北京市朝阳区建国路88号', '010-87654321', 1, '2026-01-24 10:56:09', '2026-01-24 10:56:09');
INSERT INTO `carsale_store` VALUES (3, '深圳南山门店', '深圳市南山区科技园南路200号', '0755-11223344', 1, '2026-01-24 10:56:09', '2026-01-24 10:56:09');
INSERT INTO `carsale_store` VALUES (4, '广州天河门店', '广州市天河区天河路500号', '020-55667788', 1, '2026-01-24 10:56:09', '2026-01-24 10:56:09');

-- ----------------------------
-- Table structure for carsale_test_drive
-- ----------------------------
DROP TABLE IF EXISTS `carsale_test_drive`;
CREATE TABLE `carsale_test_drive`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '预约唯一标识',
  `user_id` bigint NOT NULL COMMENT '预约用户',
  `vehicle_id` bigint NOT NULL COMMENT '意向车型',
  `store_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '预约门店',
  `appoint_time` datetime NULL DEFAULT NULL COMMENT '用户选择的试驾时间',
  `status` int NULL DEFAULT 0 COMMENT '0-待审核, 1-通过, 2-拒绝',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `audit_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审核备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_test_user`(`user_id` ASC) USING BTREE,
  INDEX `fk_test_vehicle`(`vehicle_id` ASC) USING BTREE,
  CONSTRAINT `fk_test_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_test_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `carsale_vehicle` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '试驾预约管理表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of carsale_test_drive
-- ----------------------------
INSERT INTO `carsale_test_drive` VALUES (1, 109, 6, '门店1', '2026-01-30 10:24:59', 1, '2026-01-24 10:25:24', '可以');

-- ----------------------------
-- Table structure for carsale_vehicle
-- ----------------------------
DROP TABLE IF EXISTS `carsale_vehicle`;
CREATE TABLE `carsale_vehicle`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '车辆唯一标识',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '车型名称',
  `brand` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '品牌名称',
  `price` decimal(12, 2) NOT NULL COMMENT '指导价',
  `battery_type` int NOT NULL COMMENT '电池类型',
  `range_km` int NULL DEFAULT NULL COMMENT '续航里程(km)',
  `stock` int NULL DEFAULT 0 COMMENT '库存数量',
  `launch_date` date NULL DEFAULT NULL COMMENT '上市时间',
  `config_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '配置参数(快充、智驾等JSON)',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '车辆详情描述',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '车辆封面图片路径',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_brand`(`brand` ASC) USING BTREE,
  INDEX `idx_price`(`price` ASC) USING BTREE,
  INDEX `idx_range_km`(`range_km` ASC) USING BTREE,
  INDEX `idx_battery_type`(`battery_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '车辆信息基础表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of carsale_vehicle
-- ----------------------------
INSERT INTO `carsale_vehicle` VALUES (1, 'Model 3', 'Tesla', 258900.00, 0, 606, 12, '2023-09-01', '{\"fast_charge\":\"0.5h\",\"ai_level\":\"L2\"}', NULL, 'https://sky-bucket-for-zdp.oss-cn-beijing.aliyuncs.com/vehicle/2026/01/24/Tesla Model_20260124172832A003.png');
INSERT INTO `carsale_vehicle` VALUES (6, 'SU7', 'Xiaomi', 215900.00, 2, 700, 0, '2024-03-28', '{\"fast_charge\":\"0.35h\", \"ai_level\":\"L3\"}', NULL, NULL);
INSERT INTO `carsale_vehicle` VALUES (8, '汉 EV', 'BYD', 221800.00, 1, 715, 3, '2023-03-20', '{\"fast_charge\":\"0.42h\",\"ai_level\":\"L2\"}', NULL, 'https://sky-bucket-for-zdp.oss-cn-beijing.aliyuncs.com/vehicle/2026/01/24/比亚迪汉EV_20260124172816A002.png');
INSERT INTO `carsale_vehicle` VALUES (9, 'SU7', 'Xiaomi', 215900.00, 2, 700, 2, '2024-03-28', '{\"fast_charge\":\"0.35h\",\"ai_level\":\"L3\"}', NULL, 'https://sky-bucket-for-zdp.oss-cn-beijing.aliyuncs.com/vehicle/2026/01/24/小米su7_20260124172804A001.png');
INSERT INTO `carsale_vehicle` VALUES (10, '车型1', '品牌1', 10000.00, 0, 10000, 100, '2026-01-24', '{\"fast_charge\":\"0.5h\",\"ai_level\":\"L2\"}', '111', 'https://sky-bucket-for-zdp.oss-cn-beijing.aliyuncs.com/vehicle/2026/01/24/小米su7_20260124161130A001.png');

-- ----------------------------
-- Table structure for carsale_vehicle_copy1
-- ----------------------------
DROP TABLE IF EXISTS `carsale_vehicle_copy1`;
CREATE TABLE `carsale_vehicle_copy1`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '车辆唯一标识',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '车型名称',
  `brand` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '品牌名称',
  `price` decimal(12, 2) NOT NULL COMMENT '指导价',
  `battery_type` int NOT NULL COMMENT '电池类型',
  `range_km` int NULL DEFAULT NULL COMMENT '续航里程(km)',
  `stock` int NULL DEFAULT 0 COMMENT '库存数量',
  `launch_date` date NULL DEFAULT NULL COMMENT '上市时间',
  `config_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '配置参数(快充、智驾等JSON)',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '车辆详情描述',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '车辆封面图片路径',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '车辆信息基础表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of carsale_vehicle_copy1
-- ----------------------------
INSERT INTO `carsale_vehicle_copy1` VALUES (1, 'Model 3', 'Tesla', 258900.00, 0, 606, 12, '2023-09-01', '{\"fast_charge\":\"0.5h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy1` VALUES (2, '汉 EV', 'BYD', 221800.00, 1, 715, 3, '2023-03-20', '{\"fast_charge\":\"0.42h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy1` VALUES (3, 'SU7', 'Xiaomi', 215900.00, 2, 700, 2, '2024-03-28', '{\"fast_charge\":\"0.35h\", \"ai_level\":\"L3\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy1` VALUES (4, 'Model 3', 'Tesla', 258900.00, 0, 606, 12, '2023-09-01', '{\"fast_charge\":\"0.5h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy1` VALUES (5, '汉 EV', 'BYD', 221800.00, 1, 715, 3, '2023-03-20', '{\"fast_charge\":\"0.42h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy1` VALUES (6, 'SU7', 'Xiaomi', 215900.00, 2, 700, 2, '2024-03-28', '{\"fast_charge\":\"0.35h\", \"ai_level\":\"L3\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy1` VALUES (7, 'Model 3', 'Tesla', 258900.00, 0, 606, 12, '2023-09-01', '{\"fast_charge\":\"0.5h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy1` VALUES (8, '汉 EV', 'BYD', 221800.00, 1, 715, 3, '2023-03-20', '{\"fast_charge\":\"0.42h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy1` VALUES (9, 'SU7', 'Xiaomi', 215900.00, 2, 700, 2, '2024-03-28', '{\"fast_charge\":\"0.35h\", \"ai_level\":\"L3\"}', NULL, NULL);

-- ----------------------------
-- Table structure for carsale_vehicle_copy2
-- ----------------------------
DROP TABLE IF EXISTS `carsale_vehicle_copy2`;
CREATE TABLE `carsale_vehicle_copy2`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '车辆唯一标识',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '车型名称',
  `brand` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '品牌名称',
  `price` decimal(12, 2) NOT NULL COMMENT '指导价',
  `battery_type` int NOT NULL COMMENT '电池类型',
  `range_km` int NULL DEFAULT NULL COMMENT '续航里程(km)',
  `stock` int NULL DEFAULT 0 COMMENT '库存数量',
  `launch_date` date NULL DEFAULT NULL COMMENT '上市时间',
  `config_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '配置参数(快充、智驾等JSON)',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '车辆详情描述',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '车辆封面图片路径',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '车辆信息基础表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of carsale_vehicle_copy2
-- ----------------------------
INSERT INTO `carsale_vehicle_copy2` VALUES (1, 'Model 3', 'Tesla', 258900.00, 0, 606, 12, '2023-09-01', '{\"fast_charge\":\"0.5h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy2` VALUES (2, '汉 EV', 'BYD', 221800.00, 1, 715, 3, '2023-03-20', '{\"fast_charge\":\"0.42h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy2` VALUES (3, 'SU7', 'Xiaomi', 215900.00, 2, 700, 2, '2024-03-28', '{\"fast_charge\":\"0.35h\", \"ai_level\":\"L3\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy2` VALUES (4, 'Model 3', 'Tesla', 258900.00, 0, 606, 12, '2023-09-01', '{\"fast_charge\":\"0.5h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy2` VALUES (5, '汉 EV', 'BYD', 221800.00, 1, 715, 3, '2023-03-20', '{\"fast_charge\":\"0.42h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy2` VALUES (6, 'SU7', 'Xiaomi', 215900.00, 2, 700, 2, '2024-03-28', '{\"fast_charge\":\"0.35h\", \"ai_level\":\"L3\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy2` VALUES (7, 'Model 3', 'Tesla', 258900.00, 0, 606, 12, '2023-09-01', '{\"fast_charge\":\"0.5h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy2` VALUES (8, '汉 EV', 'BYD', 221800.00, 1, 715, 3, '2023-03-20', '{\"fast_charge\":\"0.42h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy2` VALUES (9, 'SU7', 'Xiaomi', 215900.00, 2, 700, 2, '2024-03-28', '{\"fast_charge\":\"0.35h\", \"ai_level\":\"L3\"}', NULL, NULL);

-- ----------------------------
-- Table structure for carsale_vehicle_copy3
-- ----------------------------
DROP TABLE IF EXISTS `carsale_vehicle_copy3`;
CREATE TABLE `carsale_vehicle_copy3`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '车辆唯一标识',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '车型名称',
  `brand` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '品牌名称',
  `price` decimal(12, 2) NOT NULL COMMENT '指导价',
  `battery_type` int NOT NULL COMMENT '电池类型',
  `range_km` int NULL DEFAULT NULL COMMENT '续航里程(km)',
  `stock` int NULL DEFAULT 0 COMMENT '库存数量',
  `launch_date` date NULL DEFAULT NULL COMMENT '上市时间',
  `config_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '配置参数(快充、智驾等JSON)',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '车辆详情描述',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '车辆封面图片路径',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '车辆信息基础表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of carsale_vehicle_copy3
-- ----------------------------
INSERT INTO `carsale_vehicle_copy3` VALUES (1, 'Model 3', 'Tesla', 258900.00, 0, 606, 12, '2023-09-01', '{\"fast_charge\":\"0.5h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy3` VALUES (2, '汉 EV', 'BYD', 221800.00, 1, 715, 3, '2023-03-20', '{\"fast_charge\":\"0.42h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy3` VALUES (3, 'SU7', 'Xiaomi', 215900.00, 2, 700, 2, '2024-03-28', '{\"fast_charge\":\"0.35h\", \"ai_level\":\"L3\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy3` VALUES (4, 'Model 3', 'Tesla', 258900.00, 0, 606, 12, '2023-09-01', '{\"fast_charge\":\"0.5h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy3` VALUES (5, '汉 EV', 'BYD', 221800.00, 1, 715, 3, '2023-03-20', '{\"fast_charge\":\"0.42h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy3` VALUES (6, 'SU7', 'Xiaomi', 215900.00, 2, 700, 2, '2024-03-28', '{\"fast_charge\":\"0.35h\", \"ai_level\":\"L3\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy3` VALUES (7, 'Model 3', 'Tesla', 258900.00, 0, 606, 12, '2023-09-01', '{\"fast_charge\":\"0.5h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy3` VALUES (8, '汉 EV', 'BYD', 221800.00, 1, 715, 3, '2023-03-20', '{\"fast_charge\":\"0.42h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy3` VALUES (9, 'SU7', 'Xiaomi', 215900.00, 2, 700, 2, '2024-03-28', '{\"fast_charge\":\"0.35h\", \"ai_level\":\"L3\"}', NULL, NULL);

-- ----------------------------
-- Table structure for carsale_vehicle_copy4
-- ----------------------------
DROP TABLE IF EXISTS `carsale_vehicle_copy4`;
CREATE TABLE `carsale_vehicle_copy4`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '车辆唯一标识',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '车型名称',
  `brand` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '品牌名称',
  `price` decimal(12, 2) NOT NULL COMMENT '指导价',
  `battery_type` int NOT NULL COMMENT '电池类型',
  `range_km` int NULL DEFAULT NULL COMMENT '续航里程(km)',
  `stock` int NULL DEFAULT 0 COMMENT '库存数量',
  `launch_date` date NULL DEFAULT NULL COMMENT '上市时间',
  `config_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '配置参数(快充、智驾等JSON)',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '车辆详情描述',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '车辆封面图片路径',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '车辆信息基础表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of carsale_vehicle_copy4
-- ----------------------------
INSERT INTO `carsale_vehicle_copy4` VALUES (1, 'Model 3', 'Tesla', 258900.00, 0, 606, 12, '2023-09-01', '{\"fast_charge\":\"0.5h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy4` VALUES (2, '汉 EV', 'BYD', 221800.00, 1, 715, 3, '2023-03-20', '{\"fast_charge\":\"0.42h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy4` VALUES (3, 'SU7', 'Xiaomi', 215900.00, 2, 700, 2, '2024-03-28', '{\"fast_charge\":\"0.35h\", \"ai_level\":\"L3\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy4` VALUES (4, 'Model 3', 'Tesla', 258900.00, 0, 606, 12, '2023-09-01', '{\"fast_charge\":\"0.5h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy4` VALUES (5, '汉 EV', 'BYD', 221800.00, 1, 715, 3, '2023-03-20', '{\"fast_charge\":\"0.42h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy4` VALUES (6, 'SU7', 'Xiaomi', 215900.00, 2, 700, 2, '2024-03-28', '{\"fast_charge\":\"0.35h\", \"ai_level\":\"L3\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy4` VALUES (7, 'Model 3', 'Tesla', 258900.00, 0, 606, 12, '2023-09-01', '{\"fast_charge\":\"0.5h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy4` VALUES (8, '汉 EV', 'BYD', 221800.00, 1, 715, 3, '2023-03-20', '{\"fast_charge\":\"0.42h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy4` VALUES (9, 'SU7', 'Xiaomi', 215900.00, 2, 700, 2, '2024-03-28', '{\"fast_charge\":\"0.35h\", \"ai_level\":\"L3\"}', NULL, NULL);

-- ----------------------------
-- Table structure for carsale_vehicle_copy5
-- ----------------------------
DROP TABLE IF EXISTS `carsale_vehicle_copy5`;
CREATE TABLE `carsale_vehicle_copy5`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '车辆唯一标识',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '车型名称',
  `brand` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '品牌名称',
  `price` decimal(12, 2) NOT NULL COMMENT '指导价',
  `battery_type` int NOT NULL COMMENT '电池类型',
  `range_km` int NULL DEFAULT NULL COMMENT '续航里程(km)',
  `stock` int NULL DEFAULT 0 COMMENT '库存数量',
  `launch_date` date NULL DEFAULT NULL COMMENT '上市时间',
  `config_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '配置参数(快充、智驾等JSON)',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '车辆详情描述',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '车辆封面图片路径',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '车辆信息基础表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of carsale_vehicle_copy5
-- ----------------------------
INSERT INTO `carsale_vehicle_copy5` VALUES (1, 'Model 3', 'Tesla', 258900.00, 0, 606, 12, '2023-09-01', '{\"fast_charge\":\"0.5h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy5` VALUES (2, '汉 EV', 'BYD', 221800.00, 1, 715, 3, '2023-03-20', '{\"fast_charge\":\"0.42h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy5` VALUES (3, 'SU7', 'Xiaomi', 215900.00, 2, 700, 2, '2024-03-28', '{\"fast_charge\":\"0.35h\", \"ai_level\":\"L3\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy5` VALUES (4, 'Model 3', 'Tesla', 258900.00, 0, 606, 12, '2023-09-01', '{\"fast_charge\":\"0.5h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy5` VALUES (5, '汉 EV', 'BYD', 221800.00, 1, 715, 3, '2023-03-20', '{\"fast_charge\":\"0.42h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy5` VALUES (6, 'SU7', 'Xiaomi', 215900.00, 2, 700, 2, '2024-03-28', '{\"fast_charge\":\"0.35h\", \"ai_level\":\"L3\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy5` VALUES (7, 'Model 3', 'Tesla', 258900.00, 0, 606, 12, '2023-09-01', '{\"fast_charge\":\"0.5h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy5` VALUES (8, '汉 EV', 'BYD', 221800.00, 1, 715, 3, '2023-03-20', '{\"fast_charge\":\"0.42h\", \"ai_level\":\"L2\"}', NULL, NULL);
INSERT INTO `carsale_vehicle_copy5` VALUES (9, 'SU7', 'Xiaomi', 215900.00, 2, 700, 2, '2024-03-28', '{\"fast_charge\":\"0.35h\", \"ai_level\":\"L3\"}', NULL, NULL);

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table` VALUES (1, 'mes_product', '制造执行MES-产品建模表', NULL, NULL, 'MesProduct', 'crud', 'element-ui', 'com.ruoyi.mes', 'mes', 'product', '产品建模', 'ruoyi', '0', '/', '{\"parentMenuId\":2000}', 'admin', '2024-07-02 09:55:10', '', '2024-07-02 10:02:23', NULL);
INSERT INTO `gen_table` VALUES (2, 'wms_material', '智能仓储WMS-物料档案表', NULL, NULL, 'WmsMaterial', 'crud', 'element-ui', 'com.ruoyi.mes', 'mes', 'material', '物料档案', 'ruoyi', '0', '/', '{\"parentMenuId\":2000}', 'admin', '2024-07-02 11:04:01', '', '2024-07-02 11:05:08', NULL);
INSERT INTO `gen_table` VALUES (3, 'mes_device_information', '制造执行MES-设备信息表', NULL, NULL, 'MesDeviceInformation', 'crud', '', 'com.ruoyi.system', 'system', 'information', '制造执行MES-设备信息', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-02 14:26:49', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (4, 'mes_factory', '制造执行MES-工厂建模表', 'mes_factory_device_item', 'factory_id', 'MesFactory', 'sub', 'element-ui', 'com.ruoyi.mes', 'mes', 'factory', '工厂建模', 'ruoyi', '0', '/', '{\"parentMenuId\":2000}', 'admin', '2024-07-02 14:26:49', '', '2024-07-02 14:29:09', NULL);
INSERT INTO `gen_table` VALUES (5, 'mes_factory_device_item', '制造执行MES-工厂建模设备信息子表', NULL, NULL, 'MesFactoryDeviceItem', 'crud', '', 'com.ruoyi.system', 'system', 'item', '制造执行MES-工厂建模设备信息子', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-02 14:26:49', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (6, 'plat_user', '用户信息表', NULL, NULL, 'PlatUser', 'crud', 'element-ui', 'com.ruoyi.platform', 'platform', 'user', '用户信息', 'ruoyi', '0', '/', '{}', 'admin', '2024-07-03 09:40:58', '', '2024-07-03 09:41:41', NULL);
INSERT INTO `gen_table` VALUES (7, 'plat_paper', '论文管理表', NULL, NULL, 'PlatPaper', 'crud', 'element-ui', 'com.ruoyi.platform', 'platform', 'paperManage', '论文管理', 'ruoyi', '0', '/', '{}', 'admin', '2024-07-03 15:01:42', '', '2024-07-03 15:42:25', NULL);
INSERT INTO `gen_table` VALUES (9, 'plat_select_paper', '学生选择的3个课题号', NULL, NULL, 'PlatSelectPaper', 'crud', 'element-ui', 'com.ruoyi.platform', 'platform', 'selectPaper', '学生选择的3个课题号', 'ruoyi', '0', '/', '{}', 'admin', '2024-07-04 09:50:36', '', '2024-07-04 09:53:37', NULL);
INSERT INTO `gen_table` VALUES (10, 'plat_opening', '开题报告表', NULL, NULL, 'PlatOpening', 'crud', 'element-ui', 'com.ruoyi.paperUpload', 'paperUpload', 'paperUpload', '开题报告', 'ruoyi', '0', '/', '{}', 'admin', '2024-07-06 08:55:32', '', '2024-07-06 09:11:28', NULL);
INSERT INTO `gen_table` VALUES (11, 'vehicle', '车辆信息基础表', NULL, NULL, 'Vehicle', 'crud', '', 'com.ruoyi.system', 'system', 'vehicle', '车辆信息基础', 'ruoyi', '0', '/', NULL, 'admin', '2026-01-19 23:33:38', '', NULL, NULL);

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 80 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
INSERT INTO `gen_table_column` VALUES (1, 1, 'id', '模型编号', 'bigint unsigned', 'Long', 'id', '1', '1', '0', '0', NULL, '1', NULL, 'EQ', NULL, '', 1, 'admin', '2024-07-02 09:55:10', '', '2024-07-02 10:02:23');
INSERT INTO `gen_table_column` VALUES (2, 1, 'mode_name', '模型名称', 'varchar(255)', 'String', 'modeName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2024-07-02 09:55:10', '', '2024-07-02 10:02:23');
INSERT INTO `gen_table_column` VALUES (3, 1, 'material_id', '产品ID', 'bigint', 'Long', 'materialId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', '', 3, 'admin', '2024-07-02 09:55:10', '', '2024-07-02 10:02:23');
INSERT INTO `gen_table_column` VALUES (4, 1, 'remark', '备注', 'longtext', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'textarea', '', 4, 'admin', '2024-07-02 09:55:10', '', '2024-07-02 10:02:23');
INSERT INTO `gen_table_column` VALUES (5, 2, 'id', '物料档案ID', 'bigint unsigned', 'String', 'id', '1', '1', '0', '0', NULL, NULL, NULL, 'EQ', NULL, '', 1, 'admin', '2024-07-02 11:04:01', '', '2024-07-02 11:05:08');
INSERT INTO `gen_table_column` VALUES (6, 2, 'classify_id', '物料分类ID', 'bigint', 'Long', 'classifyId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-02 11:04:01', '', '2024-07-02 11:05:08');
INSERT INTO `gen_table_column` VALUES (7, 2, 'material_code', '物料编码', 'varchar(255)', 'String', 'materialCode', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-02 11:04:01', '', '2024-07-02 11:05:08');
INSERT INTO `gen_table_column` VALUES (8, 2, 'material_name', '物料名称', 'varchar(255)', 'String', 'materialName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2024-07-02 11:04:01', '', '2024-07-02 11:05:08');
INSERT INTO `gen_table_column` VALUES (9, 2, 'material_model', '型号', 'varchar(255)', 'String', 'materialModel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-02 11:04:02', '', '2024-07-02 11:05:08');
INSERT INTO `gen_table_column` VALUES (10, 2, 'material_specifications', '规格', 'varchar(255)', 'String', 'materialSpecifications', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-02 11:04:02', '', '2024-07-02 11:05:08');
INSERT INTO `gen_table_column` VALUES (11, 2, 'material_unit', '单位', 'varchar(255)', 'String', 'materialUnit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-02 11:04:02', '', '2024-07-02 11:05:08');
INSERT INTO `gen_table_column` VALUES (12, 2, 'material_price', '单价', 'decimal(10,2)', 'BigDecimal', 'materialPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-02 11:04:02', '', '2024-07-02 11:05:08');
INSERT INTO `gen_table_column` VALUES (13, 2, 'material_type', '类型', 'bigint', 'Long', 'materialType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 9, 'admin', '2024-07-02 11:04:02', '', '2024-07-02 11:05:08');
INSERT INTO `gen_table_column` VALUES (14, 2, 'remark', '备注', 'varchar(255)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'input', '', 10, 'admin', '2024-07-02 11:04:02', '', '2024-07-02 11:05:08');
INSERT INTO `gen_table_column` VALUES (15, 3, 'id', '编号', 'bigint', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-02 14:26:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (16, 3, 'device_name', '设备名称', 'varchar(255)', 'String', 'deviceName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2024-07-02 14:26:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (17, 3, 'device_code', '设备编码', 'varchar(255)', 'String', 'deviceCode', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-02 14:26:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (18, 3, 'device_model', '设备型号', 'varchar(255)', 'String', 'deviceModel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-02 14:26:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (19, 3, 'produce_date', '生产日期', 'date', 'Date', 'produceDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 5, 'admin', '2024-07-02 14:26:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (20, 3, 'produce_code', '生产批号', 'varchar(255)', 'String', 'produceCode', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-02 14:26:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (21, 3, 'manufacturer', '制造商', 'varchar(255)', 'String', 'manufacturer', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-02 14:26:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (22, 3, 'device_status', '设备状态：0:空闲,1:使用中,2:故障', 'tinyint', 'Long', 'deviceStatus', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 8, 'admin', '2024-07-02 14:26:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (23, 3, 'remark', '备注', 'varchar(255)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'input', '', 9, 'admin', '2024-07-02 14:26:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (24, 4, 'id', '编号', 'bigint unsigned', 'Long', 'id', '1', '1', '0', '0', NULL, '1', NULL, 'EQ', NULL, '', 1, 'admin', '2024-07-02 14:26:49', '', '2024-07-02 14:29:09');
INSERT INTO `gen_table_column` VALUES (25, 4, 'production_line', '生产线名称', 'varchar(255)', 'String', 'productionLine', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-02 14:26:49', '', '2024-07-02 14:29:09');
INSERT INTO `gen_table_column` VALUES (26, 4, 'factory_describe', '描述', 'varchar(255)', 'String', 'factoryDescribe', '0', '0', '0', '1', '1', '1', '0', 'EQ', 'input', '', 3, 'admin', '2024-07-02 14:26:49', '', '2024-07-02 14:29:09');
INSERT INTO `gen_table_column` VALUES (27, 4, 'material_id', '物料ID', 'bigint', 'Long', 'materialId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-02 14:26:49', '', '2024-07-02 14:29:09');
INSERT INTO `gen_table_column` VALUES (28, 5, 'id', '序号', 'bigint unsigned', 'String', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', NULL, '', 1, 'admin', '2024-07-02 14:26:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (29, 5, 'factory_id', '工厂建模ID', 'bigint', 'Long', 'factoryId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-02 14:26:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (30, 5, 'device_id', '设备ID', 'bigint', 'Long', 'deviceId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-02 14:26:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (31, 6, 'id', '主键ID', 'int', 'Long', 'id', '1', '1', '0', '0', NULL, NULL, '1', 'EQ', 'input', '', 1, 'admin', '2024-07-03 09:40:58', '', '2024-07-03 09:41:41');
INSERT INTO `gen_table_column` VALUES (32, 6, 'name', '姓名', 'varchar(255)', 'String', 'name', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2024-07-03 09:40:58', '', '2024-07-03 09:41:41');
INSERT INTO `gen_table_column` VALUES (33, 6, 'password', '密码', 'varchar(255)', 'String', 'password', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-03 09:40:58', '', '2024-07-03 09:41:41');
INSERT INTO `gen_table_column` VALUES (34, 6, 'student_id', '学号', 'varchar(255)', 'String', 'studentId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-03 09:40:58', '', '2024-07-03 09:41:41');
INSERT INTO `gen_table_column` VALUES (35, 6, 'phone', '电话', 'varchar(255)', 'String', 'phone', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-03 09:40:58', '', '2024-07-03 09:41:41');
INSERT INTO `gen_table_column` VALUES (36, 6, 'qq', 'QQ号', 'varchar(255)', 'String', 'qq', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-03 09:40:58', '', '2024-07-03 09:41:41');
INSERT INTO `gen_table_column` VALUES (37, 6, 'email', '邮箱', 'varchar(255)', 'String', 'email', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-03 09:40:58', '', '2024-07-03 09:41:41');
INSERT INTO `gen_table_column` VALUES (38, 6, 'role', '角色', 'varchar(255)', 'String', 'role', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-03 09:40:58', '', '2024-07-03 09:41:41');
INSERT INTO `gen_table_column` VALUES (39, 6, 'select_1', '选题一', 'int', 'Long', 'select1', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-03 09:40:58', '', '2024-07-03 09:41:41');
INSERT INTO `gen_table_column` VALUES (40, 6, 'select_2', '选题二', 'int', 'Long', 'select2', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-03 09:40:58', '', '2024-07-03 09:41:41');
INSERT INTO `gen_table_column` VALUES (41, 6, 'select_3', '选题三', 'int', 'Long', 'select3', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-03 09:40:58', '', '2024-07-03 09:41:41');
INSERT INTO `gen_table_column` VALUES (42, 7, 'id', '主键ID', 'int', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-03 15:01:42', '', '2024-07-03 15:42:25');
INSERT INTO `gen_table_column` VALUES (43, 7, 'topic', '题目', 'varchar(255)', 'String', 'topic', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-03 15:01:42', '', '2024-07-03 15:42:25');
INSERT INTO `gen_table_column` VALUES (44, 7, 'type', '类型', 'varchar(255)', 'String', 'type', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 3, 'admin', '2024-07-03 15:01:42', '', '2024-07-03 15:42:25');
INSERT INTO `gen_table_column` VALUES (45, 7, 'ask', '要求', 'varchar(255)', 'String', 'ask', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-03 15:01:42', '', '2024-07-03 15:42:25');
INSERT INTO `gen_table_column` VALUES (46, 7, 'code', '论文状态码', 'varchar(255)', 'String', 'code', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-03 15:01:42', '', '2024-07-03 15:42:25');
INSERT INTO `gen_table_column` VALUES (47, 7, 'teacher_name', '教师姓名', 'varchar(255)', 'String', 'teacherName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2024-07-03 15:01:42', '', '2024-07-03 15:42:25');
INSERT INTO `gen_table_column` VALUES (48, 7, 'teacher_phone', '教师电话', 'varchar(255)', 'String', 'teacherPhone', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-03 15:01:42', '', '2024-07-03 15:42:25');
INSERT INTO `gen_table_column` VALUES (49, 7, 'bond', '绑定的学生学号', 'varchar(255)', 'String', 'bond', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-03 15:01:42', '', '2024-07-03 15:42:25');
INSERT INTO `gen_table_column` VALUES (50, 7, 'grade_instruct', '指导成绩', 'varchar(255)', 'String', 'gradeInstruct', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-03 15:01:42', '', '2024-07-03 15:42:25');
INSERT INTO `gen_table_column` VALUES (51, 7, 'grade_review', '评阅成绩', 'varchar(255)', 'String', 'gradeReview', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-03 15:01:42', '', '2024-07-03 15:42:25');
INSERT INTO `gen_table_column` VALUES (52, 7, 'grade_defence', '答辩成绩', 'varchar(255)', 'String', 'gradeDefence', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-03 15:01:42', '', '2024-07-03 15:42:25');
INSERT INTO `gen_table_column` VALUES (53, 7, 'grade', '最终成绩', 'varchar(255)', 'String', 'grade', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-03 15:01:42', '', '2024-07-03 15:42:25');
INSERT INTO `gen_table_column` VALUES (59, 9, 'id', NULL, 'int', 'Long', 'id', '1', '1', '0', '0', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-04 09:50:36', '', '2024-07-04 09:53:37');
INSERT INTO `gen_table_column` VALUES (60, 9, 'user_id', '学生学号', 'varchar(255)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-04 09:50:36', '', '2024-07-04 09:53:37');
INSERT INTO `gen_table_column` VALUES (61, 9, 'select_id_1', '学生选择的论文id1', 'int', 'Long', 'selectId1', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-04 09:50:36', '', '2024-07-04 09:53:37');
INSERT INTO `gen_table_column` VALUES (62, 9, 'select_id_2', '学生选择的论文id2', 'int', 'Long', 'selectId2', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-04 09:50:36', '', '2024-07-04 09:53:37');
INSERT INTO `gen_table_column` VALUES (63, 9, 'select_id_3', '学生选择的论文id3', 'int', 'Long', 'selectId3', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-04 09:50:36', '', '2024-07-04 09:53:37');
INSERT INTO `gen_table_column` VALUES (64, 10, 'id', '主键ID', 'int', 'Long', 'id', '1', '1', '0', '0', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-06 08:55:32', '', '2024-07-06 09:11:28');
INSERT INTO `gen_table_column` VALUES (65, 10, 'opening', '开题报告', 'varchar(255)', 'String', 'opening', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-06 08:55:32', '', '2024-07-06 09:11:28');
INSERT INTO `gen_table_column` VALUES (66, 10, 'status', '状态', 'varchar(255)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 3, 'admin', '2024-07-06 08:55:32', '', '2024-07-06 09:11:28');
INSERT INTO `gen_table_column` VALUES (67, 10, 'name', '提交者姓名', 'varchar(255)', 'String', 'name', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2024-07-06 08:55:32', '', '2024-07-06 09:11:28');
INSERT INTO `gen_table_column` VALUES (68, 10, 'student_id', '提交者学号', 'varchar(255)', 'String', 'studentId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-06 08:55:32', '', '2024-07-06 09:11:28');
INSERT INTO `gen_table_column` VALUES (69, 11, 'id', '车辆唯一标识', 'bigint', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2026-01-19 23:33:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (70, 11, 'name', '车型名称', 'varchar(100)', 'String', 'name', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2026-01-19 23:33:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (71, 11, 'brand', '品牌名称', 'varchar(50)', 'String', 'brand', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2026-01-19 23:33:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (72, 11, 'price', '指导价', 'decimal(12,2)', 'BigDecimal', 'price', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2026-01-19 23:33:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (73, 11, 'battery_type', '电池类型', 'int', 'Long', 'batteryType', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', '', 5, 'admin', '2026-01-19 23:33:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (74, 11, 'range_km', '续航里程(km)', 'int', 'Long', 'rangeKm', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2026-01-19 23:33:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (75, 11, 'stock', '库存数量', 'int', 'Long', 'stock', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2026-01-19 23:33:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (76, 11, 'launch_date', '上市时间', 'date', 'Date', 'launchDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 8, 'admin', '2026-01-19 23:33:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (77, 11, 'config_json', '配置参数(快充、智驾等JSON)', 'text', 'String', 'configJson', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 9, 'admin', '2026-01-19 23:33:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (78, 11, 'description', '车辆详情描述', 'text', 'String', 'description', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 10, 'admin', '2026-01-19 23:33:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (79, 11, 'image_url', '车辆封面图片路径', 'varchar(255)', 'String', 'imageUrl', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2026-01-19 23:33:38', '', NULL);

-- ----------------------------
-- Table structure for mes_device_information
-- ----------------------------
DROP TABLE IF EXISTS `mes_device_information`;
CREATE TABLE `mes_device_information`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `device_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '设备名称',
  `device_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '设备编码',
  `device_model` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '设备型号',
  `produce_date` date NULL DEFAULT NULL COMMENT '生产日期',
  `produce_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '生产批号',
  `manufacturer` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '制造商',
  `device_status` tinyint NULL DEFAULT 0 COMMENT '设备状态：0:空闲,1:使用中,2:故障',
  `remark` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '制造执行MES-设备信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of mes_device_information
-- ----------------------------
INSERT INTO `mes_device_information` VALUES (1, '加油装置', 'EP00048', 'EP00048', '2021-10-20', 'EP00048', '加油装置制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (2, '内饰装配线', 'EP00049', 'EP00049', '2001-06-15', 'EP00049', '内饰装配线制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (3, '焊接机器', '﻿EP00001', '﻿EP00001', '2022-02-16', '﻿EP00001', '焊接机器制造商', 0, '﻿EP00001');
INSERT INTO `mes_device_information` VALUES (4, '压合机器', 'EP00002', 'EP00002', '2021-06-09', 'EP00002', '压合机器制造商', 0, '压合机器');
INSERT INTO `mes_device_information` VALUES (6, '涂装前处理设备', 'EP00004', 'EP00004', '2021-04-09', 'EP00004', '涂装前处理设备制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (7, '电泳涂装设备', 'EP00005', 'EP00005', '2011-11-03', 'EP00005', '电泳涂装设备制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (8, '静电喷涂设备', 'EP00006', 'EP00006', '2020-06-18', 'EP00006', '静电喷涂设备制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (9, '浸漆与淋漆', 'EP00007', 'EP00007', '2023-05-11', 'EP00007', '浸漆与淋漆制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (10, '输送设备', 'EP00008', 'EP00008', '2021-06-23', 'EP00008', '输送设备制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (11, '吊装设备', 'EP00009', 'EP00009', '2023-05-16', 'EP00009', '吊装设备制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (12, '油液加注设备', 'EP00010', 'EP00010', '2026-03-03', 'EP00010', '油液加注设备制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (13, '螺纹紧固设备', 'EP00011', 'EP00011', '2020-07-03', 'EP00011', '螺纹紧固设备', 0, NULL);
INSERT INTO `mes_device_information` VALUES (14, '标牌打刻机', 'EP00012', 'EP00012', '2011-03-18', 'EP00012', '标牌打刻机制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (15, '淋⾬实验间', 'EP00013', 'EP00013', '2011-03-03', 'EP00013', '淋⾬实验间制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (16, '四轮综合定位实验台', 'EP00014', 'EP00014', '2022-04-05', 'EP00014', '四轮综合定位实验台制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (17, '侧滑实验台', 'EP00015', 'EP00015', '2010-06-16', 'EP00015', '侧滑实验台制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (18, '转毂实验台', 'EP00016', 'EP00016', '2011-02-08', 'EP00016', '转毂实验台制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (19, '灯光检测仪', 'EP00017', 'EP00017', '2021-03-04', 'EP00017', '灯光检测仪制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (20, '电负载', 'EP00018', 'EP00018', '2022-10-05', 'EP00018', '电负载制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (21, '调压器', 'EP00019', 'EP00019', '2013-06-20', 'EP00019', '调压器制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (22, '全桥LCR测试仪', 'EP00020', 'EP00020', '2021-06-30', 'EP00020', '全桥LCR测试仪制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (23, '半导体测试仪', 'EP00021', 'EP00021', '2019-11-15', 'EP00021', '半导体测试仪制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (24, '数字波器', 'EP00022', 'EP00022', '2016-11-18', 'EP00022', '数字波器制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (25, '耐压测试仪', 'EP00023', 'EP00023', '2015-07-16', 'EP00023', '耐压测试仪制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (26, '稳压电源', 'EP00024', 'EP00024', '2019-11-07', 'EP00024', '稳压电源制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (27, '骑马螺栓拧紧机', 'EP00025', 'EP00025', '2023-05-24', 'EP00025', '骑马螺栓拧紧机', 0, NULL);
INSERT INTO `mes_device_information` VALUES (28, '车架翻转机', 'EP00026', 'EP00026', '2014-06-19', 'EP00026', '车架翻转机制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (29, '预装线', 'EP00027', 'EP00027', '2011-06-08', 'EP00027', '预装线制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (30, '拧紧机', 'EP00028', 'EP00028', '2021-06-23', 'EP00028', '拧紧机制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (31, '打标机', 'EP00029', 'EP00029', '2016-07-14', 'EP00029', '打标机制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (32, '检测机', 'EP00030', 'EP00030', '2013-07-25', 'EP00030', '检测机制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (33, '压装机', 'EP00031', 'EP00031', '2016-05-20', 'EP00031', '压装机制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (34, '翻转机', 'EP00032', 'EP00032', '2023-04-11', 'EP00032', '翻转机制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (35, '悬挂起重机', 'EP00033', 'EP00033', '2021-07-23', 'EP00033', '悬挂起重机制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (36, '一体式悬挂点焊机', 'EP00034', 'EP00034', '2021-07-14', 'EP00034', '一体式悬挂点焊机', 0, NULL);
INSERT INTO `mes_device_information` VALUES (37, '固定点焊机', 'EP00035', 'EP00035', '2021-11-04', 'EP00035', '固定点焊机', 0, NULL);
INSERT INTO `mes_device_information` VALUES (38, 'CO2保护焊机', 'EP00036', 'EP00036', '2020-02-21', 'EP00036', 'CO2保护焊机制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (39, '螺柱焊机', 'EP00037', 'EP00037', '2022-11-25', 'EP00037', '螺柱焊机制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (40, '包边专机轻卡车⾝焊接线', 'EP00038', 'EP00038', '2023-05-11', 'EP00038', '包边专机轻卡车⾝焊接线制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (41, 'ABB包边机器', 'EP00039', 'EP00039', '2023-04-05', 'EP00039', 'ABB包边机器制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (42, '骑马螺栓拧紧机', 'EP00040', 'EP00040', '2023-05-01', 'EP00040', '骑马螺栓拧紧机制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (43, '车架翻转机', 'EP00041', 'EP00041', '2021-10-14', 'EP00041', '车架翻转机制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (44, '预装线', 'EP00042', 'EP00042', '2012-07-05', 'EP00042', '预装线制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (45, '轮胎抓取器', 'EP00043', 'EP00043', '2023-05-10', 'EP00043', '轮胎抓取器制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (46, '轮胎螺母拧紧机', 'EP00044', 'EP00044', '2021-02-11', 'EP00044', '轮胎螺母拧紧机制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (47, '环⾏排烟装置', 'EP00045', 'EP00045', '2021-02-25', 'EP00045', '环⾏排烟装置制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (48, '灯光调整仪', 'EP00046', 'EP00046', '2020-08-13', 'EP00046', '灯光调整仪制造商', 0, NULL);
INSERT INTO `mes_device_information` VALUES (49, '发动机分装线', 'EP00047', 'EP00047', '2020-02-17', 'EP00047', '发动机分装线制造商', 0, NULL);

-- ----------------------------
-- Table structure for mes_factory
-- ----------------------------
DROP TABLE IF EXISTS `mes_factory`;
CREATE TABLE `mes_factory`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '编号',
  `production_line` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生产线名称',
  `factory_describe` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `material_id` bigint NULL DEFAULT NULL COMMENT '物料ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '制造执行MES-工厂建模表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of mes_factory
-- ----------------------------
INSERT INTO `mes_factory` VALUES (1, '1.4T排量轿车', '1.4T排量轿车', 2);
INSERT INTO `mes_factory` VALUES (11, '1.6排量轿车', '1.6排量轿车', 8);
INSERT INTO `mes_factory` VALUES (12, '1.8排量轿车', NULL, 9);
INSERT INTO `mes_factory` VALUES (13, '2.0排量轿车', NULL, 10);
INSERT INTO `mes_factory` VALUES (14, '2.5排量轿车', '2.5排量轿车', 11);
INSERT INTO `mes_factory` VALUES (15, '3.0排量轿车', '3.0排量轿车', 12);
INSERT INTO `mes_factory` VALUES (16, '4.5排量轿跑', '4.5排量轿跑', 13);
INSERT INTO `mes_factory` VALUES (17, '3.0T越野吉普', NULL, 33);
INSERT INTO `mes_factory` VALUES (18, '2.5T都市SUV', NULL, 34);
INSERT INTO `mes_factory` VALUES (19, '2.0T四驱SUV', NULL, 35);
INSERT INTO `mes_factory` VALUES (20, '1.8T三厢轿车', NULL, 36);
INSERT INTO `mes_factory` VALUES (21, '理想混合动力轿车', NULL, 37);
INSERT INTO `mes_factory` VALUES (22, '比亚迪汉DM', '比亚迪汉DM', 38);
INSERT INTO `mes_factory` VALUES (23, 'ZEEKER001', 'ZEEKER001', 39);
INSERT INTO `mes_factory` VALUES (24, '理想L7', '理想L7', 40);
INSERT INTO `mes_factory` VALUES (25, '海豹', NULL, 41);
INSERT INTO `mes_factory` VALUES (26, '小鹏P7', NULL, 42);
INSERT INTO `mes_factory` VALUES (27, '问界M7', NULL, 43);
INSERT INTO `mes_factory` VALUES (28, '宝马i3', NULL, 44);
INSERT INTO `mes_factory` VALUES (29, 'Taycan', NULL, 45);
INSERT INTO `mes_factory` VALUES (30, '宝马iX3', NULL, 46);
INSERT INTO `mes_factory` VALUES (31, 'ModelS', NULL, 47);

-- ----------------------------
-- Table structure for mes_factory_device_item
-- ----------------------------
DROP TABLE IF EXISTS `mes_factory_device_item`;
CREATE TABLE `mes_factory_device_item`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '序号',
  `factory_id` bigint NULL DEFAULT NULL COMMENT '工厂建模ID',
  `device_id` bigint NULL DEFAULT NULL COMMENT '设备ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 121 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '制造执行MES-工厂建模设备信息子表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of mes_factory_device_item
-- ----------------------------
INSERT INTO `mes_factory_device_item` VALUES (6, 4, 3);
INSERT INTO `mes_factory_device_item` VALUES (57, 1, 1);
INSERT INTO `mes_factory_device_item` VALUES (58, 1, 2);
INSERT INTO `mes_factory_device_item` VALUES (59, 1, 4);
INSERT INTO `mes_factory_device_item` VALUES (60, 1, 1);
INSERT INTO `mes_factory_device_item` VALUES (64, 11, 1);
INSERT INTO `mes_factory_device_item` VALUES (65, 11, 2);
INSERT INTO `mes_factory_device_item` VALUES (66, 11, 3);
INSERT INTO `mes_factory_device_item` VALUES (67, 11, 4);
INSERT INTO `mes_factory_device_item` VALUES (68, 12, 20);
INSERT INTO `mes_factory_device_item` VALUES (69, 12, 6);
INSERT INTO `mes_factory_device_item` VALUES (70, 12, 39);
INSERT INTO `mes_factory_device_item` VALUES (71, 12, 25);
INSERT INTO `mes_factory_device_item` VALUES (72, 13, 45);
INSERT INTO `mes_factory_device_item` VALUES (73, 13, 41);
INSERT INTO `mes_factory_device_item` VALUES (74, 13, 33);
INSERT INTO `mes_factory_device_item` VALUES (75, 13, 36);
INSERT INTO `mes_factory_device_item` VALUES (76, 14, 7);
INSERT INTO `mes_factory_device_item` VALUES (77, 14, 49);
INSERT INTO `mes_factory_device_item` VALUES (78, 14, 49);
INSERT INTO `mes_factory_device_item` VALUES (79, 15, 47);
INSERT INTO `mes_factory_device_item` VALUES (80, 15, 27);
INSERT INTO `mes_factory_device_item` VALUES (81, 15, 2);
INSERT INTO `mes_factory_device_item` VALUES (82, 16, 22);
INSERT INTO `mes_factory_device_item` VALUES (83, 16, 3);
INSERT INTO `mes_factory_device_item` VALUES (84, 16, 8);
INSERT INTO `mes_factory_device_item` VALUES (85, 16, 25);
INSERT INTO `mes_factory_device_item` VALUES (86, 16, 48);
INSERT INTO `mes_factory_device_item` VALUES (87, 17, 6);
INSERT INTO `mes_factory_device_item` VALUES (88, 17, 6);
INSERT INTO `mes_factory_device_item` VALUES (89, 18, 24);
INSERT INTO `mes_factory_device_item` VALUES (90, 18, 25);
INSERT INTO `mes_factory_device_item` VALUES (91, 19, 38);
INSERT INTO `mes_factory_device_item` VALUES (92, 19, 31);
INSERT INTO `mes_factory_device_item` VALUES (93, 19, 1);
INSERT INTO `mes_factory_device_item` VALUES (94, 20, 4);
INSERT INTO `mes_factory_device_item` VALUES (95, 20, 8);
INSERT INTO `mes_factory_device_item` VALUES (96, 20, 1);
INSERT INTO `mes_factory_device_item` VALUES (97, 21, 8);
INSERT INTO `mes_factory_device_item` VALUES (98, 21, 3);
INSERT INTO `mes_factory_device_item` VALUES (99, 21, 24);
INSERT INTO `mes_factory_device_item` VALUES (100, 22, 11);
INSERT INTO `mes_factory_device_item` VALUES (101, 22, 2);
INSERT INTO `mes_factory_device_item` VALUES (102, 22, 1);
INSERT INTO `mes_factory_device_item` VALUES (103, 23, 2);
INSERT INTO `mes_factory_device_item` VALUES (104, 23, 4);
INSERT INTO `mes_factory_device_item` VALUES (105, 24, 21);
INSERT INTO `mes_factory_device_item` VALUES (106, 24, 37);
INSERT INTO `mes_factory_device_item` VALUES (107, 25, 17);
INSERT INTO `mes_factory_device_item` VALUES (108, 25, 36);
INSERT INTO `mes_factory_device_item` VALUES (109, 26, 24);
INSERT INTO `mes_factory_device_item` VALUES (110, 26, 16);
INSERT INTO `mes_factory_device_item` VALUES (111, 27, 28);
INSERT INTO `mes_factory_device_item` VALUES (112, 27, 26);
INSERT INTO `mes_factory_device_item` VALUES (113, 28, 33);
INSERT INTO `mes_factory_device_item` VALUES (114, 28, 32);
INSERT INTO `mes_factory_device_item` VALUES (115, 29, 35);
INSERT INTO `mes_factory_device_item` VALUES (116, 29, 38);
INSERT INTO `mes_factory_device_item` VALUES (117, 30, 49);
INSERT INTO `mes_factory_device_item` VALUES (118, 30, 48);
INSERT INTO `mes_factory_device_item` VALUES (119, 31, 47);
INSERT INTO `mes_factory_device_item` VALUES (120, 31, 46);

-- ----------------------------
-- Table structure for mes_product
-- ----------------------------
DROP TABLE IF EXISTS `mes_product`;
CREATE TABLE `mes_product`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '编号',
  `mode_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '模型名称',
  `material_id` bigint NULL DEFAULT NULL COMMENT '物料id',
  `remark` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 56 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '制造执行MES-产品建模表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of mes_product
-- ----------------------------
INSERT INTO `mes_product` VALUES (1, '1.4T排量轿车', 2, 'xxxx');
INSERT INTO `mes_product` VALUES (2, '1.6排量轿车', 8, 'xxx');
INSERT INTO `mes_product` VALUES (34, '1.8排量轿车', 9, '1.8排量轿车');
INSERT INTO `mes_product` VALUES (35, '2.0排量轿车', 10, '2.0排量轿车');
INSERT INTO `mes_product` VALUES (36, '2.5排量轿车', 11, '2.5排量轿车');
INSERT INTO `mes_product` VALUES (37, '3.0排量轿车', 12, '3.0排量轿车');
INSERT INTO `mes_product` VALUES (38, '4.5排量轿跑', 13, '4.5排量轿跑');
INSERT INTO `mes_product` VALUES (40, '3.0T越野吉普', 33, NULL);
INSERT INTO `mes_product` VALUES (41, '2.5T都市SUV', 34, '2.5T都市SUV');
INSERT INTO `mes_product` VALUES (42, '2.0T四驱SUV', 35, '2.0T四驱SUV');
INSERT INTO `mes_product` VALUES (43, '1.8T三厢轿车', 36, '1.8T三厢轿车');
INSERT INTO `mes_product` VALUES (44, '理想混合动力轿车', 37, '理想混合动力轿车');
INSERT INTO `mes_product` VALUES (45, '比亚迪汉DM', 38, '比亚迪汉DM');
INSERT INTO `mes_product` VALUES (46, 'ZEEKER001', 39, 'ZEEKER001');
INSERT INTO `mes_product` VALUES (47, '理想L7', 40, '理想L7');
INSERT INTO `mes_product` VALUES (48, '海豹', 41, '海豹');
INSERT INTO `mes_product` VALUES (49, '小鹏P7', 42, '小鹏P7');
INSERT INTO `mes_product` VALUES (50, '问界M7', 43, '问界M7');
INSERT INTO `mes_product` VALUES (51, '宝马i3', 44, '宝马i3');
INSERT INTO `mes_product` VALUES (52, 'Taycan', 45, 'Taycan');
INSERT INTO `mes_product` VALUES (53, '宝马iX3', 46, '宝马iX3');
INSERT INTO `mes_product` VALUES (54, 'ModelS', 47, 'ModelS');

-- ----------------------------
-- Table structure for mes_project_maintenance
-- ----------------------------
DROP TABLE IF EXISTS `mes_project_maintenance`;
CREATE TABLE `mes_project_maintenance`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '项目维护id',
  `project_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目名',
  `project_header` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '负责人',
  `start_date` datetime NULL DEFAULT NULL COMMENT '开始日期',
  `end_date` datetime NULL DEFAULT NULL COMMENT '结束日期',
  `status` int NULL DEFAULT NULL COMMENT '项目状态 0：挂起 1：正常',
  `introduce` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目介绍',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '制造执行MES-项目维护表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of mes_project_maintenance
-- ----------------------------
INSERT INTO `mes_project_maintenance` VALUES (5, '2022-05生产项目', '斯蒂芬', '2026-01-08 00:00:00', '2026-01-09 00:00:00', 0, '123');
INSERT INTO `mes_project_maintenance` VALUES (6, '2022-06生产项目', '勒布朗', '2022-06-14 00:00:00', '2023-05-31 00:00:00', 1, '测试汉字');
INSERT INTO `mes_project_maintenance` VALUES (9, '2022-07生产项目', '凯文', '2022-07-01 00:00:00', '2023-07-01 00:00:00', 1, NULL);
INSERT INTO `mes_project_maintenance` VALUES (13, '2022-08生产项目', '凯里', '2022-08-01 00:00:00', '2023-08-01 00:00:00', 1, 'asdasfda');
INSERT INTO `mes_project_maintenance` VALUES (14, '2022-09生产项目', '德里克', '2022-09-01 00:00:00', '2023-09-01 00:00:00', 1, NULL);
INSERT INTO `mes_project_maintenance` VALUES (15, '2022-10生产项目', '德克', '2022-10-01 00:00:00', '2023-10-01 00:00:00', 1, NULL);
INSERT INTO `mes_project_maintenance` VALUES (16, '2023-05生产项目', '贾森', '2023-05-01 00:00:00', '2024-05-01 00:00:00', 1, NULL);
INSERT INTO `mes_project_maintenance` VALUES (17, '2023-06生产项目', '克里斯', '2023-06-01 00:00:00', '2023-08-01 00:00:00', 1, NULL);
INSERT INTO `mes_project_maintenance` VALUES (18, '2023-07生产项目', '扬尼斯', '2023-07-13 00:00:00', '2024-08-01 00:00:00', 1, NULL);
INSERT INTO `mes_project_maintenance` VALUES (19, '2023-08生产项目', '乔尔', '2023-08-01 00:00:00', '2024-08-01 00:00:00', 1, NULL);
INSERT INTO `mes_project_maintenance` VALUES (20, '2023-09生产项目', '尼古拉', '2023-09-01 00:00:00', '2024-09-01 00:00:00', 1, NULL);
INSERT INTO `mes_project_maintenance` VALUES (21, '2023-10生产项目', '贾马尔', '2023-10-01 00:00:00', '2024-08-31 00:00:00', 1, NULL);
INSERT INTO `mes_project_maintenance` VALUES (22, '2022-11生产项目', '克里斯', '2022-11-01 00:00:00', '2022-11-30 00:00:00', 1, NULL);
INSERT INTO `mes_project_maintenance` VALUES (23, '2022-12生产项目', '安吉', '2022-12-01 00:00:00', '2022-12-31 00:00:00', 1, NULL);
INSERT INTO `mes_project_maintenance` VALUES (24, '2023-01生产项目', '瑞安', '2023-01-01 00:00:00', '2023-01-31 00:00:00', 1, NULL);
INSERT INTO `mes_project_maintenance` VALUES (25, '2023-02生产项目', '安吉洛', '2023-02-01 00:00:00', '2023-02-28 00:00:00', 1, NULL);
INSERT INTO `mes_project_maintenance` VALUES (26, '2023-03生产项目', '德里克', '2023-03-01 00:00:00', '2023-03-31 00:00:00', 1, NULL);
INSERT INTO `mes_project_maintenance` VALUES (27, '2023-04生产项目', '拉塞尔', '2023-04-01 00:00:00', '2023-04-30 00:00:00', 1, NULL);

-- ----------------------------
-- Table structure for plat_instructor
-- ----------------------------
DROP TABLE IF EXISTS `plat_instructor`;
CREATE TABLE `plat_instructor`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `instructor` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '指导记录',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '状态',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '提交者姓名',
  `student_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '提交者学号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '指导记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of plat_instructor
-- ----------------------------

-- ----------------------------
-- Table structure for plat_notice
-- ----------------------------
DROP TABLE IF EXISTS `plat_notice`;
CREATE TABLE `plat_notice`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '公告标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '公告内容',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '公告时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '公告管理表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of plat_notice
-- ----------------------------

-- ----------------------------
-- Table structure for plat_opening
-- ----------------------------
DROP TABLE IF EXISTS `plat_opening`;
CREATE TABLE `plat_opening`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `opening` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '开题报告',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '状态',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '提交者姓名',
  `student_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '提交者学号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '开题报告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of plat_opening
-- ----------------------------
INSERT INTO `plat_opening` VALUES (1, '/profile/upload/2024/07/09/1_20240709163855A001.docx', '已通过', '李四', '2021901030');

-- ----------------------------
-- Table structure for plat_paper
-- ----------------------------
DROP TABLE IF EXISTS `plat_paper`;
CREATE TABLE `plat_paper`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `topic` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '题目',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '类型',
  `ask` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '要求',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '论文状态码',
  `teacher_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '教师姓名',
  `teacher_phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '教师电话',
  `bond` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '绑定的学生学号',
  `grade_instruct` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '指导成绩',
  `grade_review` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '评阅成绩',
  `grade_defence` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '答辩成绩',
  `grade` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '最终成绩',
  `teacher_id` bigint NULL DEFAULT NULL COMMENT '教师ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '论文管理表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of plat_paper
-- ----------------------------
INSERT INTO `plat_paper` VALUES (1, '张老师课题1', '工程设计', '张老师要求1', '已通过', '张老师', NULL, '2021901030', '3', '3', '4', '3.3', 107);
INSERT INTO `plat_paper` VALUES (2, '张老师课题2', '专题研究', '张老师要求2', '未通过', '张老师', NULL, NULL, NULL, NULL, NULL, NULL, 108);
INSERT INTO `plat_paper` VALUES (3, '张老师课题3', '文献综述', '张老师要求3', '已通过', '张老师', NULL, NULL, NULL, NULL, NULL, NULL, 108);
INSERT INTO `plat_paper` VALUES (4, '王老师课题1', '工程设计', '王老师要求1', '未审核', '王老师', NULL, NULL, NULL, NULL, NULL, NULL, 102);
INSERT INTO `plat_paper` VALUES (5, '王老师课题2', '专题研究', '王老师课题2', '未审核', '王老师', NULL, NULL, NULL, NULL, NULL, NULL, 102);

-- ----------------------------
-- Table structure for plat_select_paper
-- ----------------------------
DROP TABLE IF EXISTS `plat_select_paper`;
CREATE TABLE `plat_select_paper`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '学生学号',
  `select_id_1` int NULL DEFAULT NULL COMMENT '学生选择的论文id1',
  `select_id_2` int NULL DEFAULT NULL COMMENT '学生选择的论文id2',
  `select_id_3` int NULL DEFAULT NULL COMMENT '学生选择的论文id3',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '学生选择的3个课题号' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of plat_select_paper
-- ----------------------------
INSERT INTO `plat_select_paper` VALUES (1, '104', 1, 0, NULL);

-- ----------------------------
-- Table structure for plat_thesis
-- ----------------------------
DROP TABLE IF EXISTS `plat_thesis`;
CREATE TABLE `plat_thesis`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `thesis` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '毕业论文',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '状态',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '提交者姓名',
  `student_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '提交者学号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '毕业论文表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of plat_thesis
-- ----------------------------

-- ----------------------------
-- Table structure for plat_translation
-- ----------------------------
DROP TABLE IF EXISTS `plat_translation`;
CREATE TABLE `plat_translation`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `translation` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '外文翻译',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '状态',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '提交者姓名',
  `student_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '提交者学号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '外文翻译表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of plat_translation
-- ----------------------------

-- ----------------------------
-- Table structure for plat_user
-- ----------------------------
DROP TABLE IF EXISTS `plat_user`;
CREATE TABLE `plat_user`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '姓名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '密码',
  `student_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '学号',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '电话',
  `qq` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'QQ号',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `role` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '角色',
  `select_1` int NULL DEFAULT NULL COMMENT '选题一',
  `select_2` int NULL DEFAULT NULL COMMENT '选题二',
  `select_3` int NULL DEFAULT NULL COMMENT '选题三',
  `user_id` bigint NULL DEFAULT NULL COMMENT '系统用户id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of plat_user
-- ----------------------------
INSERT INTO `plat_user` VALUES (1, 'plat_admin', 'plat_admin', '', '', '1269666349', '1269666349@qq.com', 'ROLE_ADMIN', NULL, NULL, NULL, 108);
INSERT INTO `plat_user` VALUES (2, '张三', 'zhangsan', '2021901025', '15935956666', '2195485262', '2195485262@qq.com', 'ROLE_STUDENT', NULL, NULL, NULL, 103);
INSERT INTO `plat_user` VALUES (3, '王老师', 'wanglaoshi', NULL, '14852365512', '14852365512', '14852365512@qq.com', 'ROLE_TEACHER', NULL, NULL, NULL, 102);
INSERT INTO `plat_user` VALUES (4, '李四', 'lisilisi', '2021901030', '15866626556', '13542620856', '13542620856@qq.com', 'ROLE_STUDENT', NULL, NULL, NULL, 104);
INSERT INTO `plat_user` VALUES (5, '李老师', 'lilaoshi', NULL, '81201864000', '81811613155', '81811613155@qq.com', 'ROLE_TEACHER', NULL, NULL, NULL, 105);
INSERT INTO `plat_user` VALUES (6, '王五', 'wangwu', '2021901369', '18045158171', '72835226120', '72835226120@qq.com', 'ROLE_STUDENT', NULL, NULL, NULL, 106);
INSERT INTO `plat_user` VALUES (7, '张老师', 'zhanglaoshi', NULL, '68156519258', '98526584522', '98526584522@qq.com', 'ROLE_TEACHER', NULL, NULL, NULL, 107);

-- ----------------------------
-- Table structure for plat_watch
-- ----------------------------
DROP TABLE IF EXISTS `plat_watch`;
CREATE TABLE `plat_watch`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `topic` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '题目',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '类型',
  `ask` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '要求',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '教师姓名',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '教师电话',
  `qq` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '教师QQ',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '教师邮箱',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '选题查看表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of plat_watch
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob NULL COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Blob类型的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_blob_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`, `calendar_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '日历信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_calendars
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Cron类型的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_cron_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`, `entry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '已触发的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '任务详细信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`, `lock_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '存储的悲观锁信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_locks
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '暂停的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_paused_trigger_grps
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`, `instance_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '调度器状态表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '简单触发器的信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '同步机制的行锁表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_simprop_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint NULL DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint NULL DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int NULL DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint NULL DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint NULL DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  INDEX `sched_name`(`sched_name` ASC, `job_name` ASC, `job_group` ASC) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '触发器详细信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '参数配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2024-06-29 09:22:57', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2024-06-29 09:22:57', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2024-06-29 09:22:57', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2024-06-29 09:22:57', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2024-06-29 09:22:57', '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2024-06-29 09:22:57', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 203 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '长安大学', 0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-06-29 09:22:56', 'admin', '2026-01-15 23:50:23');
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '信息工程学院', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-06-29 09:22:56', 'admin', '2024-07-03 11:46:18');
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '机械工程学院', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-06-29 09:22:56', 'admin', '2024-07-03 11:47:16');
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '软件工程', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-06-29 09:22:56', 'admin', '2024-07-03 11:46:31');
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2024-06-29 09:22:56', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '计算机科学与技术', 3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-06-29 09:22:56', 'admin', '2024-07-03 11:46:43');
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2024-06-29 09:22:56', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2024-06-29 09:22:56', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2024-06-29 09:22:56', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2024-06-29 09:22:56', '', NULL);
INSERT INTO `sys_dept` VALUES (200, 102, '0,100,102', '机械工程', 1, NULL, NULL, NULL, '0', '0', 'admin', '2024-07-03 11:49:31', '', NULL);
INSERT INTO `sys_dept` VALUES (201, 102, '0,100,102', '能源与动力工程', 2, NULL, NULL, NULL, '0', '0', 'admin', '2024-07-03 11:49:40', '', NULL);
INSERT INTO `sys_dept` VALUES (202, 100, '0,100', '销售部门', 3, '若依', '15888888888', 'ruoyi@qq.com', '0', '2', 'admin', '2026-01-15 23:48:54', 'admin', '2026-01-15 23:49:18');

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 108 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (100, 0, '挂起', '0', 'mes_project_status', NULL, 'default', 'N', '0', 'admin', '2024-07-01 10:50:21', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (101, 1, '正常', '1', 'mes_project_status', NULL, 'default', 'N', '0', 'admin', '2024-07-01 10:50:35', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (102, 2, '教师', 'ROLE_TEACHER', 'platform_user_role', NULL, 'default', 'N', '0', 'admin', '2024-07-03 09:02:38', '', NULL, 'ROLE_TEACHER = 教师');
INSERT INTO `sys_dict_data` VALUES (103, 1, '管理员', 'ROLE_ADMIN', 'platform_user_role', NULL, 'default', 'N', '0', 'admin', '2024-07-03 09:03:18', '', NULL, 'ROLE_ADMIN = 管理员');
INSERT INTO `sys_dict_data` VALUES (104, 3, '学生', 'ROLE_STUDENT', 'platform_user_role', NULL, 'default', 'N', '0', 'admin', '2024-07-03 09:04:14', '', NULL, 'ROLE_STUDENT = 学生');
INSERT INTO `sys_dict_data` VALUES (106, 0, '挂起', '0', 'carsale_carorder_status', NULL, 'default', 'N', '0', 'admin', '2026-01-17 21:55:37', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (107, 1, '正常', '1', 'carsale_carorder_status', NULL, 'default', 'N', '0', 'admin', '2026-01-17 21:56:03', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 105 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典类型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2024-06-29 09:22:57', '', NULL, '登录状态列表');
INSERT INTO `sys_dict_type` VALUES (100, '生产状态', 'mes_product_status', '0', 'admin', '2024-06-29 09:59:20', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (101, '项目状态', 'mes_project_status', '0', 'admin', '2024-07-01 10:49:18', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (102, '用户身份', 'platform_user_role', '0', 'admin', '2024-07-03 08:57:56', 'admin', '2024-07-03 10:26:46', '论文管理平台的用户身份');
INSERT INTO `sys_dict_type` VALUES (104, '用户购车状态', 'carsale_carorder_status', '0', 'admin', '2026-01-17 21:47:37', 'admin', '2026-01-17 21:48:10', '新能源汽车销售系统');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2024-06-29 09:22:58', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2024-06-29 09:22:58', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2024-06-29 09:22:58', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '异常信息',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 421 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统访问记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-06-29 09:24:26');
INSERT INTO `sys_logininfor` VALUES (101, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-06-29 09:50:56');
INSERT INTO `sys_logininfor` VALUES (102, 'test', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-06-29 09:51:03');
INSERT INTO `sys_logininfor` VALUES (103, 'test', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-06-29 09:51:06');
INSERT INTO `sys_logininfor` VALUES (104, 'test', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-06-29 09:51:27');
INSERT INTO `sys_logininfor` VALUES (105, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-06-29 09:51:32');
INSERT INTO `sys_logininfor` VALUES (106, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码已失效', '2024-06-29 09:51:32');
INSERT INTO `sys_logininfor` VALUES (107, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-06-29 11:11:29');
INSERT INTO `sys_logininfor` VALUES (108, 'admin', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '1', '验证码已失效', '2024-06-29 11:47:28');
INSERT INTO `sys_logininfor` VALUES (109, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-06-29 14:07:06');
INSERT INTO `sys_logininfor` VALUES (110, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码已失效', '2024-07-01 09:22:09');
INSERT INTO `sys_logininfor` VALUES (111, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-01 09:22:12');
INSERT INTO `sys_logininfor` VALUES (112, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-01 10:39:43');
INSERT INTO `sys_logininfor` VALUES (113, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-01 14:29:52');
INSERT INTO `sys_logininfor` VALUES (114, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-01 15:29:22');
INSERT INTO `sys_logininfor` VALUES (115, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-01 15:57:41');
INSERT INTO `sys_logininfor` VALUES (116, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-02 09:55:02');
INSERT INTO `sys_logininfor` VALUES (117, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-02 10:49:41');
INSERT INTO `sys_logininfor` VALUES (118, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-02 11:45:46');
INSERT INTO `sys_logininfor` VALUES (119, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-02 11:58:26');
INSERT INTO `sys_logininfor` VALUES (120, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-02 14:04:42');
INSERT INTO `sys_logininfor` VALUES (121, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-02 15:14:59');
INSERT INTO `sys_logininfor` VALUES (122, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-02 15:28:08');
INSERT INTO `sys_logininfor` VALUES (123, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-02 15:28:17');
INSERT INTO `sys_logininfor` VALUES (124, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-02 15:28:23');
INSERT INTO `sys_logininfor` VALUES (125, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-02 15:28:33');
INSERT INTO `sys_logininfor` VALUES (126, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-02 15:28:37');
INSERT INTO `sys_logininfor` VALUES (127, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2024-07-02 15:28:45');
INSERT INTO `sys_logininfor` VALUES (128, 'test', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-02 15:28:55');
INSERT INTO `sys_logininfor` VALUES (129, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码已失效', '2024-07-02 15:55:12');
INSERT INTO `sys_logininfor` VALUES (130, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-02 15:55:15');
INSERT INTO `sys_logininfor` VALUES (131, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-02 16:14:45');
INSERT INTO `sys_logininfor` VALUES (132, 'test', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-02 16:14:51');
INSERT INTO `sys_logininfor` VALUES (133, 'test', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-02 16:20:04');
INSERT INTO `sys_logininfor` VALUES (134, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-02 16:20:10');
INSERT INTO `sys_logininfor` VALUES (135, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-02 17:23:20');
INSERT INTO `sys_logininfor` VALUES (136, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-02 18:14:26');
INSERT INTO `sys_logininfor` VALUES (137, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-07-03 08:29:27');
INSERT INTO `sys_logininfor` VALUES (138, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-03 08:29:30');
INSERT INTO `sys_logininfor` VALUES (139, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-03 10:22:20');
INSERT INTO `sys_logininfor` VALUES (140, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-03 10:54:07');
INSERT INTO `sys_logininfor` VALUES (141, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-03 10:54:23');
INSERT INTO `sys_logininfor` VALUES (142, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-03 10:54:35');
INSERT INTO `sys_logininfor` VALUES (143, 'sysAdmin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2024-07-03 10:54:45');
INSERT INTO `sys_logininfor` VALUES (144, 'sysAdmin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-07-03 10:54:48');
INSERT INTO `sys_logininfor` VALUES (145, 'sysAdmin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2024-07-03 10:54:51');
INSERT INTO `sys_logininfor` VALUES (146, 'sysAdmin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2024-07-03 10:55:00');
INSERT INTO `sys_logininfor` VALUES (147, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-03 10:55:33');
INSERT INTO `sys_logininfor` VALUES (148, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-03 10:55:59');
INSERT INTO `sys_logininfor` VALUES (149, 'sysAdmin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-03 10:56:06');
INSERT INTO `sys_logininfor` VALUES (150, 'sysAdmin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-03 11:05:20');
INSERT INTO `sys_logininfor` VALUES (151, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-03 11:05:26');
INSERT INTO `sys_logininfor` VALUES (152, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-03 11:57:28');
INSERT INTO `sys_logininfor` VALUES (153, 'ry', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2024-07-03 11:57:42');
INSERT INTO `sys_logininfor` VALUES (154, '王老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2024-07-03 11:57:47');
INSERT INTO `sys_logininfor` VALUES (155, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-03 11:57:56');
INSERT INTO `sys_logininfor` VALUES (156, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-03 13:02:59');
INSERT INTO `sys_logininfor` VALUES (157, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-04 08:22:55');
INSERT INTO `sys_logininfor` VALUES (158, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-04 11:19:19');
INSERT INTO `sys_logininfor` VALUES (159, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-04 14:24:08');
INSERT INTO `sys_logininfor` VALUES (160, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-04 15:58:05');
INSERT INTO `sys_logininfor` VALUES (161, '张三', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-04 15:58:10');
INSERT INTO `sys_logininfor` VALUES (162, '张三', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-04 15:58:14');
INSERT INTO `sys_logininfor` VALUES (163, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-04 15:58:19');
INSERT INTO `sys_logininfor` VALUES (164, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-04 15:58:39');
INSERT INTO `sys_logininfor` VALUES (165, '张三', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-04 15:58:42');
INSERT INTO `sys_logininfor` VALUES (166, '张三', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-04 15:59:05');
INSERT INTO `sys_logininfor` VALUES (167, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-04 15:59:09');
INSERT INTO `sys_logininfor` VALUES (168, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-04 16:04:50');
INSERT INTO `sys_logininfor` VALUES (169, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-04 16:04:53');
INSERT INTO `sys_logininfor` VALUES (170, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-04 16:04:59');
INSERT INTO `sys_logininfor` VALUES (171, '张三', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-04 16:05:03');
INSERT INTO `sys_logininfor` VALUES (172, '张三', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-04 16:08:31');
INSERT INTO `sys_logininfor` VALUES (173, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-04 16:08:34');
INSERT INTO `sys_logininfor` VALUES (174, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-04 18:07:06');
INSERT INTO `sys_logininfor` VALUES (175, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-04 18:08:14');
INSERT INTO `sys_logininfor` VALUES (176, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 08:36:05');
INSERT INTO `sys_logininfor` VALUES (177, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-07-05 08:49:32');
INSERT INTO `sys_logininfor` VALUES (178, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 08:49:34');
INSERT INTO `sys_logininfor` VALUES (179, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-05 08:52:58');
INSERT INTO `sys_logininfor` VALUES (180, '张三', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 08:53:03');
INSERT INTO `sys_logininfor` VALUES (181, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-07-05 09:37:16');
INSERT INTO `sys_logininfor` VALUES (182, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 09:37:19');
INSERT INTO `sys_logininfor` VALUES (183, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 11:24:04');
INSERT INTO `sys_logininfor` VALUES (184, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 13:58:13');
INSERT INTO `sys_logininfor` VALUES (185, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-05 15:15:27');
INSERT INTO `sys_logininfor` VALUES (186, '李四', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 15:15:32');
INSERT INTO `sys_logininfor` VALUES (187, '李四', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-05 15:15:59');
INSERT INTO `sys_logininfor` VALUES (188, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-07-05 15:16:10');
INSERT INTO `sys_logininfor` VALUES (189, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 15:16:12');
INSERT INTO `sys_logininfor` VALUES (190, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-05 15:19:16');
INSERT INTO `sys_logininfor` VALUES (191, '王老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-07-05 15:19:21');
INSERT INTO `sys_logininfor` VALUES (192, '王老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 15:19:25');
INSERT INTO `sys_logininfor` VALUES (193, '王老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-05 15:20:18');
INSERT INTO `sys_logininfor` VALUES (194, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 15:20:27');
INSERT INTO `sys_logininfor` VALUES (195, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-05 15:24:14');
INSERT INTO `sys_logininfor` VALUES (196, '王老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 15:24:19');
INSERT INTO `sys_logininfor` VALUES (197, '王老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-05 15:28:02');
INSERT INTO `sys_logininfor` VALUES (198, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 15:28:06');
INSERT INTO `sys_logininfor` VALUES (199, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-05 15:29:46');
INSERT INTO `sys_logininfor` VALUES (200, '王老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 15:29:49');
INSERT INTO `sys_logininfor` VALUES (201, '王老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-05 15:32:35');
INSERT INTO `sys_logininfor` VALUES (202, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-07-05 15:32:40');
INSERT INTO `sys_logininfor` VALUES (203, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-07-05 15:32:44');
INSERT INTO `sys_logininfor` VALUES (204, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 15:32:48');
INSERT INTO `sys_logininfor` VALUES (205, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-05 15:33:43');
INSERT INTO `sys_logininfor` VALUES (206, '王老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 15:33:48');
INSERT INTO `sys_logininfor` VALUES (207, '王老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-05 15:37:03');
INSERT INTO `sys_logininfor` VALUES (208, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 15:37:07');
INSERT INTO `sys_logininfor` VALUES (209, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-05 15:38:09');
INSERT INTO `sys_logininfor` VALUES (210, '王老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 15:38:13');
INSERT INTO `sys_logininfor` VALUES (211, '王老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-05 15:39:36');
INSERT INTO `sys_logininfor` VALUES (212, '王老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 15:39:40');
INSERT INTO `sys_logininfor` VALUES (213, '王老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-05 15:39:44');
INSERT INTO `sys_logininfor` VALUES (214, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 15:39:48');
INSERT INTO `sys_logininfor` VALUES (215, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-05 15:41:33');
INSERT INTO `sys_logininfor` VALUES (216, '王老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 15:41:38');
INSERT INTO `sys_logininfor` VALUES (217, '王老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-05 15:46:11');
INSERT INTO `sys_logininfor` VALUES (218, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 15:46:16');
INSERT INTO `sys_logininfor` VALUES (219, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-05 15:46:49');
INSERT INTO `sys_logininfor` VALUES (220, '王老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 15:46:53');
INSERT INTO `sys_logininfor` VALUES (221, '王老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-05 15:47:06');
INSERT INTO `sys_logininfor` VALUES (222, '王老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码已失效', '2024-07-05 15:49:37');
INSERT INTO `sys_logininfor` VALUES (223, '王老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 15:49:40');
INSERT INTO `sys_logininfor` VALUES (224, '王老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-05 15:54:11');
INSERT INTO `sys_logininfor` VALUES (225, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 15:54:16');
INSERT INTO `sys_logininfor` VALUES (226, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-05 15:56:58');
INSERT INTO `sys_logininfor` VALUES (227, '王老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-07-05 15:57:02');
INSERT INTO `sys_logininfor` VALUES (228, '王老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 15:57:05');
INSERT INTO `sys_logininfor` VALUES (229, '王老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-05 16:25:47');
INSERT INTO `sys_logininfor` VALUES (230, '李四', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 16:25:52');
INSERT INTO `sys_logininfor` VALUES (231, '李四', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-05 16:26:14');
INSERT INTO `sys_logininfor` VALUES (232, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 16:26:19');
INSERT INTO `sys_logininfor` VALUES (233, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-05 16:28:45');
INSERT INTO `sys_logininfor` VALUES (234, '李四', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 16:28:49');
INSERT INTO `sys_logininfor` VALUES (235, '李四', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-05 16:30:58');
INSERT INTO `sys_logininfor` VALUES (236, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 16:31:03');
INSERT INTO `sys_logininfor` VALUES (237, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-05 16:38:02');
INSERT INTO `sys_logininfor` VALUES (238, '李老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 16:38:07');
INSERT INTO `sys_logininfor` VALUES (239, '李老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-05 16:38:52');
INSERT INTO `sys_logininfor` VALUES (240, '李四', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 16:38:58');
INSERT INTO `sys_logininfor` VALUES (241, '李四', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-05 16:51:03');
INSERT INTO `sys_logininfor` VALUES (242, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 16:51:08');
INSERT INTO `sys_logininfor` VALUES (243, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 17:39:00');
INSERT INTO `sys_logininfor` VALUES (244, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-05 18:12:27');
INSERT INTO `sys_logininfor` VALUES (245, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-06 08:18:59');
INSERT INTO `sys_logininfor` VALUES (246, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-06 10:07:45');
INSERT INTO `sys_logininfor` VALUES (247, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-06 11:24:30');
INSERT INTO `sys_logininfor` VALUES (248, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-06 11:24:34');
INSERT INTO `sys_logininfor` VALUES (249, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-06 13:54:32');
INSERT INTO `sys_logininfor` VALUES (250, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码已失效', '2024-07-06 17:34:06');
INSERT INTO `sys_logininfor` VALUES (251, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-06 17:34:11');
INSERT INTO `sys_logininfor` VALUES (252, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-09 14:18:47');
INSERT INTO `sys_logininfor` VALUES (253, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-09 14:55:16');
INSERT INTO `sys_logininfor` VALUES (254, '李四', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-09 14:55:21');
INSERT INTO `sys_logininfor` VALUES (255, '李四', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-09 15:09:16');
INSERT INTO `sys_logininfor` VALUES (256, '李四', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-09 15:11:12');
INSERT INTO `sys_logininfor` VALUES (257, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-09 15:11:16');
INSERT INTO `sys_logininfor` VALUES (258, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-09 15:22:02');
INSERT INTO `sys_logininfor` VALUES (259, '李四', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-09 15:22:06');
INSERT INTO `sys_logininfor` VALUES (260, '李四', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-09 15:27:18');
INSERT INTO `sys_logininfor` VALUES (261, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-09 15:27:23');
INSERT INTO `sys_logininfor` VALUES (262, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-09 15:41:40');
INSERT INTO `sys_logininfor` VALUES (263, 'plat_admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-09 15:41:44');
INSERT INTO `sys_logininfor` VALUES (264, 'plat_admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-09 15:43:01');
INSERT INTO `sys_logininfor` VALUES (265, '张老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-09 15:44:13');
INSERT INTO `sys_logininfor` VALUES (266, '张老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-09 15:45:30');
INSERT INTO `sys_logininfor` VALUES (267, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-09 15:45:34');
INSERT INTO `sys_logininfor` VALUES (268, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-09 15:47:36');
INSERT INTO `sys_logininfor` VALUES (269, 'plat_admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-09 15:47:40');
INSERT INTO `sys_logininfor` VALUES (270, 'plat_admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-09 15:47:51');
INSERT INTO `sys_logininfor` VALUES (271, '张老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-09 15:47:57');
INSERT INTO `sys_logininfor` VALUES (272, '张老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-09 15:48:52');
INSERT INTO `sys_logininfor` VALUES (273, 'plat_admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-09 15:48:57');
INSERT INTO `sys_logininfor` VALUES (274, 'plat_admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-09 15:57:52');
INSERT INTO `sys_logininfor` VALUES (275, '王老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-09 15:57:58');
INSERT INTO `sys_logininfor` VALUES (276, '王老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-09 15:58:23');
INSERT INTO `sys_logininfor` VALUES (277, 'plat_admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-09 15:58:27');
INSERT INTO `sys_logininfor` VALUES (278, 'plat_admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-09 16:00:36');
INSERT INTO `sys_logininfor` VALUES (279, '李四', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-09 16:00:45');
INSERT INTO `sys_logininfor` VALUES (280, '李四', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-09 16:19:50');
INSERT INTO `sys_logininfor` VALUES (281, '张老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-09 16:19:56');
INSERT INTO `sys_logininfor` VALUES (282, '张老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-09 16:38:42');
INSERT INTO `sys_logininfor` VALUES (283, '李四', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-09 16:38:48');
INSERT INTO `sys_logininfor` VALUES (284, '李四', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-09 16:39:02');
INSERT INTO `sys_logininfor` VALUES (285, '张老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-07-09 16:39:06');
INSERT INTO `sys_logininfor` VALUES (286, '张老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-09 16:39:09');
INSERT INTO `sys_logininfor` VALUES (287, '张老师', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-09 16:41:58');
INSERT INTO `sys_logininfor` VALUES (288, '李四', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-09 16:42:02');
INSERT INTO `sys_logininfor` VALUES (289, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-14 21:53:37');
INSERT INTO `sys_logininfor` VALUES (290, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-15 20:37:37');
INSERT INTO `sys_logininfor` VALUES (291, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-15 21:42:21');
INSERT INTO `sys_logininfor` VALUES (292, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-15 23:26:44');
INSERT INTO `sys_logininfor` VALUES (293, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-16 23:56:57');
INSERT INTO `sys_logininfor` VALUES (294, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2026-01-16 23:57:00');
INSERT INTO `sys_logininfor` VALUES (295, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-16 23:57:04');
INSERT INTO `sys_logininfor` VALUES (296, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-17 21:43:17');
INSERT INTO `sys_logininfor` VALUES (297, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-17 23:22:53');
INSERT INTO `sys_logininfor` VALUES (298, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-18 13:24:50');
INSERT INTO `sys_logininfor` VALUES (299, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-18 13:24:53');
INSERT INTO `sys_logininfor` VALUES (300, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-18 19:54:25');
INSERT INTO `sys_logininfor` VALUES (301, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-18 21:26:20');
INSERT INTO `sys_logininfor` VALUES (302, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-19 23:29:31');
INSERT INTO `sys_logininfor` VALUES (303, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-20 00:08:10');
INSERT INTO `sys_logininfor` VALUES (304, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-20 20:34:45');
INSERT INTO `sys_logininfor` VALUES (305, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2026-01-21 01:21:45');
INSERT INTO `sys_logininfor` VALUES (306, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2026-01-21 01:21:54');
INSERT INTO `sys_logininfor` VALUES (307, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-21 01:30:56');
INSERT INTO `sys_logininfor` VALUES (308, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-21 01:31:00');
INSERT INTO `sys_logininfor` VALUES (309, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-22 18:59:10');
INSERT INTO `sys_logininfor` VALUES (310, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-23 18:06:23');
INSERT INTO `sys_logininfor` VALUES (311, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-23 19:15:38');
INSERT INTO `sys_logininfor` VALUES (312, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 10:15:21');
INSERT INTO `sys_logininfor` VALUES (313, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 10:18:46');
INSERT INTO `sys_logininfor` VALUES (314, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 10:18:54');
INSERT INTO `sys_logininfor` VALUES (315, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 10:18:55');
INSERT INTO `sys_logininfor` VALUES (316, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 10:25:12');
INSERT INTO `sys_logininfor` VALUES (317, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 10:25:17');
INSERT INTO `sys_logininfor` VALUES (318, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 10:25:31');
INSERT INTO `sys_logininfor` VALUES (319, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 10:25:43');
INSERT INTO `sys_logininfor` VALUES (320, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 10:48:02');
INSERT INTO `sys_logininfor` VALUES (321, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 10:48:08');
INSERT INTO `sys_logininfor` VALUES (322, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 10:48:09');
INSERT INTO `sys_logininfor` VALUES (323, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 10:48:32');
INSERT INTO `sys_logininfor` VALUES (324, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 10:48:38');
INSERT INTO `sys_logininfor` VALUES (325, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 10:48:38');
INSERT INTO `sys_logininfor` VALUES (326, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 10:49:09');
INSERT INTO `sys_logininfor` VALUES (327, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 10:49:25');
INSERT INTO `sys_logininfor` VALUES (328, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 10:51:14');
INSERT INTO `sys_logininfor` VALUES (329, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 10:51:17');
INSERT INTO `sys_logininfor` VALUES (330, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 10:51:18');
INSERT INTO `sys_logininfor` VALUES (331, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 10:59:43');
INSERT INTO `sys_logininfor` VALUES (332, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 10:59:51');
INSERT INTO `sys_logininfor` VALUES (333, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 10:59:52');
INSERT INTO `sys_logininfor` VALUES (334, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 11:07:19');
INSERT INTO `sys_logininfor` VALUES (335, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 11:07:26');
INSERT INTO `sys_logininfor` VALUES (336, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 11:07:26');
INSERT INTO `sys_logininfor` VALUES (337, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 11:07:40');
INSERT INTO `sys_logininfor` VALUES (338, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 11:07:49');
INSERT INTO `sys_logininfor` VALUES (339, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 11:07:49');
INSERT INTO `sys_logininfor` VALUES (340, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 11:08:05');
INSERT INTO `sys_logininfor` VALUES (341, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 11:08:10');
INSERT INTO `sys_logininfor` VALUES (342, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 11:08:10');
INSERT INTO `sys_logininfor` VALUES (343, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 11:08:25');
INSERT INTO `sys_logininfor` VALUES (344, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2026-01-24 11:08:33');
INSERT INTO `sys_logininfor` VALUES (345, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 11:08:34');
INSERT INTO `sys_logininfor` VALUES (346, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 11:08:37');
INSERT INTO `sys_logininfor` VALUES (347, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 11:16:33');
INSERT INTO `sys_logininfor` VALUES (348, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 11:16:38');
INSERT INTO `sys_logininfor` VALUES (349, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 11:16:39');
INSERT INTO `sys_logininfor` VALUES (350, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 11:16:54');
INSERT INTO `sys_logininfor` VALUES (351, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 11:17:05');
INSERT INTO `sys_logininfor` VALUES (352, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 11:17:05');
INSERT INTO `sys_logininfor` VALUES (353, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 11:17:22');
INSERT INTO `sys_logininfor` VALUES (354, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 11:17:25');
INSERT INTO `sys_logininfor` VALUES (355, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 11:17:25');
INSERT INTO `sys_logininfor` VALUES (356, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 11:17:46');
INSERT INTO `sys_logininfor` VALUES (357, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 11:18:00');
INSERT INTO `sys_logininfor` VALUES (358, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 11:20:17');
INSERT INTO `sys_logininfor` VALUES (359, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 11:20:26');
INSERT INTO `sys_logininfor` VALUES (360, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 11:20:26');
INSERT INTO `sys_logininfor` VALUES (361, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 11:25:46');
INSERT INTO `sys_logininfor` VALUES (362, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2026-01-24 11:25:49');
INSERT INTO `sys_logininfor` VALUES (363, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2026-01-24 11:25:49');
INSERT INTO `sys_logininfor` VALUES (364, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 11:25:55');
INSERT INTO `sys_logininfor` VALUES (365, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 11:25:55');
INSERT INTO `sys_logininfor` VALUES (366, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 11:27:32');
INSERT INTO `sys_logininfor` VALUES (367, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 11:27:39');
INSERT INTO `sys_logininfor` VALUES (368, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 11:27:40');
INSERT INTO `sys_logininfor` VALUES (369, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 11:28:05');
INSERT INTO `sys_logininfor` VALUES (370, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 11:28:09');
INSERT INTO `sys_logininfor` VALUES (371, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 11:28:09');
INSERT INTO `sys_logininfor` VALUES (372, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 11:28:24');
INSERT INTO `sys_logininfor` VALUES (373, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 11:28:35');
INSERT INTO `sys_logininfor` VALUES (374, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 11:28:35');
INSERT INTO `sys_logininfor` VALUES (375, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 11:38:50');
INSERT INTO `sys_logininfor` VALUES (376, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 11:38:54');
INSERT INTO `sys_logininfor` VALUES (377, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 15:31:22');
INSERT INTO `sys_logininfor` VALUES (378, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 15:31:22');
INSERT INTO `sys_logininfor` VALUES (379, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 15:41:30');
INSERT INTO `sys_logininfor` VALUES (380, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 15:41:39');
INSERT INTO `sys_logininfor` VALUES (381, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 15:41:39');
INSERT INTO `sys_logininfor` VALUES (382, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 16:10:42');
INSERT INTO `sys_logininfor` VALUES (383, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 16:10:47');
INSERT INTO `sys_logininfor` VALUES (384, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 16:15:04');
INSERT INTO `sys_logininfor` VALUES (385, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '用户不存在/密码错误', '2026-01-24 16:15:10');
INSERT INTO `sys_logininfor` VALUES (386, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2026-01-24 16:15:10');
INSERT INTO `sys_logininfor` VALUES (387, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2026-01-24 16:15:15');
INSERT INTO `sys_logininfor` VALUES (388, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 16:15:19');
INSERT INTO `sys_logininfor` VALUES (389, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 16:15:19');
INSERT INTO `sys_logininfor` VALUES (390, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 16:16:21');
INSERT INTO `sys_logininfor` VALUES (391, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 16:16:24');
INSERT INTO `sys_logininfor` VALUES (392, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 16:16:24');
INSERT INTO `sys_logininfor` VALUES (393, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 16:32:11');
INSERT INTO `sys_logininfor` VALUES (394, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 16:32:19');
INSERT INTO `sys_logininfor` VALUES (395, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 16:32:19');
INSERT INTO `sys_logininfor` VALUES (396, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 17:15:28');
INSERT INTO `sys_logininfor` VALUES (397, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 17:15:28');
INSERT INTO `sys_logininfor` VALUES (398, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 17:17:37');
INSERT INTO `sys_logininfor` VALUES (399, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 17:17:49');
INSERT INTO `sys_logininfor` VALUES (400, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 17:19:06');
INSERT INTO `sys_logininfor` VALUES (401, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 17:19:15');
INSERT INTO `sys_logininfor` VALUES (402, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 17:19:16');
INSERT INTO `sys_logininfor` VALUES (403, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 17:19:23');
INSERT INTO `sys_logininfor` VALUES (404, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 17:19:24');
INSERT INTO `sys_logininfor` VALUES (405, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 17:19:45');
INSERT INTO `sys_logininfor` VALUES (406, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 17:19:49');
INSERT INTO `sys_logininfor` VALUES (407, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 17:20:49');
INSERT INTO `sys_logininfor` VALUES (408, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 17:20:52');
INSERT INTO `sys_logininfor` VALUES (409, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 17:20:52');
INSERT INTO `sys_logininfor` VALUES (410, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 17:22:11');
INSERT INTO `sys_logininfor` VALUES (411, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 17:22:18');
INSERT INTO `sys_logininfor` VALUES (412, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 17:22:18');
INSERT INTO `sys_logininfor` VALUES (413, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 17:27:19');
INSERT INTO `sys_logininfor` VALUES (414, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 17:27:25');
INSERT INTO `sys_logininfor` VALUES (415, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 17:27:25');
INSERT INTO `sys_logininfor` VALUES (416, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-24 17:28:40');
INSERT INTO `sys_logininfor` VALUES (417, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 17:28:49');
INSERT INTO `sys_logininfor` VALUES (418, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '用户不存在/密码错误', '2026-01-24 17:28:49');
INSERT INTO `sys_logininfor` VALUES (419, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-24 17:28:55');
INSERT INTO `sys_logininfor` VALUES (420, 'user', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-24 17:28:56');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '路由参数',
  `is_frame` int NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2049 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '菜单权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, 'system', NULL, '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2024-06-29 09:22:56', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 2, 'monitor', NULL, '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2024-06-29 09:22:56', '', NULL, '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, 'tool', NULL, '', 1, 0, 'M', '0', '0', '', 'tool', 'admin', '2024-06-29 09:22:56', '', NULL, '系统工具目录');
INSERT INTO `sys_menu` VALUES (4, '若依官网', 0, 4, 'http://ruoyi.vip', NULL, '', 0, 0, 'M', '0', '0', '', 'guide', 'admin', '2024-06-29 09:22:56', '', NULL, '若依官网地址');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2024-06-29 09:22:56', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2024-06-29 09:22:56', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2024-06-29 09:22:56', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2024-06-29 09:22:56', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2024-06-29 09:22:56', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2024-06-29 09:22:56', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2024-06-29 09:22:56', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2024-06-29 09:22:56', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2024-06-29 09:22:56', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2024-06-29 09:22:56', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2024-06-29 09:22:56', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2024-06-29 09:22:56', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2024-06-29 09:22:56', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2024-06-29 09:22:56', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2024-06-29 09:22:56', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2024-06-29 09:22:56', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2024-06-29 09:22:56', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2024-06-29 09:22:56', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2024-06-29 09:22:56', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2024-06-29 09:22:56', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2024-06-29 09:22:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2000, '生产制造', 0, 10, '/mes/', NULL, NULL, 1, 0, 'M', '0', '0', '', 'rate', 'admin', '2024-06-29 09:53:06', 'admin', '2024-06-29 09:53:33', '');
INSERT INTO `sys_menu` VALUES (2002, '项目维护', 2000, 20, 'project', 'mes/project/index', NULL, 1, 0, 'C', '0', '0', 'mes:project:list', 'dashboard', 'admin', '2024-06-29 14:09:40', 'admin', '2024-07-01 09:26:45', '');
INSERT INTO `sys_menu` VALUES (2003, '新增', 2000, 20, '', NULL, NULL, 1, 0, 'F', '0', '0', 'mes:project:add', '#', 'admin', '2024-07-01 15:30:08', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2004, '产品建模', 2000, 1, 'product', 'mes/product/index', NULL, 1, 0, 'C', '0', '0', 'mes:product:list', 'component', 'admin', '2024-07-02 10:15:40', 'admin', '2024-07-02 10:17:17', '产品建模菜单');
INSERT INTO `sys_menu` VALUES (2005, '产品建模查询', 2004, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'mes:product:query', '#', 'admin', '2024-07-02 10:15:40', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2006, '产品建模新增', 2004, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'mes:product:add', '#', 'admin', '2024-07-02 10:15:40', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2007, '产品建模修改', 2004, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'mes:product:edit', '#', 'admin', '2024-07-02 10:15:40', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2008, '产品建模删除', 2004, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'mes:product:remove', '#', 'admin', '2024-07-02 10:15:40', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2009, '产品建模导出', 2004, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'mes:product:export', '#', 'admin', '2024-07-02 10:15:41', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2011, '论文管理平台', 0, 30, 'platform', NULL, NULL, 1, 0, 'M', '0', '0', '', 'redis-list', 'admin', '2024-07-02 16:39:46', 'admin', '2024-07-03 14:01:04', '');
INSERT INTO `sys_menu` VALUES (2013, '课题管理', 2011, 2, 'paperManage', 'platform/paperManage/index', NULL, 1, 0, 'C', '0', '0', 'platform:paperManage:list', 'form', 'admin', '2024-07-02 16:42:50', 'admin', '2024-07-03 14:18:54', '');
INSERT INTO `sys_menu` VALUES (2020, '课题审核', 2011, 1, 'topicAudit', 'platform/topicAudit/index', NULL, 1, 0, 'C', '0', '0', 'platform:topicAudit:index', 'form', 'admin', '2024-07-03 14:13:37', 'admin', '2024-07-03 14:20:18', '');
INSERT INTO `sys_menu` VALUES (2021, '课题匹配状况', 2011, 3, 'topicMatch', 'platform/topicMatch/index', NULL, 1, 0, 'C', '1', '0', 'platform:topicMatch:list', 'eye-open', 'admin', '2024-07-03 14:18:24', 'admin', '2024-07-09 15:41:13', '');
INSERT INTO `sys_menu` VALUES (2022, '选择课题', 2011, 4, 'topicSelect', 'platform/topicSelect/index', NULL, 1, 0, 'C', '0', '0', 'platform:topicSelect:list', 'button', 'admin', '2024-07-03 14:25:21', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2023, '选题查看', 2011, 5, 'topicWatch', 'platform/topicWatch/index', NULL, 1, 0, 'C', '0', '0', 'platform:topicWatch:list', 'eye', 'admin', '2024-07-03 14:27:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2024, '选题审核', 2011, 6, 'selectAudit', 'platform/selectAudit/index', NULL, 1, 0, 'C', '0', '0', 'platform:selectAudit:list', 'example', 'admin', '2024-07-03 14:29:04', 'admin', '2024-07-05 16:55:54', '');
INSERT INTO `sys_menu` VALUES (2025, '课题查询', 2013, 1, '', NULL, NULL, 1, 0, 'F', '0', '0', 'platform:topic:query', '#', 'admin', '2024-07-03 16:20:26', 'admin', '2024-07-05 15:23:07', '');
INSERT INTO `sys_menu` VALUES (2026, '课题新增', 2013, 2, '', NULL, NULL, 1, 0, 'F', '0', '0', 'platform:topic:add', '#', 'admin', '2024-07-03 16:21:03', 'admin', '2024-07-05 15:23:13', '');
INSERT INTO `sys_menu` VALUES (2027, '课题修改', 2013, 3, '', NULL, NULL, 1, 0, 'F', '0', '0', 'platform:topic:edit', '#', 'admin', '2024-07-03 16:21:21', 'admin', '2024-07-05 15:23:18', '');
INSERT INTO `sys_menu` VALUES (2028, '课题删除', 2013, 4, '', NULL, NULL, 1, 0, 'F', '0', '0', 'platform:topic:remove', '#', 'admin', '2024-07-03 16:21:44', 'admin', '2024-07-05 15:23:23', '');
INSERT INTO `sys_menu` VALUES (2029, '课题导出', 2013, 5, '', NULL, NULL, 1, 0, 'F', '0', '0', 'platform:topic:export', '#', 'admin', '2024-07-03 16:22:17', 'admin', '2024-07-05 15:23:27', '');
INSERT INTO `sys_menu` VALUES (2030, '课题导入', 2013, 6, '', NULL, NULL, 1, 0, 'F', '0', '0', 'platform:topic:import', '#', 'admin', '2024-07-03 16:22:33', 'admin', '2024-07-05 15:23:30', '');
INSERT INTO `sys_menu` VALUES (2031, '选择课题', 2022, 1, '', NULL, NULL, 1, 0, 'F', '0', '0', 'platform:topicSelect:edit', '#', 'admin', '2024-07-04 16:00:56', 'admin', '2024-07-09 15:12:29', '');
INSERT INTO `sys_menu` VALUES (2032, '删除所选课题', 2022, 2, '', NULL, NULL, 1, 0, 'F', '0', '0', 'platform:topicSelect:remove', '#', 'admin', '2024-07-04 16:01:17', 'admin', '2024-07-09 15:12:33', '');
INSERT INTO `sys_menu` VALUES (2033, '查询所选课题', 2022, 3, '', NULL, NULL, 1, 0, 'F', '0', '0', 'platform:topicSelect:query', '#', 'admin', '2024-07-04 16:02:00', 'admin', '2024-07-09 15:12:38', '');
INSERT INTO `sys_menu` VALUES (2034, '导出所选课题', 2022, 4, '', NULL, NULL, 1, 0, 'F', '0', '0', 'platform:topicSelect:export', '#', 'admin', '2024-07-04 16:03:34', 'admin', '2024-07-09 15:12:44', '');
INSERT INTO `sys_menu` VALUES (2035, '展示所选课题', 2022, 5, '', NULL, NULL, 1, 0, 'F', '0', '0', 'platform:topicSelect:list', '#', 'admin', '2024-07-04 16:04:20', 'admin', '2024-07-09 15:12:48', '');
INSERT INTO `sys_menu` VALUES (2036, '课题列表', 2013, 1, 'platform:topic:list', NULL, NULL, 1, 0, 'F', '0', '0', 'platform:topic:list', '#', 'admin', '2024-07-05 15:56:12', 'admin', '2024-07-05 15:56:35', '');
INSERT INTO `sys_menu` VALUES (2037, '论文提交', 2011, 7, 'paperUpload', 'platform/paperUpload/index', NULL, 1, 0, 'C', '0', '0', 'platform:paperUpload:list', 'upload', 'admin', '2024-07-05 16:53:33', 'admin', '2024-07-05 16:56:03', '');
INSERT INTO `sys_menu` VALUES (2038, '成绩查看', 2011, 15, 'gradeCheck', 'platform/gradeCheck/index', NULL, 1, 0, 'C', '0', '0', 'platform:gradeCheck:list', 'rate', 'admin', '2024-07-05 16:58:18', 'admin', '2024-07-05 17:05:18', '');
INSERT INTO `sys_menu` VALUES (2039, '成绩管理', 2011, 9, 'gradeManage', 'platform/gradeManage/index', NULL, 1, 0, 'C', '0', '0', 'platform:gradeManage:list', 'edit', 'admin', '2024-07-05 16:59:16', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2040, '论文查看', 2011, 8, 'paperDownload', 'platform/paperDownload/index', NULL, 1, 0, 'C', '0', '0', 'platform:gradeManage:list', 'skill', 'admin', '2024-07-05 17:05:04', 'admin', '2024-07-05 17:06:53', '');
INSERT INTO `sys_menu` VALUES (2041, '查看提交论文', 2037, 1, '', NULL, NULL, 1, 0, 'F', '0', '0', 'platform:paperUpload:list', '#', 'admin', '2024-07-06 09:21:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2042, '新增论文提交', 2037, 2, '', NULL, NULL, 1, 0, 'F', '0', '0', 'platform:paperUpload:add', '#', 'admin', '2024-07-06 09:22:47', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2043, '更新论文提交', 2037, 4, '', NULL, NULL, 1, 0, 'F', '0', '0', 'platform:paperUpload:edit', '#', 'admin', '2024-07-06 09:23:32', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2044, '删除提交论文', 2037, 3, '', NULL, NULL, 1, 0, 'F', '0', '0', 'platform:paperUpload:remove', '#', 'admin', '2024-07-06 09:23:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2045, '新能源汽车销售', 0, 30, '/carsale', NULL, NULL, 1, 0, 'M', '0', '0', NULL, 'example', 'admin', '2026-01-15 21:45:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2046, '用户购车数据', 2045, 1, 'carOrder', 'carsale/carOrder/index', NULL, 1, 0, 'C', '0', '0', 'carsale:carorder:list', 'build', 'admin', '2026-01-15 21:59:02', 'admin', '2026-01-18 13:28:37', '');
INSERT INTO `sys_menu` VALUES (2047, '新增', 2046, 20, '', NULL, NULL, 1, 0, 'F', '0', '0', 'carsale:carorder:add', '#', 'admin', '2026-01-18 13:27:34', '', NULL, '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '通知公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '温馨提醒：2018-07-01 若依新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '0', 'admin', '2024-06-29 09:22:58', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (2, '维护通知：2018-07-01 若依系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '0', 'admin', '2024-06-29 09:22:58', '', NULL, '管理员');

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 530 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (100, '角色管理', 1, 'com.ruoyi.web.controller.system.SysRoleController.add()', 'POST', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,104,1020,1021,1022,1023,1024],\"params\":{},\"roleId\":100,\"roleKey\":\"system:test\",\"roleName\":\"test\",\"roleSort\":0,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-29 09:48:22', 33);
INSERT INTO `sys_oper_log` VALUES (101, '用户管理', 1, 'com.ruoyi.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"test\",\"params\":{},\"postIds\":[],\"roleIds\":[100],\"status\":\"0\",\"userId\":100,\"userName\":\"test\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-29 09:50:41', 86);
INSERT INTO `sys_oper_log` VALUES (102, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"rate\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"生产制造\",\"menuType\":\"M\",\"orderNum\":10,\"params\":{},\"parentId\":0,\"path\":\"/mes\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-29 09:53:06', 12);
INSERT INTO `sys_oper_log` VALUES (103, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-06-29 09:53:06\",\"icon\":\"rate\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"生产制造\",\"menuType\":\"M\",\"orderNum\":10,\"params\":{},\"parentId\":0,\"path\":\"/mes/\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-29 09:53:33', 11);
INSERT INTO `sys_oper_log` VALUES (104, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"/mes/product\",\"createBy\":\"admin\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"产品建模\",\"menuType\":\"C\",\"orderNum\":20,\"params\":{},\"parentId\":2000,\"path\":\"/mes/product\",\"perms\":\"mes:product:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-29 09:58:02', 9);
INSERT INTO `sys_oper_log` VALUES (105, '字典类型', 1, 'com.ruoyi.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"dictName\":\"生产状态\",\"dictType\":\"mes_product_status\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-29 09:59:20', 13);
INSERT INTO `sys_oper_log` VALUES (106, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2001', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-29 14:07:27', 32);
INSERT INTO `sys_oper_log` VALUES (107, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"/mes/product\",\"createBy\":\"admin\",\"icon\":\"checkbox\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"项目维护\",\"menuType\":\"C\",\"orderNum\":20,\"params\":{},\"parentId\":2000,\"path\":\"/mes/product\",\"perms\":\"mes:product:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-29 14:09:40', 18);
INSERT INTO `sys_oper_log` VALUES (108, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"/mes/project/index\",\"createTime\":\"2024-06-29 14:09:40\",\"icon\":\"dashboard\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2002,\"menuName\":\"项目维护\",\"menuType\":\"C\",\"orderNum\":20,\"params\":{},\"parentId\":2000,\"path\":\"project\",\"perms\":\"mes:project:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-06-29 14:11:53', 17);
INSERT INTO `sys_oper_log` VALUES (109, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"/mes/project/index\",\"createTime\":\"2024-06-29 14:09:40\",\"icon\":\"dashboard\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2002,\"menuName\":\"项目维护\",\"menuType\":\"C\",\"orderNum\":20,\"params\":{},\"parentId\":2000,\"path\":\"project\",\"perms\":\"mes:project:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-01 09:24:51', 23);
INSERT INTO `sys_oper_log` VALUES (110, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"mes/project/index\",\"createTime\":\"2024-06-29 14:09:40\",\"icon\":\"dashboard\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2002,\"menuName\":\"项目维护\",\"menuType\":\"C\",\"orderNum\":20,\"params\":{},\"parentId\":2000,\"path\":\"project\",\"perms\":\"mes:project:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-01 09:26:45', 12);
INSERT INTO `sys_oper_log` VALUES (111, '字典类型', 1, 'com.ruoyi.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"dictName\":\"项目状态\",\"dictType\":\"mes_project_status\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-01 10:49:18', 20);
INSERT INTO `sys_oper_log` VALUES (112, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"挂起\",\"dictSort\":0,\"dictType\":\"mes_project_status\",\"dictValue\":\"0\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-01 10:50:21', 18);
INSERT INTO `sys_oper_log` VALUES (113, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"正常\",\"dictSort\":1,\"dictType\":\"mes_project_status\",\"dictValue\":\"1\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-01 10:50:35', 12);
INSERT INTO `sys_oper_log` VALUES (114, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"新增\",\"menuType\":\"F\",\"orderNum\":20,\"params\":{},\"parentId\":2000,\"perms\":\"mes:project:add\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-01 15:30:08', 23);
INSERT INTO `sys_oper_log` VALUES (115, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"mes_product\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-02 09:55:10', 82);
INSERT INTO `sys_oper_log` VALUES (116, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"product\",\"className\":\"MesProduct\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"模型编号\",\"columnId\":1,\"columnName\":\"id\",\"columnType\":\"bigint unsigned\",\"createBy\":\"admin\",\"createTime\":\"2024-07-02 09:55:10\",\"dictType\":\"\",\"edit\":false,\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isList\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"ModeName\",\"columnComment\":\"模型名称\",\"columnId\":2,\"columnName\":\"mode_name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-02 09:55:10\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"modeName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"MaterialId\",\"columnComment\":\"产品ID\",\"columnId\":3,\"columnName\":\"material_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2024-07-02 09:55:10\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"select\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"materialId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Remark\",\"columnComment\":\"备注\",\"columnId\":4,\"columnName\":\"remark\",\"columnType\":\"longtext\",\"createBy\":\"admin\",\"createTime\":\"2024-07-02 09:55:10\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"textarea\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isRequired\":\"0\",\"javaField\":\"remark\",\"java', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-02 10:02:23', 36);
INSERT INTO `sys_oper_log` VALUES (117, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"mes_product\"}', NULL, 0, NULL, '2024-07-02 10:07:31', 33);
INSERT INTO `sys_oper_log` VALUES (118, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"mes/product/index\",\"createTime\":\"2024-07-02 10:15:40\",\"icon\":\"component\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2004,\"menuName\":\"产品建模\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"product\",\"perms\":\"mes:product:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-02 10:17:18', 23);
INSERT INTO `sys_oper_log` VALUES (119, '产品建模', 1, 'com.ruoyi.web.controller.mes.MesProductController.add()', 'POST', 1, 'admin', '研发部门', '/mes/product', '127.0.0.1', '内网IP', '{\"id\":55,\"materialId\":25,\"modeName\":\"2.5排量新型轿车\",\"params\":{},\"remark\":\"新型\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-02 10:21:48', 13);
INSERT INTO `sys_oper_log` VALUES (120, '产品建模', 2, 'com.ruoyi.web.controller.mes.MesProductController.edit()', 'PUT', 1, 'admin', '研发部门', '/mes/product', '127.0.0.1', '内网IP', '{\"id\":55,\"materialId\":25,\"modeName\":\"2.5排量新型轿车\",\"params\":{},\"remark\":\"新型2\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-02 10:22:07', 8);
INSERT INTO `sys_oper_log` VALUES (121, '产品建模', 3, 'com.ruoyi.web.controller.mes.MesProductController.remove()', 'DELETE', 1, 'admin', '研发部门', '/mes/product/55', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-02 10:22:09', 12);
INSERT INTO `sys_oper_log` VALUES (122, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"wms_material\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-02 11:04:02', 155);
INSERT INTO `sys_oper_log` VALUES (123, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"material\",\"className\":\"WmsMaterial\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"物料档案ID\",\"columnId\":5,\"columnName\":\"id\",\"columnType\":\"bigint unsigned\",\"createBy\":\"admin\",\"createTime\":\"2024-07-02 11:04:01\",\"dictType\":\"\",\"edit\":false,\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"String\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"ClassifyId\",\"columnComment\":\"物料分类ID\",\"columnId\":6,\"columnName\":\"classify_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2024-07-02 11:04:01\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"classifyId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"MaterialCode\",\"columnComment\":\"物料编码\",\"columnId\":7,\"columnName\":\"material_code\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-02 11:04:01\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"materialCode\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"MaterialName\",\"columnComment\":\"物料名称\",\"columnId\":8,\"columnName\":\"material_name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-02 11:04:01\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isReq', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-02 11:05:08', 53);
INSERT INTO `sys_oper_log` VALUES (124, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"wms_material\"}', NULL, 0, NULL, '2024-07-02 11:05:50', 35);
INSERT INTO `sys_oper_log` VALUES (125, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"mes_factory,mes_device_information,mes_factory_device_item\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-02 14:26:49', 171);
INSERT INTO `sys_oper_log` VALUES (126, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"factory\",\"className\":\"MesFactory\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"编号\",\"columnId\":24,\"columnName\":\"id\",\"columnType\":\"bigint unsigned\",\"createBy\":\"admin\",\"createTime\":\"2024-07-02 14:26:49\",\"dictType\":\"\",\"edit\":false,\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isList\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"ProductionLine\",\"columnComment\":\"生产线名称\",\"columnId\":25,\"columnName\":\"production_line\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-02 14:26:49\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"productionLine\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"FactoryDescribe\",\"columnComment\":\"描述\",\"columnId\":26,\"columnName\":\"factory_describe\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-02 14:26:49\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"0\",\"javaField\":\"factoryDescribe\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"MaterialId\",\"columnComment\":\"物料ID\",\"columnId\":27,\"columnName\":\"material_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2024-07-02 14:26:49\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-02 14:29:09', 34);
INSERT INTO `sys_oper_log` VALUES (127, '角色管理', 1, 'com.ruoyi.web.controller.system.SysRoleController.add()', 'POST', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045],\"params\":{},\"roleId\":101,\"roleKey\":\"ROLE_ADMIN\",\"roleName\":\"论文系统管理员\",\"roleSort\":3,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-02 16:01:44', 40);
INSERT INTO `sys_oper_log` VALUES (128, '用户管理', 1, 'com.ruoyi.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"nickName\":\"admin\",\"params\":{},\"postIds\":[],\"roleIds\":[101],\"sex\":\"0\",\"status\":\"0\",\"userName\":\"admin\"}', '{\"msg\":\"新增用户\'admin\'失败，登录账号已存在\",\"code\":500}', 0, NULL, '2024-07-02 16:05:47', 3);
INSERT INTO `sys_oper_log` VALUES (129, '用户管理', 1, 'com.ruoyi.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"admin\",\"params\":{},\"postIds\":[],\"roleIds\":[101],\"sex\":\"0\",\"status\":\"0\",\"userId\":101,\"userName\":\"sysAdmin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-02 16:06:41', 86);
INSERT INTO `sys_oper_log` VALUES (130, '用户管理', 3, 'com.ruoyi.web.controller.system.SysUserController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/user/100', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-02 16:22:02', 15);
INSERT INTO `sys_oper_log` VALUES (131, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/platformUser/index\",\"createBy\":\"admin\",\"icon\":\"peoples\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"平台用户\",\"menuType\":\"C\",\"orderNum\":50,\"params\":{},\"parentId\":1,\"path\":\"platformUser\",\"perms\":\"system:platformUser:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-02 16:30:27', 15);
INSERT INTO `sys_oper_log` VALUES (132, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2010', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-02 16:38:36', 14);
INSERT INTO `sys_oper_log` VALUES (133, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"redis-list\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"平台管理\",\"menuType\":\"M\",\"orderNum\":30,\"params\":{},\"parentId\":0,\"path\":\"platform\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-02 16:39:46', 13);
INSERT INTO `sys_oper_log` VALUES (134, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"platform/user/index\",\"createBy\":\"admin\",\"icon\":\"user\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"用户管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2011,\"path\":\"user\",\"perms\":\"platform:user:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-02 16:41:13', 11);
INSERT INTO `sys_oper_log` VALUES (135, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"platform/role/index\",\"createBy\":\"admin\",\"icon\":\"peoples\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"角色管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2011,\"path\":\"role\",\"perms\":\"platform:role:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-02 16:42:50', 9);
INSERT INTO `sys_oper_log` VALUES (136, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"platform/notice/index\",\"createBy\":\"admin\",\"icon\":\"message\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"通知公告\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2011,\"path\":\"notice\",\"perms\":\"platform:notice:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-02 16:44:37', 8);
INSERT INTO `sys_oper_log` VALUES (137, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"tree-table\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"论文模块管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"33\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-02 16:46:54', 10);
INSERT INTO `sys_oper_log` VALUES (138, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-02 16:46:54\",\"icon\":\"tree-table\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2015,\"menuName\":\"论文模块管理\",\"menuType\":\"M\",\"orderNum\":32,\"params\":{},\"parentId\":0,\"path\":\"paper\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-02 16:47:54', 10);
INSERT INTO `sys_oper_log` VALUES (139, '字典类型', 1, 'com.ruoyi.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"dictName\":\"用户身份\",\"dictType\":\"platform_user_status\",\"params\":{},\"remark\":\"论文管理平台的用户身份\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 08:57:56', 21);
INSERT INTO `sys_oper_log` VALUES (140, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"教师\",\"dictSort\":2,\"dictType\":\"platform_user_status\",\"dictValue\":\"ROLE_TEACHER\",\"listClass\":\"default\",\"params\":{},\"remark\":\"ROLE_TEACHER = 教师\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 09:02:38', 15);
INSERT INTO `sys_oper_log` VALUES (141, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"管理员\",\"dictSort\":1,\"dictType\":\"platform_user_status\",\"dictValue\":\"ROLE_ADMIN\",\"listClass\":\"default\",\"params\":{},\"remark\":\"ROLE_ADMIN = 管理员\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 09:03:18', 12);
INSERT INTO `sys_oper_log` VALUES (142, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"学生\",\"dictSort\":3,\"dictType\":\"platform_user_status\",\"dictValue\":\"ROLE_STUDENT\",\"listClass\":\"default\",\"params\":{},\"remark\":\"ROLE_STUDENT = 学生\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 09:04:14', 14);
INSERT INTO `sys_oper_log` VALUES (143, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"用户修改\",\"menuType\":\"F\",\"orderNum\":1,\"params\":{},\"parentId\":2012,\"perms\":\"platform:user:edit\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 09:21:07', 14);
INSERT INTO `sys_oper_log` VALUES (144, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"用户删除\",\"menuType\":\"F\",\"orderNum\":2,\"params\":{},\"parentId\":2012,\"perms\":\"platform:user:remove\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 09:22:22', 12);
INSERT INTO `sys_oper_log` VALUES (145, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"重置密码\",\"menuType\":\"F\",\"orderNum\":3,\"params\":{},\"parentId\":2012,\"perms\":\"platform:user:resetPwd\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 09:22:54', 10);
INSERT INTO `sys_oper_log` VALUES (146, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"plat_user\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 09:40:58', 76);
INSERT INTO `sys_oper_log` VALUES (147, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"user\",\"className\":\"PlatUser\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"主键ID\",\"columnId\":31,\"columnName\":\"id\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2024-07-03 09:40:58\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":6,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"姓名\",\"columnId\":32,\"columnName\":\"name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-03 09:40:58\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":6,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Password\",\"columnComment\":\"密码\",\"columnId\":33,\"columnName\":\"password\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-03 09:40:58\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"password\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":6,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"StudentId\",\"columnComment\":\"学号\",\"columnId\":34,\"columnName\":\"student_id\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-03 09:40:58\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 09:41:41', 33);
INSERT INTO `sys_oper_log` VALUES (148, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"plat_user\"}', NULL, 0, NULL, '2024-07-03 09:41:45', 155);
INSERT INTO `sys_oper_log` VALUES (149, '字典类型', 2, 'com.ruoyi.web.controller.system.SysDictTypeController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-07-03 08:57:56\",\"dictId\":102,\"dictName\":\"用户身份\",\"dictType\":\"platform_user_role\",\"params\":{},\"remark\":\"论文管理平台的用户身份\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 10:26:46', 37);
INSERT INTO `sys_oper_log` VALUES (150, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.resetPwd()', 'PUT', 1, 'admin', '研发部门', '/system/user/resetPwd', '127.0.0.1', '内网IP', '{\"admin\":false,\"params\":{},\"updateBy\":\"admin\",\"userId\":101}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 10:55:54', 78);
INSERT INTO `sys_oper_log` VALUES (151, '用户管理', 3, 'com.ruoyi.web.controller.system.SysUserController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/user/101', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 11:24:59', 19);
INSERT INTO `sys_oper_log` VALUES (152, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0\",\"children\":[],\"deptId\":100,\"deptName\":\"长安大学\",\"email\":\"ry@qq.com\",\"leader\":\"若依\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 11:46:04', 15);
INSERT INTO `sys_oper_log` VALUES (153, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100\",\"children\":[],\"deptId\":101,\"deptName\":\"信息工程学院\",\"email\":\"ry@qq.com\",\"leader\":\"若依\",\"orderNum\":1,\"params\":{},\"parentId\":100,\"parentName\":\"长安大学\",\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 11:46:18', 25);
INSERT INTO `sys_oper_log` VALUES (154, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101\",\"children\":[],\"deptId\":103,\"deptName\":\"软件工程\",\"email\":\"ry@qq.com\",\"leader\":\"若依\",\"orderNum\":1,\"params\":{},\"parentId\":101,\"parentName\":\"信息工程学院\",\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 11:46:31', 16);
INSERT INTO `sys_oper_log` VALUES (155, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101\",\"children\":[],\"deptId\":105,\"deptName\":\"计算机科学与技术\",\"email\":\"ry@qq.com\",\"leader\":\"若依\",\"orderNum\":3,\"params\":{},\"parentId\":101,\"parentName\":\"信息工程学院\",\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 11:46:43', 18);
INSERT INTO `sys_oper_log` VALUES (156, '部门管理', 3, 'com.ruoyi.web.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/104', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 11:46:47', 11);
INSERT INTO `sys_oper_log` VALUES (157, '部门管理', 3, 'com.ruoyi.web.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/106', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 11:46:50', 11);
INSERT INTO `sys_oper_log` VALUES (158, '部门管理', 3, 'com.ruoyi.web.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/107', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 11:46:53', 12);
INSERT INTO `sys_oper_log` VALUES (159, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100\",\"children\":[],\"deptId\":102,\"deptName\":\"机械工程学院\",\"email\":\"ry@qq.com\",\"leader\":\"若依\",\"orderNum\":2,\"params\":{},\"parentId\":100,\"parentName\":\"长安大学\",\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 11:47:16', 18);
INSERT INTO `sys_oper_log` VALUES (160, '部门管理', 3, 'com.ruoyi.web.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/108', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 11:47:33', 11);
INSERT INTO `sys_oper_log` VALUES (161, '部门管理', 3, 'com.ruoyi.web.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/109', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 11:47:36', 11);
INSERT INTO `sys_oper_log` VALUES (162, '部门管理', 1, 'com.ruoyi.web.controller.system.SysDeptController.add()', 'POST', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,102\",\"children\":[],\"createBy\":\"admin\",\"deptName\":\"机械工程\",\"orderNum\":1,\"params\":{},\"parentId\":102,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 11:49:31', 14);
INSERT INTO `sys_oper_log` VALUES (163, '部门管理', 1, 'com.ruoyi.web.controller.system.SysDeptController.add()', 'POST', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,102\",\"children\":[],\"createBy\":\"admin\",\"deptName\":\"能源与动力工程\",\"orderNum\":2,\"params\":{},\"parentId\":102,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 11:49:40', 11);
INSERT INTO `sys_oper_log` VALUES (164, '岗位管理', 2, 'com.ruoyi.web.controller.system.SysPostController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/post', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-06-29 09:22:56\",\"flag\":false,\"params\":{},\"postCode\":\"headmaster\",\"postId\":1,\"postName\":\"校长\",\"postSort\":1,\"remark\":\"\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 11:51:07', 14);
INSERT INTO `sys_oper_log` VALUES (165, '岗位管理', 2, 'com.ruoyi.web.controller.system.SysPostController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/post', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-06-29 09:22:56\",\"flag\":false,\"params\":{},\"postCode\":\"professor\",\"postId\":2,\"postName\":\"教授\",\"postSort\":2,\"remark\":\"\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 11:51:33', 12);
INSERT INTO `sys_oper_log` VALUES (166, '岗位管理', 2, 'com.ruoyi.web.controller.system.SysPostController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/post', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-06-29 09:22:56\",\"flag\":false,\"params\":{},\"postCode\":\"researcher\",\"postId\":3,\"postName\":\"研究员\",\"postSort\":3,\"remark\":\"\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 11:51:54', 11);
INSERT INTO `sys_oper_log` VALUES (167, '岗位管理', 2, 'com.ruoyi.web.controller.system.SysPostController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/post', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-06-29 09:22:56\",\"flag\":false,\"params\":{},\"postCode\":\"dean\",\"postId\":4,\"postName\":\"院长\",\"postSort\":4,\"remark\":\"\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 11:52:40', 10);
INSERT INTO `sys_oper_log` VALUES (168, '岗位管理', 1, 'com.ruoyi.web.controller.system.SysPostController.add()', 'POST', 1, 'admin', '研发部门', '/system/post', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"flag\":false,\"params\":{},\"postCode\":\"instructor\",\"postId\":5,\"postName\":\"讲师\",\"postSort\":5,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 11:53:35', 14);
INSERT INTO `sys_oper_log` VALUES (169, '角色管理', 3, 'com.ruoyi.web.controller.system.SysRoleController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/role/101', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 11:53:52', 23);
INSERT INTO `sys_oper_log` VALUES (170, '角色管理', 1, 'com.ruoyi.web.controller.system.SysRoleController.add()', 'POST', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"roleId\":102,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 11:54:35', 16);
INSERT INTO `sys_oper_log` VALUES (171, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-06-29 09:22:56\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 11:55:06', 20);
INSERT INTO `sys_oper_log` VALUES (172, '角色管理', 3, 'com.ruoyi.web.controller.system.SysRoleController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/role/100', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 11:55:14', 15);
INSERT INTO `sys_oper_log` VALUES (173, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-07-03 11:54:35\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"roleId\":102,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 11:55:24', 15);
INSERT INTO `sys_oper_log` VALUES (174, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-07-03 11:54:35\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"roleId\":102,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 11:55:41', 13);
INSERT INTO `sys_oper_log` VALUES (175, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2024-06-29 09:22:56\",\"delFlag\":\"0\",\"dept\":{\"ancestors\":\"0,100,101\",\"children\":[],\"deptId\":105,\"deptName\":\"计算机科学与技术\",\"leader\":\"若依\",\"orderNum\":3,\"params\":{},\"parentId\":101,\"status\":\"0\"},\"deptId\":103,\"email\":\"ry@qq.com\",\"loginDate\":\"2024-06-29 09:22:56\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"王老师\",\"params\":{},\"phonenumber\":\"15666666666\",\"postIds\":[2],\"remark\":\"\",\"roleIds\":[102],\"roles\":[{\"admin\":false,\"dataScope\":\"2\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":2,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\"}],\"sex\":\"1\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":2,\"userName\":\"ry\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 11:56:45', 20);
INSERT INTO `sys_oper_log` VALUES (176, '用户管理', 3, 'com.ruoyi.web.controller.system.SysUserController.remove()', 'DELETE', 1, 'admin', '软件工程', '/system/user/2', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 11:59:16', 11);
INSERT INTO `sys_oper_log` VALUES (177, '用户管理', 1, 'com.ruoyi.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '软件工程', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptId\":103,\"nickName\":\"王老师\",\"params\":{},\"postIds\":[],\"roleIds\":[102],\"status\":\"0\",\"userId\":102,\"userName\":\"王老师\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 12:00:11', 87);
INSERT INTO `sys_oper_log` VALUES (178, '用户管理', 1, 'com.ruoyi.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '软件工程', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptId\":103,\"nickName\":\"张三\",\"params\":{},\"postIds\":[],\"roleIds\":[2],\"status\":\"0\",\"userId\":103,\"userName\":\"张三\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 12:00:43', 84);
INSERT INTO `sys_oper_log` VALUES (179, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2024-07-03 12:00:11\",\"delFlag\":\"0\",\"dept\":{\"ancestors\":\"0,100,101\",\"children\":[],\"deptId\":103,\"deptName\":\"软件工程\",\"leader\":\"若依\",\"orderNum\":1,\"params\":{},\"parentId\":101,\"status\":\"0\"},\"deptId\":103,\"email\":\"\",\"loginIp\":\"\",\"nickName\":\"王老师\",\"params\":{},\"phonenumber\":\"\",\"postIds\":[2],\"roleIds\":[102],\"roles\":[{\"admin\":false,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":102,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":102,\"userName\":\"王老师\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 12:00:52', 13);
INSERT INTO `sys_oper_log` VALUES (180, '用户管理', 1, 'com.ruoyi.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '软件工程', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptId\":105,\"nickName\":\"李四\",\"params\":{},\"postIds\":[],\"roleIds\":[2],\"status\":\"0\",\"userId\":104,\"userName\":\"李四\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 13:16:33', 113);
INSERT INTO `sys_oper_log` VALUES (181, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"platform/user/index\",\"createTime\":\"2024-07-02 16:41:13\",\"icon\":\"user\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2012,\"menuName\":\"平台用户\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2011,\"path\":\"user\",\"perms\":\"platform:user:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 13:17:19', 19);
INSERT INTO `sys_oper_log` VALUES (182, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"star\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"课题管理\",\"menuType\":\"M\",\"orderNum\":30,\"params\":{},\"parentId\":0,\"path\":\"课题\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 13:52:20', 14);
INSERT INTO `sys_oper_log` VALUES (183, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-03 13:52:20\",\"icon\":\"star\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2019,\"menuName\":\"课题管理\",\"menuType\":\"M\",\"orderNum\":30,\"params\":{},\"parentId\":0,\"path\":\"select\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 13:53:32', 12);
INSERT INTO `sys_oper_log` VALUES (184, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '软件工程', '/system/menu/2019', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 13:56:27', 18);
INSERT INTO `sys_oper_log` VALUES (185, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-02 16:46:54\",\"icon\":\"tree-table\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2015,\"menuName\":\"课题管理\",\"menuType\":\"C\",\"orderNum\":33,\"params\":{},\"parentId\":0,\"path\":\"paper\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 13:59:08', 12);
INSERT INTO `sys_oper_log` VALUES (186, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '软件工程', '/system/menu/2015', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 13:59:35', 15);
INSERT INTO `sys_oper_log` VALUES (187, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '软件工程', '/system/menu/2012', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}', 0, NULL, '2024-07-03 13:59:40', 3);
INSERT INTO `sys_oper_log` VALUES (188, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '软件工程', '/system/menu/2016', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 13:59:47', 10);
INSERT INTO `sys_oper_log` VALUES (189, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '软件工程', '/system/menu/2017', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 13:59:49', 12);
INSERT INTO `sys_oper_log` VALUES (190, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '软件工程', '/system/menu/2018', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 13:59:51', 14);
INSERT INTO `sys_oper_log` VALUES (191, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '软件工程', '/system/menu/2012', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 13:59:53', 11);
INSERT INTO `sys_oper_log` VALUES (192, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"platform/paper/index\",\"createTime\":\"2024-07-02 16:42:50\",\"icon\":\"peoples\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2013,\"menuName\":\"课题管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2011,\"path\":\"paper\",\"perms\":\"platform:paper:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 14:00:53', 12);
INSERT INTO `sys_oper_log` VALUES (193, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-02 16:39:46\",\"icon\":\"redis-list\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2011,\"menuName\":\"论文管理平台\",\"menuType\":\"M\",\"orderNum\":30,\"params\":{},\"parentId\":0,\"path\":\"platform\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 14:01:04', 11);
INSERT INTO `sys_oper_log` VALUES (194, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '软件工程', '/system/menu/2014', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 14:01:20', 12);
INSERT INTO `sys_oper_log` VALUES (195, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"platform/paper/index\",\"createTime\":\"2024-07-02 16:42:50\",\"icon\":\"form\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2013,\"menuName\":\"课题管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2011,\"path\":\"paper\",\"perms\":\"platform:paper:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 14:01:41', 9);
INSERT INTO `sys_oper_log` VALUES (196, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"form\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"课题审核\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2011,\"path\":\"paper_\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 14:13:37', 9);
INSERT INTO `sys_oper_log` VALUES (197, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"platform/paperAdmin/index\",\"createTime\":\"2024-07-03 14:13:37\",\"icon\":\"form\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2020,\"menuName\":\"课题审核\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2011,\"path\":\"paperAdmin\",\"perms\":\"platform:paperAdmin:index\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 14:15:14', 11);
INSERT INTO `sys_oper_log` VALUES (198, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"platform/topicMatch/index\",\"createBy\":\"admin\",\"icon\":\"eye-open\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"课题匹配状况\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2011,\"path\":\"topicMatch\",\"perms\":\"platform:topicMatch:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 14:18:24', 10);
INSERT INTO `sys_oper_log` VALUES (199, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"platform/paperManage/index\",\"createTime\":\"2024-07-02 16:42:50\",\"icon\":\"form\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2013,\"menuName\":\"课题管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2011,\"path\":\"paperManage\",\"perms\":\"platform:paperManage:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 14:18:54', 10);
INSERT INTO `sys_oper_log` VALUES (200, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"platform/topicAudit/index\",\"createTime\":\"2024-07-03 14:13:37\",\"icon\":\"form\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2020,\"menuName\":\"课题审核\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2011,\"path\":\"topicAudit\",\"perms\":\"platform:topicAudit:index\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 14:20:18', 9);
INSERT INTO `sys_oper_log` VALUES (201, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"platform/topicSelect/index\",\"createBy\":\"admin\",\"icon\":\"button\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"选择课题\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":2011,\"path\":\"topicSelect\",\"perms\":\"platform:topicSelect:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 14:25:21', 9);
INSERT INTO `sys_oper_log` VALUES (202, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"platform/topicWatch/index\",\"createBy\":\"admin\",\"icon\":\"eye\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"选题查看\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":2011,\"path\":\"topicWatch\",\"perms\":\"platform:topicWatch:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 14:27:46', 12);
INSERT INTO `sys_oper_log` VALUES (203, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"platform/selectAudit/index\",\"createBy\":\"admin\",\"icon\":\"example\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"选题审核\",\"menuType\":\"C\",\"orderNum\":6,\"params\":{},\"parentId\":2011,\"path\":\"selectAudit\",\"perms\":\"platform:selectAudit:index\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 14:29:04', 13);
INSERT INTO `sys_oper_log` VALUES (204, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '软件工程', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"plat_paper\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 15:01:42', 68);
INSERT INTO `sys_oper_log` VALUES (205, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '软件工程', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"paperManage\",\"className\":\"PlatPaper\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"主键ID\",\"columnId\":42,\"columnName\":\"id\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2024-07-03 15:01:42\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":7,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Topic\",\"columnComment\":\"题目\",\"columnId\":43,\"columnName\":\"topic\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-03 15:01:42\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"topic\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":7,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Type\",\"columnComment\":\"类型\",\"columnId\":44,\"columnName\":\"type\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-03 15:01:42\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"select\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"type\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":7,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Ask\",\"columnComment\":\"要求\",\"columnId\":45,\"columnName\":\"ask\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-03 15:01:42\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"ask\",\"javaType\":\"String\",\"li', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 15:42:25', 41);
INSERT INTO `sys_oper_log` VALUES (206, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '软件工程', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"plat_paper\"}', NULL, 0, NULL, '2024-07-03 15:42:37', 40);
INSERT INTO `sys_oper_log` VALUES (207, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '软件工程', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"plat_paper\"}', NULL, 0, NULL, '2024-07-03 15:42:50', 29);
INSERT INTO `sys_oper_log` VALUES (208, '论文管理', 1, 'com.ruoyi.web.controller.platform.PlatPaperController.add()', 'POST', 1, 'admin', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"ask\":\"222\",\"id\":1,\"params\":{},\"topic\":\"课题1\",\"type\":\"工程设计\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 15:53:41', 29);
INSERT INTO `sys_oper_log` VALUES (209, '论文管理', 1, 'com.ruoyi.web.controller.platform.PlatPaperController.add()', 'POST', 1, 'admin', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"ask\":\"22222\",\"code\":\"未审核\",\"id\":2,\"params\":{},\"topic\":\"课题2\",\"type\":\"专题研究\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 16:00:25', 11);
INSERT INTO `sys_oper_log` VALUES (210, '论文管理', 1, 'com.ruoyi.web.controller.platform.PlatPaperController.add()', 'POST', 1, 'admin', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"ask\":\"wwww www我\",\"code\":\"未审核\",\"id\":3,\"params\":{},\"topic\":\"课题3\",\"type\":\"文献综述\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 16:01:24', 9);
INSERT INTO `sys_oper_log` VALUES (211, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"课题查询\",\"menuType\":\"F\",\"orderNum\":1,\"params\":{},\"parentId\":2013,\"perms\":\"platform:paperManage:query\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 16:20:26', 31);
INSERT INTO `sys_oper_log` VALUES (212, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"课题新增\",\"menuType\":\"F\",\"orderNum\":2,\"params\":{},\"parentId\":2013,\"perms\":\"platform:paperManage:add\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 16:21:03', 12);
INSERT INTO `sys_oper_log` VALUES (213, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"课题修改\",\"menuType\":\"F\",\"orderNum\":3,\"params\":{},\"parentId\":2013,\"perms\":\"platform:paperManage:edit\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 16:21:21', 10);
INSERT INTO `sys_oper_log` VALUES (214, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"课题删除\",\"menuType\":\"F\",\"orderNum\":4,\"params\":{},\"parentId\":2013,\"perms\":\"platform:paperManage:remove\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 16:21:44', 13);
INSERT INTO `sys_oper_log` VALUES (215, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"课题导出\",\"menuType\":\"F\",\"orderNum\":5,\"params\":{},\"parentId\":2013,\"perms\":\"platform:paperManage:export\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 16:22:17', 12);
INSERT INTO `sys_oper_log` VALUES (216, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"课题导入\",\"menuType\":\"F\",\"orderNum\":6,\"params\":{},\"parentId\":2013,\"perms\":\"platform:paperManage:import\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 16:22:33', 10);
INSERT INTO `sys_oper_log` VALUES (217, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"ask\":\"32二分法\",\"id\":1,\"params\":{},\"topic\":\"课题2\",\"type\":\"综合实验\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 16:39:48', 19);
INSERT INTO `sys_oper_log` VALUES (218, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"ask\":\"22222\",\"code\":\"未审核\",\"id\":2,\"params\":{},\"topic\":\"课题2\",\"type\":\"工程设计\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 16:39:59', 7);
INSERT INTO `sys_oper_log` VALUES (219, '论文管理', 3, 'com.ruoyi.web.controller.platform.PlatPaperController.remove()', 'DELETE', 1, 'admin', '软件工程', '/platform/paperManage/1', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 16:44:26', 11);
INSERT INTO `sys_oper_log` VALUES (220, '论文管理', 1, 'com.ruoyi.web.controller.platform.PlatPaperController.add()', 'POST', 1, 'admin', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"ask\":\"我清道夫\",\"code\":\"未审核\",\"id\":4,\"params\":{},\"teacherName\":\"admin\",\"topic\":\"我的\",\"type\":\"专题研究\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 17:04:01', 23);
INSERT INTO `sys_oper_log` VALUES (221, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"code\":\"已审核\",\"id\":2,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 17:31:26', 21);
INSERT INTO `sys_oper_log` VALUES (222, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"code\":\"已审核\",\"id\":3,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 17:31:32', 11);
INSERT INTO `sys_oper_log` VALUES (223, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"code\":\"未审核\",\"id\":3,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 17:31:36', 8);
INSERT INTO `sys_oper_log` VALUES (224, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"code\":\"未审核\",\"id\":3,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 17:32:18', 3);
INSERT INTO `sys_oper_log` VALUES (225, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"code\":\"已审核\",\"id\":3,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 17:32:28', 9);
INSERT INTO `sys_oper_log` VALUES (226, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"code\":\"未审核\",\"id\":3,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 17:32:31', 8);
INSERT INTO `sys_oper_log` VALUES (227, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"code\":\"已通过\",\"id\":2,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 17:32:55', 16);
INSERT INTO `sys_oper_log` VALUES (228, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"code\":\"未通过\",\"id\":2,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 17:32:57', 10);
INSERT INTO `sys_oper_log` VALUES (229, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"code\":\"未通过\",\"id\":3,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 17:33:00', 10);
INSERT INTO `sys_oper_log` VALUES (230, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"code\":\"已通过\",\"id\":2,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 17:33:02', 10);
INSERT INTO `sys_oper_log` VALUES (231, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '软件工程', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"plat_select_paper\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 17:48:38', 66);
INSERT INTO `sys_oper_log` VALUES (232, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '软件工程', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"select_paper\",\"className\":\"PlatSelectPaper\",\"columns\":[{\"capJavaField\":\"Id\",\"columnId\":54,\"columnName\":\"id\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2024-07-03 17:48:38\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":8,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"StudentId\",\"columnComment\":\"学生学号\",\"columnId\":55,\"columnName\":\"student_id\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-03 17:48:38\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"studentId\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":8,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"SelectId1\",\"columnComment\":\"学生选择的论文id1\",\"columnId\":56,\"columnName\":\"select_id_1\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2024-07-03 17:48:38\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"selectId1\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":8,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"SelectId2\",\"columnComment\":\"学生选择的论文id2\",\"columnId\":57,\"columnName\":\"select_id_2\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2024-07-03 17:48:38\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"se', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-03 17:49:57', 23);
INSERT INTO `sys_oper_log` VALUES (233, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '软件工程', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"plat_select_paper\"}', NULL, 0, NULL, '2024-07-03 17:50:01', 153);
INSERT INTO `sys_oper_log` VALUES (234, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '软件工程', '/tool/gen/8', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-04 09:50:31', 36);
INSERT INTO `sys_oper_log` VALUES (235, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '软件工程', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"plat_select_paper\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-04 09:50:36', 40);
INSERT INTO `sys_oper_log` VALUES (236, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '软件工程', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"paperSel\",\"className\":\"PlatSelectPaper\",\"columns\":[{\"capJavaField\":\"Id\",\"columnId\":59,\"columnName\":\"id\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2024-07-04 09:50:36\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":9,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"学生学号\",\"columnId\":60,\"columnName\":\"user_id\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-04 09:50:36\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":9,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"SelectId1\",\"columnComment\":\"学生选择的论文id1\",\"columnId\":61,\"columnName\":\"select_id_1\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2024-07-04 09:50:36\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"selectId1\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":9,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"SelectId2\",\"columnComment\":\"学生选择的论文id2\",\"columnId\":62,\"columnName\":\"select_id_2\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2024-07-04 09:50:36\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"selectId2\",\"javaT', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-04 09:52:42', 29);
INSERT INTO `sys_oper_log` VALUES (237, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '软件工程', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"selectPaper\",\"className\":\"PlatSelectPaper\",\"columns\":[{\"capJavaField\":\"Id\",\"columnId\":59,\"columnName\":\"id\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2024-07-04 09:50:36\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":9,\"updateBy\":\"\",\"updateTime\":\"2024-07-04 09:52:42\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"学生学号\",\"columnId\":60,\"columnName\":\"user_id\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-04 09:50:36\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":9,\"updateBy\":\"\",\"updateTime\":\"2024-07-04 09:52:42\",\"usableColumn\":false},{\"capJavaField\":\"SelectId1\",\"columnComment\":\"学生选择的论文id1\",\"columnId\":61,\"columnName\":\"select_id_1\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2024-07-04 09:50:36\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"selectId1\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":9,\"updateBy\":\"\",\"updateTime\":\"2024-07-04 09:52:42\",\"usableColumn\":false},{\"capJavaField\":\"SelectId2\",\"columnComment\":\"学生选择的论文id2\",\"columnId\":62,\"columnName\":\"select_id_2\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2024-07-04 09:50:36\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncreme', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-04 09:53:37', 18);
INSERT INTO `sys_oper_log` VALUES (238, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '软件工程', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"plat_select_paper\"}', NULL, 0, NULL, '2024-07-04 10:01:12', 43);
INSERT INTO `sys_oper_log` VALUES (239, '学生选择的3个课题号', 1, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.add()', 'POST', 1, 'admin', '软件工程', '/platform/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3,\"selectId3\":4,\"userId\":1}', NULL, 1, '', '2024-07-04 11:19:36', 8);
INSERT INTO `sys_oper_log` VALUES (240, '学生选择的3个课题号', 1, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.add()', 'POST', 1, 'admin', '软件工程', '/platform/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3,\"selectId3\":4,\"userId\":1}', NULL, 1, '', '2024-07-04 11:31:08', 10);
INSERT INTO `sys_oper_log` VALUES (241, '学生选择的3个课题号', 1, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.add()', 'POST', 1, 'admin', '软件工程', '/platform/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3,\"userId\":1}', NULL, 1, '', '2024-07-04 11:35:57', 10);
INSERT INTO `sys_oper_log` VALUES (242, '学生选择的3个课题号', 1, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.add()', 'POST', 1, 'admin', '软件工程', '/platform/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3,\"userId\":1}', NULL, 1, '', '2024-07-04 11:40:10', 14);
INSERT INTO `sys_oper_log` VALUES (243, '学生选择的3个课题号', 1, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.add()', 'POST', 1, 'admin', '软件工程', '/platform/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3,\"userId\":1}', NULL, 1, '', '2024-07-04 11:41:01', 3);
INSERT INTO `sys_oper_log` VALUES (244, '学生选择的3个课题号', 1, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.add()', 'POST', 1, 'admin', '软件工程', '/platform/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3,\"userId\":1}', NULL, 1, '', '2024-07-04 11:41:11', 3);
INSERT INTO `sys_oper_log` VALUES (245, '学生选择的3个课题号', 1, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.add()', 'POST', 1, 'admin', '软件工程', '/platform/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3,\"selectId3\":4,\"userId\":1}', NULL, 1, '', '2024-07-04 11:42:06', 4);
INSERT INTO `sys_oper_log` VALUES (246, '学生选择的3个课题号', 1, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.add()', 'POST', 1, 'admin', '软件工程', '/platform/selectPaper', '127.0.0.1', '内网IP', '{\"id\":2,\"params\":{},\"selectId1\":2,\"selectId2\":3,\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-04 14:24:15', 22);
INSERT INTO `sys_oper_log` VALUES (247, '学生选择的3个课题号', 1, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.add()', 'POST', 1, 'admin', '软件工程', '/platform/selectPaper', '127.0.0.1', '内网IP', '{\"id\":3,\"params\":{},\"selectId1\":4,\"selectId2\":3,\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-04 14:25:13', 12);
INSERT INTO `sys_oper_log` VALUES (248, '学生选择的3个课题号', 1, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.add()', 'POST', 1, 'admin', '软件工程', '/platform/selectPaper', '127.0.0.1', '内网IP', '{\"id\":4,\"params\":{},\"selectId1\":2,\"selectId2\":4,\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-04 14:33:27', 26);
INSERT INTO `sys_oper_log` VALUES (249, '学生选择的3个课题号', 1, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.add()', 'POST', 1, 'admin', '软件工程', '/platform/selectPaper', '127.0.0.1', '内网IP', '{\"id\":5,\"params\":{},\"selectId1\":3,\"selectId2\":4,\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-04 14:35:42', 23);
INSERT INTO `sys_oper_log` VALUES (250, '学生选择的3个课题号', 1, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.add()', 'POST', 1, 'admin', '软件工程', '/platform/selectPaper', '127.0.0.1', '内网IP', '{\"id\":6,\"params\":{},\"selectId1\":2,\"selectId2\":3,\"selectId3\":4,\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-04 14:39:08', 27);
INSERT INTO `sys_oper_log` VALUES (251, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3,\"userId\":1}', NULL, 1, '', '2024-07-04 14:41:29', 8);
INSERT INTO `sys_oper_log` VALUES (252, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3,\"selectId3\":4,\"userId\":1}', NULL, 1, '', '2024-07-04 14:43:54', 3);
INSERT INTO `sys_oper_log` VALUES (253, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3,\"selectId3\":4,\"userId\":1}', NULL, 1, '', '2024-07-04 14:45:32', 3);
INSERT INTO `sys_oper_log` VALUES (254, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3,\"selectId3\":4,\"userId\":1}', NULL, 1, '', '2024-07-04 14:48:53', 3);
INSERT INTO `sys_oper_log` VALUES (255, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":3,\"userId\":1}', NULL, 1, '', '2024-07-04 14:50:42', 3);
INSERT INTO `sys_oper_log` VALUES (256, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":3,\"userId\":1}', NULL, 1, '', '2024-07-04 14:51:03', 3);
INSERT INTO `sys_oper_log` VALUES (257, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"code\":\"已通过\",\"id\":3,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-04 15:03:37', 16);
INSERT INTO `sys_oper_log` VALUES (258, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"code\":\"已通过\",\"id\":4,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-04 15:03:39', 10);
INSERT INTO `sys_oper_log` VALUES (259, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"userId\":1}', NULL, 1, '', '2024-07-04 15:03:50', 5);
INSERT INTO `sys_oper_log` VALUES (260, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3,\"userId\":1}', NULL, 1, '', '2024-07-04 15:05:52', 3);
INSERT INTO `sys_oper_log` VALUES (261, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3,\"userId\":1}', NULL, 1, '', '2024-07-04 15:07:21', 4);
INSERT INTO `sys_oper_log` VALUES (262, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3}', NULL, 1, '', '2024-07-04 15:18:01', 11);
INSERT INTO `sys_oper_log` VALUES (263, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3}', NULL, 1, '', '2024-07-04 15:20:32', 4);
INSERT INTO `sys_oper_log` VALUES (264, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3,\"selectId3\":4}', NULL, 1, '请先选择3个课题', '2024-07-04 15:20:49', 9);
INSERT INTO `sys_oper_log` VALUES (265, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3,\"selectId3\":4}', NULL, 1, '', '2024-07-04 15:22:45', 8);
INSERT INTO `sys_oper_log` VALUES (266, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3,\"selectId3\":4}', NULL, 1, '', '2024-07-04 15:24:14', 12);
INSERT INTO `sys_oper_log` VALUES (267, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-04 15:28:43', 15);
INSERT INTO `sys_oper_log` VALUES (268, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-04 15:31:06', 16);
INSERT INTO `sys_oper_log` VALUES (269, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3,\"selectId3\":4}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-04 15:32:38', 6);
INSERT INTO `sys_oper_log` VALUES (270, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3,\"selectId3\":4}', NULL, 1, '2', '2024-07-04 15:34:29', 5);
INSERT INTO `sys_oper_log` VALUES (271, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3,\"selectId3\":4}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-04 15:36:49', 16);
INSERT INTO `sys_oper_log` VALUES (272, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-04 15:36:59', 6);
INSERT INTO `sys_oper_log` VALUES (273, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3,\"selectId3\":4}', NULL, 1, 'com.ruoyi.platform.domain.PlatSelectPaper@5a45a557[\r\n  id=<null>\r\n  userId=1\r\n  selectId1=<null>\r\n  selectId2=<null>\r\n  selectId3=<null>\r\n]', '2024-07-04 15:43:11', 18);
INSERT INTO `sys_oper_log` VALUES (274, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3,\"selectId3\":4}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-04 15:47:59', 13);
INSERT INTO `sys_oper_log` VALUES (275, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-04 15:48:02', 5);
INSERT INTO `sys_oper_log` VALUES (276, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3,\"selectId3\":4}', NULL, 1, 'com.ruoyi.platform.domain.PlatSelectPaper@465e339b[\r\n  id=<null>\r\n  userId=1\r\n  selectId1=2\r\n  selectId2=3\r\n  selectId3=4\r\n]', '2024-07-04 15:49:46', 13);
INSERT INTO `sys_oper_log` VALUES (277, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3,\"selectId3\":4}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-04 15:52:14', 26);
INSERT INTO `sys_oper_log` VALUES (278, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3,\"selectId3\":4}', NULL, 1, '所选课题超出3个', '2024-07-04 15:55:04', 9);
INSERT INTO `sys_oper_log` VALUES (279, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":3,\"selectId2\":4}', NULL, 1, '所选课题超出3个', '2024-07-04 15:55:08', 7);
INSERT INTO `sys_oper_log` VALUES (280, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":3,\"selectId2\":4,\"selectId3\":2}', NULL, 1, '所选课题超出3个', '2024-07-04 15:55:11', 8);
INSERT INTO `sys_oper_log` VALUES (281, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2}', NULL, 1, '所选课题超出3个', '2024-07-04 15:55:56', 8);
INSERT INTO `sys_oper_log` VALUES (282, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3}', NULL, 1, '所选课题超出3个', '2024-07-04 15:57:58', 6);
INSERT INTO `sys_oper_log` VALUES (283, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-06-29 09:22:56\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2011,2020,2013,2025,2026,2027,2028,2029,2030,2021,2022,2023,2024],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-04 15:58:35', 38);
INSERT INTO `sys_oper_log` VALUES (284, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"选择课题\",\"menuType\":\"F\",\"orderNum\":1,\"params\":{},\"parentId\":2022,\"perms\":\"platform:selectPaper:edit\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-04 16:00:56', 14);
INSERT INTO `sys_oper_log` VALUES (285, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"删除所选课题\",\"menuType\":\"F\",\"orderNum\":2,\"params\":{},\"parentId\":2022,\"perms\":\"platform:selectPaper:remove\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-04 16:01:17', 9);
INSERT INTO `sys_oper_log` VALUES (286, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"查看所选课题\",\"menuType\":\"F\",\"orderNum\":3,\"params\":{},\"parentId\":2022,\"perms\":\"platform:selectPaper:query\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-04 16:02:00', 11);
INSERT INTO `sys_oper_log` VALUES (287, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"导出所选课题\",\"menuType\":\"F\",\"orderNum\":4,\"params\":{},\"parentId\":2022,\"perms\":\"platform:selectPaper:export\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-04 16:03:34', 9);
INSERT INTO `sys_oper_log` VALUES (288, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"展示所选课题\",\"menuType\":\"F\",\"orderNum\":5,\"params\":{},\"parentId\":2022,\"perms\":\"platform:selectPaper:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-04 16:04:20', 9);
INSERT INTO `sys_oper_log` VALUES (289, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-04 16:02:00\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2033,\"menuName\":\"查询所选课题\",\"menuType\":\"F\",\"orderNum\":3,\"params\":{},\"parentId\":2022,\"path\":\"\",\"perms\":\"platform:selectPaper:query\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-04 16:04:28', 10);
INSERT INTO `sys_oper_log` VALUES (290, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-06-29 09:22:56\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2011,2020,2013,2025,2026,2027,2028,2029,2030,2021,2022,2031,2032,2033,2034,2035,2023,2024],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-04 16:04:47', 18);
INSERT INTO `sys_oper_log` VALUES (291, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, '张三', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":3,\"selectId2\":4}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-04 16:05:12', 11);
INSERT INTO `sys_oper_log` VALUES (292, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, '张三', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":3,\"selectId2\":4,\"selectId3\":2}', NULL, 1, '所选课题超出3个', '2024-07-04 16:06:23', 5);
INSERT INTO `sys_oper_log` VALUES (293, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, '张三', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3,\"selectId3\":4}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-04 16:07:00', 11);
INSERT INTO `sys_oper_log` VALUES (294, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, '张三', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3,\"selectId3\":4}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-04 16:08:10', 27);
INSERT INTO `sys_oper_log` VALUES (295, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, '张三', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2}', NULL, 1, '所选课题超出3个', '2024-07-04 16:08:12', 5);
INSERT INTO `sys_oper_log` VALUES (296, '学生选择的3个课题号', 3, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.delSelectPaperByPaperId()', 'DELETE', 1, 'admin', '软件工程', '/platform/selectPaper/delSelectPaperByPaperId/3', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-04 17:17:01', 22);
INSERT INTO `sys_oper_log` VALUES (297, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":3,\"selectId2\":4}', NULL, 1, '所选课题超出3个', '2024-07-04 18:08:22', 12);
INSERT INTO `sys_oper_log` VALUES (298, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":4}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-04 18:08:37', 12);
INSERT INTO `sys_oper_log` VALUES (299, '学生选择的3个课题号', 3, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.delSelectPaperByPaperId()', 'DELETE', 1, 'admin', '软件工程', '/platform/selectPaper/delSelectPaperByPaperId/4', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-04 18:09:43', 14);
INSERT INTO `sys_oper_log` VALUES (300, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, 'admin', '软件工程', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":4}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 08:36:29', 19);
INSERT INTO `sys_oper_log` VALUES (301, '学生选择的3个课题号', 3, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.delSelectPaperByPaperId()', 'DELETE', 1, 'admin', '软件工程', '/platform/selectPaper/delSelectPaperByPaperId/4', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 09:37:54', 17);
INSERT INTO `sys_oper_log` VALUES (302, '学生选择的3个课题号', 3, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.delSelectPaperByPaperId()', 'DELETE', 1, 'admin', '软件工程', '/platform/selectPaper/delSelectPaperByPaperId/4', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 09:37:58', 15);
INSERT INTO `sys_oper_log` VALUES (303, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"bond\":\"0\",\"params\":{},\"topic\":\"课题2\"}', NULL, 1, 'com.ruoyi.platform.domain.PlatPaper@25a2f749[\r\n  id=<null>\r\n  topic=课题2\r\n  type=<null>\r\n  ask=<null>\r\n  code=<null>\r\n  teacherName=<null>\r\n  teacherPhone=<null>\r\n  bond=0\r\n  gradeInstruct=<null>\r\n  gradeReview=<null>\r\n  gradeDefence=<null>\r\n  grade=<null>\r\n]', '2024-07-05 14:35:49', 12);
INSERT INTO `sys_oper_log` VALUES (304, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"bond\":\"0\",\"params\":{},\"topic\":\"课题2\"}', NULL, 1, 'com.ruoyi.platform.domain.PlatPaper@3162fa36[\r\n  id=<null>\r\n  topic=课题2\r\n  type=<null>\r\n  ask=<null>\r\n  code=<null>\r\n  teacherName=<null>\r\n  teacherPhone=<null>\r\n  bond=0\r\n  gradeInstruct=<null>\r\n  gradeReview=<null>\r\n  gradeDefence=<null>\r\n  grade=<null>\r\n]', '2024-07-05 14:36:39', 0);
INSERT INTO `sys_oper_log` VALUES (305, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"bond\":\"2021901025\",\"params\":{},\"topic\":\"课题3\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 14:37:27', 18);
INSERT INTO `sys_oper_log` VALUES (306, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"bond\":\"2021901025\",\"params\":{},\"topic\":\"课题3\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 14:44:45', 16);
INSERT INTO `sys_oper_log` VALUES (307, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"bond\":\"2021901025\",\"params\":{},\"topic\":\"课题2\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 14:44:51', 9);
INSERT INTO `sys_oper_log` VALUES (308, '字典类型', 1, 'com.ruoyi.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', '软件工程', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"dictName\":\"选题审核状态\",\"dictType\":\"platform_selectaudit_status\",\"params\":{},\"remark\":\"教师审核学生的选题\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 14:49:40', 18);
INSERT INTO `sys_oper_log` VALUES (309, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '软件工程', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"未审核\",\"dictSort\":1,\"dictType\":\"platform_selectaudit_status\",\"dictValue\":\"null\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 14:50:12', 15);
INSERT INTO `sys_oper_log` VALUES (310, '字典类型', 3, 'com.ruoyi.web.controller.system.SysDictDataController.remove()', 'DELETE', 1, 'admin', '软件工程', '/system/dict/data/105', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 14:50:43', 18);
INSERT INTO `sys_oper_log` VALUES (311, '字典类型', 3, 'com.ruoyi.web.controller.system.SysDictTypeController.remove()', 'DELETE', 1, 'admin', '软件工程', '/system/dict/type/103', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 14:50:53', 17);
INSERT INTO `sys_oper_log` VALUES (312, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"bond\":\"0\",\"params\":{},\"topic\":\"课题3\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 14:58:18', 10);
INSERT INTO `sys_oper_log` VALUES (313, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"bond\":\"0\",\"params\":{},\"topic\":\"课题3\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 14:58:38', 3);
INSERT INTO `sys_oper_log` VALUES (314, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"bond\":\"0\",\"params\":{},\"topic\":\"课题2\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 14:59:59', 9);
INSERT INTO `sys_oper_log` VALUES (315, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"bond\":\"0\",\"params\":{},\"topic\":\"课题3\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:00:34', 3);
INSERT INTO `sys_oper_log` VALUES (316, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"bond\":\"0\",\"params\":{},\"topic\":\"课题3\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:04:14', 3);
INSERT INTO `sys_oper_log` VALUES (317, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"bond\":\"2021901025\",\"params\":{},\"topic\":\"课题2\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:07:17', 9);
INSERT INTO `sys_oper_log` VALUES (318, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"bond\":\"0\",\"params\":{},\"topic\":\"课题2\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:07:20', 15);
INSERT INTO `sys_oper_log` VALUES (319, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"bond\":\"2021901025\",\"params\":{},\"topic\":\"课题3\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:07:53', 11);
INSERT INTO `sys_oper_log` VALUES (320, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"bond\":\"0\",\"params\":{},\"topic\":\"课题3\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:07:55', 10);
INSERT INTO `sys_oper_log` VALUES (321, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"params\":{},\"topic\":\"课题2\"}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'where topic = \'课题2\'\' at line 3\r\n### The error may exist in file [F:\\代码练习\\IDEA Code\\校内培训\\阶段一课设\\论文管理平台\\ruoyi-platform\\target\\classes\\mapper\\platform\\PlatPaperMapper.xml]\r\n### The error may involve com.ruoyi.platform.mapper.PlatPaperMapper.updatePaperManageBondInfoByTeacher-Inline\r\n### The error occurred while setting parameters\r\n### SQL: update plat_paper                    where topic = ?\r\n### Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'where topic = \'课题2\'\' at line 3\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'where topic = \'课题2\'\' at line 3', '2024-07-05 15:08:24', 46);
INSERT INTO `sys_oper_log` VALUES (322, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"bond\":\"2021901025\",\"params\":{},\"topic\":\"课题3\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:08:36', 9);
INSERT INTO `sys_oper_log` VALUES (323, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"params\":{},\"topic\":\"课题2\"}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'where topic = \'课题2\'\' at line 3\r\n### The error may exist in file [F:\\代码练习\\IDEA Code\\校内培训\\阶段一课设\\论文管理平台\\ruoyi-platform\\target\\classes\\mapper\\platform\\PlatPaperMapper.xml]\r\n### The error may involve com.ruoyi.platform.mapper.PlatPaperMapper.updatePaperManageBondInfoByTeacher-Inline\r\n### The error occurred while setting parameters\r\n### SQL: update plat_paper                    where topic = ?\r\n### Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'where topic = \'课题2\'\' at line 3\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'where topic = \'课题2\'\' at line 3', '2024-07-05 15:12:31', 4);
INSERT INTO `sys_oper_log` VALUES (324, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"bond\":\"0\",\"params\":{},\"topic\":\"课题3\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:12:33', 9);
INSERT INTO `sys_oper_log` VALUES (325, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"bond\":\"2021901025\",\"params\":{},\"topic\":\"课题3\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:13:04', 9);
INSERT INTO `sys_oper_log` VALUES (326, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"bond\":\"2021901025\",\"params\":{},\"topic\":\"课题2\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:13:26', 8);
INSERT INTO `sys_oper_log` VALUES (327, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"bond\":\"0\",\"params\":{},\"topic\":\"课题2\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:13:34', 9);
INSERT INTO `sys_oper_log` VALUES (328, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"bond\":\"2021901025\",\"params\":{},\"topic\":\"课题2\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:14:03', 10);
INSERT INTO `sys_oper_log` VALUES (329, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, '李四', '计算机科学与技术', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":2,\"selectId2\":3,\"selectId3\":4}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:15:39', 14);
INSERT INTO `sys_oper_log` VALUES (330, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-07-03 11:54:35\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,107,2011,1035,2013,2025,2026,2027,2028,2029,2030,2024],\"params\":{},\"roleId\":102,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:18:38', 34);
INSERT INTO `sys_oper_log` VALUES (331, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-06-29 09:22:56\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,107,2011,1035,2013,2025,2026,2027,2028,2029,2030,2022,2031,2032,2033,2034,2035,2023],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:19:11', 17);
INSERT INTO `sys_oper_log` VALUES (332, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-03 16:20:26\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2025,\"menuName\":\"课题查询\",\"menuType\":\"F\",\"orderNum\":1,\"params\":{},\"parentId\":2013,\"path\":\"\",\"perms\":\"platform:topic:query\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:23:07', 14);
INSERT INTO `sys_oper_log` VALUES (333, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-03 16:21:03\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2026,\"menuName\":\"课题新增\",\"menuType\":\"F\",\"orderNum\":2,\"params\":{},\"parentId\":2013,\"path\":\"\",\"perms\":\"platform:topic:add\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:23:13', 9);
INSERT INTO `sys_oper_log` VALUES (334, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-03 16:21:21\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2027,\"menuName\":\"课题修改\",\"menuType\":\"F\",\"orderNum\":3,\"params\":{},\"parentId\":2013,\"path\":\"\",\"perms\":\"platform:topic:edit\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:23:18', 11);
INSERT INTO `sys_oper_log` VALUES (335, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-03 16:21:44\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2028,\"menuName\":\"课题删除\",\"menuType\":\"F\",\"orderNum\":4,\"params\":{},\"parentId\":2013,\"path\":\"\",\"perms\":\"platform:topic:remove\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:23:23', 9);
INSERT INTO `sys_oper_log` VALUES (336, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-03 16:22:17\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2029,\"menuName\":\"课题导出\",\"menuType\":\"F\",\"orderNum\":5,\"params\":{},\"parentId\":2013,\"path\":\"\",\"perms\":\"platform:topic:export\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:23:27', 9);
INSERT INTO `sys_oper_log` VALUES (337, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-03 16:22:33\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2030,\"menuName\":\"课题导入\",\"menuType\":\"F\",\"orderNum\":6,\"params\":{},\"parentId\":2013,\"path\":\"\",\"perms\":\"platform:topic:import\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:23:30', 10);
INSERT INTO `sys_oper_log` VALUES (338, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-07-03 11:54:35\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,107,2011,1035,2013,2025,2026,2027,2028,2029,2030,2024],\"params\":{},\"roleId\":102,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:29:38', 20);
INSERT INTO `sys_oper_log` VALUES (339, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-07-03 11:54:35\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,107,2011,1035,2013,2025,2026,2027,2028,2029,2030,2024],\"params\":{},\"roleId\":102,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:33:28', 18);
INSERT INTO `sys_oper_log` VALUES (340, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-07-03 11:54:35\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,107,2011,1035,2013,2025,2026,2027,2028,2029,2030,2024],\"params\":{},\"roleId\":102,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:38:06', 22);
INSERT INTO `sys_oper_log` VALUES (341, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-07-03 11:54:35\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,107,2011,1035,2013,2025,2026,2027,2028,2029,2030,2024],\"params\":{},\"roleId\":102,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:40:40', 13);
INSERT INTO `sys_oper_log` VALUES (342, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-07-03 11:54:35\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,107,2011,1035,2013,2025,2026,2027,2028,2029,2030,2024],\"params\":{},\"roleId\":102,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:40:56', 14);
INSERT INTO `sys_oper_log` VALUES (343, '论文管理', 1, 'com.ruoyi.web.controller.platform.PlatPaperController.add()', 'POST', 1, '王老师', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"ask\":\"王老师要求1\",\"code\":\"未审核\",\"id\":5,\"params\":{},\"teacherName\":\"王老师\",\"topic\":\"王老师题目1\",\"type\":\"专题研究\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:41:58', 12);
INSERT INTO `sys_oper_log` VALUES (344, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-07-03 11:54:35\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,107,2011,1000,1035,2013,2025,2026,2027,2028,2029,2030,2024],\"params\":{},\"roleId\":102,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:46:45', 22);
INSERT INTO `sys_oper_log` VALUES (345, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"课题列表\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":2013,\"path\":\"platform:topic:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:56:12', 15);
INSERT INTO `sys_oper_log` VALUES (346, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-05 15:56:12\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2036,\"menuName\":\"课题列表\",\"menuType\":\"F\",\"orderNum\":1,\"params\":{},\"parentId\":2013,\"path\":\"platform:topic:list\",\"perms\":\"platform:topic:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:56:35', 12);
INSERT INTO `sys_oper_log` VALUES (347, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-07-03 11:54:35\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,107,2011,1000,1035,2013,2025,2036,2026,2027,2028,2029,2030,2024],\"params\":{},\"roleId\":102,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:56:55', 16);
INSERT INTO `sys_oper_log` VALUES (348, '论文管理', 1, 'com.ruoyi.web.controller.platform.PlatPaperController.add()', 'POST', 1, '王老师', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"ask\":\"王老师要求2\",\"code\":\"未审核\",\"id\":6,\"params\":{},\"topic\":\"王老师课题2\",\"type\":\"工程设计\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 15:57:29', 10);
INSERT INTO `sys_oper_log` VALUES (349, '论文管理', 1, 'com.ruoyi.web.controller.platform.PlatPaperController.add()', 'POST', 1, '王老师', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"ask\":\"王老师要求2\",\"code\":\"未审核\",\"id\":7,\"params\":{},\"topic\":\"王老师课题2\",\"type\":\"文献综述\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 16:04:01', 24);
INSERT INTO `sys_oper_log` VALUES (350, '论文管理', 1, 'com.ruoyi.web.controller.platform.PlatPaperController.add()', 'POST', 1, '王老师', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"ask\":\"王老师要求1\",\"code\":\"未审核\",\"id\":8,\"params\":{},\"teacherName\":\"王老师\",\"teacher_id\":102,\"topic\":\"王老师课题1\",\"type\":\"工程设计\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 16:19:20', 25);
INSERT INTO `sys_oper_log` VALUES (351, '论文管理', 1, 'com.ruoyi.web.controller.platform.PlatPaperController.add()', 'POST', 1, '王老师', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"ask\":\"王老师要求1\",\"code\":\"未审核\",\"id\":9,\"params\":{},\"teacherName\":\"王老师\",\"teacher_id\":102,\"topic\":\"王老师课题1\",\"type\":\"工程设计\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 16:25:21', 26);
INSERT INTO `sys_oper_log` VALUES (352, '论文管理', 1, 'com.ruoyi.web.controller.platform.PlatPaperController.add()', 'POST', 1, '王老师', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"ask\":\"王老师要求2\",\"code\":\"未审核\",\"id\":10,\"params\":{},\"teacherName\":\"王老师\",\"teacher_id\":102,\"topic\":\"王老师课题2\",\"type\":\"专题研究\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 16:25:32', 13);
INSERT INTO `sys_oper_log` VALUES (353, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-06-29 09:22:56\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,107,2011,1035,2013,2025,2036,2026,2027,2028,2029,2030,2022,2031,2032,2033,2034,2035,2023],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 16:26:51', 36);
INSERT INTO `sys_oper_log` VALUES (354, '学生选择的3个课题号', 3, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.delSelectPaperByPaperId()', 'DELETE', 1, '李四', '计算机科学与技术', '/platform/selectPaper/delSelectPaperByPaperId/2', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 16:29:17', 13);
INSERT INTO `sys_oper_log` VALUES (355, '学生选择的3个课题号', 3, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.delSelectPaperByPaperId()', 'DELETE', 1, '李四', '计算机科学与技术', '/platform/selectPaper/delSelectPaperByPaperId/3', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 16:29:18', 13);
INSERT INTO `sys_oper_log` VALUES (356, '学生选择的3个课题号', 3, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.delSelectPaperByPaperId()', 'DELETE', 1, '李四', '计算机科学与技术', '/platform/selectPaper/delSelectPaperByPaperId/4', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 16:29:20', 15);
INSERT INTO `sys_oper_log` VALUES (357, '用户管理', 1, 'com.ruoyi.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '软件工程', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptId\":105,\"nickName\":\"李老师\",\"params\":{},\"phonenumber\":\"13685210584\",\"postIds\":[2],\"roleIds\":[102],\"sex\":\"1\",\"status\":\"0\",\"userId\":105,\"userName\":\"李老师\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 16:31:44', 91);
INSERT INTO `sys_oper_log` VALUES (358, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"code\":\"已通过\",\"id\":9,\"params\":{},\"teacherName\":\"admin\",\"teacher_id\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 16:35:04', 17);
INSERT INTO `sys_oper_log` VALUES (359, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"code\":\"未通过\",\"id\":9,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 16:37:31', 13);
INSERT INTO `sys_oper_log` VALUES (360, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"code\":\"已通过\",\"id\":10,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 16:37:35', 8);
INSERT INTO `sys_oper_log` VALUES (361, '论文管理', 1, 'com.ruoyi.web.controller.platform.PlatPaperController.add()', 'POST', 1, '李老师', '计算机科学与技术', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"ask\":\"李老师要求1\",\"code\":\"未审核\",\"id\":11,\"params\":{},\"teacherName\":\"李老师\",\"teacher_id\":105,\"topic\":\"李老师课题1\",\"type\":\"工程设计\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 16:38:36', 8);
INSERT INTO `sys_oper_log` VALUES (362, '论文管理', 1, 'com.ruoyi.web.controller.platform.PlatPaperController.add()', 'POST', 1, '李老师', '计算机科学与技术', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"ask\":\"李老师要求2\",\"code\":\"未审核\",\"id\":12,\"params\":{},\"teacherName\":\"李老师\",\"teacher_id\":105,\"topic\":\"李老师课题2\",\"type\":\"专题研究\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 16:38:47', 8);
INSERT INTO `sys_oper_log` VALUES (363, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, '李四', '计算机科学与技术', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":10}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 16:39:35', 13);
INSERT INTO `sys_oper_log` VALUES (364, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-06-29 09:22:56\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,107,2011,1035,2022,2031,2032,2033,2034,2035,2023],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 16:52:18', 36);
INSERT INTO `sys_oper_log` VALUES (365, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"upload\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"论文提交\",\"menuType\":\"C\",\"orderNum\":7,\"params\":{},\"parentId\":2011,\"path\":\"2\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 16:53:33', 16);
INSERT INTO `sys_oper_log` VALUES (366, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"platform/paperUpload/index\",\"createTime\":\"2024-07-05 16:53:33\",\"icon\":\"upload\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2037,\"menuName\":\"论文提交\",\"menuType\":\"C\",\"orderNum\":7,\"params\":{},\"parentId\":2011,\"path\":\"paperUpload\",\"perms\":\"platform:topic:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 16:55:31', 13);
INSERT INTO `sys_oper_log` VALUES (367, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"platform/selectAudit/index\",\"createTime\":\"2024-07-03 14:29:04\",\"icon\":\"example\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2024,\"menuName\":\"选题审核\",\"menuType\":\"C\",\"orderNum\":6,\"params\":{},\"parentId\":2011,\"path\":\"selectAudit\",\"perms\":\"platform:selectAudit:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 16:55:54', 11);
INSERT INTO `sys_oper_log` VALUES (368, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"platform/paperUpload/index\",\"createTime\":\"2024-07-05 16:53:33\",\"icon\":\"upload\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2037,\"menuName\":\"论文提交\",\"menuType\":\"C\",\"orderNum\":7,\"params\":{},\"parentId\":2011,\"path\":\"paperUpload\",\"perms\":\"platform:paperUpload:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 16:56:03', 13);
INSERT INTO `sys_oper_log` VALUES (369, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"platform/gradeCheck/index\",\"createBy\":\"admin\",\"icon\":\"rate\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"成绩查看\",\"menuType\":\"C\",\"orderNum\":8,\"params\":{},\"parentId\":2011,\"path\":\"gradeCheck\",\"perms\":\"platform:gradeCheck:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 16:58:18', 13);
INSERT INTO `sys_oper_log` VALUES (370, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"platform/gradeManage/index\",\"createBy\":\"admin\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"成绩管理\",\"menuType\":\"C\",\"orderNum\":9,\"params\":{},\"parentId\":2011,\"path\":\"gradeManage\",\"perms\":\"platform:gradeManage:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 16:59:16', 9);
INSERT INTO `sys_oper_log` VALUES (371, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"platform/paperDownload/index\",\"createBy\":\"admin\",\"icon\":\"download\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"论文查看\",\"menuType\":\"C\",\"orderNum\":10,\"params\":{},\"parentId\":2011,\"path\":\"paperDownload\",\"perms\":\"platform:gradeManage:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 17:05:05', 9);
INSERT INTO `sys_oper_log` VALUES (372, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"platform/gradeCheck/index\",\"createTime\":\"2024-07-05 16:58:18\",\"icon\":\"rate\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2038,\"menuName\":\"成绩查看\",\"menuType\":\"C\",\"orderNum\":15,\"params\":{},\"parentId\":2011,\"path\":\"gradeCheck\",\"perms\":\"platform:gradeCheck:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 17:05:18', 9);
INSERT INTO `sys_oper_log` VALUES (373, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"platform/paperDownload/index\",\"createTime\":\"2024-07-05 17:05:04\",\"icon\":\"download\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2040,\"menuName\":\"论文查看\",\"menuType\":\"C\",\"orderNum\":8,\"params\":{},\"parentId\":2011,\"path\":\"paperDownload\",\"perms\":\"platform:gradeManage:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 17:05:27', 10);
INSERT INTO `sys_oper_log` VALUES (374, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"platform/paperDownload/index\",\"createTime\":\"2024-07-05 17:05:04\",\"icon\":\"download\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2040,\"menuName\":\"论文查看\",\"menuType\":\"C\",\"orderNum\":8,\"params\":{},\"parentId\":2011,\"path\":\"paperDownload\",\"perms\":\"platform:gradeManage:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 17:06:16', 10);
INSERT INTO `sys_oper_log` VALUES (375, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"platform/paperDownload/index\",\"createTime\":\"2024-07-05 17:05:04\",\"icon\":\"skill\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2040,\"menuName\":\"论文查看\",\"menuType\":\"C\",\"orderNum\":8,\"params\":{},\"parentId\":2011,\"path\":\"paperDownload\",\"perms\":\"platform:gradeManage:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-05 17:06:53', 9);
INSERT INTO `sys_oper_log` VALUES (376, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '软件工程', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"plat_opening\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 08:55:32', 70);
INSERT INTO `sys_oper_log` VALUES (377, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '软件工程', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"paperUpload\",\"className\":\"PlatOpening\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"主键ID\",\"columnId\":64,\"columnName\":\"id\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2024-07-06 08:55:32\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":10,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Opening\",\"columnComment\":\"开题报告\",\"columnId\":65,\"columnName\":\"opening\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-06 08:55:32\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"opening\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":10,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Status\",\"columnComment\":\"状态\",\"columnId\":66,\"columnName\":\"status\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-06 08:55:32\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"radio\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"status\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":10,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"提交者姓名\",\"columnId\":67,\"columnName\":\"name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-06 08:55:32\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"name', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 09:11:28', 50);
INSERT INTO `sys_oper_log` VALUES (378, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '软件工程', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"plat_opening\"}', NULL, 0, NULL, '2024-07-06 09:12:28', 41);
INSERT INTO `sys_oper_log` VALUES (379, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"查看提交论文\",\"menuType\":\"F\",\"orderNum\":1,\"params\":{},\"parentId\":2037,\"perms\":\"platform:paperUpload:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 09:21:45', 30);
INSERT INTO `sys_oper_log` VALUES (380, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"新增论文提交\",\"menuType\":\"F\",\"orderNum\":2,\"params\":{},\"parentId\":2037,\"perms\":\"platform:paperUpload:add\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 09:22:47', 24);
INSERT INTO `sys_oper_log` VALUES (381, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"更新论文提交\",\"menuType\":\"F\",\"orderNum\":4,\"params\":{},\"parentId\":2037,\"perms\":\"platform:paperUpload:edit\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 09:23:32', 13);
INSERT INTO `sys_oper_log` VALUES (382, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"删除提交论文\",\"menuType\":\"F\",\"orderNum\":3,\"params\":{},\"parentId\":2037,\"perms\":\"platform:paperUpload:remove\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 09:23:56', 10);
INSERT INTO `sys_oper_log` VALUES (383, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-06-29 09:22:56\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,107,2011,1035,2022,2031,2032,2033,2034,2035,2023,2037,2041,2042,2044,2043],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 09:24:44', 41);
INSERT INTO `sys_oper_log` VALUES (384, '开题报告', 1, 'com.ruoyi.web.controller.platform.PlatOpeningController.add()', 'POST', 1, 'admin', '软件工程', '/platform/paperUpload', '127.0.0.1', '内网IP', '{\"id\":1,\"name\":\"admin\",\"opening\":\"/profile/upload/2024/07/06/1_20240706112017A003.docx\",\"params\":{},\"status\":\"未审核\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 11:20:17', 34);
INSERT INTO `sys_oper_log` VALUES (385, '开题报告', 1, 'com.ruoyi.web.controller.platform.PlatOpeningController.add()', 'POST', 1, 'admin', '软件工程', '/platform/paperUpload', '127.0.0.1', '内网IP', '{\"name\":\"admin\",\"opening\":\"/profile/upload/2024/07/06/1_20240706112443A001.docx\",\"params\":{},\"status\":\"未审核\"}', NULL, 1, 'com.ruoyi.platform.domain.PlatOpening@20bb91de[\r\n  id=<null>\r\n  opening=/profile/upload/2024/07/06/1_20240706112443A001.docx\r\n  status=未审核\r\n  name=admin\r\n  studentId=<null>\r\n]', '2024-07-06 11:24:43', 13);
INSERT INTO `sys_oper_log` VALUES (386, '开题报告', 1, 'com.ruoyi.web.controller.platform.PlatOpeningController.add()', 'POST', 1, 'admin', '软件工程', '/platform/paperUpload', '127.0.0.1', '内网IP', '{\"opening\":\"/profile/upload/2024/07/06/1_20240706112629A001.docx\",\"params\":{}}', NULL, 1, 'com.ruoyi.platform.domain.PlatUser@3f39c910[\r\n  id=1\r\n  name=admin\r\n  password=admin\r\n  studentId=<null>\r\n  phone=15333098888\r\n  qq=1269666349\r\n  email=1269666349@qq.com\r\n  role=ROLE_ADMIN\r\n  select1=<null>\r\n  select2=<null>\r\n  select3=<null>\r\n]', '2024-07-06 11:26:30', 11);
INSERT INTO `sys_oper_log` VALUES (387, '开题报告', 1, 'com.ruoyi.web.controller.platform.PlatOpeningController.add()', 'POST', 1, 'admin', '软件工程', '/platform/paperUpload', '127.0.0.1', '内网IP', '{\"id\":2,\"name\":\"admin\",\"opening\":\"/profile/upload/2024/07/06/1_20240706112737A001.docx\",\"params\":{},\"status\":\"未审核\",\"studentId\":\"2021901030\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 11:27:37', 18);
INSERT INTO `sys_oper_log` VALUES (388, '开题报告', 1, 'com.ruoyi.web.controller.platform.PlatOpeningController.add()', 'POST', 1, 'admin', '软件工程', '/platform/paperUpload', '127.0.0.1', '内网IP', '{\"opening\":\"/profile/upload/2024/07/06/1_20240706135449A001.docx\",\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 13:54:49', 16);
INSERT INTO `sys_oper_log` VALUES (389, '开题报告', 1, 'com.ruoyi.web.controller.platform.PlatOpeningController.add()', 'POST', 1, 'admin', '软件工程', '/platform/paperUpload', '127.0.0.1', '内网IP', '{\"opening\":\"/profile/upload/2024/07/06/1_20240706135543A002.docx\",\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 13:55:44', 12);
INSERT INTO `sys_oper_log` VALUES (390, '开题报告', 1, 'com.ruoyi.web.controller.platform.PlatOpeningController.add()', 'POST', 1, 'admin', '软件工程', '/platform/paperUpload', '127.0.0.1', '内网IP', '{\"opening\":\"/profile/upload/2024/07/06/1_20240706140249A003.docx\",\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 14:02:49', 12);
INSERT INTO `sys_oper_log` VALUES (391, '开题报告', 1, 'com.ruoyi.web.controller.platform.PlatOpeningController.add()', 'POST', 1, 'admin', '软件工程', '/platform/paperUpload', '127.0.0.1', '内网IP', '{\"opening\":\"/profile/upload/2024/07/06/1_20240706140554A004.docx\",\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 14:05:54', 11);
INSERT INTO `sys_oper_log` VALUES (392, '开题报告', 1, 'com.ruoyi.web.controller.platform.PlatOpeningController.add()', 'POST', 1, 'admin', '软件工程', '/platform/paperUpload', '127.0.0.1', '内网IP', '{\"opening\":\"/profile/upload/2024/07/06/1_20240706142616A005.docx\",\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 14:26:16', 11);
INSERT INTO `sys_oper_log` VALUES (393, '开题报告', 1, 'com.ruoyi.web.controller.platform.PlatOpeningController.add()', 'POST', 1, 'admin', '软件工程', '/platform/paperUpload', '127.0.0.1', '内网IP', '{\"opening\":\"/profile/upload/2024/07/06/1_20240706143350A006.docx\",\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 14:33:50', 11);
INSERT INTO `sys_oper_log` VALUES (394, '开题报告', 1, 'com.ruoyi.web.controller.platform.PlatOpeningController.add()', 'POST', 1, 'admin', '软件工程', '/platform/paperUpload', '127.0.0.1', '内网IP', '{\"opening\":\"/profile/upload/2024/07/06/1_20240706150012A007.docx\",\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 15:00:13', 15);
INSERT INTO `sys_oper_log` VALUES (395, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"code\":\"已通过\",\"id\":9,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 15:08:07', 29);
INSERT INTO `sys_oper_log` VALUES (396, '开题报告', 2, 'com.ruoyi.web.controller.platform.PlatOpeningController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperUpload', '127.0.0.1', '内网IP', '{\"params\":{}}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'where student_id = null\' at line 3\r\n### The error may exist in file [F:\\代码练习\\IDEA Code\\校内培训\\阶段一课设\\论文管理平台\\ruoyi-platform\\target\\classes\\mapper\\platform\\PlatOpeningMapper.xml]\r\n### The error may involve com.ruoyi.platform.mapper.PlatOpeningMapper.updatePlatOpening-Inline\r\n### The error occurred while setting parameters\r\n### SQL: update plat_opening                    where student_id = ?\r\n### Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'where student_id = null\' at line 3\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'where student_id = null\' at line 3', '2024-07-06 16:53:54', 57);
INSERT INTO `sys_oper_log` VALUES (397, '开题报告', 2, 'com.ruoyi.web.controller.platform.PlatOpeningController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperUpload', '127.0.0.1', '内网IP', '{\"params\":{}}', NULL, 1, 'com.ruoyi.platform.domain.PlatOpening@55b68231[\r\n  id=<null>\r\n  opening=<null>\r\n  status=<null>\r\n  name=<null>\r\n  studentId=<null>\r\n]', '2024-07-06 16:55:16', 10);
INSERT INTO `sys_oper_log` VALUES (398, '开题报告', 2, 'com.ruoyi.web.controller.platform.PlatOpeningController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperUpload', '127.0.0.1', '内网IP', '{\"params\":{},\"status\":\"已通过\"}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-06 17:05:03', 12);
INSERT INTO `sys_oper_log` VALUES (399, '开题报告', 2, 'com.ruoyi.web.controller.platform.PlatOpeningController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperUpload', '127.0.0.1', '内网IP', '{\"params\":{},\"status\":\"已通过\"}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-06 17:05:13', 3);
INSERT INTO `sys_oper_log` VALUES (400, '开题报告', 2, 'com.ruoyi.web.controller.platform.PlatOpeningController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperUpload', '127.0.0.1', '内网IP', '{\"params\":{},\"status\":\"已通过\"}', NULL, 1, 'com.ruoyi.platform.domain.PlatOpening@6b7fc260[\r\n  id=<null>\r\n  opening=<null>\r\n  status=已通过\r\n  name=<null>\r\n  studentId=<null>\r\n]', '2024-07-06 17:06:32', 10);
INSERT INTO `sys_oper_log` VALUES (401, '开题报告', 2, 'com.ruoyi.web.controller.platform.PlatOpeningController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperUpload', '127.0.0.1', '内网IP', '{\"params\":{},\"status\":\"已通过\"}', NULL, 1, 'com.ruoyi.platform.domain.PlatOpening@32722118[\r\n  id=<null>\r\n  opening=<null>\r\n  status=已通过\r\n  name=<null>\r\n  studentId=<null>\r\n]', '2024-07-06 17:06:58', 0);
INSERT INTO `sys_oper_log` VALUES (402, '开题报告', 2, 'com.ruoyi.web.controller.platform.PlatOpeningController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperUpload', '127.0.0.1', '内网IP', '{\"params\":{},\"status\":\"已通过\",\"studentId\":\"2021901030\"}', NULL, 1, 'com.ruoyi.platform.domain.PlatOpening@1e27fea4[\r\n  id=<null>\r\n  opening=<null>\r\n  status=已通过\r\n  name=<null>\r\n  studentId=2021901030\r\n]', '2024-07-06 17:07:25', 1);
INSERT INTO `sys_oper_log` VALUES (403, '开题报告', 2, 'com.ruoyi.web.controller.platform.PlatOpeningController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperUpload', '127.0.0.1', '内网IP', '{\"params\":{},\"status\":\"已通过\",\"studentId\":\"2021901030\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 17:07:52', 16);
INSERT INTO `sys_oper_log` VALUES (404, '开题报告', 2, 'com.ruoyi.web.controller.platform.PlatOpeningController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperUpload', '127.0.0.1', '内网IP', '{\"params\":{},\"status\":\"未通过\",\"studentId\":\"2021901030\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 17:07:54', 8);
INSERT INTO `sys_oper_log` VALUES (405, '开题报告', 2, 'com.ruoyi.web.controller.platform.PlatOpeningController.edit()', 'PUT', 1, 'admin', '软件工程', '/platform/paperUpload', '127.0.0.1', '内网IP', '{\"params\":{},\"status\":\"已通过\",\"studentId\":\"2021901025\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 17:07:55', 7);
INSERT INTO `sys_oper_log` VALUES (406, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"ask\":\"王老师要求1\",\"bond\":\"2021901030\",\"code\":\"已通过\",\"id\":9,\"name\":\"admin\",\"params\":{},\"teacher_id\":1,\"topic\":\"王老师课题1\",\"type\":\"工程设计\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 17:46:04', 10);
INSERT INTO `sys_oper_log` VALUES (407, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"ask\":\"王老师要求1\",\"bond\":\"2021901030\",\"code\":\"已通过\",\"id\":9,\"name\":\"admin\",\"params\":{},\"teacher_id\":1,\"topic\":\"王老师课题1\",\"type\":\"工程设计\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 17:47:58', 2);
INSERT INTO `sys_oper_log` VALUES (408, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"ask\":\"王老师要求1\",\"bond\":\"2021901030\",\"code\":\"已通过\",\"id\":9,\"name\":\"admin\",\"params\":{},\"teacher_id\":1,\"topic\":\"王老师课题1\",\"type\":\"工程设计\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 17:48:45', 3);
INSERT INTO `sys_oper_log` VALUES (409, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"ask\":\"王老师要求1\",\"bond\":\"2021901030\",\"code\":\"已通过\",\"grade\":\"0\",\"id\":9,\"name\":\"admin\",\"params\":{},\"teacher_id\":1,\"topic\":\"王老师课题1\",\"type\":\"工程设计\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 17:50:50', 7);
INSERT INTO `sys_oper_log` VALUES (410, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"ask\":\"王老师要求1\",\"bond\":\"2021901030\",\"code\":\"已通过\",\"id\":9,\"name\":\"admin\",\"params\":{},\"teacher_id\":1,\"topic\":\"王老师课题1\",\"type\":\"工程设计\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 17:51:23', 3);
INSERT INTO `sys_oper_log` VALUES (411, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"ask\":\"王老师要求1\",\"bond\":\"2021901030\",\"code\":\"已通过\",\"grade\":\"0\",\"id\":9,\"name\":\"admin\",\"params\":{},\"teacher_id\":1,\"topic\":\"王老师课题1\",\"type\":\"工程设计\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 17:53:39', 2);
INSERT INTO `sys_oper_log` VALUES (412, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"ask\":\"王老师要求1\",\"bond\":\"2021901030\",\"code\":\"已通过\",\"gradeDefence\":\"10\",\"gradeInstruct\":\"10\",\"gradeReview\":\"10\",\"id\":9,\"name\":\"admin\",\"params\":{},\"teacher_id\":1,\"topic\":\"王老师课题1\",\"type\":\"工程设计\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 17:55:50', 8);
INSERT INTO `sys_oper_log` VALUES (413, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"ask\":\"王老师要求2\",\"bond\":\"2021901025\",\"code\":\"已通过\",\"gradeDefence\":\"10\",\"gradeInstruct\":\"10\",\"gradeReview\":\"10\",\"id\":10,\"name\":\"张三\",\"params\":{},\"teacher_id\":1,\"topic\":\"王老师课题2\",\"type\":\"专题研究\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 18:01:41', 9);
INSERT INTO `sys_oper_log` VALUES (414, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"ask\":\"王老师要求1\",\"bond\":\"2021901030\",\"code\":\"已通过\",\"grade\":\"0\",\"gradeDefence\":\"100\",\"gradeInstruct\":\"100\",\"gradeReview\":\"100\",\"id\":9,\"name\":\"admin\",\"params\":{},\"teacher_id\":1,\"topic\":\"王老师课题1\",\"type\":\"工程设计\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-06 18:15:46', 9);
INSERT INTO `sys_oper_log` VALUES (415, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"ask\":\"王老师要求1\",\"bond\":\"2021901030\",\"code\":\"已通过\",\"grade\":\"0\",\"gradeDefence\":\"100\",\"gradeInstruct\":\"100\",\"gradeReview\":\"100\",\"id\":9,\"name\":\"admin\",\"params\":{},\"teacherName\":\"王老师\",\"topic\":\"王老师课题1\",\"type\":\"工程设计\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 14:29:17', 12);
INSERT INTO `sys_oper_log` VALUES (416, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"ask\":\"王老师要求1\",\"bond\":\"2021901030\",\"code\":\"已通过\",\"grade\":\"0\",\"gradeDefence\":\"100\",\"gradeInstruct\":\"100\",\"gradeReview\":\"100\",\"id\":9,\"name\":\"admin\",\"params\":{},\"teacherName\":\"王老师\",\"topic\":\"王老师课题1\",\"type\":\"工程设计\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 14:30:51', 4);
INSERT INTO `sys_oper_log` VALUES (417, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"ask\":\"王老师要求1\",\"bond\":\"2021901030\",\"code\":\"已通过\",\"grade\":\"100.0\",\"gradeDefence\":\"100\",\"gradeInstruct\":\"100\",\"gradeReview\":\"100\",\"id\":9,\"name\":\"admin\",\"params\":{},\"teacherName\":\"王老师\",\"topic\":\"王老师课题1\",\"type\":\"工程设计\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 14:33:14', 20);
INSERT INTO `sys_oper_log` VALUES (418, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"ask\":\"王老师要求1\",\"bond\":\"2021901030\",\"code\":\"已通过\",\"grade\":\"3.3\",\"gradeDefence\":\"4\",\"gradeInstruct\":\"3\",\"gradeReview\":\"3\",\"id\":9,\"name\":\"admin\",\"params\":{},\"teacherName\":\"王老师\",\"topic\":\"王老师课题1\",\"type\":\"工程设计\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 14:33:29', 8);
INSERT INTO `sys_oper_log` VALUES (419, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, 'admin', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"ask\":\"王老师要求2\",\"bond\":\"2021901025\",\"code\":\"已通过\",\"grade\":\"10.0\",\"gradeDefence\":\"10\",\"gradeInstruct\":\"10\",\"gradeReview\":\"10\",\"id\":10,\"name\":\"张三\",\"params\":{},\"teacherName\":\"王老师\",\"topic\":\"王老师课题2\",\"type\":\"专题研究\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 14:33:36', 10);
INSERT INTO `sys_oper_log` VALUES (420, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-06-29 09:22:56\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,107,2011,1035,2022,2031,2032,2033,2034,2035,2023,2037,2041,2042,2044,2043,2038],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 14:54:45', 52);
INSERT INTO `sys_oper_log` VALUES (421, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-07-03 11:54:35\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,107,2011,1035,2013,2025,2036,2026,2027,2028,2029,2030,2023,2024,2040,2039],\"params\":{},\"roleId\":102,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 14:55:12', 19);
INSERT INTO `sys_oper_log` VALUES (422, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-04 16:00:56\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2031,\"menuName\":\"选择课题\",\"menuType\":\"F\",\"orderNum\":1,\"params\":{},\"parentId\":2022,\"path\":\"\",\"perms\":\"platform:topicSelect:edit\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 15:12:29', 19);
INSERT INTO `sys_oper_log` VALUES (423, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-04 16:01:17\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2032,\"menuName\":\"删除所选课题\",\"menuType\":\"F\",\"orderNum\":2,\"params\":{},\"parentId\":2022,\"path\":\"\",\"perms\":\"platform:topicSelect:remove\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 15:12:33', 12);
INSERT INTO `sys_oper_log` VALUES (424, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-04 16:02:00\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2033,\"menuName\":\"查询所选课题\",\"menuType\":\"F\",\"orderNum\":3,\"params\":{},\"parentId\":2022,\"path\":\"\",\"perms\":\"platform:topicSelect:query\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 15:12:38', 15);
INSERT INTO `sys_oper_log` VALUES (425, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-04 16:03:34\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2034,\"menuName\":\"导出所选课题\",\"menuType\":\"F\",\"orderNum\":4,\"params\":{},\"parentId\":2022,\"path\":\"\",\"perms\":\"platform:topicSelect:export\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 15:12:44', 11);
INSERT INTO `sys_oper_log` VALUES (426, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-04 16:04:20\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2035,\"menuName\":\"展示所选课题\",\"menuType\":\"F\",\"orderNum\":5,\"params\":{},\"parentId\":2022,\"path\":\"\",\"perms\":\"platform:topicSelect:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 15:12:48', 10);
INSERT INTO `sys_oper_log` VALUES (427, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-06-29 09:22:56\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,107,2011,1035,2022,2031,2032,2033,2034,2035,2023,2037,2041,2042,2044,2043,2038],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 15:21:59', 50);
INSERT INTO `sys_oper_log` VALUES (428, '学生选择的3个课题号', 3, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.delSelectPaperByPaperId()', 'DELETE', 1, '李四', '计算机科学与技术', '/platform/selectPaper/delSelectPaperByPaperId/10', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 15:26:44', 18);
INSERT INTO `sys_oper_log` VALUES (429, '用户管理', 1, 'com.ruoyi.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '软件工程', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptId\":105,\"nickName\":\"王五\",\"params\":{},\"postIds\":[],\"roleIds\":[2],\"sex\":\"0\",\"status\":\"0\",\"userId\":106,\"userName\":\"王五\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 15:31:22', 89);
INSERT INTO `sys_oper_log` VALUES (430, '用户管理', 1, 'com.ruoyi.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '软件工程', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptId\":103,\"nickName\":\"张老师\",\"params\":{},\"postIds\":[2],\"roleIds\":[102],\"sex\":\"1\",\"status\":\"0\",\"userId\":107,\"userName\":\"张老师\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 15:32:55', 90);
INSERT INTO `sys_oper_log` VALUES (431, '角色管理', 1, 'com.ruoyi.web.controller.system.SysRoleController.add()', 'POST', 1, 'admin', '软件工程', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,2011,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,103,1016,1017,1018,1019,107,1035,1036,1037,1038,2020],\"params\":{},\"roleKey\":\"admin\",\"roleName\":\"论文管理员\",\"roleSort\":1,\"status\":\"0\"}', '{\"msg\":\"新增角色\'论文管理员\'失败，角色权限已存在\",\"code\":500}', 0, NULL, '2024-07-09 15:38:29', 6);
INSERT INTO `sys_oper_log` VALUES (432, '角色管理', 1, 'com.ruoyi.web.controller.system.SysRoleController.add()', 'POST', 1, 'admin', '软件工程', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,2011,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,103,1016,1017,1018,1019,107,1035,1036,1037,1038,2020],\"params\":{},\"roleId\":103,\"roleKey\":\"platform:admin\",\"roleName\":\"论文管理员\",\"roleSort\":1,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 15:38:45', 18);
INSERT INTO `sys_oper_log` VALUES (433, '用户管理', 1, 'com.ruoyi.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '软件工程', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptId\":101,\"nickName\":\"平台管理员\",\"params\":{},\"postIds\":[1],\"roleIds\":[103],\"status\":\"0\",\"userId\":108,\"userName\":\"plat_admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 15:40:03', 86);
INSERT INTO `sys_oper_log` VALUES (434, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"platform/topicMatch/index\",\"createTime\":\"2024-07-03 14:18:24\",\"icon\":\"eye-open\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2021,\"menuName\":\"课题匹配状况\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2011,\"path\":\"topicMatch\",\"perms\":\"platform:topicMatch:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 15:41:13', 15);
INSERT INTO `sys_oper_log` VALUES (435, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-07-03 11:54:35\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,107,2011,1035,2013,2025,2036,2026,2027,2028,2029,2030,2024,2040,2039],\"params\":{},\"roleId\":102,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 15:45:50', 22);
INSERT INTO `sys_oper_log` VALUES (436, '论文管理', 1, 'com.ruoyi.web.controller.platform.PlatPaperController.add()', 'POST', 1, '张老师', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"ask\":\"张老师要求1\",\"code\":\"未审核\",\"id\":1,\"params\":{},\"teacherName\":\"张老师\",\"teacher_id\":107,\"topic\":\"张老师课题1\",\"type\":\"工程设计\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 15:48:16', 13);
INSERT INTO `sys_oper_log` VALUES (437, '论文管理', 1, 'com.ruoyi.web.controller.platform.PlatPaperController.add()', 'POST', 1, '张老师', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"ask\":\"张老师要求2\",\"code\":\"未审核\",\"id\":2,\"params\":{},\"teacherName\":\"张老师\",\"teacher_id\":107,\"topic\":\"张老师课题2\",\"type\":\"专题研究\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 15:48:30', 8);
INSERT INTO `sys_oper_log` VALUES (438, '论文管理', 1, 'com.ruoyi.web.controller.platform.PlatPaperController.add()', 'POST', 1, '张老师', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"ask\":\"张老师要求3\",\"code\":\"未审核\",\"id\":3,\"params\":{},\"teacherName\":\"张老师\",\"teacher_id\":107,\"topic\":\"张老师课题3\",\"type\":\"文献综述\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 15:48:44', 8);
INSERT INTO `sys_oper_log` VALUES (439, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.edit()', 'PUT', 1, 'plat_admin', '信息工程学院', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"code\":\"未通过\",\"id\":2,\"params\":{},\"teacherName\":\"plat_admin\",\"teacher_id\":108}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 15:55:54', 14);
INSERT INTO `sys_oper_log` VALUES (440, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.edit()', 'PUT', 1, 'plat_admin', '信息工程学院', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"code\":\"未通过\",\"id\":2,\"params\":{},\"teacherName\":\"plat_admin\",\"teacher_id\":108}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 15:56:01', 2);
INSERT INTO `sys_oper_log` VALUES (441, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.edit()', 'PUT', 1, 'plat_admin', '信息工程学院', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"code\":\"已通过\",\"id\":3,\"params\":{},\"teacherName\":\"plat_admin\",\"teacher_id\":108}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 15:56:54', 8);
INSERT INTO `sys_oper_log` VALUES (442, '论文管理', 1, 'com.ruoyi.web.controller.platform.PlatPaperController.add()', 'POST', 1, '王老师', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"ask\":\"王老师要求1\",\"code\":\"未审核\",\"id\":4,\"params\":{},\"teacherName\":\"王老师\",\"teacher_id\":102,\"topic\":\"王老师课题1\",\"type\":\"工程设计\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 15:58:11', 9);
INSERT INTO `sys_oper_log` VALUES (443, '论文管理', 1, 'com.ruoyi.web.controller.platform.PlatPaperController.add()', 'POST', 1, '王老师', '软件工程', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"ask\":\"王老师课题2\",\"code\":\"未审核\",\"id\":5,\"params\":{},\"teacherName\":\"王老师\",\"teacher_id\":102,\"topic\":\"王老师课题2\",\"type\":\"专题研究\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 15:58:18', 8);
INSERT INTO `sys_oper_log` VALUES (444, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.edit()', 'PUT', 1, 'plat_admin', '信息工程学院', '/platform/paperManage', '127.0.0.1', '内网IP', '{\"code\":\"已通过\",\"id\":1,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 16:00:08', 14);
INSERT INTO `sys_oper_log` VALUES (445, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, '李四', '计算机科学与技术', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":3,\"selectId2\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 16:01:02', 12);
INSERT INTO `sys_oper_log` VALUES (446, '学生选择的3个课题号', 3, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.delSelectPaperByPaperId()', 'DELETE', 1, '李四', '计算机科学与技术', '/platform/selectPaper/delSelectPaperByPaperId/3', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 16:01:21', 10);
INSERT INTO `sys_oper_log` VALUES (447, '学生选择的3个课题号', 3, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.delSelectPaperByPaperId()', 'DELETE', 1, '李四', '计算机科学与技术', '/platform/selectPaper/delSelectPaperByPaperId/1', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 16:19:24', 18);
INSERT INTO `sys_oper_log` VALUES (448, '学生选择的3个课题号', 2, 'com.ruoyi.web.controller.platform.PlatSelectPaperController.selectPaper()', 'PUT', 1, '李四', '计算机科学与技术', '/platform/selectPaper/selectPaper', '127.0.0.1', '内网IP', '{\"params\":{},\"selectId1\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 16:19:29', 17);
INSERT INTO `sys_oper_log` VALUES (449, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, '张老师', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"params\":{},\"topic\":\"张老师课题1\"}', NULL, 1, '', '2024-07-09 16:28:29', 3);
INSERT INTO `sys_oper_log` VALUES (450, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, '张老师', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"bond\":\"2021901030\",\"params\":{},\"topic\":\"张老师课题1\"}', NULL, 1, '', '2024-07-09 16:34:36', 6);
INSERT INTO `sys_oper_log` VALUES (451, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, '张老师', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"bond\":\"2021901030\",\"params\":{},\"topic\":\"张老师课题1\"}', NULL, 1, '', '2024-07-09 16:34:39', 0);
INSERT INTO `sys_oper_log` VALUES (452, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, '张老师', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"bond\":\"2021901030\",\"params\":{},\"topic\":\"张老师课题1\"}', NULL, 1, '', '2024-07-09 16:36:00', 6);
INSERT INTO `sys_oper_log` VALUES (453, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, '张老师', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"bond\":\"2021901030\",\"params\":{},\"topic\":\"张老师课题1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 16:38:24', 15);
INSERT INTO `sys_oper_log` VALUES (454, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, '张老师', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"bond\":\"0\",\"params\":{},\"topic\":\"张老师课题1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 16:38:29', 9);
INSERT INTO `sys_oper_log` VALUES (455, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, '张老师', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"bond\":\"2021901030\",\"params\":{},\"topic\":\"张老师课题1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 16:38:36', 8);
INSERT INTO `sys_oper_log` VALUES (456, '开题报告', 1, 'com.ruoyi.web.controller.platform.PlatOpeningController.add()', 'POST', 1, '李四', '计算机科学与技术', '/platform/paperUpload', '127.0.0.1', '内网IP', '{\"id\":1,\"name\":\"李四\",\"opening\":\"/profile/upload/2024/07/09/1_20240709163855A001.docx\",\"params\":{},\"status\":\"未审核\",\"studentId\":\"2021901030\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 16:38:55', 21);
INSERT INTO `sys_oper_log` VALUES (457, '开题报告', 2, 'com.ruoyi.web.controller.platform.PlatOpeningController.edit()', 'PUT', 1, '张老师', '软件工程', '/platform/paperUpload', '127.0.0.1', '内网IP', '{\"params\":{},\"status\":\"已通过\",\"studentId\":\"2021901030\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 16:39:28', 9);
INSERT INTO `sys_oper_log` VALUES (458, '开题报告', 2, 'com.ruoyi.web.controller.platform.PlatOpeningController.edit()', 'PUT', 1, '张老师', '软件工程', '/platform/paperUpload', '127.0.0.1', '内网IP', '{\"params\":{},\"status\":\"未通过\",\"studentId\":\"2021901030\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 16:39:29', 8);
INSERT INTO `sys_oper_log` VALUES (459, '开题报告', 2, 'com.ruoyi.web.controller.platform.PlatOpeningController.edit()', 'PUT', 1, '张老师', '软件工程', '/platform/paperUpload', '127.0.0.1', '内网IP', '{\"params\":{},\"status\":\"已通过\",\"studentId\":\"2021901030\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 16:39:31', 7);
INSERT INTO `sys_oper_log` VALUES (460, '论文管理', 2, 'com.ruoyi.web.controller.platform.PlatPaperController.updatePaperManageBondInfoByTeacher()', 'PUT', 1, '张老师', '软件工程', '/platform/paperManage/updatePaperManageBondInfoByTeacher', '127.0.0.1', '内网IP', '{\"ask\":\"张老师要求1\",\"bond\":\"2021901030\",\"code\":\"已通过\",\"grade\":\"3.3\",\"gradeDefence\":\"4\",\"gradeInstruct\":\"3\",\"gradeReview\":\"3\",\"id\":1,\"name\":\"李四\",\"params\":{},\"teacherName\":\"张老师\",\"topic\":\"张老师课题1\",\"type\":\"工程设计\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-09 16:41:52', 13);
INSERT INTO `sys_oper_log` VALUES (461, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"example\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"新能源汽车销售\",\"menuType\":\"M\",\"orderNum\":30,\"params\":{},\"parentId\":0,\"path\":\"/carsale\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-15 21:45:57', 36);
INSERT INTO `sys_oper_log` VALUES (462, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"carsale/carOrder/index\",\"createBy\":\"admin\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"用户购车数据\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2045,\"path\":\"carOrder\",\"perms\":\"carsale:carOrder:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-15 21:59:02', 45);
INSERT INTO `sys_oper_log` VALUES (463, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"carsale/carOrder/index\",\"createTime\":\"2026-01-15 21:59:02\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2046,\"menuName\":\"用户购车数据\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2045,\"path\":\"carOrder\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-15 22:06:08', 32);
INSERT INTO `sys_oper_log` VALUES (464, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.changeStatus()', 'PUT', 1, 'admin', '软件工程', '/system/role/changeStatus', '127.0.0.1', '内网IP', '{\"admin\":false,\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":102,\"status\":\"1\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-15 23:35:26', 21);
INSERT INTO `sys_oper_log` VALUES (465, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.changeStatus()', 'PUT', 1, 'admin', '软件工程', '/system/role/changeStatus', '127.0.0.1', '内网IP', '{\"admin\":false,\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":2,\"status\":\"1\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-15 23:35:27', 8);
INSERT INTO `sys_oper_log` VALUES (466, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.changeStatus()', 'PUT', 1, 'admin', '软件工程', '/system/role/changeStatus', '127.0.0.1', '内网IP', '{\"admin\":false,\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":103,\"status\":\"1\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-15 23:35:29', 11);
INSERT INTO `sys_oper_log` VALUES (467, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.changeStatus()', 'PUT', 1, 'admin', '软件工程', '/system/role/changeStatus', '127.0.0.1', '内网IP', '{\"admin\":false,\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":103,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-15 23:35:55', 9);
INSERT INTO `sys_oper_log` VALUES (468, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.changeStatus()', 'PUT', 1, 'admin', '软件工程', '/system/role/changeStatus', '127.0.0.1', '内网IP', '{\"admin\":false,\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":102,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-15 23:35:56', 13);
INSERT INTO `sys_oper_log` VALUES (469, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.changeStatus()', 'PUT', 1, 'admin', '软件工程', '/system/role/changeStatus', '127.0.0.1', '内网IP', '{\"admin\":false,\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":2,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-15 23:35:57', 9);
INSERT INTO `sys_oper_log` VALUES (470, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0\",\"children\":[],\"deptId\":100,\"deptName\":\"新能源汽车销售\",\"email\":\"ry@qq.com\",\"leader\":\"若依\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-15 23:38:23', 20);
INSERT INTO `sys_oper_log` VALUES (471, '部门管理', 1, 'com.ruoyi.web.controller.system.SysDeptController.add()', 'POST', 1, 'admin', '软件工程', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100\",\"children\":[],\"createBy\":\"admin\",\"deptName\":\"销售部门\",\"orderNum\":3,\"params\":{},\"parentId\":100,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-15 23:48:54', 20);
INSERT INTO `sys_oper_log` VALUES (472, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100\",\"children\":[],\"deptId\":202,\"deptName\":\"销售部门\",\"email\":\"ruoyi@qq.com\",\"leader\":\"若依\",\"orderNum\":3,\"params\":{},\"parentId\":100,\"parentName\":\"新能源汽车销售\",\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-15 23:49:18', 40);
INSERT INTO `sys_oper_log` VALUES (473, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0\",\"children\":[],\"deptId\":100,\"deptName\":\"长安大学\",\"email\":\"ry@qq.com\",\"leader\":\"若依\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-15 23:50:23', 15);
INSERT INTO `sys_oper_log` VALUES (474, '部门管理', 3, 'com.ruoyi.web.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '软件工程', '/system/dept/202', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-15 23:50:27', 14);
INSERT INTO `sys_oper_log` VALUES (475, '字典类型', 1, 'com.ruoyi.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', '软件工程', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"dictName\":\"用户购车状态\",\"dictType\":\"carsale_carorder_status\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-17 21:47:38', 24);
INSERT INTO `sys_oper_log` VALUES (476, '字典类型', 2, 'com.ruoyi.web.controller.system.SysDictTypeController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-01-17 21:47:37\",\"dictId\":104,\"dictName\":\"用户购车状态\",\"dictType\":\"carsale_carorder_status\",\"params\":{},\"remark\":\"新能源汽车销售系统\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-17 21:47:53', 27);
INSERT INTO `sys_oper_log` VALUES (477, '字典类型', 2, 'com.ruoyi.web.controller.system.SysDictTypeController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-01-17 21:47:37\",\"dictId\":104,\"dictName\":\"用户购车状态\",\"dictType\":\"carsale_carorder_status\",\"params\":{},\"remark\":\"新能源汽车销售系统\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-17 21:48:10', 15);
INSERT INTO `sys_oper_log` VALUES (478, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '软件工程', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"挂起\",\"dictSort\":0,\"dictType\":\"carsale_carorder_status\",\"dictValue\":\"0\",\"listClass\":\"default\",\"params\":{},\"remark\":\"\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-17 21:55:37', 26);
INSERT INTO `sys_oper_log` VALUES (479, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '软件工程', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"正常\",\"dictSort\":1,\"dictType\":\"carsale_carorder_status\",\"dictValue\":\"1\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-17 21:56:03', 26);
INSERT INTO `sys_oper_log` VALUES (480, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"新增\",\"menuType\":\"F\",\"orderNum\":20,\"params\":{},\"parentId\":2046,\"perms\":\"carsale:carorder:add\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-18 13:27:34', 137);
INSERT INTO `sys_oper_log` VALUES (481, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"新增\",\"menuType\":\"F\",\"orderNum\":20,\"params\":{},\"parentId\":2046,\"perms\":\"carsale:carorder:add\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-18 13:27:34', 287);
INSERT INTO `sys_oper_log` VALUES (482, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '软件工程', '/system/menu/2048', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-18 13:27:41', 130);
INSERT INTO `sys_oper_log` VALUES (483, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '软件工程', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"carsale/carOrder/index\",\"createTime\":\"2026-01-15 21:59:02\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2046,\"menuName\":\"用户购车数据\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2045,\"path\":\"carOrder\",\"perms\":\"carsale:carorder:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-18 13:28:37', 14);
INSERT INTO `sys_oper_log` VALUES (484, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '软件工程', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"CREATE TABLE `carsale_vehicle`  (\\n  `id` bigint NOT NULL AUTO_INCREMENT COMMENT \'车辆唯一标识\',\\n  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT \'车型名称\',\\n  `brand` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT \'品牌名称\',\\n  `price` decimal(12, 2) NOT NULL COMMENT \'指导价\',\\n  `battery_type` int NOT NULL COMMENT \'电池类型\',\\n  `range_km` int NULL DEFAULT NULL COMMENT \'续航里程(km)\',\\n  `stock` int NULL DEFAULT 0 COMMENT \'库存数量\',\\n  `launch_date` date NULL DEFAULT NULL COMMENT \'上市时间\',\\n  `config_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT \'配置参数(快充、智驾等JSON)\',\\n  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT \'车辆详情描述\',\\n  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT \'车辆封面图片路径\',\\n  PRIMARY KEY (`id`) USING BTREE\\n) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = \'车辆信息基础表\' ROW_FORMAT = Dynamic;\"}', '{\"msg\":\"创建表结构异常\",\"code\":500}', 0, NULL, '2026-01-19 23:31:48', 109);
INSERT INTO `sys_oper_log` VALUES (485, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '软件工程', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"CREATE TABLE `carsale_vehicle`  (\\n  `id` bigint NOT NULL AUTO_INCREMENT COMMENT \'车辆唯一标识\',\\n  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT \'车型名称\',\\n  `brand` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT \'品牌名称\',\\n  `price` decimal(12, 2) NOT NULL COMMENT \'指导价\',\\n  `battery_type` int NOT NULL COMMENT \'电池类型\',\\n  `range_km` int NULL DEFAULT NULL COMMENT \'续航里程(km)\',\\n  `stock` int NULL DEFAULT 0 COMMENT \'库存数量\',\\n  `launch_date` date NULL DEFAULT NULL COMMENT \'上市时间\',\\n  `config_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT \'配置参数(快充、智驾等JSON)\',\\n  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT \'车辆详情描述\',\\n  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT \'车辆封面图片路径\',\\n  PRIMARY KEY (`id`) USING BTREE\\n) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = \'车辆信息基础表\' ROW_FORMAT = Dynamic;\"}', '{\"msg\":\"创建表结构异常\",\"code\":500}', 0, NULL, '2026-01-19 23:33:10', 21);
INSERT INTO `sys_oper_log` VALUES (486, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '软件工程', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"CREATE TABLE `vehicle` (\\n  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT \'车辆唯一标识\',\\n  `name` VARCHAR(100) NOT NULL COMMENT \'车型名称\',\\n  `brand` VARCHAR(50) NOT NULL COMMENT \'品牌名称\',\\n  `price` DECIMAL(12,2) NOT NULL COMMENT \'指导价\',\\n  `battery_type` INT NOT NULL COMMENT \'电池类型\',\\n  `range_km` INT DEFAULT NULL COMMENT \'续航里程(km)\',\\n  `stock` INT DEFAULT 0 COMMENT \'库存数量\',\\n  `launch_date` DATE DEFAULT NULL COMMENT \'上市时间\',\\n  `config_json` TEXT DEFAULT NULL COMMENT \'配置参数(快充、智驾等JSON)\',\\n  `description` TEXT DEFAULT NULL COMMENT \'车辆详情描述\',\\n  `image_url` VARCHAR(255) DEFAULT NULL COMMENT \'车辆封面图片路径\',\\n  PRIMARY KEY (`id`)\\n) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=\'车辆信息基础表\';\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-19 23:33:38', 145);
INSERT INTO `sys_oper_log` VALUES (487, '用户管理', 1, 'com.ruoyi.web.controller.carsale.AdminUserController.addUser()', 'POST', 1, 'admin', '软件工程', '/carsale/admin/user/add', '127.0.0.1', '内网IP', '{\"address\":\"\",\"admin\":false,\"createBy\":\"admin\",\"idCard\":\"\",\"nickName\":\"user\",\"params\":{},\"phonenumber\":\"13991245952\",\"roleIds\":[104],\"userId\":109,\"userName\":\"user\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-24 10:18:39', 279);
INSERT INTO `sys_oper_log` VALUES (488, '试驾预约', 1, 'com.ruoyi.web.controller.carsale.TestdriveController.addTestdrive()', 'POST', 1, 'user', NULL, '/carsale/testdrive/create', '127.0.0.1', '内网IP', '{\"appointTime\":\"2026-01-30 10:24:59\",\"id\":1,\"params\":{},\"status\":0,\"storeName\":\"门店1\",\"userId\":109,\"vehicleId\":6}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-24 10:25:03', 69);
INSERT INTO `sys_oper_log` VALUES (489, '试驾审核', 2, 'com.ruoyi.web.controller.carsale.TestdriveController.auditTestdrive()', 'PUT', 1, 'admin', '软件工程', '/carsale/admin/testdrive/1/audit', '127.0.0.1', '内网IP', '1 {\"auditRemark\":\"可以\",\"auditTime\":\"2026-01-24 10:25:24\",\"id\":1,\"params\":{},\"status\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-24 10:25:24', 14);
INSERT INTO `sys_oper_log` VALUES (490, '订单管理', 1, 'com.ruoyi.web.controller.carsale.OrdersController.addOrder()', 'POST', 1, 'user', NULL, '/carsale/order/create', '127.0.0.1', '内网IP', '{\"amount\":215900.0,\"id\":1769221564341,\"number\":1,\"params\":{},\"phone\":\"13991245952\",\"status\":0,\"storeLocation\":\"门店1\",\"userId\":109,\"vehicleId\":9}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-24 10:26:04', 47);
INSERT INTO `sys_oper_log` VALUES (491, '订单管理', 2, 'com.ruoyi.web.controller.carsale.OrdersController.payOrder()', 'PUT', 1, 'user', NULL, '/carsale/order/pay/1769221564341', '127.0.0.1', '内网IP', '{\"{}\":\"\"}', NULL, 1, '\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Incorrect datetime value: \'Sat Jan 24 10:45:17 CST 2026\' for column \'pay_time\' at row 1\r\n### The error may exist in file [C:\\Users\\hag\\Desktop\\17\\数据库大作业\\carsale\\新能源汽车销售系统\\ruoyi-carsale\\target\\classes\\mapper\\carsale\\OrdersMapper.xml]\r\n### The error may involve com.ruoyi.carsale.mapper.OrdersMapper.updateOrders-Inline\r\n### The error occurred while setting parameters\r\n### SQL: update carsale_orders          SET id = ?,                                           user_id = ?,                                           vehicle_id = ?,                                           status = ?,                                           amount = ?,                                           number = ?,                                           phone = ?,                                           store_location = ?,                                                        pay_time = ?          where id = ?\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Incorrect datetime value: \'Sat Jan 24 10:45:17 CST 2026\' for column \'pay_time\' at row 1\n; Data truncation: Incorrect datetime value: \'Sat Jan 24 10:45:17 CST 2026\' for column \'pay_time\' at row 1; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Incorrect datetime value: \'Sat Jan 24 10:45:17 CST 2026\' for column \'pay_time\' at row 1', '2026-01-24 10:45:17', 129);
INSERT INTO `sys_oper_log` VALUES (492, '订单管理', 2, 'com.ruoyi.web.controller.carsale.OrdersController.payOrder()', 'PUT', 1, 'user', NULL, '/carsale/order/pay/1769221564341', '127.0.0.1', '内网IP', '{\"{}\":\"\"}', NULL, 1, '\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Incorrect datetime value: \'Sat Jan 24 10:45:26 CST 2026\' for column \'pay_time\' at row 1\r\n### The error may exist in file [C:\\Users\\hag\\Desktop\\17\\数据库大作业\\carsale\\新能源汽车销售系统\\ruoyi-carsale\\target\\classes\\mapper\\carsale\\OrdersMapper.xml]\r\n### The error may involve com.ruoyi.carsale.mapper.OrdersMapper.updateOrders-Inline\r\n### The error occurred while setting parameters\r\n### SQL: update carsale_orders          SET id = ?,                                           user_id = ?,                                           vehicle_id = ?,                                           status = ?,                                           amount = ?,                                           number = ?,                                           phone = ?,                                           store_location = ?,                                                        pay_time = ?          where id = ?\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Incorrect datetime value: \'Sat Jan 24 10:45:26 CST 2026\' for column \'pay_time\' at row 1\n; Data truncation: Incorrect datetime value: \'Sat Jan 24 10:45:26 CST 2026\' for column \'pay_time\' at row 1; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Incorrect datetime value: \'Sat Jan 24 10:45:26 CST 2026\' for column \'pay_time\' at row 1', '2026-01-24 10:45:26', 16);
INSERT INTO `sys_oper_log` VALUES (493, '订单管理', 2, 'com.ruoyi.web.controller.carsale.OrdersController.payOrder()', 'PUT', 1, 'user', NULL, '/carsale/order/pay/1769221564341', '127.0.0.1', '内网IP', '{\"{}\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-24 10:47:42', 121);
INSERT INTO `sys_oper_log` VALUES (494, '订单管理', 2, 'com.ruoyi.web.controller.carsale.OrdersController.updateOrderStatus()', 'PUT', 1, 'admin', '软件工程', '/carsale/admin/order/status/update', '127.0.0.1', '内网IP', '{\"amount\":null,\"id\":202601130001,\"params\":{},\"pickupTime\":\"2026-01-24 10:48:22\",\"status\":2}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-24 10:48:22', 20);
INSERT INTO `sys_oper_log` VALUES (495, '订单管理', 2, 'com.ruoyi.web.controller.carsale.OrdersController.updateOrderStatus()', 'PUT', 1, 'admin', '软件工程', '/carsale/admin/order/status/update', '127.0.0.1', '内网IP', '{\"amount\":null,\"id\":1769221564341,\"params\":{},\"status\":2}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-24 11:07:36', 22);
INSERT INTO `sys_oper_log` VALUES (496, '订单管理', 2, 'com.ruoyi.web.controller.carsale.OrdersController.updateOrderStatus()', 'PUT', 1, 'admin', '软件工程', '/carsale/admin/order/status/update', '127.0.0.1', '内网IP', '{\"amount\":null,\"id\":1769221564341,\"params\":{},\"pickupTime\":\"2026-01-24 11:08:18\",\"status\":3}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-24 11:08:18', 11);
INSERT INTO `sys_oper_log` VALUES (497, '评价管理', 1, 'com.ruoyi.web.controller.carsale.EvaluationController.addEvaluation()', 'POST', 1, 'user', NULL, '/carsale/evaluation/create', '127.0.0.1', '内网IP', '{\"comment\":\"好\",\"id\":1,\"orderId\":1769221564341,\"params\":{},\"score\":5,\"userId\":109,\"vehicleId\":9}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-24 11:11:07', 46);
INSERT INTO `sys_oper_log` VALUES (498, '订单管理', 1, 'com.ruoyi.web.controller.carsale.OrdersController.addOrder()', 'POST', 1, 'user', NULL, '/carsale/order/create', '127.0.0.1', '内网IP', '{\"amount\":215900.0,\"id\":1769224584373,\"number\":1,\"params\":{},\"phone\":\"13991245952\",\"status\":0,\"storeLocation\":\"上海中心门店\",\"userId\":109,\"vehicleId\":6}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"amount\":215900.0,\"id\":1769224584373,\"number\":1,\"params\":{},\"phone\":\"13991245952\",\"status\":0,\"storeLocation\":\"上海中心门店\",\"userId\":109,\"vehicleId\":6}}', 0, NULL, '2026-01-24 11:16:24', 175);
INSERT INTO `sys_oper_log` VALUES (499, '订单管理', 2, 'com.ruoyi.web.controller.carsale.OrdersController.payOrder()', 'PUT', 1, 'user', NULL, '/carsale/order/pay/1769224584373', '127.0.0.1', '内网IP', '{\"{}\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-24 11:16:27', 39);
INSERT INTO `sys_oper_log` VALUES (500, '订单管理', 2, 'com.ruoyi.web.controller.carsale.OrdersController.updateOrderStatus()', 'PUT', 1, 'admin', '软件工程', '/carsale/admin/order/status/update', '127.0.0.1', '内网IP', '{\"amount\":null,\"id\":1769224584373,\"params\":{},\"status\":2}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-24 11:16:46', 14);
INSERT INTO `sys_oper_log` VALUES (501, '订单管理', 2, 'com.ruoyi.web.controller.carsale.OrdersController.updateOrderStatus()', 'PUT', 1, 'admin', '软件工程', '/carsale/admin/order/status/update', '127.0.0.1', '内网IP', '{\"amount\":null,\"id\":1769224584373,\"params\":{},\"pickupTime\":\"2026-01-24 11:17:34\",\"status\":3}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-24 11:17:34', 21);
INSERT INTO `sys_oper_log` VALUES (502, '评价管理', 1, 'com.ruoyi.web.controller.carsale.EvaluationController.addEvaluation()', 'POST', 1, 'user', NULL, '/carsale/evaluation/create', '127.0.0.1', '内网IP', '{\"comment\":\"好好好\",\"id\":2,\"images\":\"[\\\"https://sky-bucket-for-zdp.oss-cn-beijing.aliyuncs.com/vehicle/2026/01/24/face_default_m_20260124112328A003.jpg\\\"]\",\"orderId\":1769224584373,\"params\":{},\"score\":5,\"userId\":109,\"vehicleId\":6}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-24 11:23:33', 36);
INSERT INTO `sys_oper_log` VALUES (503, '订单管理', 1, 'com.ruoyi.web.controller.carsale.OrdersController.addOrder()', 'POST', 1, 'user', NULL, '/carsale/order/create', '127.0.0.1', '内网IP', '{\"amount\":215900.0,\"id\":1769225278509,\"number\":1,\"params\":{},\"phone\":\"13991245952\",\"status\":0,\"storeLocation\":\"深圳南山门店\",\"userId\":109,\"vehicleId\":6}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"amount\":215900.0,\"id\":1769225278509,\"number\":1,\"params\":{},\"phone\":\"13991245952\",\"status\":0,\"storeLocation\":\"深圳南山门店\",\"userId\":109,\"vehicleId\":6}}', 0, NULL, '2026-01-24 11:27:58', 23);
INSERT INTO `sys_oper_log` VALUES (504, '订单管理', 2, 'com.ruoyi.web.controller.carsale.OrdersController.payOrder()', 'PUT', 1, 'user', NULL, '/carsale/order/pay/1769225278509', '127.0.0.1', '内网IP', '{\"{}\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-24 11:28:00', 38);
INSERT INTO `sys_oper_log` VALUES (505, '订单管理', 2, 'com.ruoyi.web.controller.carsale.OrdersController.updateOrderStatus()', 'PUT', 1, 'admin', '软件工程', '/carsale/admin/order/status/update', '127.0.0.1', '内网IP', '{\"amount\":null,\"id\":1769225278509,\"params\":{},\"status\":2}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-24 11:28:18', 17);
INSERT INTO `sys_oper_log` VALUES (506, '订单管理', 2, 'com.ruoyi.web.controller.carsale.OrdersController.updateOrderStatus()', 'PUT', 1, 'admin', '软件工程', '/carsale/admin/order/status/update', '127.0.0.1', '内网IP', '{\"amount\":null,\"id\":1769225278509,\"params\":{},\"pickupTime\":\"2026-01-24 11:28:20\",\"status\":3}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-24 11:28:20', 26);
INSERT INTO `sys_oper_log` VALUES (507, '评价管理', 1, 'com.ruoyi.web.controller.carsale.EvaluationController.addEvaluation()', 'POST', 1, 'user', NULL, '/carsale/evaluation/create', '127.0.0.1', '内网IP', '{\"comment\":\"非常好\",\"id\":3,\"images\":\"[\\\"https://sky-bucket-for-zdp.oss-cn-beijing.aliyuncs.com/vehicle/2026/01/24/微信图片_20211210175704_20260124112854A001.jpg\\\"]\",\"orderId\":1769225278509,\"params\":{},\"score\":5,\"userId\":109,\"vehicleId\":6}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-24 11:28:58', 30);
INSERT INTO `sys_oper_log` VALUES (508, '促销活动管理', 1, 'com.ruoyi.web.controller.carsale.PromotionController.addPromotion()', 'POST', 1, 'admin', '软件工程', '/carsale/admin/promotion/add', '127.0.0.1', '内网IP', '{\"discountType\":0,\"discountValue\":10000.0,\"endTime\":\"2026-01-31 15:40:14\",\"params\":{},\"startTime\":\"2026-01-24 15:40:13\",\"status\":1,\"title\":\"活动汉EV\",\"vehicleId\":8}', NULL, 1, '', '2026-01-24 15:40:18', 20);
INSERT INTO `sys_oper_log` VALUES (509, '促销活动管理', 1, 'com.ruoyi.web.controller.carsale.PromotionController.addPromotion()', 'POST', 1, 'admin', '软件工程', '/carsale/admin/promotion/add', '127.0.0.1', '内网IP', '{\"discountType\":0,\"discountValue\":10000.0,\"endTime\":\"2026-01-31 15:40:14\",\"params\":{},\"startTime\":\"2026-01-24 15:40:13\",\"status\":1,\"title\":\"活动汉EV\",\"vehicleId\":8}', NULL, 1, '', '2026-01-24 15:40:18', 2);
INSERT INTO `sys_oper_log` VALUES (510, '促销活动管理', 1, 'com.ruoyi.web.controller.carsale.PromotionController.addPromotion()', 'POST', 1, 'admin', '软件工程', '/carsale/admin/promotion/add', '127.0.0.1', '内网IP', '{\"discountType\":0,\"discountValue\":10000.0,\"endTime\":\"2026-01-31 15:40:14\",\"params\":{},\"startTime\":\"2026-01-24 15:40:13\",\"status\":1,\"title\":\"活动汉EV\",\"vehicleId\":8}', NULL, 1, '', '2026-01-24 15:40:24', 1);
INSERT INTO `sys_oper_log` VALUES (511, '车辆管理', 1, 'com.ruoyi.web.controller.carsale.AdminVehicleManageController.addVehicle()', 'POST', 1, 'admin', '软件工程', '/carsale/admin/vehicle/add', '127.0.0.1', '内网IP', '{\"batteryType\":0,\"brand\":\"品牌1\",\"configJson\":\"{\\\"fast_charge\\\":\\\"0.5h\\\",\\\"ai_level\\\":\\\"L2\\\"}\",\"description\":\"111\",\"id\":10,\"imageUrl\":\"https://sky-bucket-for-zdp.oss-cn-beijing.aliyuncs.com/vehicle/2026/01/24/小米su7_20260124161130A001.png\",\"launchDate\":\"2026-01-24\",\"maxPrice\":null,\"minPrice\":null,\"name\":\"车型1\",\"params\":{},\"price\":10000.0,\"rangeKm\":10000,\"stock\":100}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-24 16:11:33', 32);
INSERT INTO `sys_oper_log` VALUES (512, '促销活动管理', 1, 'com.ruoyi.web.controller.carsale.PromotionController.addPromotion()', 'POST', 1, 'admin', '软件工程', '/carsale/admin/promotion/add', '127.0.0.1', '内网IP', '{\"discountType\":0,\"discountValue\":10000.0,\"endTime\":\"2026-01-31 16:14:19\",\"params\":{},\"startTime\":\"2026-01-24 16:14:18\",\"status\":1,\"title\":\"活动1\",\"vehicleId\":10}', NULL, 1, '', '2026-01-24 16:14:22', 7);
INSERT INTO `sys_oper_log` VALUES (513, '促销活动管理', 1, 'com.ruoyi.web.controller.carsale.PromotionController.addPromotion()', 'POST', 1, 'admin', '软件工程', '/carsale/admin/promotion/add', '127.0.0.1', '内网IP', '{\"discountType\":0,\"discountValue\":10000.0,\"endTime\":\"2026-01-31 16:14:19\",\"params\":{},\"startTime\":\"2026-01-24 16:14:18\",\"status\":1,\"title\":\"活动1\",\"vehicleId\":10}', NULL, 1, '', '2026-01-24 16:14:30', 0);
INSERT INTO `sys_oper_log` VALUES (514, '车辆管理', 3, 'com.ruoyi.web.controller.carsale.AdminVehicleManageController.deleteVehicle()', 'DELETE', 1, 'admin', '软件工程', '/carsale/admin/vehicle/delete/6,5,4,3,2,1', '127.0.0.1', '内网IP', '{}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`carsale_orders`, CONSTRAINT `fk_order_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `carsale_vehicle` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT)\r\n### The error may exist in file [C:\\Users\\hag\\Desktop\\17\\数据库大作业\\carsale\\新能源汽车销售系统\\ruoyi-carsale\\target\\classes\\mapper\\carsale\\AdminVehicleManageMapper.xml]\r\n### The error may involve com.ruoyi.carsale.mapper.AdminVehicleManageMapper.deleteVehicleByIds-Inline\r\n### The error occurred while setting parameters\r\n### SQL: delete from carsale_vehicle where id in          (               ?          ,              ?          ,              ?          ,              ?          ,              ?          ,              ?          )\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`carsale_orders`, CONSTRAINT `fk_order_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `carsale_vehicle` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT)\n; Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`carsale_orders`, CONSTRAINT `fk_order_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `carsale_vehicle` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT); nested exception is java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`carsale_orders`, CONSTRAINT `fk_order_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `carsale_vehicle` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT)', '2026-01-24 16:22:33', 575);
INSERT INTO `sys_oper_log` VALUES (515, '车辆管理', 3, 'com.ruoyi.web.controller.carsale.AdminVehicleManageController.deleteVehicle()', 'DELETE', 1, 'admin', '软件工程', '/carsale/admin/vehicle/delete/6,5,4,3,2,1', '127.0.0.1', '内网IP', '{}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`carsale_orders`, CONSTRAINT `fk_order_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `carsale_vehicle` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT)\r\n### The error may exist in file [C:\\Users\\hag\\Desktop\\17\\数据库大作业\\carsale\\新能源汽车销售系统\\ruoyi-carsale\\target\\classes\\mapper\\carsale\\AdminVehicleManageMapper.xml]\r\n### The error may involve com.ruoyi.carsale.mapper.AdminVehicleManageMapper.deleteVehicleByIds-Inline\r\n### The error occurred while setting parameters\r\n### SQL: delete from carsale_vehicle where id in          (               ?          ,              ?          ,              ?          ,              ?          ,              ?          ,              ?          )\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`carsale_orders`, CONSTRAINT `fk_order_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `carsale_vehicle` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT)\n; Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`carsale_orders`, CONSTRAINT `fk_order_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `carsale_vehicle` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT); nested exception is java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`carsale_orders`, CONSTRAINT `fk_order_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `carsale_vehicle` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT)', '2026-01-24 16:22:42', 49);
INSERT INTO `sys_oper_log` VALUES (516, '车辆管理', 3, 'com.ruoyi.web.controller.carsale.AdminVehicleManageController.deleteVehicle()', 'DELETE', 1, 'admin', '软件工程', '/carsale/admin/vehicle/delete/6', '127.0.0.1', '内网IP', '{}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`carsale_evaluation`, CONSTRAINT `fk_eval_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `carsale_vehicle` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT)\r\n### The error may exist in file [C:\\Users\\hag\\Desktop\\17\\数据库大作业\\carsale\\新能源汽车销售系统\\ruoyi-carsale\\target\\classes\\mapper\\carsale\\AdminVehicleManageMapper.xml]\r\n### The error may involve com.ruoyi.carsale.mapper.AdminVehicleManageMapper.deleteVehicleByIds-Inline\r\n### The error occurred while setting parameters\r\n### SQL: delete from carsale_vehicle where id in          (               ?          )\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`carsale_evaluation`, CONSTRAINT `fk_eval_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `carsale_vehicle` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT)\n; Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`carsale_evaluation`, CONSTRAINT `fk_eval_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `carsale_vehicle` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT); nested exception is java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`carsale_evaluation`, CONSTRAINT `fk_eval_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `carsale_vehicle` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT)', '2026-01-24 16:23:40', 17);
INSERT INTO `sys_oper_log` VALUES (517, '订单管理', 2, 'com.ruoyi.web.controller.carsale.OrdersController.updateOrderStatus()', 'PUT', 1, 'admin', '软件工程', '/carsale/admin/order/status/update', '127.0.0.1', '内网IP', '{\"amount\":null,\"id\":202601130001,\"params\":{},\"pickupTime\":\"2026-01-24 16:23:59\",\"status\":3}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-24 16:23:59', 48);
INSERT INTO `sys_oper_log` VALUES (518, '促销活动管理', 1, 'com.ruoyi.web.controller.carsale.PromotionController.addPromotion()', 'POST', 1, 'admin', '软件工程', '/carsale/admin/promotion/add', '127.0.0.1', '内网IP', '{\"discountType\":0,\"discountValue\":1000.0,\"endTime\":\"2026-01-31 16:24:54\",\"params\":{},\"startTime\":\"2026-01-24 16:24:53\",\"status\":1,\"title\":\"活动1\",\"vehicleId\":10}', NULL, 1, '', '2026-01-24 16:24:57', 13);
INSERT INTO `sys_oper_log` VALUES (519, '促销活动管理', 1, 'com.ruoyi.web.controller.carsale.PromotionController.addPromotion()', 'POST', 1, 'admin', '软件工程', '/carsale/admin/promotion/add', '127.0.0.1', '内网IP', '{\"discountType\":0,\"discountValue\":1000.0,\"endTime\":\"2026-01-31 16:27:36\",\"id\":4,\"params\":{},\"startTime\":\"2026-01-24 16:27:44\",\"status\":1,\"title\":\"活动1\",\"vehicleId\":10}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-24 16:27:48', 189);
INSERT INTO `sys_oper_log` VALUES (520, '车辆管理', 3, 'com.ruoyi.web.controller.carsale.AdminVehicleManageController.deleteVehicle()', 'DELETE', 1, 'admin', '软件工程', '/carsale/admin/vehicle/delete/6,5,4,3,2,1', '127.0.0.1', '内网IP', '{}', NULL, 1, '车辆【SU7】存在 2 个关联订单，无法删除。请先处理相关订单后再删除车辆。', '2026-01-24 17:21:08', 22);
INSERT INTO `sys_oper_log` VALUES (521, '车辆管理', 3, 'com.ruoyi.web.controller.carsale.AdminVehicleManageController.deleteVehicle()', 'DELETE', 1, 'admin', '软件工程', '/carsale/admin/vehicle/delete/5,4,3,2,1', '127.0.0.1', '内网IP', '{}', NULL, 1, '车辆【Model 3】存在 1 个关联订单，无法删除。请先处理相关订单后再删除车辆。', '2026-01-24 17:21:14', 20);
INSERT INTO `sys_oper_log` VALUES (522, '车辆管理', 3, 'com.ruoyi.web.controller.carsale.AdminVehicleManageController.deleteVehicle()', 'DELETE', 1, 'admin', '软件工程', '/carsale/admin/vehicle/delete/5,3,2', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-24 17:21:25', 36);
INSERT INTO `sys_oper_log` VALUES (523, '车辆管理', 3, 'com.ruoyi.web.controller.carsale.AdminVehicleManageController.deleteVehicle()', 'DELETE', 1, 'admin', '软件工程', '/carsale/admin/vehicle/delete/4', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-24 17:21:32', 15);
INSERT INTO `sys_oper_log` VALUES (524, '车辆管理', 3, 'com.ruoyi.web.controller.carsale.AdminVehicleManageController.deleteVehicle()', 'DELETE', 1, 'admin', '软件工程', '/carsale/admin/vehicle/delete/7', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-24 17:21:38', 14);
INSERT INTO `sys_oper_log` VALUES (525, '车辆管理', 3, 'com.ruoyi.web.controller.carsale.AdminVehicleManageController.deleteVehicle()', 'DELETE', 1, 'admin', '软件工程', '/carsale/admin/vehicle/delete/9', '127.0.0.1', '内网IP', '{}', NULL, 1, '车辆【SU7】存在 1 个关联订单，无法删除。请先处理相关订单后再删除车辆。', '2026-01-24 17:21:42', 3);
INSERT INTO `sys_oper_log` VALUES (526, '车辆管理', 3, 'com.ruoyi.web.controller.carsale.AdminVehicleManageController.deleteVehicle()', 'DELETE', 1, 'admin', '软件工程', '/carsale/admin/vehicle/delete/6', '127.0.0.1', '内网IP', '{}', NULL, 1, '车辆【SU7】存在 2 个关联订单，无法删除。请先处理相关订单后再删除车辆。', '2026-01-24 17:21:45', 7);
INSERT INTO `sys_oper_log` VALUES (527, '车辆管理', 2, 'com.ruoyi.web.controller.carsale.AdminVehicleManageController.updateVehicle()', 'PUT', 1, 'admin', '软件工程', '/carsale/admin/vehicle/update', '127.0.0.1', '内网IP', '{\"batteryType\":2,\"brand\":\"Xiaomi\",\"configJson\":\"{\\\"fast_charge\\\":\\\"0.35h\\\",\\\"ai_level\\\":\\\"L3\\\"}\",\"id\":9,\"imageUrl\":\"https://sky-bucket-for-zdp.oss-cn-beijing.aliyuncs.com/vehicle/2026/01/24/小米su7_20260124172804A001.png\",\"launchDate\":\"2024-03-28\",\"maxPrice\":null,\"minPrice\":null,\"name\":\"SU7\",\"params\":{},\"price\":215900.0,\"rangeKm\":700,\"stock\":2}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-24 17:28:06', 33);
INSERT INTO `sys_oper_log` VALUES (528, '车辆管理', 2, 'com.ruoyi.web.controller.carsale.AdminVehicleManageController.updateVehicle()', 'PUT', 1, 'admin', '软件工程', '/carsale/admin/vehicle/update', '127.0.0.1', '内网IP', '{\"batteryType\":1,\"brand\":\"BYD\",\"configJson\":\"{\\\"fast_charge\\\":\\\"0.42h\\\",\\\"ai_level\\\":\\\"L2\\\"}\",\"id\":8,\"imageUrl\":\"https://sky-bucket-for-zdp.oss-cn-beijing.aliyuncs.com/vehicle/2026/01/24/比亚迪汉EV_20260124172816A002.png\",\"launchDate\":\"2023-03-20\",\"maxPrice\":null,\"minPrice\":null,\"name\":\"汉 EV\",\"params\":{},\"price\":221800.0,\"rangeKm\":715,\"stock\":3}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-24 17:28:18', 7);
INSERT INTO `sys_oper_log` VALUES (529, '车辆管理', 2, 'com.ruoyi.web.controller.carsale.AdminVehicleManageController.updateVehicle()', 'PUT', 1, 'admin', '软件工程', '/carsale/admin/vehicle/update', '127.0.0.1', '内网IP', '{\"batteryType\":0,\"brand\":\"Tesla\",\"configJson\":\"{\\\"fast_charge\\\":\\\"0.5h\\\",\\\"ai_level\\\":\\\"L2\\\"}\",\"id\":1,\"imageUrl\":\"https://sky-bucket-for-zdp.oss-cn-beijing.aliyuncs.com/vehicle/2026/01/24/Tesla Model_20260124172832A003.png\",\"launchDate\":\"2023-09-01\",\"maxPrice\":null,\"minPrice\":null,\"name\":\"Model 3\",\"params\":{},\"price\":258900.0,\"rangeKm\":606,\"stock\":12}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-24 17:28:33', 9);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '岗位信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'headmaster', '校长', 1, '0', 'admin', '2024-06-29 09:22:56', 'admin', '2024-07-03 11:51:07', '');
INSERT INTO `sys_post` VALUES (2, 'professor', '教授', 2, '0', 'admin', '2024-06-29 09:22:56', 'admin', '2024-07-03 11:51:33', '');
INSERT INTO `sys_post` VALUES (3, 'researcher', '研究员', 3, '0', 'admin', '2024-06-29 09:22:56', 'admin', '2024-07-03 11:51:54', '');
INSERT INTO `sys_post` VALUES (4, 'dean', '院长', 4, '0', 'admin', '2024-06-29 09:22:56', 'admin', '2024-07-03 11:52:40', '');
INSERT INTO `sys_post` VALUES (5, 'instructor', '讲师', 5, '0', 'admin', '2024-07-03 11:53:35', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 105 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2024-06-29 09:22:56', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '学生', 'student', 3, '2', 0, 0, '0', '0', 'admin', '2024-06-29 09:22:56', 'admin', '2026-01-15 23:35:57', '普通角色');
INSERT INTO `sys_role` VALUES (100, 'test', 'system:test', 0, '1', 1, 1, '0', '2', 'admin', '2024-06-29 09:48:22', '', NULL, NULL);
INSERT INTO `sys_role` VALUES (101, '论文系统管理员', 'ROLE_ADMIN', 3, '1', 1, 1, '0', '2', 'admin', '2024-07-02 16:01:44', '', NULL, NULL);
INSERT INTO `sys_role` VALUES (102, '教师', 'teacher', 2, '1', 0, 0, '0', '0', 'admin', '2024-07-03 11:54:35', 'admin', '2026-01-15 23:35:56', NULL);
INSERT INTO `sys_role` VALUES (103, '论文管理员', 'platform:admin', 1, '1', 0, 0, '0', '0', 'admin', '2024-07-09 15:38:45', 'admin', '2026-01-15 23:35:55', NULL);
INSERT INTO `sys_role` VALUES (104, '普通用户', 'customer', 4, '1', 0, 0, '0', '0', 'admin', '2026-01-22 18:11:33', '', NULL, '购车客户角色');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和部门关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (2, 1);
INSERT INTO `sys_role_menu` VALUES (2, 107);
INSERT INTO `sys_role_menu` VALUES (2, 1035);
INSERT INTO `sys_role_menu` VALUES (2, 2011);
INSERT INTO `sys_role_menu` VALUES (2, 2022);
INSERT INTO `sys_role_menu` VALUES (2, 2023);
INSERT INTO `sys_role_menu` VALUES (2, 2031);
INSERT INTO `sys_role_menu` VALUES (2, 2032);
INSERT INTO `sys_role_menu` VALUES (2, 2033);
INSERT INTO `sys_role_menu` VALUES (2, 2034);
INSERT INTO `sys_role_menu` VALUES (2, 2035);
INSERT INTO `sys_role_menu` VALUES (2, 2037);
INSERT INTO `sys_role_menu` VALUES (2, 2038);
INSERT INTO `sys_role_menu` VALUES (2, 2041);
INSERT INTO `sys_role_menu` VALUES (2, 2042);
INSERT INTO `sys_role_menu` VALUES (2, 2043);
INSERT INTO `sys_role_menu` VALUES (2, 2044);
INSERT INTO `sys_role_menu` VALUES (102, 1);
INSERT INTO `sys_role_menu` VALUES (102, 107);
INSERT INTO `sys_role_menu` VALUES (102, 1035);
INSERT INTO `sys_role_menu` VALUES (102, 2011);
INSERT INTO `sys_role_menu` VALUES (102, 2013);
INSERT INTO `sys_role_menu` VALUES (102, 2024);
INSERT INTO `sys_role_menu` VALUES (102, 2025);
INSERT INTO `sys_role_menu` VALUES (102, 2026);
INSERT INTO `sys_role_menu` VALUES (102, 2027);
INSERT INTO `sys_role_menu` VALUES (102, 2028);
INSERT INTO `sys_role_menu` VALUES (102, 2029);
INSERT INTO `sys_role_menu` VALUES (102, 2030);
INSERT INTO `sys_role_menu` VALUES (102, 2036);
INSERT INTO `sys_role_menu` VALUES (102, 2039);
INSERT INTO `sys_role_menu` VALUES (102, 2040);
INSERT INTO `sys_role_menu` VALUES (103, 1);
INSERT INTO `sys_role_menu` VALUES (103, 100);
INSERT INTO `sys_role_menu` VALUES (103, 101);
INSERT INTO `sys_role_menu` VALUES (103, 103);
INSERT INTO `sys_role_menu` VALUES (103, 107);
INSERT INTO `sys_role_menu` VALUES (103, 1000);
INSERT INTO `sys_role_menu` VALUES (103, 1001);
INSERT INTO `sys_role_menu` VALUES (103, 1002);
INSERT INTO `sys_role_menu` VALUES (103, 1003);
INSERT INTO `sys_role_menu` VALUES (103, 1004);
INSERT INTO `sys_role_menu` VALUES (103, 1005);
INSERT INTO `sys_role_menu` VALUES (103, 1006);
INSERT INTO `sys_role_menu` VALUES (103, 1007);
INSERT INTO `sys_role_menu` VALUES (103, 1008);
INSERT INTO `sys_role_menu` VALUES (103, 1009);
INSERT INTO `sys_role_menu` VALUES (103, 1010);
INSERT INTO `sys_role_menu` VALUES (103, 1011);
INSERT INTO `sys_role_menu` VALUES (103, 1016);
INSERT INTO `sys_role_menu` VALUES (103, 1017);
INSERT INTO `sys_role_menu` VALUES (103, 1018);
INSERT INTO `sys_role_menu` VALUES (103, 1019);
INSERT INTO `sys_role_menu` VALUES (103, 1035);
INSERT INTO `sys_role_menu` VALUES (103, 1036);
INSERT INTO `sys_role_menu` VALUES (103, 1037);
INSERT INTO `sys_role_menu` VALUES (103, 1038);
INSERT INTO `sys_role_menu` VALUES (103, 2011);
INSERT INTO `sys_role_menu` VALUES (103, 2020);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `real_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '真实姓名',
  `id_card` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '身份证号',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '收获/联系地址',
  `role` int NULL DEFAULT NULL COMMENT '角色：0-普通用户；1-管理员',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户头像路径',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 110 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-01-24 17:27:25', 'admin', '2024-06-29 09:22:56', '', '2026-01-24 17:27:25', '管理员', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (2, 103, 'ry', '王老师', '00', 'ry@qq.com', '15666666666', '1', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '2', '127.0.0.1', '2024-06-29 09:22:56', 'admin', '2024-06-29 09:22:56', 'admin', '2024-07-03 11:56:45', '', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (100, NULL, 'test', 'test', '00', '', '', '0', '$2a$10$0V6b0uzM0kUGwIb.BCk1YekLyRy6KSE22Rxzm4Mx1nU1nBMz6kJ9u', '0', '2', '127.0.0.1', '2024-07-02 16:14:51', 'admin', '2024-06-29 09:50:41', '', '2024-07-02 16:14:51', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (101, NULL, 'sysAdmin', 'admin', '00', '', '', '0', '$2a$10$ROeTcvC9NicHhJIORm2q0.DjL31mi/9/S/Tl6hh78XvnUBUCFE60a', '0', '2', '127.0.0.1', '2024-07-03 10:56:07', 'admin', '2024-07-02 16:06:41', 'admin', '2024-07-03 10:56:06', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (102, 103, '王老师', '王老师', '00', '', '', '0', '$2a$10$8oWt7saXkqCStsvp8kiNZO2GW6Jzh8rFwuDnT3MYg7i7ujuFTTHay', '0', '0', '127.0.0.1', '2024-07-09 15:57:58', 'admin', '2024-07-03 12:00:11', 'admin', '2024-07-09 15:57:58', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (103, 103, '张三', '张三', '00', '', '', '0', '$2a$10$XR7CzZfqWDIJ9ub0eFdvJOTrEXL9MR6bf93/qwPrZB78U9k0ctBXu', '0', '0', '127.0.0.1', '2024-07-05 08:53:04', 'admin', '2024-07-03 12:00:43', '', '2024-07-05 08:53:03', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (104, 105, '李四', '李四', '00', '', '', '0', '$2a$10$dmWmHlqvQgNcPhrRdBbUxeNQp3GX3JK15u3NuAc0O0NxD4xQgRFCK', '0', '0', '127.0.0.1', '2024-07-09 16:42:03', 'admin', '2024-07-03 13:16:33', '', '2024-07-09 16:42:02', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (105, 105, '李老师', '李老师', '00', '', '13685210584', '1', '$2a$10$SLmUtnuVDuR.n2Ac7YyeNuVm5c.iBliZ5MbjhZbhjLJGHYmYDDSHW', '0', '0', '127.0.0.1', '2024-07-05 16:38:08', 'admin', '2024-07-05 16:31:44', '', '2024-07-05 16:38:07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (106, 105, '王五', '王五', '00', '', '', '0', '$2a$10$.YC5r33ANUwkpCdHRFaybuyj7zz9lTE3ZVf8U3fHHKbnUSwtwumiu', '0', '0', '', NULL, 'admin', '2024-07-09 15:31:22', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (107, 103, '张老师', '张老师', '00', '', '', '1', '$2a$10$ASWMnGqiVnIftKysnOHDVOJEUi8JFHfw0wL7jIZUfld1WRKZqPjHO', '0', '0', '127.0.0.1', '2024-07-09 16:39:10', 'admin', '2024-07-09 15:32:55', '', '2024-07-09 16:39:09', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (108, 101, 'plat_admin', '平台管理员', '00', '', '', '0', '$2a$10$/2o2sKcB/5aID3m2Kr65dumxt9p3iB3RkFoHOLzJtLiG4cxqHxKY.', '0', '0', '127.0.0.1', '2024-07-09 15:58:27', 'admin', '2024-07-09 15:40:03', '', '2024-07-09 15:58:27', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (109, NULL, 'user', 'user', '00', '', '13991245952', '0', '$2a$10$Bigh9c.QdP3NyMYWS55yQuXb9YDOi6KPjmb9hEjA.4g6fxtuGEJ36', '0', '0', '127.0.0.1', '2026-01-24 17:28:56', 'admin', '2026-01-24 10:18:39', '', '2026-01-24 17:28:56', NULL, NULL, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);
INSERT INTO `sys_user_post` VALUES (102, 2);
INSERT INTO `sys_user_post` VALUES (105, 2);
INSERT INTO `sys_user_post` VALUES (107, 2);
INSERT INTO `sys_user_post` VALUES (108, 1);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户和角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (102, 102);
INSERT INTO `sys_user_role` VALUES (103, 2);
INSERT INTO `sys_user_role` VALUES (104, 2);
INSERT INTO `sys_user_role` VALUES (105, 102);
INSERT INTO `sys_user_role` VALUES (106, 2);
INSERT INTO `sys_user_role` VALUES (107, 102);
INSERT INTO `sys_user_role` VALUES (108, 103);
INSERT INTO `sys_user_role` VALUES (109, 104);

-- ----------------------------
-- Table structure for vehicle
-- ----------------------------
DROP TABLE IF EXISTS `vehicle`;
CREATE TABLE `vehicle`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '车辆唯一标识',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '车型名称',
  `brand` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '品牌名称',
  `price` decimal(12, 2) NOT NULL COMMENT '指导价',
  `battery_type` int NOT NULL COMMENT '电池类型',
  `range_km` int NULL DEFAULT NULL COMMENT '续航里程(km)',
  `stock` int NULL DEFAULT 0 COMMENT '库存数量',
  `launch_date` date NULL DEFAULT NULL COMMENT '上市时间',
  `config_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '配置参数(快充、智驾等JSON)',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '车辆详情描述',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '车辆封面图片路径',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '车辆信息基础表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of vehicle
-- ----------------------------

-- ----------------------------
-- Table structure for wms_material
-- ----------------------------
DROP TABLE IF EXISTS `wms_material`;
CREATE TABLE `wms_material`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '物料档案ID',
  `classify_id` bigint NULL DEFAULT NULL COMMENT '物料分类ID',
  `material_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '物料编码',
  `material_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '物料名称',
  `material_model` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '型号',
  `material_specifications` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '规格',
  `material_unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '单位',
  `material_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '单价',
  `material_type` bigint NULL DEFAULT NULL COMMENT '类型',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '智能仓储WMS-物料档案表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of wms_material
-- ----------------------------
INSERT INTO `wms_material` VALUES (1, 11, '0001', '1.4T发动机', '1.4TASFG', '1.4排量', '个', 5000.00, 1, '');
INSERT INTO `wms_material` VALUES (2, 9, '0002', '1.4T排量轿车', '1.4TSI', '直立4缸', '辆', 100000.00, 0, '');
INSERT INTO `wms_material` VALUES (8, 9, '0003', '1.6排量轿车', '5挡手动两箱', '汽油车', '辆', 85500.00, 0, NULL);
INSERT INTO `wms_material` VALUES (9, 9, '0004', '1.8排量轿车', '9挡双离合三厢', '汽油车', '辆', 248000.00, 0, NULL);
INSERT INTO `wms_material` VALUES (10, 9, '0005', '2.0排量轿车', '7挡双离合三厢', '汽油车', '辆', 298000.00, 0, NULL);
INSERT INTO `wms_material` VALUES (11, 9, '0006', '2.5排量轿车', '9挡双离合三厢', '汽油车', '辆', 398000.00, 0, NULL);
INSERT INTO `wms_material` VALUES (12, 9, '0007', '3.0排量轿车', '9挡双离合两箱', '汽油车', '辆', 428000.00, 0, NULL);
INSERT INTO `wms_material` VALUES (13, 9, '0008', '4.5排量轿跑', '9挡双离合三厢', '汽油车', '辆', 888000.00, 0, NULL);
INSERT INTO `wms_material` VALUES (14, 13, '1001', '米其林轮胎', '胎面宽168', '210', '条', 588.00, 1, NULL);
INSERT INTO `wms_material` VALUES (15, 14, '1002', '锂电池', 'EL3RT4G', 'EL3RT4G', '块', 9800.00, 1, NULL);
INSERT INTO `wms_material` VALUES (16, 11, '1003', '1.8排量发动机', 'VM18ERT', '汽油发动机', '台', 488.00, 1, NULL);
INSERT INTO `wms_material` VALUES (17, 11, '1004', '1.6排量发动机', 'EX917394', '汽油发动机', '台', 68888.00, 1, NULL);
INSERT INTO `wms_material` VALUES (18, 13, '1005', '215轮胎', '固特异', '宽胎', '个', 118.00, 1, NULL);
INSERT INTO `wms_material` VALUES (19, 12, '1006', 'CVT变速箱', 'CVT', 'CVT', '个', 688.00, 1, NULL);
INSERT INTO `wms_material` VALUES (20, 13, '1007', '215轮胎', '马牌215', '窄胎', '个', 320.00, 1, NULL);
INSERT INTO `wms_material` VALUES (21, 11, '1008', '2.5T发动机', '汽油发动机', '2.5排量自然吸气', '个', 1288.00, 1, NULL);
INSERT INTO `wms_material` VALUES (22, 11, '1009', '3.0T发动机', '汽油发动机', '3.0排量自然吸气', '个', 1588.00, 1, NULL);
INSERT INTO `wms_material` VALUES (23, 11, '1010', '4.5T发动机', '汽油', '4.5排量自然吸气', '个', 2088.00, 1, NULL);
INSERT INTO `wms_material` VALUES (24, 19, '1011', 'LED刹车灯', 'FA5987', 'LED', '对', 1088.00, 1, NULL);
INSERT INTO `wms_material` VALUES (25, 20, '1012', '自动空调', 'DS3625', '自动空调9.1', '套', 1388.00, 1, NULL);
INSERT INTO `wms_material` VALUES (26, 21, '1013', '主驾座椅', 'FSA6366', '真皮', '个', 3000.00, 1, NULL);
INSERT INTO `wms_material` VALUES (27, 21, '1014', '副驾座椅', 'GS6366', '真皮', '个', 1588.00, 1, NULL);
INSERT INTO `wms_material` VALUES (28, 15, '1015', '4门三厢', 'DF659841', '4门', '个', 6600.00, 1, NULL);
INSERT INTO `wms_material` VALUES (29, 15, '1016', '4门一体', '4门一体', 'RE5968', '个', 5800.00, 1, NULL);
INSERT INTO `wms_material` VALUES (30, 16, '1017', 'A类底盘', 'DS5666', '整车', '个', 600.00, 1, NULL);
INSERT INTO `wms_material` VALUES (31, 16, '1018', 'B类底盘', 'TE3633', '整车', '个', 1200.00, 1, NULL);
INSERT INTO `wms_material` VALUES (32, 18, '1019', 'LED转向灯', 'FF9988', 'LED', '对', 980.00, 1, NULL);
INSERT INTO `wms_material` VALUES (33, 9, '1020', '3.0T越野吉普', '全时四驱', '3.0排量', '辆', 400000.00, 0, NULL);
INSERT INTO `wms_material` VALUES (34, 9, '1021', '2.5T都市SUV', '长城SUV', '2.5排量四驱', '辆', 250000.00, 0, NULL);
INSERT INTO `wms_material` VALUES (35, 9, '1022', '2.0T四驱SUV', '大众SUV', '四驱1.8T', '辆', 200000.00, 0, NULL);
INSERT INTO `wms_material` VALUES (36, 9, '1023', '1.8T三厢轿车', '哈弗1.8T', '三厢1.8T', '辆', 170000.00, 0, NULL);
INSERT INTO `wms_material` VALUES (37, 10, '1024', '理想混合动力轿车', 'VHE', '油电混合', '辆', 220000.00, 0, NULL);
INSERT INTO `wms_material` VALUES (38, 10, '0101', '比亚迪汉DM', '5挡三厢', '电车', '辆', 270000.00, 0, NULL);
INSERT INTO `wms_material` VALUES (39, 10, '0102', 'ZEEKER001', '9挡三厢', '纯电车', '辆', 350000.00, 0, NULL);
INSERT INTO `wms_material` VALUES (40, 10, '0103', '理想L7', '9挡三厢', '纯电车', '辆', 370000.00, 0, NULL);
INSERT INTO `wms_material` VALUES (41, 10, '0104', '海豹', '9挡三厢', '纯电车', '辆', 250000.00, 0, NULL);
INSERT INTO `wms_material` VALUES (42, 10, '0105', '小鹏P7', '10挡三厢', '纯电车', '量', 330000.00, 0, NULL);
INSERT INTO `wms_material` VALUES (43, 10, '0106', '问界M7', '9挡三厢', '纯电车', '量', 350000.00, 0, NULL);
INSERT INTO `wms_material` VALUES (44, 10, '0107', '宝马i3', '8挡三厢', '纯电车', '辆', 400000.00, 0, NULL);
INSERT INTO `wms_material` VALUES (45, 10, '0108', 'Taycan', '10挡三厢', '纯电车', '辆', 890000.00, 0, NULL);
INSERT INTO `wms_material` VALUES (46, 10, '0109', '宝马iX3', '9挡三厢', '纯电车', '辆', 420000.00, 0, NULL);
INSERT INTO `wms_material` VALUES (47, 10, '0110', 'ModelS', '7挡三厢', '纯电车', '辆', 800000.00, 0, NULL);
INSERT INTO `wms_material` VALUES (48, 17, '1020', '氙气大灯', 'DF1020', '氙气', '个', 720.00, 1, NULL);

SET FOREIGN_KEY_CHECKS = 1;
