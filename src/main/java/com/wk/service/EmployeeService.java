package com.wk.service;

import com.wk.pojo.Employee;
import com.wk.pojo.Msg;

import java.util.List;

public interface EmployeeService {

    List<Employee> getAll();

	Msg saveEmp(Employee employee);

	boolean checkData(Employee employee);

	Msg getEmp(Integer id);

	Msg updEmp(Employee employee);
}
