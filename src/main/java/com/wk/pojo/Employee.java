package com.wk.pojo;

import javax.validation.constraints.Pattern;

public class Employee {
    private Integer id;

    //自定义jsr303数据校验(正则，提示信息)
    @Pattern(regexp = "(^[a-zA-Z0-9_-]{3,16}$)|(^[\\u4e00-\\u9fa5]{2,4})",message = "用户名必须是2-4位中文或3-16位英文和数字的组合")
    private String name;

    @Pattern(regexp = "^([A-Za-z0-9_\\-\\.])+\\@([A-Za-z0-9_\\-\\.])+\\.([A-Za-z]{2,4})$",message = "邮箱格式不正确")
    private String email;

    private Integer gender;

    private Integer dId;

    private Department department;

    public Employee() {
    }

    public Employee(String name, String email, Integer gender, Integer dId) {
        this.name = name;
        this.email = email;
        this.gender = gender;
        this.dId = dId;
    }

    public Department getDepartment() {
        return department;
    }

    public void setDepartment(Department department) {
        this.department = department;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email == null ? null : email.trim();
    }

    public Integer getGender() {
        return gender;
    }

    public void setGender(Integer gender) {
        this.gender = gender;
    }

    public Integer getdId() {
        return dId;
    }

    public void setdId(Integer dId) {
        this.dId = dId;
    }

    @Override
    public String toString() {
        return "Employee{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", gender=" + gender +
                ", dId=" + dId +
                ", department=" + department +
                '}';
    }
}