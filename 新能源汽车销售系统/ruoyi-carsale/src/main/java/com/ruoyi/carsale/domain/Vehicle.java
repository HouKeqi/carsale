package com.ruoyi.carsale.domain;

/*
* -- 车辆数据 (含库存<=5的预警数据)
INSERT INTO `carsale_vehicle` (name, brand, price, battery_type, range_km, stock, launch_date, config_json)
VALUES
('Model 3', 'Tesla', 258900.00, 0, 606, 12, '2023-09-01', '{"fast_charge":"0.5h", "ai_level":"L2"}'),
('汉 EV', 'BYD', 221800.00, 1, 715, 3, '2023-03-20', '{"fast_charge":"0.42h", "ai_level":"L2"}'),
('SU7', 'Xiaomi', 215900.00, 2, 700, 2, '2024-03-28', '{"fast_charge":"0.35h", "ai_level":"L3"}');

-- 促销活动
INSERT INTO `carsale_promotion` (title, vehicle_id, discount_type, discount_value, start_time, end_time)
VALUES ('春季购车送桩', 1, 1, 3000.00, '2026-01-01', '2026-03-31');

-- 示例订单 (status 1=已支付)
INSERT INTO `carsale_orders` (id, user_id, vehicle_id, status, amount, store_location)
VALUES (202601130001, 2, 1, 1, 258900.00, '上海中心门店');

ALTER TABLE `carsale_orders`
MODIFY COLUMN `number` INT NOT NULL DEFAULT 1;

ALTER TABLE `carsale_orders`
MODIFY COLUMN `phone` VARCHAR(20) NULL DEFAULT NULL;
*
* */

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

public class Vehicle extends BaseEntity {

    @Excel(name = "车辆编号")
    private int id;
    @Excel(name = "车辆名称")
    private String name;
    @Excel(name = "车辆品牌")
    private String brand;
    @Excel(name = "车辆价格")
    private double price;

    private int priceOrder;
    private int rangeKmOrder;

    public int getPriceOrder() {
        return priceOrder;
    }

    public void setPriceOrder(int priceOrder) {
        this.priceOrder = priceOrder;
    }

    public int getRangeKmOrder() {
        return rangeKmOrder;
    }

    public void setRangeKmOrder(int rangeKmOrder) {
        this.rangeKmOrder = rangeKmOrder;
    }

    public int getBatteryType() {
        return batteryType;
    }

    public void setBatteryType(int batteryType) {
        this.batteryType = batteryType;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getRangeKm() {
        return rangeKm;
    }

    public void setRangeKm(int rangeKm) {
        this.rangeKm = rangeKm;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public String getLaunchDate() {
        return launchDate;
    }

    public void setLaunchDate(String launchDate) {
        this.launchDate = launchDate;
    }

    public String getConfigJson() {
        return configJson;
    }

    public void setConfigJson(String configJson) {
        this.configJson = configJson;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    @Excel(name = "电池类型")
    private int batteryType;
    @Excel(name = "车辆续航里程")
    private int rangeKm;
    @Excel(name = "车辆库存")
    private int stock;
    @Excel(name = "车辆上架时间")
    private String launchDate;
    @Excel(name = "车辆配置")
    private String configJson;
    @Excel(name = "车辆描述")
    private String description;
    @Excel(name = "车辆图片")
    private String imageUrl;

}


