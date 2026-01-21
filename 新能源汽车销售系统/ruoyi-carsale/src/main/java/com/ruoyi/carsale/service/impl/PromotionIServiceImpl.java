package com.ruoyi.carsale.service.impl;

import com.ruoyi.carsale.domain.Promotion;
import com.ruoyi.carsale.mapper.OrdersMapper;
import com.ruoyi.carsale.mapper.PromotionMapper;
import com.ruoyi.carsale.service.IPromotionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PromotionIServiceImpl implements IPromotionService {

    @Autowired
    private PromotionMapper promotionMapper;

    @Override
    public int insertPromotion(Promotion promotion) {
        return promotionMapper.insertPromotion(promotion);
    }

    @Override
    public int updatePromotion(Promotion promotion) {
        return promotionMapper.updatePromotion(promotion);
    }

    @Override
    public int deletePromotionById(Long id) {
        return promotionMapper.deletePromotionById(id);
    }

    @Override
    public int deletePromotionByIds(Long[] ids) {
        return promotionMapper.deletePromotionByIds(ids);
    }

    @Override
    public Promotion selectPromotionById(Long id) {
        return promotionMapper.selectPromotionById(id);
    }

    @Override
    public List<Promotion> selectPromotionList(Promotion promotion) {
        return promotionMapper.selectPromotionList(promotion);
    }
}
