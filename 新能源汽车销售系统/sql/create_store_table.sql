-- 创建门店表
CREATE TABLE IF NOT EXISTS `carsale_store` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '门店ID',
  `name` VARCHAR(100) NOT NULL COMMENT '门店名称',
  `address` VARCHAR(200) DEFAULT NULL COMMENT '门店地址',
  `phone` VARCHAR(20) DEFAULT NULL COMMENT '联系电话',
  `status` INT DEFAULT 1 COMMENT '状态：0-停用，1-启用',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='门店表';

-- 插入示例数据
INSERT INTO `carsale_store` (`name`, `address`, `phone`, `status`) VALUES
('上海中心门店', '上海市黄浦区南京东路100号', '021-12345678', 1),
('北京朝阳门店', '北京市朝阳区建国路88号', '010-87654321', 1),
('深圳南山门店', '深圳市南山区科技园南路200号', '0755-11223344', 1),
('广州天河门店', '广州市天河区天河路500号', '020-55667788', 1);
