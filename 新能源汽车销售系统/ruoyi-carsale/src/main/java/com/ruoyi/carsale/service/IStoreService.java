package com.ruoyi.carsale.service;

import com.ruoyi.carsale.domain.Store;

import java.util.List;

public interface IStoreService {
    /**
     * 新增门店
     */
    public int insertStore(Store store);

    /**
     * 修改门店
     */
    public int updateStore(Store store);

    /**
     * 删除门店
     */
    public int deleteStoreById(Long id);

    /**
     * 批量删除门店
     */
    public int deleteStoreByIds(Long[] ids);

    /**
     * 通过ID查询门店
     */
    public Store selectStoreById(Long id);

    /**
     * 查询门店列表
     */
    public List<Store> selectStoreList(Store store);
}
