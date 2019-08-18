<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
<head>
    <title>Title</title>
    <base href="<%=basePath%>">
    <link href="<%=basePath%>static/bootstrap-3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <script type="text/javascript" src="<%=basePath%>static/js/jquery-3.4.1.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>static/bootstrap-3.3.7/js/bootstrap.min.js"></script>
</head>
<script type="text/javascript">
    /*页面加载完成后发送ajax请求获取数据*/
    $(function () {
        to_page(1);
    });
    
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
            <button class="btn btn-primary">新增</button>
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
                <tbody>

                </tbody>
            </table>
        </div>
    </div>
    <%--分页--%>
    <div class="row">
        <div class="col-md-6" id="page_info_area">

        </div>
        <div class="col-md-6" id="page_nav_area">

        </div>

    </div>
</div>

</body>


</html>
