package com.wk.service.impl;

import com.wk.dao.EmployeeMapper;
import com.wk.pojo.Employee;
import com.wk.pojo.EmployeeExample;
import com.wk.pojo.Msg;
import com.wk.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmployeeServiceImpl implements EmployeeService {

    @Autowired
    private EmployeeMapper employeeMapper;

    @Override
    public List<Employee> getAll() {
        EmployeeExample example = new EmployeeExample();
        example.setOrderByClause("e.id desc");
        return employeeMapper.selectByExampleWithDept(example);
    }

    @Override
    public Msg saveEmp(Employee employee) {
        int i = employeeMapper.insertSelective(employee);
        if(i>0){
            return Msg.success();
        }else{
            return Msg.fail();
        }
    }

    @Override
    public boolean checkData(Employee employee) {
        EmployeeExample example = new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        if (employee.getName() != null||"".equals(employee.getName())) {
            criteria.andNameEqualTo(employee.getName());
        } else if (employee.getEmail() != null||"".equals(employee.getEmail())) {
            criteria.andEmailEqualTo(employee.getEmail());
        }
        long count = employeeMapper.countByExample(example);
        return count==0;
    }

    @Override
    public Msg getEmp(Integer id) {
        Employee employee = employeeMapper.selectByPrimaryKey(id);
        if (employee != null) {
            return Msg.success().add("emp",employee);
        }
        return Msg.fail();
    }

    @Override
    public Msg updEmp(Employee employee) {
        int index = employeeMapper.updateByPrimaryKeySelective(employee);
        if(index>0){
            return Msg.success();
        }
        return Msg.fail();
    }

    @Override
    public Msg delEmp(Integer id) {
        int index = employeeMapper.deleteByPrimaryKey(id);
        if(index>0){
            return Msg.success();
        }
        return Msg.fail();
    }

    @Override
    public Msg delBatch(List<Integer> ids) {
        EmployeeExample example = new EmployeeExample();
        //delete from xxx where id in(x,x,x);
        example.createCriteria().andIdIn(ids);
        int index = employeeMapper.deleteByExample(example);
        if(index>0){
            return Msg.success();
        }
        return Msg.fail();
    }
}
