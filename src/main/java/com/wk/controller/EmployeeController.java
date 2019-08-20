package com.wk.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wk.pojo.Employee;
import com.wk.pojo.Msg;
import com.wk.service.EmployeeService;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
public class EmployeeController {

    @Resource
    private EmployeeService employeeService;

    @DeleteMapping("emp/{ids}")
    public Msg delEmp(@PathVariable String ids){
        if(ids.contains(",")){
            List<Integer> delIds = new ArrayList<>();
            String[] split = ids.split(",");
            for (String str : split) {
                delIds.add(Integer.parseInt(str));
            }
            return employeeService.delBatch(delIds);
        }else{
            int id = Integer.parseInt(ids);
            return employeeService.delEmp(id);
        }
    }

    /**
     * 更新员工信息
     * @param employee
     * @return
     */
    @PutMapping("emp/{id}")
    public Msg updEmp(Employee employee){
        return employeeService.updEmp(employee);
    }

    /**
     * 根据ID查询员工信息
     * @param id
     * @return
     */
    @GetMapping("emp/{id}")
    public Msg getEmp(@PathVariable Integer id){
        return employeeService.getEmp(id);
    }

    /**
     * 数据查重
      * @param employee
     * @return true:可用 false:数据重复
     */
    @GetMapping("checkData")
    public boolean checkData(Employee employee){
        /*判断用户名是否合法
        String regx = "(^[a-zA-Z0-9_-]{3,16}$)|(^[\\u4e00-\\u9fa5]{2,4})";
        if(!employee.getName().matches(regx)){
            return false;
        }*/
        return employeeService.checkData(employee);
    }

    /**
     * 添加员工信息
     * @param employee
     * @result 数据校验的结果
     * @return
     * @Valid：对疯转的数据进行校验
     */
    @PostMapping("emp")
    public Msg saveEmp(@Valid Employee employee, BindingResult result){
        if (result.hasErrors()){
            Map<String,Object> map = new HashMap<>();
            //校验失败，在页面模态框中显示提示信息
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError error : errors) {
                System.out.println("错误字段名" + error.getField());
                System.out.println("错误信息" + error.getDefaultMessage());
                map.put(error.getField(),error.getDefaultMessage());
            }
            return Msg.fail().add("errMsg",map);
        }else{
            return  employeeService.saveEmp(employee);
        }
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
