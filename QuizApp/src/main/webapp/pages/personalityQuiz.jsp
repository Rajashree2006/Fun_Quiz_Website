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
    final int TOTAL_QUESTIONS = 20; // Changed from 10 to 20
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
         PreparedStatement stmt = conn.prepareStatement("SELECT * FROM personality_quiz ORDER BY id LIMIT 1 OFFSET ?")) {
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
    String posterURL = "https://picsum.photos/seed/personality" + currentQuestion + "/200/300.jpg";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Personality Quiz</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #d2f8d2, #8bd7a3);
            margin: 0;
            padding: 0;
            color: #1b5e20;
            overflow-x: hidden;
        }
        body::before {
            content: "";
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-image: radial-gradient(circle, rgba(255,255,255,0.2) 1px, transparent 1px);
            background-size: 20px 20px;
            opacity: 0.3;
            pointer-events: none;
            z-index: -1;
        }
        .navbar {
            background-color: #388e3c;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }
        .navbar h1 {
            margin: 0;
            color: #ffffff;
            font-size: 26px;
            display: flex;
            align-items: center;
        }
        .navbar h1 i {
            margin-right: 10px;
        }
        .logout-btn {
            background: #ffffff;
            border: none;
            border-radius: 20px;
            padding: 8px 18px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            color: #2e7d32;
            transition: all 0.3s ease;
        }
        .logout-btn:hover {
            background-color: #c8e6c9;
            transform: translateY(-2px);
        }
        .quiz-container {
            max-width: 600px;
            margin: 40px auto;
            background-color: rgba(255, 255, 255, 0.85);
            border-radius: 20px;
            padding: 35px;
            text-align: center;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
            backdrop-filter: blur(10px);
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
            background: radial-gradient(circle, rgba(46, 125, 50, 0.1) 0%, transparent 70%);
            z-index: -1;
            animation: pulse 10s infinite linear;
        }
        @keyframes pulse {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        .poster {
            width: 220px;
            height: 320px;
            object-fit: cover;
            border-radius: 12px;
            margin-bottom: 25px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
            border: 3px solid rgba(255, 255, 255, 0.7);
            transition: all 0.5s ease;
        }
        .poster:hover {
            transform: scale(1.03);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.25);
        }
        .question-card {
            background-color: rgba(255, 255, 255, 0.6);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            border: 1px solid rgba(46, 125, 50, 0.2);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        }
        .question-card h2 {
            font-size: 22px;
            margin-bottom: 0;
            color: #1b5e20;
            line-height: 1.4;
        }
        .question-number {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 20px;
            color: #2e7d32;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .question-number i {
            margin-right: 8px;
        }
        .options-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
            margin-top: 20px;
        }
        .option-label {
            background: #43a047;
            color: white;
            padding: 15px;
            border-radius: 12px;
            font-size: 16px;
            font-weight: bold;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .option-label::before {
            content: "";
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s ease;
        }
        .option-label:hover {
            background: #66bb6a;
            transform: translateY(-3px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
        }
        .option-label:hover::before {
            left: 100%;
        }
        input[type="radio"] {
            display: none;
        }
        input[type="radio"]:checked + .option-label {
            background-color: #2e7d32;
            box-shadow: 0 0 10px rgba(46, 125, 50, 0.5);
        }
        .submit-btn {
            margin-top: 30px;
            width: 100%;
            padding: 14px;
            font-size: 17px;
            background: linear-gradient(45deg, #2e7d32, #43a047);
            border: none;
            border-radius: 12px;
            font-weight: 600;
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .submit-btn::before {
            content: "";
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s ease;
        }
        .submit-btn:hover {
            background: linear-gradient(45deg, #43a047, #2e7d32);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
        }
        .submit-btn:hover::before {
            left: 100%;
        }
        .progress-bar {
            width: 100%;
            height: 12px;
            background-color: #a5d6a7;
            border-radius: 10px;
            margin-bottom: 20px;
            overflow: hidden;
            box-shadow: inset 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .progress {
            height: 100%;
            width: <%= currentQuestion * 5 %>%; /* Updated for 20 questions (100/20=5% per question) */
            background: linear-gradient(to right, #2e7d32, #81c784);
            transition: width 0.5s ease-in-out;
            border-radius: 10px;
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
    <h1><i class="fas fa-brain"></i> Personality Quiz</h1>
    <button class="logout-btn" onclick="confirmQuit()">Quit</button>
</div>
<div class="quiz-container">
    <div class="progress-bar"><div class="progress"></div></div>
    <div class="question-number">
        <i class="fas fa-question-circle"></i> Question <%= currentQuestion %> of <%= TOTAL_QUESTIONS %>
    </div>
    <img src="<%= posterURL %>" class="poster" alt="Personality Poster">
    <div class="question-card">
        <h2><%= question %></h2>
    </div>
    <form action="/QuizApp/personalityServlet" method="post">
        <input type="hidden" name="questionId" value="<%= questionId %>">
        <input type="hidden" name="currentQuestion" value="<%= currentQuestion %>">
        <div class="options-grid">
            <label>
                <input type="radio" name="answer" value="<%= genreA %>" onclick="enableSubmit()">
                <div class="option-label">A. <%= optionA %></div>
            </label>
            <label>
                <input type="radio" name="answer" value="<%= genreB %>" onclick="enableSubmit()">
                <div class="option-label">B. <%= optionB %></div>
            </label>
            <label>
                <input type="radio" name="answer" value="<%= genreC %>" onclick="enableSubmit()">
                <div class="option-label">C. <%= optionC %></div>
            </label>
            <label>
                <input type="radio" name="answer" value="<%= genreD %>" onclick="enableSubmit()">
                <div class="option-label">D. <%= optionD %></div>
            </label>
        </div>
        <%
            String btnLabel = currentQuestion == TOTAL_QUESTIONS ? "Finish Quiz" : "Next Question";
            String submitValue = currentQuestion == TOTAL_QUESTIONS ? "finish" : "next";
        %>
        <button type="submit" id="submitBtn" name="submitType" value="<%= submitValue %>" class="submit-btn" disabled>
            <%= btnLabel %>
        </button>
    </form>
</div>
</body>
</html>