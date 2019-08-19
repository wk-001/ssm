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
        return employeeMapper.selectByExampleWithDept(null);
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
}
