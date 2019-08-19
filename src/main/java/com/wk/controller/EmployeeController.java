package com.wk.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wk.pojo.Employee;
import com.wk.pojo.Msg;
import com.wk.service.EmployeeService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

@RestController
public class EmployeeController {

    @Resource
    private EmployeeService employeeService;

    /**
     * 数据查重
      * @param employee
     * @return true:可用 false:数据重复
     */
    @GetMapping("checkData")
    public boolean checkData(Employee employee){
        return employeeService.checkData(employee);
    }

    /**
     * 添加员工信息
     * @param employee
     * @return
     */
    @PostMapping("emp")
    public Msg saveEmp(Employee employee){
        Msg msg = employeeService.saveEmp(employee);
        return msg;
    }


    /**
     * 分页查询员工信息，返回json格式的数据
     * @param pn
     * @return
     */
    @GetMapping("emps")
    public Msg emps(@RequestParam(value = "pn",defaultValue = "1")int pn){
        //查询之前设置页面和每页数据条数
        PageHelper.startPage(pn,5);     //每页查询5条
        List<Employee> list = employeeService.getAll();
        //页面显示5个页码
        PageInfo page = new PageInfo(list,5);
        return Msg.success().add("page",page);
    }


    /**
     * 分页查询员工信息,查询完成后将信息放到request作用域中返回到前台
     * 只适用于浏览器方式访问，为了适应其他客户端的访问，如Android iOS
     * 修改为前台使用ajax发送请求，后台返回json数据
     * @param pn
     * @param model
     * @return

    @RequestMapping("emps")
    public String emps(@RequestParam(value = "pn",defaultValue = "1")int pn, Model model){
        //查询之前设置页面和每页数据条数
        PageHelper.startPage(pn,5);     //每页查询5条
        List<Employee> list = employeeService.getAll();
        //页面显示5个页码
        PageInfo pageInfo = new PageInfo(list,5);
        model.addAttribute("page",pageInfo);
        return "list";
    }*/

}
