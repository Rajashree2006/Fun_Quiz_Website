<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quiz Master - Login Error</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #14532d, #064e3b);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .form-container {
            background: #ffffff;
            padding: 60px 50px;
            border-radius: 20px;
            box-shadow: 0 12px 28px rgba(0, 0, 0, 0.2);
            max-width: 550px;
            width: 90%;
        }

        .form-container h2 {
            margin-bottom: 25px;
            color: #064e3b;
            font-size: 32px;
            text-align: center;
        }

        .form-container form input[type="text"],
        .form-container form input[type="password"] {
            width: 100%;
            padding: 18px;
            margin: 15px 0;
            font-size: 18px;
            border: 1px solid #ccc;
            border-radius: 10px;
            outline: none;
            box-sizing: border-box;
        }

        .form-container form input[type="submit"] {
            width: 100%;
            padding: 18px;
            background-color: #064e3b;
            border: none;
            color: white;
            font-size: 20px;
            font-weight: bold;
            border-radius: 10px;
            cursor: pointer;
            transition: 0.3s ease;
        }

        .form-container form input[type="submit"]:hover {
            background-color: #022c22;
        }

        .form-container .links {
            margin-top: 20px;
            text-align: center;
            font-size: 1.1rem;
        }

        .form-container .links a {
            color: #064e3b;
            font-weight: bold;
            text-decoration: none;
        }

        .form-container .links a:hover {
            text-decoration: underline;
        }

        .error-message {
            color: red;
            font-weight: bold;
            text-align: center;
            margin-bottom: 20px;
            font-size: 1.1rem;
        }

        @media screen and (max-width: 600px) {
            .form-container {
                padding: 40px 25px;
            }

            .form-container h2 {
                font-size: 26px;
            }

            .form-container form input[type="submit"],
            .form-container form input[type="text"],
            .form-container form input[type="password"] {
                font-size: 16px;
                padding: 14px;
            }
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>🔐 Login to Quiz Master</h2>

        <div class="error-message">❌ Invalid username or password!</div>

        <form action="/QuizApp/LoginServlet" method="post">
            <input type="text" name="username" placeholder="Username or Email" required>
            <input type="password" name="password" placeholder="Password" required>
            <input type="submit" value="Login">
        </form>

        <div class="links">
            Don't have an account? <a href="register.jsp">Register</a><br>
            Forgot your password? <a href="forget.jsp">Reset Here</a>
        </div>
    </div>
</body>
</html>
