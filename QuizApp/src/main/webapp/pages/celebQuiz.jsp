<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Initialize session attributes if not exists
    if (session.getAttribute("currentQuestion") == null) {
        session.setAttribute("currentQuestion", 1);
    }
    if (session.getAttribute("userAnswers") == null) {
        session.setAttribute("userAnswers", new HashMap<Integer, String>());
    }
    if (session.getAttribute("genreScores") == null) {
        session.setAttribute("genreScores", new HashMap<String, Integer>());
    }

    final int TOTAL_QUESTIONS = 20;
    int currentQuestion = 1;
    if (session.getAttribute("currentQuestion") != null) {
        currentQuestion = Integer.parseInt(session.getAttribute("currentQuestion").toString());
    }
    if (currentQuestion > TOTAL_QUESTIONS) {
        response.sendRedirect("result.jsp");
        return;
    }
    String question = "", optionA = "", optionB = "", optionC = "", optionD = "";
    String genreA = "", genreB = "", genreC = "", genreD = "";
    int questionId = 0;
    try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mydb1", "root", "");
         PreparedStatement stmt = conn.prepareStatement("SELECT * FROM celebrity_quiz ORDER BY id LIMIT 1 OFFSET ?")) {
        stmt.setInt(1, currentQuestion - 1);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                questionId = rs.getInt("id");
                question = rs.getString("question");
                optionA = rs.getString("optionA");
                optionB = rs.getString("optionB");
                optionC = rs.getString("optionC");
                optionD = rs.getString("optionD");
                genreA = rs.getString("genreA");
                genreB = rs.getString("genreB");
                genreC = rs.getString("genreC");
                genreD = rs.getString("genreD");
            } else {
                response.sendRedirect("result.jsp");
                return;
            }
        }
    } catch (Exception e) {
        out.println("Database error: " + e.getMessage());
        return;
    }
    String posterURL = "https://picsum.photos/seed/celebrity" + currentQuestion + "/200/300.jpg";
    int progressPercent = (currentQuestion * 100) / TOTAL_QUESTIONS;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hair Strand Type</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Montserrat:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* CSS remains unchanged */
        body {
            font-family: 'Montserrat', sans-serif;
            background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
            margin: 0;
            padding: 0;
            color: #ffffff;
            overflow-x: hidden;
        }
        body::before {
            content: "";
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-image:
                radial-gradient(white, rgba(255,255,255,.2) 2px, transparent 2px);
            background-size: 50px 50px;
            opacity: 0.1;
            pointer-events: none;
            z-index: -1;
        }
        body::after {
            content: "";
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200" viewBox="0 0 200 200"><path d="M20,100 Q60,60 100,100 T180,100" fill="none" stroke="%23ffffff" stroke-width="0.5" stroke-opacity="0.1"/><path d="M20,150 Q60,110 100,150 T180,150" fill="none" stroke="%23ffffff" stroke-width="0.5" stroke-opacity="0.1"/><path d="M20,50 Q60,10 100,50 T180,50" fill="none" stroke="%23ffffff" stroke-width="0.5" stroke-opacity="0.1"/></svg>');
            background-repeat: repeat;
            background-size: 200px 200px;
            opacity: 0.1;
            pointer-events: none;
            z-index: -1;
        }
        .navbar {
            background-color: rgba(0, 0, 0, 0.7);
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: white;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
            border-bottom: 3px solid #ff0099;
        }
        .navbar h1 {
            margin: 0;
            color: #ffffff;
            font-size: 32px;
            font-family: 'Playfair Display', serif;
            letter-spacing: 2px;
            text-transform: uppercase;
            display: flex;
            align-items: center;
        }
        .navbar h1 i {
            margin-right: 15px;
            color: #ff0099;
            font-size: 28px;
        }
        .logout-btn {
            background: linear-gradient(45deg, #ff0099, #ff6b6b);
            border: none;
            border-radius: 30px;
            padding: 10px 24px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            color: #ffffff;
            transition: all 0.3s ease;
            font-family: 'Montserrat', sans-serif;
            letter-spacing: 1px;
            text-transform: uppercase;
            box-shadow: 0 4px 15px rgba(255, 0, 153, 0.3);
        }
        .logout-btn:hover {
            background: linear-gradient(45deg, #ff6b6b, #ff0099);
            transform: translateY(-3px);
            box-shadow: 0 7px 20px rgba(255, 0, 153, 0.4);
        }
        .quiz-container {
            max-width: 650px;
            margin: 40px auto;
            background-color: rgba(0, 0, 0, 0.6);
            border-radius: 20px;
            padding: 40px;
            text-align: center;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(10px);
            border: 2px solid rgba(255, 0, 153, 0.3);
            position: relative;
            overflow: hidden;
        }
        .quiz-container::before {
            content: "";
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255, 0, 153, 0.1) 0%, transparent 70%);
            z-index: -1;
            animation: pulse 8s infinite linear;
        }
        @keyframes pulse {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        .poster {
            width: 240px;
            height: 340px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.6);
            border: 3px solid rgba(255, 255, 255, 0.3);
            transition: all 0.5s ease;
            position: relative;
            overflow: hidden;
        }
        .poster::after {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(to bottom, transparent 70%, rgba(0, 0, 0, 0.7));
            border-radius: 10px;
        }
        .poster:hover {
            transform: scale(1.03) rotate(1deg);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.7);
            border-color: rgba(255, 0, 153, 0.5);
        }
        .question-card {
            background-color: rgba(0, 0, 0, 0.4);
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 35px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            position: relative;
            overflow: hidden;
        }
        .question-card::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 5px;
            height: 100%;
            background: linear-gradient(to bottom, #ff0099, #ff6b6b);
        }
        .question-card h2 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #ffffff;
            font-weight: 500;
            line-height: 1.4;
            font-family: 'Playfair Display', serif;
        }
        .options-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-top: 25px;
        }
        .option-btn {
            padding: 18px;
            background: rgba(255, 255, 255, 0.1);
            color: #ffffff;
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            font-size: 18px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: 'Montserrat', sans-serif;
            position: relative;
            overflow: hidden;
            text-align: left;
        }
        .option-btn::before {
            content: "";
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 0, 153, 0.2), transparent);
            transition: left 0.5s ease;
        }
        .option-btn:hover {
            background-color: rgba(255, 255, 255, 0.2);
            transform: translateY(-3px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.3);
            border-color: rgba(255, 0, 153, 0.5);
        }
        .option-btn:hover::before {
            left: 100%;
        }
        .submit-btn {
            margin-top: 35px;
            width: 100%;
            padding: 16px;
            font-size: 20px;
            background: linear-gradient(45deg, #ff0099, #ff6b6b);
            border: none;
            border-radius: 8px;
            font-weight: 700;
            color: #ffffff;
            cursor: pointer;
            font-family: 'Montserrat', sans-serif;
            transition: all 0.3s ease;
            letter-spacing: 1px;
            text-transform: uppercase;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(255, 0, 153, 0.3);
        }
        .submit-btn::before {
            content: "";
            position: absolute;
            top: 0; left: -100%;
            width: 100%; height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transition: left 0.5s ease;
        }
        .submit-btn:hover {
            background: linear-gradient(45deg, #ff6b6b, #ff0099);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(255, 0, 153, 0.4);
        }
        .submit-btn:hover::before {
            left: 100%;
        }
        .progress-bar {
            width: 100%;
            height: 14px;
            background-color: rgba(0, 0, 0, 0.3);
            border-radius: 7px;
            margin-bottom: 25px;
            overflow: hidden;
            box-shadow: inset 0 2px 5px rgba(0, 0, 0, 0.2);
        }
        .progress {
            height: 100%;
            width: <%= progressPercent %>%;
            background: linear-gradient(to right, #ff0099, #ff6b6b, #ffcc00);
            transition: width 0.5s ease-in-out;
            border-radius: 7px;
            position: relative;
        }
        .progress::after {
            content: "";
            position: absolute; top: 0; left: 0; right: 0; bottom: 0;
            background: linear-gradient(90deg, rgba(255,255,255,0) 0%, rgba(255,255,255,0.3) 50%, rgba(255,255,255,0) 100%);
            animation: shimmer 2s infinite;
        }
        @keyframes shimmer {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(100%); }
        }
        .question-number {
            font-size: 22px;
            font-weight: 600;
            margin-bottom: 25px;
            color: #ffffff;
            font-family: 'Playfair Display', serif;
            letter-spacing: 1px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .question-number i {
            margin-right: 10px;
            color: #ff0099;
        }
        .celebrity-pattern {
            position: relative;
        }
        .glow {
            position: absolute;
            width: 150px;
            height: 150px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(255, 0, 153, 0.2) 0%, transparent 70%);
            pointer-events: none;
            z-index: -1;
            animation: float 8s infinite ease-in-out;
        }
        @keyframes float {
            0%, 100% { transform: translateY(0) translateX(0); }
            25% { transform: translateY(-20px) translateX(10px); }
            50% { transform: translateY(0) translateX(20px); }
            75% { transform: translateY(20px) translateX(10px); }
        }
        .hidden-inputs {
            display: none;
        }
        /* Hide radio and apply label styling */
        input[type="radio"] {
            display: none;
        }
        input[type="radio"]:checked + .option-btn {
            background: linear-gradient(45deg, #ff0099, #ff6b6b);
            border-color: rgba(255, 255, 255, 0.5);
            box-shadow: 0 0 12px rgba(255, 0, 153, 0.4);
        }
    </style>
    <script>
        function confirmQuit() {
            if (confirm("Are you sure you want to quit the quiz?")) {
                window.location.href = "second.jsp";
            }
        }
        function enableSubmit() {
            document.getElementById('submitBtn').disabled = false;
        }
    </script>
</head>
<body>
<div class="navbar">
    <h1><i class="fas fa-star"></i> Hair Strand Type Quiz</h1>
    <button class="logout-btn" onclick="confirmQuit()">Quit Quiz</button>
</div>
<div class="quiz-container celebrity-pattern">
    <div class="glow" style="top: 50px; left: 100px;"></div>
    <div class="glow" style="bottom: 70px; right: 120px;"></div>
    <div class="progress-bar"><div class="progress"></div></div>
    <div class="question-number"><i class="fas fa-camera"></i> Question <%= currentQuestion %> of <%= TOTAL_QUESTIONS %></div>
    <img src="<%= posterURL %>" class="poster" alt="Celebrity Poster">
    <div class="question-card"><h2><%= question %></h2></div>
    <form action="/QuizApp/celebrityServlet" method="post">
        <input type="hidden" name="questionId" value="<%= questionId %>">
        <input type="hidden" name="currentQuestion" value="<%= currentQuestion %>">
        <div class="options-grid">
            <label>
                <input type="radio" name="answer" value="<%= genreA %>" onclick="enableSubmit()">
                <div class="option-btn">A. <%= optionA %></div>
            </label>
            <label>
                <input type="radio" name="answer" value="<%= genreB %>" onclick="enableSubmit()">
                <div class="option-btn">B. <%= optionB %></div>
            </label>
            <label>
                <input type="radio" name="answer" value="<%= genreC %>" onclick="enableSubmit()">
                <div class="option-btn">C. <%= optionC %></div>
            </label>
            <label>
                <input type="radio" name="answer" value="<%= genreD %>" onclick="enableSubmit()">
                <div class="option-btn">D. <%= optionD %></div>
            </label>
        </div>
        <%
            String btnLabel = currentQuestion == TOTAL_QUESTIONS ? "Finish Quiz" : "Next Question";
            // Fixed: Changed "Generate Result" to "finish" to match servlet logic
            String submitTypeVal = currentQuestion == TOTAL_QUESTIONS ? "finish" : "next";
        %>
        <button type="submit" id="submitBtn" name="submitType" value="<%= submitTypeVal %>" class="submit-btn" disabled>
            <%= btnLabel %>
        </button>
    </form>
</div>
</body>
</html>