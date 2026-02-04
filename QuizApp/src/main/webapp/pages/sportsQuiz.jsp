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
    
    // Changed from 10 to 20 questions
    final int TOTAL_QUESTIONS = 20;
    int currentQuestion = 1;
    if (session.getAttribute("currentQuestion") != null) {
        currentQuestion = (Integer) session.getAttribute("currentQuestion");
    }
    session.setAttribute("currentQuestion", currentQuestion);
    
    if (currentQuestion > TOTAL_QUESTIONS) {
        response.sendRedirect("result.jsp");
        return;
    }
    
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mydb1", "root", "");
    
    // Get a list of all question IDs to ensure we get distinct questions
    List<Integer> allQuestionIds = new ArrayList<>();
    PreparedStatement getAllIdsStmt = conn.prepareStatement("SELECT id FROM sports_quiz");
    ResultSet idsRs = getAllIdsStmt.executeQuery();
    while (idsRs.next()) {
        allQuestionIds.add(idsRs.getInt("id"));
    }
    idsRs.close();
    getAllIdsStmt.close();
    
    // Shuffle the IDs to get random questions without duplicates
    Collections.shuffle(allQuestionIds);
    
    // Get the current question ID based on the shuffled list
    int currentQuestionId = allQuestionIds.get((currentQuestion - 1) % allQuestionIds.size());
    
    // Get the specific question
    PreparedStatement stmt = conn.prepareStatement("SELECT * FROM sports_quiz WHERE id = ?");
    stmt.setInt(1, currentQuestionId);
    ResultSet rs = stmt.executeQuery();
    
    String question = "", optionA = "", optionB = "", optionC = "", optionD = "";
    String genreA = "", genreB = "", genreC = "", genreD = "";
    
    // Generate mythology-themed poster URL
    String posterURL = "";
    int questionId = 0;
    
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
        
        // Generate mythology-themed poster URL based on question number
        String[] mythologyThemes = {
            "greek-gods", "norse-mythology", "egyptian-gods", "roman-gods",
            "hindu-gods", "celtic-mythology", "aztec-gods", "chinese-mythology",
            "japanese-mythology", "native-american", "african-mythology", "slavic-gods",
            "mesopotamian-gods", "mayan-gods", "inca-gods", "polynesian-mythology",
            "persian-gods", "baltic-mythology", "finnish-mythology", "tibetan-gods"
        };
        
        String theme = mythologyThemes[(currentQuestion - 1) % mythologyThemes.length];
        posterURL = "https://picsum.photos/seed/" + theme + "-" + questionId + "/200/300.jpg";
    }
    conn.close();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Mythology Quiz</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&family=Montserrat:wght@700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* All existing CSS remains the same */
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 50%, #7db9e8 100%);
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
                linear-gradient(rgba(255, 255, 255, 0.05) 1px, transparent 1px),
                linear-gradient(90deg, rgba(255, 255, 255, 0.05) 1px, transparent 1px);
            background-size: 50px 50px;
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
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200" viewBox="0 0 200 200"><circle cx="100" cy="100" r="40" fill="none" stroke="%23ffffff" stroke-width="1" stroke-opacity="0.1"/><circle cx="100" cy="100" r="60" fill="none" stroke="%23ffffff" stroke-width="1" stroke-opacity="0.1"/><circle cx="100" cy="100" r="80" fill="none" stroke="%23ffffff" stroke-width="1" stroke-opacity="0.1"/></svg>');
            background-repeat: repeat;
            background-size: 200px 200px;
            opacity: 0.1;
            pointer-events: none;
            z-index: -1;
        }
        
        .navbar {
            background-color: #8e44ad;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: white;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }
        .navbar h1 {
            margin: 0;
            color: #ffffff;
            font-size: 32px;
            font-family: 'Montserrat', sans-serif;
            letter-spacing: 1px;
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
            padding: 10px 22px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            color: #8e44ad;
            transition: all 0.3s ease;
            font-family: 'Poppins', sans-serif;
        }
        .logout-btn:hover {
            background-color: #f8e6ff;
            transform: translateY(-2px);
        }
        .quiz-container {
            max-width: 600px;
            margin: 40px auto;
            background-color: rgba(255, 255, 255, 0.15);
            border-radius: 20px;
            padding: 40px;
            text-align: center;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(5px);
            border: 2px solid rgba(255, 255, 255, 0.2);
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
            background: radial-gradient(circle, rgba(142, 68, 173, 0.1) 0%, transparent 70%);
            z-index: -1;
            animation: pulse 10s infinite linear;
        }
        @keyframes pulse {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        .poster {
            width: 240px;
            height: 340px;
            object-fit: cover;
            border-radius: 12px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.4);
            border: 3px solid rgba(255, 255, 255, 0.3);
            transition: all 0.3s ease;
        }
        .poster:hover {
            transform: scale(1.03);
        }
        .question-card {
            background-color: rgba(0, 0, 0, 0.2);
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 35px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        .question-card h2 {
            font-size: 26px;
            margin-bottom: 0;
            color: #ffffff;
            font-weight: 600;
            line-height: 1.4;
        }
        .question-number {
            font-size: 22px;
            font-weight: 600;
            margin-bottom: 25px;
            color: #ffffff;
            font-family: 'Montserrat', sans-serif;
            letter-spacing: 1px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .question-number i {
            margin-right: 10px;
            color: #f1c40f;
        }
        .options-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-top: 25px;
        }
        .option-label {
            padding: 18px;
            background: linear-gradient(45deg, #9b59b6, #8e44ad);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: 'Poppins', sans-serif;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            text-align: center;
        }
        .option-label:hover {
            background: linear-gradient(45deg, #8e44ad, #7d3c98);
            transform: translateY(-3px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.3);
        }
        input[type="radio"] {
            display: none;
        }
        input[type="radio"]:checked + .option-label {
            background: linear-gradient(45deg, #7d3c98, #6c3483);
            box-shadow: 0 0 15px rgba(155, 89, 182, 0.5);
        }
        .submit-btn {
            margin-top: 35px;
            width: 100%;
            padding: 16px;
            font-size: 20px;
            background: linear-gradient(45deg, #3498db, #2980b9);
            border: none;
            border-radius: 12px;
            font-weight: 600;
            color: white;
            cursor: pointer;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s ease;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
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
            background: linear-gradient(45deg, #2980b9, #1c6ea4);
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.3);
        }
        .submit-btn:hover::before {
            left: 100%;
        }
        .progress-bar {
            width: 100%;
            height: 14px;
            background-color: rgba(255, 255, 255, 0.2);
            border-radius: 10px;
            margin-bottom: 25px;
            overflow: hidden;
            box-shadow: inset 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        /* Updated progress calculation for 20 questions */
        .progress {
            height: 100%;
            width: <%= (currentQuestion * 100) / TOTAL_QUESTIONS %>%;
            background: linear-gradient(to right, #9b59b6, #8e44ad, #3498db);
            transition: width 0.5s ease-in-out;
            border-radius: 10px;
        }
        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }
        .poster-animate {
            animation: bounce 3s infinite ease-in-out;
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
    <h1><i class="fas fa-landmark"></i> Mythology Quiz</h1>
    <button class="logout-btn" onclick="confirmQuit()">Quit Quiz</button>
</div>
<div class="quiz-container">
    <div class="progress-bar"><div class="progress"></div></div>
    <div class="question-number">
        <i class="fas fa-scroll"></i> Question <%= currentQuestion %> of <%= TOTAL_QUESTIONS %>
    </div>
    <img src="<%= posterURL %>" class="poster poster-animate" alt="Mythology Art">
    <div class="question-card">
        <h2><%= question %></h2>
    </div>
    <!-- Fixed: Use context path for form action -->
    <form action="/QuizApp//sportsServlet" method="post">
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