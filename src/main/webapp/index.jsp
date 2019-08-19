<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>Title</title>
    <base href="<%=basePath%>">
    <link href="<%=basePath%>static/bootstrap-3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <script type="text/javascript" src="<%=basePath%>static/js/jquery-3.4.1.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>static/bootstrap-3.3.7/js/bootstrap.min.js"></script>
</head>
<script type="text/javascript">

    var lastPages;
    /*页面加载完成后发送ajax请求获取数据*/
    $(function () {
        to_page(1);
    });

    //点击页码跳转页面
    function to_page(pn) {
        $("#emps_table tbody").empty();
        $("#page_info_area").empty();
        $("#page_nav_area").empty();
        $.get(
            "<%=basePath%>emps",
            {"pn":pn},
            function (data) {
                build_emps_table(data);
                build_page_info(data);
                build_page_nav(data);
            }
        )
    }

    //表格信息
    function build_emps_table(data) {
        var emps = data.extend.page.list;
        $.each(emps,function (index, item) {
            var id = $("<td></td>").append(item.id);
            var name = $("<td></td>").append(item.name);
            var email = $("<td></td>").append(item.email);
            var gender = $("<td></td>").append(item.gender==1?"男":"女");
            var deptName = $("<td></td>").append(item.department.deptName);
            //添加按钮
            var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm")
                .append($("<span></span>").addClass("glyphicon glyphicon-pencil"))
                .append("编辑");
            var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm")
                .append($("<span></span>").addClass("glyphicon glyphicon-trash"))
                .append("删除");
            var btnTd = $("<td></td>").append(editBtn).append("  ").append(delBtn);
            $("<tr></tr>").append(id)
                .append(name)
                .append(email)
                .append(gender)
                .append(deptName)
                .append(btnTd)
                .appendTo("#emps_table tbody");
        });
    }
    
    //分页信息
    function build_page_info(data) {
        $("#page_info_area").append("当前第"+data.extend.page.pageNum+"页，共"+data.extend.page.pages+"页，总"+data.extend.page.total+"条记录")
        lastPages = data.extend.page.pages+1;
    }
    
    //分页条
    function build_page_nav(data) {
        var numb = data.extend.page.pageNum;
        var ul = $("<ul></ul>").addClass("pagination").css("cursor","pointer");
        if(data.extend.page.hasPreviousPage==true){
            var firstPage = $("<li></li>").append($("<a></a>").append("首页"));
            var prePage = $("<li></li>").append($("<a></a>").append("&laquo;"));

            firstPage.click(function () {
                to_page(1);
            })

            prePage.click(function () {
                to_page(numb-1);
            })
        }

        if(data.extend.page.hasNextPage==true){
            var nextPage = $("<li></li>").append($("<a></a>").append("&raquo;"));
            var lastPage = $("<li></li>").append($("<a></a>").append("尾页"));

            nextPage.click(function () {
                to_page(numb+1);
            })

            lastPage.click(function () {
                to_page(data.extend.page.pages);
            })
        }

        //首页和前一页
        ul.append(firstPage).append(prePage);
        //遍历页码
        $.each(data.extend.page.navigatepageNums,function (index, item) {
            var nums = $("<li></li>").append($("<a></a>").append(item));
            if(numb == item){
                nums.addClass("active");
            }
            nums.click(function () {
                to_page(item);
            });
            ul.append(nums);
        })
        ul.append(nextPage).append(lastPage);
        var nav = $("<nav></nav>").append(ul);
        nav.appendTo("#page_nav_area");
    }

    //点击新增按钮弹出模态框
    function openAddModel() {
        //清空原数据
        /*$("#empName").val("");
        $("#email").val("");*/
        //转成dom对象再调用方法，否则无效
        $("#empForm")[0].reset();

        //发送ajax请求查询部门信息，添加到下拉列表
        getDepts();

        //模态框
        $('#empAddModel').modal({
            keyboard: false,    //禁止按esc关闭模态框
            backdrop: 'static'  //点击模态框以外的区域不会关闭模态框
        });
    }

    //查询所有部门信息并显示在下拉列表
    function getDepts() {
        $("#did").empty();
        $.get(
            "<%=basePath%>depts",
            function (data) {
                $.each(data.extend.depts,function (index, item) {
                    var sel = $("<option></option>").append(item.deptName).val(item.id);
                    sel.appendTo("#did");
                })
            }
        )
    }

    //添加员工
    function saveEmp() {
        //数据校验
        if(!checkUser()){
            return false;
        }
        if(!checkEmail()){
            return false;
        }
        $.post(
            "<%=basePath%>emp",
            $("#empForm").serialize(),
            function (data) {
                if(data.code==1){
                    //保存成功后关闭模态框
                    $('#empAddModel').modal('hide')
                    //添加成功后跳转到最后一页显示最新添加的数据，发送ajax请求显示最后一页即可
                    to_page(lastPages);
                }
                alert(data.msg);
            }
        )
    }

    //数据校验提示
    function validate_msg(ele, status, msg) {
        //清除之前的class
        $("#"+ele).parent().removeClass("has-success has-error");
        $("#"+ele).next("span").text("");
        if("success"==status){
            //输入框变红色
            $("#"+ele).parent().addClass("has-success");
            //输入框后面的span设置值
            $("#"+ele).next("span").text(msg);
        }else if("error"==status){
            //输入框变绿色
            $("#"+ele).parent().addClass("has-error");
            //输入框后面的span设置值
            $("#"+ele).next("span").text(msg);
        }
    }

    //检查用户名格式是否符合，是否重复
    function checkUser() {
        var empName = $("#empName").val();
        var pattern = /(^[a-zA-Z0-9_-]{3,16}$)|(^[\u4e00-\u9fa5]{2,4})/;
        if(!pattern.test(empName)){
            validate_msg("empName", "error", "用户名可以是2-4位中文或3-16位英文和数字的组合");
            return false;
        }else{
            $.get(
                "<%=basePath%>checkData",
                {name:empName},
                function (data) {
                    if(data){
                        validate_msg("empName", "success", "可以使用的用户名");
                        return true;
                    }else {
                        validate_msg("empName", "error","用户名已存在");
                        return false;
                    }
                }
            )
        }
    }

    //检查邮箱格式是否符合，是否重复
    function checkEmail() {
        var ePattern = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
        var email = $("#email").val();
        if(!ePattern.test(email)){
            validate_msg("email", "error", "请输入正确的邮箱格式");
            return false;
        }else{
            $.get(
                "<%=basePath%>checkData",
                {email:email},
                function (data) {
                    if(data){
                        validate_msg("email", "success", "可以使用的邮箱");
                        return true;
                    }else {
                        validate_msg("email", "error","邮箱已存在");
                        return false;
                    }
                }
            )
        }
    }
</script>
<body>

<%--搭建显示页面--%>
<div class="container">
    <%--标题--%>
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>

    <%--操作按钮--%>
    <div class="row">
        <div class="col-md-4 col-md-offset-8"> <%--div占4列，偏移8列--%>
            <button class="btn btn-primary" onclick="openAddModel()">新增</button>
            <button class="btn btn-danger">删除</button>
        </div>
    </div>

    <%--表格--%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                    <tr>
                        <th>id</th>
                        <th>name</th>
                        <th>email</th>
                        <th>gender</th>
                        <th>deptName</th>
                        <th>operate</th>
                    </tr>
                </thead>

                <tbody></tbody>
            </table>
        </div>
    </div>

    <%--分页--%>
    <div class="row">
        <div class="col-md-6" id="page_info_area"></div>

        <div class="col-md-6" id="page_nav_area"></div>
    </div>
</div>

<!-- 添加员工模态框 -->
<div class="modal fade" id="empAddModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">添加员工</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="empForm">
                    <div class="form-group">
                        <label class="col-sm-4 control-label">EmpName</label>
                        <div class="col-sm-6">
                            <input type="text" class="form-control" id="empName" name="name" placeholder="tom" onblur="checkUser()">
                            <span class="help-block"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-4 control-label">Email</label>
                        <div class="col-sm-6">
                            <input type="email" class="form-control" id="email" name="email" placeholder="abc@qq.com" onblur="checkEmail()">
                            <span class="help-block"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-4 control-label">Gender</label>
                        <div class="col-sm-6">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1" value="1" checked> male
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2" value="0"> female
                            </label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-4 control-label">Department</label>
                        <div class="col-sm-6">
                            <select class="form-control" name="dId" id="did"></select>
                        </div>
                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" onclick="saveEmp()">保存</button>
            </div>
        </div>
    </div>
</div>
</body>


</html>
