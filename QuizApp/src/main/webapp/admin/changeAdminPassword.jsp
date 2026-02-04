<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String username = (String) session.getAttribute("username");
    if (username == null || username.trim().equals("")) {
        response.sendRedirect("admin_login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Change Admin Password</title>
</head>
<body style="display: flex; justify-content: center; align-items: center; height: 100vh; font-size: 20px; font-family: Arial, sans-serif;">

    <div style="text-align: center;">
        <h2>Change Password for <%= username %></h2>

        <form action="/QuizApp/changeAdminPasswordServlet" method="post">
            <label for="oldPassword">Old Password:</label><br>
            <input type="password" name="oldPassword" required><br><br>

            <label for="newPassword">New Password:</label><br>
            <input type="password" name="newPassword" required><br><br>

            <label for="confirmPassword">Confirm Password:</label><br>
            <input type="password" name="confirmPassword" required><br><br>

            <input type="submit" value="Change Password">
        </form>
    </div>

</body>
</html>
