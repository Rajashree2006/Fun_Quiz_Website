<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Forgot Password - Quiz Master</title>
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
        }

        .forget-container {
            background: #ffffff;
            padding: 50px 40px;
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

        input[type="email"],
        input[type="text"] {
            width: 100%;
            padding: 16px;
            margin: 15px 0;
            border: 1px solid #ccc;
            border-radius: 12px;
            font-size: 18px;
        }

        button, input[type="submit"] {
            background-color: #388e3c;
            color: white;
            padding: 16px 24px;
            border: none;
            border-radius: 12px;
            font-size: 18px;
            margin-top: 20px;
            cursor: pointer;
            width: 100%;
        }

        button:hover, input[type="submit"]:hover {
            background-color: #2e7d32;
        }

        label {
            font-size: 18px;
            color: #333;
            display: block;
            text-align: left;
            margin-bottom: 10px;
        }

        .links {
            margin-top: 25px;
            font-size: 16px;
        }

        .links a {
            color: #2e7d32;
            text-decoration: none;
            font-weight: bold;
            margin: 0 10px;
        }

        .links a:hover {
            text-decoration: underline;
        }

        @media (max-width: 600px) {
            .forget-container {
                padding: 30px 20px;
            }

            h2 {
                font-size: 26px;
            }

            input, button {
                font-size: 16px;
            }
        }
    </style>
</head>
<body>
    <div class="forget-container">
        <h2>🔒 Forgot Password?</h2>
        <form action="LoginServlet" method="post">
            <label for="contactinfo">📧 Email or 📞 Phone Number:</label>
            <input type="email" name="contactinfo" id="contactinfo" placeholder="Enter your email or phone number" required>

            <input type="submit" value="Let's Go! 🚀">
        </form>

        <div class="links">
            🙋‍♂️ Don’t have an account? <a href="register.jsp">Register</a><br>
            🏠 <a href="index.jsp">Back to Home</a>
        </div>
    </div>
</body>
</html>
