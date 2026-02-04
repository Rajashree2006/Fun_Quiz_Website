<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Login</title>
</head>
<body style="display: flex; justify-content: center; align-items: center; height: 100vh; font-size: 20px; font-family: Arial, sans-serif;">

    <div>
        <h2 style="text-align: center;">Admin Login</h2>

        <form action="/QuizApp/adminLoginServlet" method="post" style="text-align: center;">
            <label for="username">User Name:</label><br>
            <input type="text" name="username" id="username" placeholder="User Name" required style="font-size: 18px; padding: 8px;"><br><br>

            <label for="password">Password:</label><br>
            <input type="password" name="password" id="password" placeholder="password" required style="font-size: 18px; padding: 8px;"><br><br>

            <input type="submit" value="Login" style="font-size: 18px; padding: 10px 20px;">
        </form>
    </div>

</body>
</html>
