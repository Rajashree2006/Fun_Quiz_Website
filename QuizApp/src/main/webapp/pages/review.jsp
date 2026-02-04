<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Reviews | Quiz Master</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            color: #065f46;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
            padding: 40px 20px;
        }

        .review-container {
            max-width: 900px;
            background: #f0fdf4;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 12px 20px rgba(0, 0, 0, 0.2);
        }

        .review-container h1 {
            text-align: center;
            font-size: 36px;
            margin-bottom: 30px;
            color: #047857;
        }

        .review {
            background-color: #ecfdf5;
            border-left: 6px solid #10b981;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
        }

        .review h3 {
            margin: 0;
            font-size: 20px;
            color: #065f46;
        }

        .review p {
            margin-top: 8px;
            font-size: 16px;
            color: #064e3b;
        }

        .btn-home {
            margin-top: 20px;
            display: inline-block;
            padding: 10px 20px;
            font-size: 25px;
            background-color: #10b981;
            color: white;
            border-radius: 8px;
            text-decoration: none;
            transition: 0.3s ease;
        }

        .btn-home:hover {
            background-color: #059669;
            transform: scale(1.05);
        }
    </style>
</head>
<body>
    <div class="review-container">
        <h1>🌟 What Users Say About Quiz Master</h1>

       

        <a href="index.jsp" class="btn-home"> Back to Home</a>
    </div>
</body>
</html>
