<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>  
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    final int TOTAL_QUESTIONS = 20;
    int currentQuestion = 1;
    if (session.getAttribute("currentQuestion") != null) {
        currentQuestion = Integer.parseInt(session.getAttribute("currentQuestion").toString());
    }
    if (currentQuestion > TOTAL_QUESTIONS) {
        response.sendRedirect("mresults.jsp");
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
    String posterURL = "https://picsum.photos/seed/cinema" + currentQuestion + "/200/300.jpg";
    int progressPercent = (currentQuestion * 100) / TOTAL_QUESTIONS;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Natural Element Type Quiz</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #ff9a9e 0%, #fad0c4 25%, #fad0c4 50%, #a18cd1 75%, #fbc2eb 100%);
            margin: 0; padding: 0;
            color: #2c3e50;
        }
        .navbar {
            background-color: #2c3e50;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: white;
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
        .quiz-container {
            max-width: 600px;
            margin: 40px auto;
            background-color: rgba(255, 255, 255, 0.85);
            border-radius: 20px;
            padding: 35px;
            text-align: center;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.25);
        }
        .poster {
            width: 220px;
            height: 320px;
            object-fit: cover;
            border-radius: 12px;
            margin-bottom: 25px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
            border: 3px solid white;
        }
        .question-card h2 {
            font-size: 22px;
            margin-bottom: 25px;
        }
        .options-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
            margin-top: 20px;
        }
        .option-label {
            padding: 15px;
            background: linear-gradient(45deg, #ff9a9e, #fad0c4);
            color: white;
            border-radius: 12px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        .option-label:hover {
            transform: translateY(-3px);
            background: linear-gradient(45deg, #fad0c4, #ff9a9e);
        }
        input[type="radio"] {
            display: none;
        }
        input[type="radio"]:checked + .option-label {
            background: linear-gradient(45deg, #a18cd1, #fbc2eb);
            color: white;
        }
        .progress-bar {
            width: 100%;
            height: 12px;
            background-color: rgba(255, 255, 255, 0.5);
            border-radius: 10px;
            margin-bottom: 20px;
            overflow: hidden;
            box-shadow: inset 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .progress {
            height: 100%;
            width: <%= progressPercent %>%;
            background: linear-gradient(to right, #ff9a9e, #fad0c4, #a18cd1, #fbc2eb);
            transition: width 0.5s ease-in-out;
            border-radius: 10px;
        }
        .question-number {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 20px;
        }
        .submit-btn {
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
        }
        .submit-btn:hover {
            transform: scale(1.05);
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
    <h1>Natural Element Type Quiz</h1>
    <button class="logout-btn" onclick="confirmQuit()">Quit</button>
</div>
<div class="quiz-container">
    <div class="progress-bar"><div class="progress"></div></div>
    <div class="question-number">Question <%= currentQuestion %> of <%= TOTAL_QUESTIONS %></div>
    <img src="<%= posterURL %>" class="poster" alt="Poster">
    <div class="question-card">
        <h2><%= question %></h2>
    </div>
   <form action="/QuizApp/moviesServlet" method="post" id="quizForm">
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
    <%-- If this is the last question, button says Finish --%>
    <%
        String btnLabel = currentQuestion == TOTAL_QUESTIONS ? "Finish Quiz" : "Next Question";
    %>
    <button type="submit" id="submitBtn" name="submitType" value="<%= currentQuestion == TOTAL_QUESTIONS ? "finish" : "next" %>" 
            class="submit-btn" disabled><%= btnLabel %></button>
</form>
</div>
</body>
</html>