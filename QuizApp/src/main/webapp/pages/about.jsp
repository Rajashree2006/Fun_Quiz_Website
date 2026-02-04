<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>About | Quiz Master</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #e0f2f1, #a7f3d0, #bbf7d0, #6ee7b7);
            color: #064e3b;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
            padding: 40px 20px;
        }

        .about-container {
            max-width: 900px;
            background: linear-gradient(135deg, #d1fae5, #c7f7eb);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.15);
            backdrop-filter: blur(4px);
            text-align: left;
            animation: fadeIn 1s ease;
        }

        .about-container h1 {
            font-size: 36px;
            color: #065f46;
            margin-bottom: 20px;
            text-align: center;
        }

        .about-container p {
            font-size: 18px;
            line-height: 1.7;
            color:black;
            margin-bottom: 20px;
        }

        .about-container ul {
            padding-left: 20px;
        }

        .about-container li {
            margin-bottom: 10px;
            font-size: 17px;
            line-height: 1.6;
        }

        .highlight {
            color: #059669;
            font-weight: bold;
        }

        .btn-home {
            margin-top: 30px;
            display: inline-block;
            padding: 12px 24px;
            font-size: 22px;
            background-color: #10b981;
            color: white;
            border-radius: 8px;
            text-decoration: none;
            transition: 0.3s ease;
            text-align: center;
        }

        .btn-home:hover {
            background-color: #059669;
            transform: scale(1.05);
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <div class="about-container">
        <h1>About Quiz Master 🎯</h1>
        <p><span class="highlight">Quiz Master</span> is a full-featured, interactive web platform where learning meets fun! Whether you're a trivia enthusiast or a student brushing up your knowledge, Quiz Master gives you a smart and gamified way to test yourself.</p>

        <p><strong>🌟 Key Features:</strong></p>
        <ul>
            <li>✅ <strong>Guest Mode:</strong> Instantly play without signing up.</li>
            <li>🧑‍💻 <strong>User Accounts:</strong> Sign up to track scores and attempt more quizzes.</li>
            <li>🧠 <strong>Diverse Categories:</strong> Choose from Movies, History, Science, Sports & more.</li>
            <li>📊 <strong>Live Feedback:</strong> Get score previews before final results.</li>
            <li>🔐 <strong>Password Recovery:</strong> Reset via email or phone verification.</li>
            <li>📱 <strong>Mobile Friendly:</strong> Responsive layout for all screen sizes.</li>
            <li>📈 <strong>Progress Saving:</strong> Logged-in users can track past performance.</li>
        </ul>

        <a href="index.jsp" class="btn-home">Back to Home</a>
    </div>
</body>
</html>
