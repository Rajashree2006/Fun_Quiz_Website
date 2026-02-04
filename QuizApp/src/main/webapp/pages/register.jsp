<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register - Quiz Master</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: "Arial", sans-serif;
            background: linear-gradient(135deg, #c8e6c9, #81c784);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            position: relative;
        }

        .home-link {
            position: absolute;
            top: 20px;
            right: 30px;
            font-size: 16px;
            background: #2e7d32;
            color: white;
            padding: 10px 16px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: bold;
        }

        .home-link:hover {
            background: #1b5e20;
        }

        .register-container {
            background: #ffffff;
            padding: 60px 40px;
            border-radius: 25px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.25);
            width: 95%;
            max-width: 550px;
            text-align: center;
        }

        h2 {
            margin-bottom: 30px;
            color: #2e7d32;
            font-size: 34px;
        }

        input[type="text"],
        input[type="password"],
        input[type="email"] {
            width: 100%;
            padding: 16px;
            margin: 15px 0;
            border: 1px solid #ccc;
            border-radius: 12px;
            font-size: 18px;
        }

        .checkbox-container {
            display: flex;
            align-items: center;
            justify-content: flex-start;
            font-size: 16px;
            margin-top: 10px;
        }

        .checkbox-container input[type="checkbox"] {
            margin-right: 8px;
        }

        button {
            background-color: #388e3c;
            color: white;
            padding: 16px 24px;
            border: none;
            border-radius: 12px;
            font-size: 18px;
            margin-top: 25px;
            cursor: pointer;
            width: 100%;
        }

        button:hover {
            background-color: #2e7d32;
        }

        .footer-link {
            margin-top: 20px;
            font-size: 16px;
        }

        .footer-link a {
            color: #388e3c;
            text-decoration: none;
        }

        .footer-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <a href="index.jsp" class="home-link">🏠 Home</a>

    <div class="register-container">
        <h2>📝 Register for Quiz Master</h2>
        <form action="/QuizApp/RegisterServlet" method="post">
            <input type="text" name="username" placeholder="Username" required>
            <input type="email" name="email" placeholder="Email" required>
            <input type="password" id="password" name="password" placeholder="Password" required>
            <input type="password" id="confirm" name="confirm" placeholder="Confirm Password" required>

            <div class="checkbox-container">
                <input type="checkbox" id="showPassword">
                <label for="showPassword">Show Password</label>
            </div>

            <button type="submit">Register</button>
        </form>

        <div class="footer-link">
            Already have an account? <a href="login.jsp">Login here</a>
        </div>
    </div>
</body>
</html>
