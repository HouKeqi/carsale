package com.ruoyi.platform.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 用户信息对象 plat_user
 *
 * @author ruoyi
 * @date 2024-07-03
 */
public class PlatUser extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键ID */
    private Long id;

    /** 姓名 */
    @Excel(name = "姓名")
    private String name;

    /** 密码 */
    @Excel(name = "密码")
    private String password;

    /** 学号 */
    @Excel(name = "学号")
    private String studentId;

    /** 电话 */
    @Excel(name = "电话")
    private String phone;

    /** QQ号 */
    @Excel(name = "QQ号")
    private String qq;

    /** 邮箱 */
    @Excel(name = "邮箱")
    private String email;

    /** 角色 */
    @Excel(name = "角色")
    private String role;

    /** 选题一 */
    @Excel(name = "选题一")
    private Long select1;

    /** 选题二 */
    @Excel(name = "选题二")
    private Long select2;

    /** 选题三 */
    @Excel(name = "选题三")
    private Long select3;

    /** 用户编号 */
    @Excel(name = "用户编号")
    private String userId;

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public Long getId()
    {
        return id;
    }
    public void setName(String name)
    {
        this.name = name;
    }

    public String getName()
    {
        return name;
    }
    public void setPassword(String password)
    {
        this.password = password;
    }

    public String getPassword()
    {
        return password;
    }
    public void setStudentId(String studentId)
    {
        this.studentId = studentId;
    }

    public String getStudentId()
    {
        return studentId;
    }
    public void setPhone(String phone)
    {
        this.phone = phone;
    }

    public String getPhone()
    {
        return phone;
    }
    public void setQq(String qq)
    {
        this.qq = qq;
    }

    public String getQq()
    {
        return qq;
    }
    public void setEmail(String email)
    {
        this.email = email;
    }

    public String getEmail()
    {
        return email;
    }
    public void setRole(String role)
    {
        this.role = role;
    }

    public String getRole()
    {
        return role;
    }
    public void setSelect1(Long select1)
    {
        this.select1 = select1;
    }

    public Long getSelect1()
    {
        return select1;
    }
    public void setSelect2(Long select2)
    {
        this.select2 = select2;
    }

    public Long getSelect2()
    {
        return select2;
    }
    public void setSelect3(Long select3)
    {
        this.select3 = select3;
    }

    public Long getSelect3()
    {
        return select3;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("name", getName())
            .append("password", getPassword())
            .append("studentId", getStudentId())
            .append("phone", getPhone())
            .append("qq", getQq())
            .append("email", getEmail())
            .append("role", getRole())
            .append("select1", getSelect1())
            .append("select2", getSelect2())
            .append("select3", getSelect3())
            .toString();
    }
}
