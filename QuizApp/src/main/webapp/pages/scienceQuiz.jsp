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
    
    // Get a list of all question IDs to ensure we get 20 distinct questions
    List<Integer> allQuestionIds = new ArrayList<>();
    PreparedStatement getAllIdsStmt = conn.prepareStatement("SELECT id FROM science_quiz");
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
    PreparedStatement stmt = conn.prepareStatement("SELECT * FROM science_quiz WHERE id = ?");
    stmt.setInt(1, currentQuestionId);
    ResultSet rs = stmt.executeQuery();
    
    String question = "", optionA = "", optionB = "", optionC = "", optionD = "";
    String genreA = "", genreB = "", genreC = "", genreD = "";
    
    // Generate story book-themed poster URL based on genre
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
        
        // Determine the dominant genre for this question to select appropriate book cover
        String dominantGenre = genreA; // Default to first genre
        if (genreB != null && !genreB.isEmpty()) dominantGenre = genreB;
        if (genreC != null && !genreC.isEmpty()) dominantGenre = genreC;
        if (genreD != null && !genreD.isEmpty()) dominantGenre = genreD;
        
        // Generate book cover URL based on genre
        switch(dominantGenre) {
            case "Fantasy":
                posterURL = "https://picsum.photos/seed/fantasy-book-" + questionId + "/200/300.jpg";
                break;
            case "Romance":
                posterURL = "https://picsum.photos/seed/romance-book-" + questionId + "/200/300.jpg";
                break;
            case "Dystopian":
                posterURL = "https://picsum.photos/seed/dystopian-book-" + questionId + "/200/300.jpg";
                break;
            case "Mystery":
                posterURL = "https://picsum.photos/seed/mystery-book-" + questionId + "/200/300.jpg";
                break;
            default:
                posterURL = "https://picsum.photos/seed/story-book-" + questionId + "/200/300.jpg";
        }
    }
    conn.close();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Novel Type Quiz</title>
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;500;700&family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* All existing CSS remains the same */
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #0f2027 0%, #203a43 50%, #2c5364 100%);
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
                linear-gradient(rgba(0, 255, 255, 0.03) 1px, transparent 1px),
                linear-gradient(90deg, rgba(0, 255, 255, 0.03) 1px, transparent 1px);
            background-size: 30px 30px;
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
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200" viewBox="0 0 200 200"><circle cx="100" cy="100" r="30" fill="none" stroke="%2300ffff" stroke-width="0.5" stroke-opacity="0.1"/><circle cx="100" cy="100" r="60" fill="none" stroke="%2300ffff" stroke-width="0.5" stroke-opacity="0.1"/><circle cx="100" cy="100" r="90" fill="none" stroke="%2300ffff" stroke-width="0.5" stroke-opacity="0.1"/></svg>');
            background-repeat: repeat;
            background-size: 200px 200px;
            opacity: 0.1;
            pointer-events: none;
            z-index: -1;
        }
        
        .navbar {
            background-color: rgba(0, 150, 255, 0.8);
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: white;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
            border-bottom: 2px solid rgba(0, 255, 255, 0.3);
        }
        .navbar h1 {
            margin: 0;
            color: #ffffff;
            font-size: 32px;
            font-family: 'Orbitron', sans-serif;
            letter-spacing: 2px;
            text-transform: uppercase;
            display: flex;
            align-items: center;
        }
        .navbar h1 i {
            margin-right: 15px;
            color: #00ffff;
        }
        .logout-btn {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 20px;
            padding: 10px 22px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            color: #ffffff;
            transition: all 0.3s ease;
            font-family: 'Orbitron', sans-serif;
            letter-spacing: 1px;
            text-transform: uppercase;
        }
        .logout-btn:hover {
            background-color: rgba(255, 255, 255, 0.2);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
        .quiz-container {
            max-width: 650px;
            margin: 40px auto;
            background-color: rgba(0, 30, 60, 0.7);
            border-radius: 15px;
            padding: 40px;
            text-align: center;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(0, 255, 255, 0.2);
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
            background: radial-gradient(circle, rgba(0, 255, 255, 0.1) 0%, transparent 70%);
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
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.5);
            border: 3px solid rgba(0, 255, 255, 0.3);
            transition: all 0.5s ease;
            position: relative;
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
        }
        .question-card {
            background-color: rgba(0, 60, 120, 0.5);
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 35px;
            border: 1px solid rgba(0, 255, 255, 0.2);
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
            background: linear-gradient(to bottom, #00ffff, #0066ff);
        }
        .question-card h2 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #ffffff;
            font-weight: 500;
            line-height: 1.4;
        }
        .options-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-top: 25px;
        }
        .option-btn {
            padding: 18px;
            background: rgba(0, 60, 120, 0.7);
            color: #ffffff;
            border: 1px solid rgba(0, 255, 255, 0.3);
            border-radius: 8px;
            font-size: 18px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: 'Roboto', sans-serif;
            position: relative;
            overflow: hidden;
            text-align: left;
        }
        .option-btn::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(45deg, transparent 49%, rgba(0, 255, 255, 0.2) 50%, transparent 51%);
            background-size: 200% 200%;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        .option-btn:hover {
            background-color: rgba(0, 80, 160, 0.8);
            transform: translateY(-3px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.3);
            border-color: rgba(0, 255, 255, 0.5);
        }
        .option-btn:hover::before {
            opacity: 1;
            animation: shine 1.5s infinite;
        }
        @keyframes shine {
            0% { background-position: -100% -100%; }
            100% { background-position: 100% 100%; }
        }
        .submit-btn {
            margin-top: 35px;
            width: 100%;
            padding: 16px;
            font-size: 20px;
            background: linear-gradient(45deg, #0066ff, #00ccff);
            border: none;
            border-radius: 8px;
            font-weight: 700;
            color: #ffffff;
            cursor: pointer;
            font-family: 'Orbitron', sans-serif;
            transition: all 0.3s ease;
            letter-spacing: 1px;
            text-transform: uppercase;
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
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s ease;
        }
        .submit-btn:hover {
            background: linear-gradient(45deg, #0055cc, #00b3e6);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.3);
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
        /* Updated progress calculation for 20 questions */
        .progress {
            height: 100%;
            width: <%= (currentQuestion * 100) / TOTAL_QUESTIONS %>%;
            background: linear-gradient(to right, #00ffff, #0066ff, #00ccff);
            transition: width 0.5s ease-in-out;
            border-radius: 7px;
            position: relative;
        }
        .progress::after {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(90deg, 
                rgba(255, 255, 255, 0) 0%, 
                rgba(255, 255, 255, 0.3) 50%, 
                rgba(255, 255, 255, 0) 100%);
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
            font-family: 'Orbitron', sans-serif;
            letter-spacing: 1px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .question-number i {
            margin-right: 10px;
            color: #00ffff;
        }
        .science-pattern {
            position: relative;
        }
        .glow {
            position: absolute;
            width: 150px;
            height: 150px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(0, 255, 255, 0.2) 0%, transparent 70%);
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
        input[type="radio"] {
            display: none;
        }
        input[type="radio"]:checked + .option-btn {
            background: linear-gradient(45deg, #0066ff, #00ccff);
            border-color: rgba(0, 255, 255, 0.7);
            box-shadow: 0 0 15px rgba(0, 204, 255, 0.5);
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
    <h1><i class="fas fa-book-open"></i> Novel Type Quiz</h1>
    <button class="logout-btn" onclick="confirmQuit()">Quit Quiz</button>
</div>
<div class="quiz-container science-pattern">
    <div class="glow" style="top: 50px; left: 100px;"></div>
    <div class="glow" style="bottom: 70px; right: 120px;"></div>
    
    <div class="progress-bar"><div class="progress"></div></div>
    <div class="question-number">
        <i class="fas fa-bookmark"></i> Question <%= currentQuestion %> of <%= TOTAL_QUESTIONS %>
    </div>
    
    <img src="<%= posterURL %>" class="poster" alt="Story Book Cover">
    
    <div class="question-card">
        <h2><%= question %></h2>
    </div>
    
    <form action="/QuizApp/scienceServlet" method="post">
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
            String submitValue = currentQuestion == TOTAL_QUESTIONS ? "finish" : "next";
        %>
        <button type="submit" id="submitBtn" name="submitType" value="<%= submitValue %>" class="submit-btn" disabled>
            <%= btnLabel %>
        </button>
    </form>
</div>
</body>
</html>