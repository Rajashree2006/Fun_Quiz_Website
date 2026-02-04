<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reset Password - Quiz Master</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #b7eeb1, #a8e063, #56ab2f);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .reset-container {
            background-color: #ffffff;
            padding: 40px 30px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            width: 90%;
            max-width: 420px;
        }

        .reset-container h2 {
            margin-bottom: 20px;
            color: #2e7d32;
            font-size: 28px;
            text-align: center;
        }

        .reset-container input[type="text"],
        .reset-container input[type="password"] {
            width: 100%;
            padding: 14px;
            margin-bottom: 16px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 16px;
            box-sizing: border-box;
        }

        .checkbox-container {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            font-size: 16px;
        }

        .checkbox-container input {
            margin-right: 8px;
        }

        .reset-container input[type="submit"] {
            width: 100%;
            background-color: #2e7d32;
            color: white;
            padding: 14px;
            border: none;
            border-radius: 8px;
            font-size: 18px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .reset-container input[type="submit"]:hover {
            background-color: #1e6332;
        }

        .footer-note {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: #555;
        }

        .footer-note a {
            color: #2e7d32;
            text-decoration: none;
        }

        .footer-note a:hover {
            text-decoration: underline;
        }

        .home-link {
            display: block;
            text-align: center;
            margin-top: 15px;
            font-size: 19px;
            color: #2e7d32;
            text-decoration: none;
        }

        .home-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="reset-container">
        <h2>🔒 Reset Your Password</h2>
        <form action="ResetPasswordServlet" method="post">
            <input type="text" name="identifier" placeholder="Username or Email" required>
            <input type="password" id="password" name="password" placeholder="New Password" required>
            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm New Password" required>

            <div class="checkbox-container">
                <input type="checkbox" onclick="togglePasswordVisibility()" id="showPass">
                <label for="showPass">Show Passwords</label>
            </div>

            <input type="submit" value="Reset Password">
        </form>

        <a class="home-link" href="index.jsp"> Back to Home</a>

        <div class="footer-note">
            Need help? Contact <a href="rajashreedeb23@gmail.com">support@quizmaster.com</a>
        </div>
    </div>
</body>
</html>
