package com.ruoyi.platform.mapper;

import java.util.List;
import com.ruoyi.platform.domain.PlatPaper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

/**
 * 论文管理Mapper接口
 *
 * @author ruoyi
 * @date 2024-07-03
 */
public interface PlatPaperMapper
{
    /**
     * 查询论文管理
     *
     * @param id 论文管理主键
     * @return 论文管理
     */
    public PlatPaper selectPlatPaperById(Long id);

    /**
     * 查询论文管理列表
     *
     * @param platPaper 论文管理
     * @return 论文管理集合
     */
    public List<PlatPaper> selectPlatPaperList(PlatPaper platPaper);


    /**
     * 新增论文管理
     *
     * @param platPaper 论文管理
     * @return 结果
     */
    public int insertPlatPaper(PlatPaper platPaper);

    /**
     * 修改论文管理
     *
     * @param platPaper 论文管理
     * @return 结果
     */
    public int updatePlatPaper(PlatPaper platPaper);

    /**
     * 删除论文管理
     *
     * @param id 论文管理主键
     * @return 结果
     */
    public int deletePlatPaperById(Long id);

    /**
     * 批量删除论文管理
     *
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deletePlatPaperByIds(Long[] ids);

    /** 查看bond=“userID"的课题信息 */

            /** 先查当前学生的学生号 */
    @Select("select student_id from plat_user where user_id=#{userId}")
    public String getStudentIdByUserId(Long userId);

    @Select("select * from plat_paper where bond=#{student_id}")
    public List<PlatPaper> getSelectBondPaper(String student_id);

    /**
     * 学生查询没有选中的课题信息
     *
     * @param platPaper 论文管理
     * @return 论文管理集合
     */
    public List<PlatPaper> slectUnslectPaperList(PlatPaper platPaper);

    /**
     * 教师查看选择了自己课题的课题 + 学生信息
     * 教师id--paperid---学生userid---学生信息
     */
    @Select("SELECT DISTINCT p.topic,p.bond, p.type, p.ask, u.name, u.student_id " +
            "FROM plat_paper p, plat_user u, plat_select_paper sp " +
            "WHERE p.teacher_id = #{userId} " +
            "AND (sp.select_id_1 = p.id or sp.select_id_2 = p.id or select_id_3 = p.id) " +
            "AND (sp.user_id = u.user_id)")
    List<PlatPaper> getPaperManageForTeacher(@Param("userId") Long userId);



    /** 老师审核学生选题，绑定 */
    public int updatePaperManageBondInfoByTeacher(PlatPaper platPaper);

    /** 教师id -- bond学生Id */
    @Select("SELECT DISTINCT bond FROM plat_paper WHERE teacher_id = #{teacherId}")
    List<String> selectbondListByTeacherId(Long teacherId);


    /** bond(学生ID) --> paper信息 */
    PlatPaper  getBondPaperByStudentId(String bond);

}

