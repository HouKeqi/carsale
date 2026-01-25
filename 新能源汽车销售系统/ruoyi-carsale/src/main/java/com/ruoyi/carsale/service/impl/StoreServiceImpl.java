package com.ruoyi.carsale.service.impl;

import com.ruoyi.carsale.domain.Store;
import com.ruoyi.carsale.mapper.StoreMapper;
import com.ruoyi.carsale.service.IStoreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class StoreServiceImpl implements IStoreService {

    @Autowired
    private StoreMapper storeMapper;

    @Override
    public int insertStore(Store store) {
        return storeMapper.insertStore(store);
    }

    @Override
    public int updateStore(Store store) {
        return storeMapper.updateStore(store);
    }

    @Override
    public int deleteStoreById(Long id) {
        return storeMapper.deleteStoreById(id);
    }

    @Override
    public int deleteStoreByIds(Long[] ids) {
        return storeMapper.deleteStoreByIds(ids);
    }

    @Override
    public Store selectStoreById(Long id) {
        return storeMapper.selectStoreById(id);
    }

    @Override
    public List<Store> selectStoreList(Store store) {
        return storeMapper.selectStoreList(store);
    }
}
