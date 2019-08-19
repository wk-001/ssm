package com.wk.controller;

import com.wk.pojo.Department;
import com.wk.pojo.Msg;
import com.wk.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class DepartmentController {

	@Autowired
	private DepartmentService departmentService;

	/**
	 * 查询所有部门信息
	 * @return
	 */
	@GetMapping("depts")
	public Msg getDepts(){
		List<Department> depts = departmentService.getDepts();
		return Msg.success().add("depts",depts);
	}
}
