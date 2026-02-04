<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Sample dynamic values (replace with DB values as in your servlet)
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int active = 5, social = 3, mindful = 2, avoidant = 0;
    int total = active + social + mindful + avoidant;

    int displayActive = (int) Math.round((active * 100.0) / total);
    int displaySocial = (int) Math.round((social * 100.0) / total);
    int displayMindful = (int) Math.round((mindful * 100.0) / total);
    int displayAvoidant = (int) Math.round((avoidant * 100.0) / total);

    // Example fun result text
    String elementType = "Active and Social";
    String funResult = "You're full of energy 🌟 and love being around people!";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quiz Results 🌿</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #ff9a9e 0%, #fad0c4 25%, #fad0c4 50%, #a18cd1 75%, #fbc2eb 100%);
            margin: 0; padding: 0;
            color: #2c3e50;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .navbar {
            background-color: #2c3e50;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: white;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }
        .navbar h1 {
            margin: 0;
            font-size: 26px;
        }
        .logout-btn {
            background: #fbc2eb;
            border: none;
            border-radius: 20px;
            padding: 8px 18px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            color: #2c3e50;
            transition: 0.3s;
        }
        .logout-btn:hover {
            background-color: #a18cd1;
            color: white;
        }
        .result-container {
            max-width: 600px;
            margin: 40px auto;
            background-color: rgba(255, 255, 255, 0.85);
            border-radius: 20px;
            padding: 35px;
            text-align: center;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.25);
            animation: fadeIn 1.5s ease;
            flex-grow: 1;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .result-icon {
            font-size: 60px;
            margin-bottom: 20px;
        }
        h1 {
            color: #2c3e50;
            font-size: 32px;
            margin-bottom: 15px;
        }
        h2 {
            color: #a18cd1;
            margin: 12px 0;
            font-size: 24px;
        }
        p {
            color: #2c3e50;
            font-size: 18px;
            margin-bottom: 25px;
            line-height: 1.6;
        }
        .element-display {
            display: flex;
            justify-content: space-between;
            margin: 25px 0;
            font-size: 16px;
        }
        .element-item {
            text-align: center;
            flex: 1;
            padding: 15px 10px;
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.7);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }
        .element-item:hover {
            transform: translateY(-5px);
        }
        .element-icon {
            font-size: 24px;
            margin-bottom: 8px;
        }
        .element-bar {
            height: 8px;
            background: #e0e0e0;
            border-radius: 4px;
            margin-top: 8px;
            overflow: hidden;
        }
        .element-fill {
            height: 100%;
            border-radius: 4px;
        }
        .fun-facts {
            margin-top: 25px;
            font-size: 16px;
            color: #2c3e50;
            background: linear-gradient(135deg, #ff9a9e, #fad0c4);
            padding: 15px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            animation: bounceIn 1s ease;
        }
        @keyframes bounceIn {
            0% { transform: scale(0.8); opacity: 0; }
            50% { transform: scale(1.05); opacity: 1; }
            100% { transform: scale(1); }
        }
        .home-btn {
            margin-top: 30px;
            padding: 15px 30px;
            background: linear-gradient(45deg, #a18cd1, #fbc2eb);
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: bold;
            color: white;
            cursor: pointer;
            transition: 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }
        .home-btn:hover {
            transform: scale(1.05);
            background: linear-gradient(45deg, #fbc2eb, #a18cd1);
        }
    </style>
</head>
<body>
<div class="navbar">
    <h1>Natural Element Quiz</h1>
    <button class="logout-btn" onclick="window.location.href='second.jsp'">Quit</button>
</div>

<div class="result-container">
    <div class="result-icon">🌿</div>
    <h1>Your Result</h1>
    <h2><%= elementType %></h2>
    <p><%= funResult %></p>

    <div class="element-display">
        <div class="element-item">
            <div class="element-icon">🔥</div>
            <div>Active</div>
            <div class="element-bar"><div class="element-fill" style="width: <%= displayActive %>%; background-color: #ff9a9e;"></div></div>
            <div><%= displayActive %>%</div>
        </div>
        <div class="element-item">
            <div class="element-icon">💧</div>
            <div>Social</div>
            <div class="element-bar"><div class="element-fill" style="width: <%= displaySocial %>%; background-color: #fad0c4;"></div></div>
            <div><%= displaySocial %>%</div>
        </div>
        <div class="element-item">
            <div class="element-icon">🌱</div>
            <div>Mindful</div>
            <div class="element-bar"><div class="element-fill" style="width: <%= displayMindful %>%; background-color: #a18cd1;"></div></div>
            <div><%= displayMindful %>%</div>
        </div>
        <div class="element-item">
            <div class="element-icon">💨</div>
            <div>Avoidant</div>
            <div class="element-bar"><div class="element-fill" style="width: <%= displayAvoidant %>%; background-color: #fbc2eb;"></div></div>
            <div><%= displayAvoidant %>%</div>
        </div>
    </div>

    <div class="fun-facts">
        💡 Fun Fact: Understanding your element helps you embrace your strengths and balance your lifestyle!
    </div>

    <button class="home-btn" onclick="window.location.href='second.jsp'">🏠 Go Home</button>
</div>
</body>
</html>
