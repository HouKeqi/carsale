package com.ruoyi.platform.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 论文管理对象 plat_paper
 *
 * @author ruoyi
 * @date 2024-07-03
 */
public class PlatPaper extends BaseEntity
{
    private static final long serialVersionUID = 1L;



    /** userId 系统用户id */
    private Long userId;




    private Long teacher_id;



    @Excel(name = "学号")
    private String student_id;

    public String getStudent_id() {
        return student_id;
    }

    public void setStudent_id(String student_id) {
        this.student_id = student_id;
    }

    // 学生姓名
    @Excel(name = "姓名")
    private String name;


    /** 主键ID */
    private Long id;

    /** 题目 */
    @Excel(name = "题目")
    private String topic;

    /** 类型 */
    @Excel(name = "类型")
    private String type;

    /** 要求 */
    @Excel(name = "要求")
    private String ask;

    /** 论文状态码 */
    @Excel(name = "论文状态码")
    private String code;

    /** 教师姓名 */
    @Excel(name = "教师姓名")
    private String teacherName;

    /** 教师电话 */
    @Excel(name = "教师电话")
    private String teacherPhone;

    /** 绑定的学生学号 */
    @Excel(name = "绑定的学生学号")
    private String bond;

    /** 指导成绩 */
    @Excel(name = "指导成绩")
    private String gradeInstruct;

    /** 评阅成绩 */
    @Excel(name = "评阅成绩")
    private String gradeReview;

    /** 答辩成绩 */
    @Excel(name = "答辩成绩")
    private String gradeDefence;

    /** 最终成绩 */
    @Excel(name = "最终成绩")
    private String grade;

    public void setId(Long id)
    {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Long getTeacher_id() {
        return teacher_id;
    }

    public void setTeacher_id(Long teacher_id) {
        this.teacher_id = teacher_id;
    }
    public Long getId()
    {
        return id;
    }
    public void setTopic(String topic)
    {
        this.topic = topic;
    }

    public String getTopic()
    {
        return topic;
    }
    public void setType(String type)
    {
        this.type = type;
    }

    public String getType()
    {
        return type;
    }
    public void setAsk(String ask)
    {
        this.ask = ask;
    }

    public String getAsk()
    {
        return ask;
    }
    public void setCode(String code)
    {
        this.code = code;
    }

    public String getCode()
    {
        return code;
    }
    public void setTeacherName(String teacherName)
    {
        this.teacherName = teacherName;
    }

    public String getTeacherName()
    {
        return teacherName;
    }
    public void setTeacherPhone(String teacherPhone)
    {
        this.teacherPhone = teacherPhone;
    }

    public String getTeacherPhone()
    {
        return teacherPhone;
    }
    public void setBond(String bond)
    {
        this.bond = bond;
    }

    public String getBond()
    {
        return bond;
    }
    public void setGradeInstruct(String gradeInstruct)
    {
        this.gradeInstruct = gradeInstruct;
    }

    public String getGradeInstruct()
    {
        return gradeInstruct;
    }
    public void setGradeReview(String gradeReview)
    {
        this.gradeReview = gradeReview;
    }

    public String getGradeReview()
    {
        return gradeReview;
    }
    public void setGradeDefence(String gradeDefence)
    {
        this.gradeDefence = gradeDefence;
    }

    public String getGradeDefence()
    {
        return gradeDefence;
    }
    public void setGrade(String grade)
    {
        this.grade = grade;
    }

    public String getGrade()
    {
        return grade;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("topic", getTopic())
            .append("type", getType())
            .append("ask", getAsk())
            .append("code", getCode())
            .append("teacherName", getTeacherName())
            .append("teacherPhone", getTeacherPhone())
            .append("bond", getBond())
            .append("gradeInstruct", getGradeInstruct())
            .append("gradeReview", getGradeReview())
            .append("gradeDefence", getGradeDefence())
            .append("grade", getGrade())
            .toString();
    }
}
