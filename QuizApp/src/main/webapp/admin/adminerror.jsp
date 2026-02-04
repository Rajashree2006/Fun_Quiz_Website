<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Error</title>
</head>
<body style="text-align: center; font-family: Arial, sans-serif; font-size: 18px; margin-top: 100px;">

<%
    String errorType = request.getParameter("type");
    if ("passwordMismatch".equals(errorType)) {
%>
    <p style="color: red;">Password mismatch</p>
    <a href="changeAdminPassword.jsp">Back to Change Password</a>
<%
    } else {
%>
    <p style="color: red;">Username or Password mismatch</p>
    <a href="admin_login.jsp">Back to Login</a>
<%
    }
%>

</body>
</html>
