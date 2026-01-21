package com.ruoyi.carsale.service;
import com.ruoyi.carsale.domain.Promotion;

import java.util.List;

public interface IPromotionService {
    /*  新增促销活动   */
    public int insertPromotion(Promotion  promotion);

    /*  修改促销活动   */
    public int updatePromotion(Promotion  promotion);

    /*  删除促销活动  */
    public int deletePromotionById(Long id);

    /*  批量删除促销活动  */
    public int deletePromotionByIds(Long[] ids);

    /*  通过ID,查询促销活动   */
    public Promotion selectPromotionById(Long id);

    /*  查询促销活动列表   */
    public List<Promotion> selectPromotionList(Promotion  promotion);
}
