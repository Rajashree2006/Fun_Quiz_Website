<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String username = (String) session.getAttribute("username");
    if (username == null || username.trim().equals("")) {
        response.sendRedirect("admin_login.jsp");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Home</title>
</head>
<body style="display: flex; justify-content: center; align-items: center; height: 100vh; font-size: 20px; font-family: Arial, sans-serif;">

    <div style="text-align: center;">
        <h2 style="font-size: 30px;">Welcome, <%= username %></h2>

        <ul style="list-style-type: none; padding: 0;">
            <li><a href="addQuiz.jsp" style="font-size: 25px;">Add Quiz</a></li>
            <li><a href="viewUsers.jsp" style="font-size: 25px;">View Users</a></li>
            <li><a href="viewAllQuestions.jsp" style="font-size: 25px;">View All Question</a></li>
            <li><a href="changeAdminPassword.jsp" style="font-size: 25px;">Change Password</a></li>
            <li><a href="LogoutAdmin.jsp" style="font-size: 25px;">Logout</a></li>
        </ul>
    </div>

</body>
</html>
