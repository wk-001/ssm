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
    <script type="text/html" src="<%=basePath%>static/bootstrap-3.3.7/js/jquery-3.4.1.js"></script>
    <script type="text/html" src="<%=basePath%>static/bootstrap-3.3.7/js/bootstrap.min.js"></script>
</head>
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
            <table class="table table-hover">
                <tr>
                    <th>id</th>
                    <th>name</th>
                    <th>email</th>
                    <th>gender</th>
                    <th>deptName</th>
                    <th>operate</th>
                </tr>
                <c:forEach items="${page.list}" var="list">
                    <tr>
                        <td>${list.id}</td>
                        <td>${list.name}</td>
                        <td>${list.email}</td>
                        <td>${list.gender==1?"男":"女"}</td>
                        <td>${list.department.deptName}</td>
                        <td>
                            <button class="btn btn-primary btn-sm">
                                <span class="glyphicon glyphicon-pencil" aria-hidden="true" style="padding-right: 5px;"></span>编辑
                            </button>
                            <button class="btn btn-danger btn-sm">
                                <span class="glyphicon glyphicon-trash" aria-hidden="true" style="padding-right: 5px;"></span>删除
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>
    </div>
        <%--分页--%>
    <div class="row">
        <div class="col-md-6">
            当前第${page.pageNum}页，共${page.pages}页，总${page.total}条记录
        </div>
        <div class="col-md-6">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <li><a href="<%=basePath%>emps?pn=1">首页</a></li>
                    <%--如果有上一页才能点击--%>
                    <c:if test="${page.hasPreviousPage}">
                        <li>
                            <a href="<%=basePath%>emps?pn=${page.pageNum-1}" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                    </c:if>
                    <c:forEach items="${page.navigatepageNums}" var="nums">
                        <%--当前页显示选中状态--%>
                        <c:if test="${nums==page.pageNum}">
                            <li class="active"><a href="<%=basePath%>emps?pn=${nums}">${nums}</a></li>
                        </c:if>
                        <c:if test="${nums!=page.pageNum}">
                            <li><a href="<%=basePath%>emps?pn=${nums}">${nums}</a></li>
                        </c:if>
                    </c:forEach>
                    <c:if test="${page.hasNextPage}">
                        <li>
                            <a href="<%=basePath%>emps?pn=${page.pageNum+1}" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </c:if>
                    <li><a href="<%=basePath%>emps?pn=${page.pages}">尾页</a></li>
                </ul>
            </nav>
        </div>

    </div>
</div>

</body>
</html>
