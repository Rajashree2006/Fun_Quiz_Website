<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login to Quiz Master</title>
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

        .login-container {
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
        input[type="password"] {
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

        .forgot-password {
            text-align: right;
            margin-top: 10px;
            margin-bottom: 15px;
        }

        .forgot-password a {
            font-size: 16px;
            color: #388e3c;
            text-decoration: none;
        }

        .forgot-password a:hover {
            text-decoration: underline;
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

    <div class="login-container">
        <h2>🔐 Login to Quiz Master</h2>
        <form action="/QuizApp/LoginServlet" method="post" onsubmit="return validateForm()">
            <input type="text" id="username" name="username" placeholder="Username or Email" required>
            <input type="password" id="password" name="password" placeholder="Password" required>

            <div class="checkbox-container">
                <input type="checkbox" id="showPassword">
                <label for="showPassword">Show Password</label>
            </div>

            <div class="forgot-password">
                <a href="forget.jsp">Forgot Password?</a>
            </div>

            <button type="submit">Login</button>
        </form>

        <div class="footer-link">
            Don’t have an account? <a href="register.jsp">Register here</a>
        </div>
    </div>

    <script>
        // Show/Hide Password
        document.getElementById("showPassword").addEventListener("change", function () {
            const passwordField = document.getElementById("password");
            if (this.checked) {
                passwordField.type = "text";
            } else {
                passwordField.type = "password";
            }
        });

        // Basic Validation
        function validateForm() {
            const username = document.getElementById("username").value.trim();
            const password = document.getElementById("password").value.trim();

            if (username === "" || password === "") {
                alert("Please fill out both fields before logging in.");
                return false; // Prevent form submission
            }
            return true;
        }
    </script>

</body>
</html>
