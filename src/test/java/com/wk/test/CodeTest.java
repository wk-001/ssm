package com.wk.test;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wk.dao.EmployeeMapper;
import com.wk.pojo.Employee;
import org.apache.ibatis.session.ExecutorType;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import javax.annotation.Resource;
import java.util.List;
import java.util.UUID;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration    //获取web的IOC
@ContextConfiguration(locations = {"classpath:applicationContext.xml", "classpath:springMVC.xml"})
public class CodeTest {

    @Autowired
    WebApplicationContext context;

    @Autowired
    private SqlSessionFactory sqlSessionFactory;


    //虚拟mvc，获取到处理后的结果
    MockMvc mockMvc;

    @Resource
    private EmployeeMapper employeeMapper;

    //使用MockMvc需要进行初始化
    @Before
    public void initMockMvc(){
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    //发送请求测试controller方法
    @Test
    public void testPage() throws Exception {
        //模拟请求拿到返回值
        MvcResult result = mockMvc
                .perform(MockMvcRequestBuilders
                        .get("/emps")       //这里路径必须要加"/"
                        .param("pn", "1"))
                .andReturn();
        PageInfo page = (PageInfo) result.getRequest().getAttribute("page");
        System.out.println("当前页码" + page.getPageNum());
        System.out.println("总页码" + page.getPages());
        System.out.println("数据总数" + page.getTotal());
        System.out.println("页面连续显示的页码");
        int[] nums = page.getNavigatepageNums();
        for (int num : nums) {
            System.out.println("num = " + num);
        }

        //获取员工数据
        List<Employee> list = page.getList();
        for (Employee emp : list) {
            System.out.println("emp = " + emp);
        }
    }

    @Test
    public void getOne(){
//        System.out.println(employeeMapper.selectByPrimaryKeyWithDept(10));
        PageHelper.startPage(0,5);
        List<Employee> list = employeeMapper.selectByExampleWithDept(null);
        PageInfo pageInfo = new PageInfo(list);
        List<Employee> list1 = pageInfo.getList();
        for (Employee emp : list1) {
            System.out.println("emp = " + emp.getDepartment());
        }
    }

    //批量添加对象
    @Test
    public void addEmp(){
        //开启批量添加功能
        SqlSession sqlSession = sqlSessionFactory.openSession(ExecutorType.BATCH);
        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
        for (int i = 0; i < 10; i++) {
            String str = UUID.randomUUID().toString().substring(0, 5);
            mapper.insertSelective(new Employee(str,str+"@qq.com",1,1));
        }
    }
}
