<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // DB values
    int genreA = 0, genreB = 0, genreC = 0, genreD = 0, total = 1;
    String quiztype = "", elementType = "", funResult = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mydb1", "root", "");
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM quiz_results WHERE username = ? AND quiztype = ?");
        ps.setString(1, username);
        ps.setString(2, "sports");
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            genreA = rs.getInt("genreA");
            genreB = rs.getInt("genreB");
            genreC = rs.getInt("genreC");
            genreD = rs.getInt("genreD");
            total = rs.getInt("total_questions");
        }

        rs.close(); ps.close(); conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    // Calculate %
    int displayA = (int) Math.round((genreA * 100.0) / total);
    int displayB = (int) Math.round((genreB * 100.0) / total);
    int displayC = (int) Math.round((genreC * 100.0) / total);
    int displayD = (int) Math.round((genreD * 100.0) / total);

    // Decide fun result (you can customize these messages)
    if (displayA >= displayB && displayA >= displayC && displayA >= displayD) {
        elementType = "Greek Mythology Hero";
        funResult = "You belong with the gods ⚡ on Mount Olympus — full of power and destiny!";
    } else if (displayB >= displayA && displayB >= displayC && displayB >= displayD) {
        elementType = "Wizard Extraordinaire";
        funResult = "Magic 🧙 flows through your veins — Hogwarts would welcome you anytime!";
    } else if (displayC >= displayA && displayC >= displayB && displayC >= displayD) {
        elementType = "Epic Adventurer";
        funResult = "You are destined for quests 🗡️ across Middle-earth style worlds!";
    } else {
        elementType = "Creature Whisperer";
        funResult = "Unicorns 🦄 and dragons are your best friends — you thrive with magical beings!";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Novel Type Quiz Results 🏆</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #43cea2, #185a9d);
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
        .navbar h1 { margin: 0; font-size: 26px; }
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
        .logout-btn:hover { background-color: #a18cd1; color: white; }
        .result-container {
            max-width: 650px;
            margin: 40px auto;
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 20px;
            padding: 35px;
            text-align: center;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.25);
            flex-grow: 1;
        }
        .result-icon { font-size: 60px; margin-bottom: 20px; }
        h1 { font-size: 32px; margin-bottom: 15px; }
        h2 { color: #185a9d; margin: 12px 0; font-size: 24px; }
        p { font-size: 18px; margin-bottom: 25px; line-height: 1.6; }
        .element-display { display: flex; justify-content: space-between; margin: 25px 0; font-size: 16px; gap: 10px; }
        .element-item {
            text-align: center;
            flex: 1;
            padding: 15px 10px;
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.7);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .element-icon { font-size: 24px; margin-bottom: 8px; }
        .element-bar { height: 8px; background: #e0e0e0; border-radius: 4px; margin-top: 8px; overflow: hidden; }
        .element-fill { height: 100%; border-radius: 4px; }
        .fun-facts {
            margin-top: 25px;
            font-size: 16px;
            background: linear-gradient(135deg, #43cea2, #185a9d);
            color: white;
            padding: 15px;
            border-radius: 12px;
        }
        .home-btn {
            margin-top: 30px;
            padding: 15px 30px;
            background: linear-gradient(45deg, #185a9d, #43cea2);
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: bold;
            color: white;
            cursor: pointer;
            transition: 0.3s ease;
        }
        .home-btn:hover { transform: scale(1.05); background: linear-gradient(45deg, #43cea2, #185a9d); }
    </style>
</head>
<body>
<div class="navbar">
    <h1>Sports Quiz</h1>
    <button class="logout-btn" onclick="window.location.href='second.jsp'">Quit</button>
</div>

<div class="result-container">
    <div class="result-icon">🏆</div>
    <h1>Your Result</h1>
    <h2><%= elementType %></h2>
    <p><%= funResult %></p>

    <div class="element-display">
        <div class="element-item">
            <div class="element-icon">⚡</div>
            <div>Genre A</div>
            <div class="element-bar"><div class="element-fill" style="width:<%= displayA %>%; background:#ff9a9e;"></div></div>
            <div><%= displayA %>%</div>
        </div>
        <div class="element-item">
            <div class="element-icon">🤝</div>
            <div>Genre B</div>
            <div class="element-bar"><div class="element-fill" style="width:<%= displayB %>%; background:#fad0c4;"></div></div>
            <div><%= displayB %>%</div>
        </div>
        <div class="element-item">
            <div class="element-icon">🎯</div>
            <div>Genre C</div>
            <div class="element-bar"><div class="element-fill" style="width:<%= displayC %>%; background:#a18cd1;"></div></div>
            <div><%= displayC %>%</div>
        </div>
        <div class="element-item">
            <div class="element-icon">🌍</div>
            <div>Genre D</div>
            <div class="element-bar"><div class="element-fill" style="width:<%= displayD %>%; background:#fbc2eb;"></div></div>
            <div><%= displayD %>%</div>
        </div>
    </div>

    <div class="fun-facts">
        💡 Fun Fact: Every athlete has a unique style — embrace yours and play to your strengths!
    </div>

    <button class="home-btn" onclick="window.location.href='second.jsp'">🏠 Go Home</button>
</div>
</body>
</html>
