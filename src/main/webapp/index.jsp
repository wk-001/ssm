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

    //当前页，修改完数据后使用
    var currentPages;
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
            var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-pencil"))
                .append("编辑");
            //给编辑按钮添加自定义属性，放入id值
            editBtn.attr("edit_id",item.id);
            var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm del_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-trash"))
                .append("删除");
            delBtn.attr("del_id",item.id);
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
        currentPages = data.extend.page.pageNum;
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

    //清空表单数据及class
    function reset_form(ele){
        //转成dom对象再调用方法，否则无效
        $(ele)[0].reset();
        //清空表单样式
        $(ele).find("*").removeClass("has-success has-error");
        $(ele).find(".help-block").text("");
    }

    //点击新增按钮弹出模态框
    function openAddModel() {
        reset_form("#empForm");

        //发送ajax请求查询部门信息，添加到下拉列表
        getDepts("#empForm select");

        //模态框
        $('#empAddModel').modal({
            keyboard: false,    //禁止按esc关闭模态框
            backdrop: 'static'  //点击模态框以外的区域不会关闭模态框
        });
    }

    //修改按钮绑定事件，修改按钮是动态增加的，所以用"on"。点击弹出模态框
    $(document).on("click",".edit_btn",function () {
        reset_form("#empUpdForm");
        //查询员工信息
        getEmp($(this).attr("edit_id"));
        //发送ajax请求查询部门信息，添加到下拉列表
        getDepts("#empUpdForm select");

        //把员工的ID传递给模态框的更新按钮
        $("#updBtn").attr("edit_id",$(this).attr("edit_id"));

        //模态框
        $('#empEditModel').modal({
            keyboard: false,    //禁止按esc关闭模态框
            backdrop: 'static'  //点击模态框以外的区域不会关闭模态框
        });
    });

    function getEmp(id) {
        $.get(
            "<%=basePath%>emp/"+id,
            function (data) {
                var emp = data.extend.emp;
                $("#empName_upd").text(emp.name);
                $("#email_upd").val(emp.email);
                //单选和下拉框的回显
                $("#empEditModel input[name=gender]").val([emp.gender]);
                $("#empEditModel select").val([emp.dId]);
            }
        )
    }

    //查询所有部门信息并显示在下拉列表
    function getDepts(ele) {
        $(ele).empty();
        $.get(
            "<%=basePath%>depts",
            function (data) {
                $.each(data.extend.depts,function (index, item) {
                    var sel = $("<option></option>").append(item.deptName).val(item.id);
                    sel.appendTo(ele);
                })
            }
        )
    }

    //添加员工
    function saveEmp() {
        //数据校验
        if(!(checkUser()&&checkEmail())){
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
                    //员工以ID降序排列，最新添加的在最前面，添加完成后跳转到第一页
                    to_page(1);
                    alert(data.msg);
                }else{
                    //name不为空就显示name
                    if(undefined!=data.extend.errMsg.name){
                        validate_msg("empName", "error", data.extend.errMsg.name);
                    }
                    if(undefined!=data.extend.errMsg.email){
                        validate_msg("email", "error", data.extend.errMsg.email);
                    }
                }
            }
        )
    }

    //数据校验提示
    function validate_msg(ele, status, msg) {
        var eles = "#"+ele;
        //清除之前的class
        $(eles).parent().removeClass("has-success has-error");
        $(eles).next("span").text("");
        if("success"===status){
            //输入框变红色
            $(eles).parent().addClass("has-success");
            //输入框后面的span设置值
            $(eles).next("span").text(msg);
        }else if("error"===status){
            //输入框变绿色
            $(eles).parent().addClass("has-error");
            //输入框后面的span设置值
            $(eles).next("span").text(msg);
        }
    }

    //检查用户名格式是否符合，是否重复
    function checkUser() {
        var result;
        var empName = $("#empName").val();
        var pattern = /(^[a-zA-Z0-9_-]{3,16}$)|(^[\u4e00-\u9fa5]{2,4})/;
        if(!pattern.test(empName)){
            validate_msg("empName", "error", "用户名必须是2-4位中文或3-16位英文和数字的组合");
            return false;
        }else{
            $.ajax({
                url:"<%=basePath%>checkData",
                type:"get",
                async:false,
                data:{name:empName},
                dataType:'json' ,  // 返回json格式类型
                success:function(data) {
                    if(data){
                        validate_msg("empName", "success", "可以使用的用户名");
                        result = true;
                    }else {
                        validate_msg("empName", "error","用户名已存在");
                        result = false;
                    }
                }
            });
        }
        return result;
    }

    //检查邮箱格式是否符合，是否重复
    function checkEmail() {
        var result;
        var ePattern = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
        var email = $("#email").val();
        if(!ePattern.test(email)){
            validate_msg("email", "error", "请输入正确的邮箱格式");
            return false;
        }else{
            $.ajax({
                url:"<%=basePath%>checkData",
                type:"get",
                async:false,
                data:{email:email},
                dataType:'json' ,  // 返回json格式类型
                success:function(data) {
                    if(data){
                        validate_msg("email", "success", "可以使用的邮箱");
                        result = true;
                    }else {
                        validate_msg("email", "error","邮箱已存在");
                        result = false;
                    }
                }
            });
        }
        return result;
    }

    //检查修改时的邮箱
    function checkEmailUpd() {
        var result;
        var ePattern = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
        var email = $("#email_upd").val();
        if(!ePattern.test(email)){
            validate_msg("email_upd", "error", "请输入正确的邮箱格式");
            return false;
        }else{
            $.ajax({
                url:"<%=basePath%>checkData",
                type:"get",
                async:false,
                data:{email:email},
                dataType:'json' ,  // 返回json格式类型
                success:function(data) {
                    if(data){
                        validate_msg("email_upd", "success", "可以使用的邮箱");
                        result = true;
                    }else {
                        validate_msg("email_upd", "error","邮箱已存在");
                        result = false;
                    }
                }
            });
        }
        return result;
    }

    //更新员工信息
    function updEmp(obj) {
        if(!checkEmailUpd()){
            return false;
        }
        //直接发送put请求需要在web.xml中配置HttpPutFormContentFilter过滤器
        $.ajax({
            url:"<%=basePath%>emp/"+$(obj).attr("edit_id"),
            type:"PUT",
            data:$("#empUpdForm").serialize(),
            success:function (data) {
                $('#empEditModel').modal('hide');
                //回到被修改数据的那一页
                to_page(currentPages);
                alert(data.msg);
            }
        });

        /* 发送post请求，参数带上"&_method=PUT"可以实现发送put请求
        $.post(
            "<%=basePath%>emp/"+$(obj).attr("edit_id"),
            $("#empUpdForm").serialize()+"&_method=PUT",
            function (data) {
                $('#empEditModel').modal('hide')
                to_page(1);
                alert(data.msg);
            }
        )*/
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
                            <input type="text" class="form-control" id="empName" name="name" placeholder="tom" onchange="checkUser()">
                            <span class="help-block"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-4 control-label">Email</label>
                        <div class="col-sm-6">
                            <input type="email" class="form-control" id="email" name="email" placeholder="abc@qq.com" onchange="checkEmail()">
                            <span class="help-block"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-4 control-label">Gender</label>
                        <div class="col-sm-6">
                            <label class="radio-inline">
                                <input type="radio" name="gender" value="1" checked> male
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" value="0"> female
                            </label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-4 control-label">Department</label>
                        <div class="col-sm-6">
                            <select class="form-control" name="dId" ></select>
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

<!-- 员工修改模态框 -->
<div class="modal fade" id="empEditModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel1">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel1">添加员工</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="empUpdForm">
                    <div class="form-group">
                        <label class="col-sm-4 control-label">EmpName</label>
                        <div class="col-sm-6">
                            <p class="form-control-static" id="empName_upd"></p>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-4 control-label">Email</label>
                        <div class="col-sm-6">
                            <input type="email" class="form-control" id="email_upd" name="email" placeholder="abc@qq.com" onchange="checkEmailUpd()">
                            <span class="help-block"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-4 control-label">Gender</label>
                        <div class="col-sm-6">
                            <label class="radio-inline">
                                <input type="radio" name="gender" value="1" checked> male
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" value="0"> female
                            </label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-4 control-label">Department</label>
                        <div class="col-sm-6">
                            <select class="form-control" name="dId" ></select>
                        </div>
                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updBtn" onclick="updEmp(this)">更新</button>
            </div>
        </div>
    </div>
</div>
</body>


</html>
