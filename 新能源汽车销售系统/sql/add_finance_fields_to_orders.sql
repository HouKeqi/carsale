-- 添加金融方案相关字段到订单表
-- 执行日期: 2026-01-29

ALTER TABLE `carsale_orders` 
ADD COLUMN `finance_plan_id` BIGINT NULL COMMENT '金融方案ID' AFTER `pickup_time`,
ADD COLUMN `original_price` DECIMAL(12,2) NULL COMMENT '原价（未打折前的总价）' AFTER `finance_plan_id`,
ADD COLUMN `discount_amount` DECIMAL(12,2) NULL COMMENT '折扣金额（促销活动直降金额）' AFTER `original_price`,
ADD COLUMN `down_payment` DECIMAL(12,2) NULL COMMENT '首付金额（选择金融方案时的首付）' AFTER `discount_amount`;

-- 添加外键约束（可选）
-- ALTER TABLE `carsale_orders` 
-- ADD CONSTRAINT `fk_order_finance_plan` FOREIGN KEY (`finance_plan_id`) REFERENCES `carsale_finance_plan` (`id`);
