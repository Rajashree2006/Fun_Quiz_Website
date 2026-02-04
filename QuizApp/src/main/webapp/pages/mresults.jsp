<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    // Check if user is logged in
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String username = (String) session.getAttribute("username");
    int active = 0, social = 0, mindful = 0, avoidant = 0;
    int total = 0;
    boolean dataFound = false;
    
    // Get the latest quiz result for this user and quiz type 'movies'
    try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mydb1?useSSL=false&serverTimezone=UTC", "root", "");
         PreparedStatement stmt = conn.prepareStatement(
             "SELECT genreA, genreB, genreC, genreD, total_questions FROM quiz_results " +
             "WHERE username = ? AND quiztype = 'movies' ORDER BY attempt_date DESC LIMIT 1")) {
        
        stmt.setString(1, username);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                active = rs.getInt("genreA");
                social = rs.getInt("genreB");
                mindful = rs.getInt("genreC");
                avoidant = rs.getInt("genreD");
                total = rs.getInt("total_questions");
                dataFound = true;
            }
        }
    } catch (Exception e) {
        // Handle database error
        out.println("<div style='color:red; text-align:center; margin-top:50px;'>Database error: " + e.getMessage() + "</div>");
        return;
    }
    
    // If no data found, redirect to quiz page
    if (!dataFound) {
        response.sendRedirect("moviesQuiz.jsp");
        return;
    }
    
    // Calculate percentages
    double percentActive = (total > 0) ? (active * 100.0) / total : 0;
    double percentSocial = (total > 0) ? (social * 100.0) / total : 0;
    double percentMindful = (total > 0) ? (mindful * 100.0) / total : 0;
    double percentAvoidant = (total > 0) ? (avoidant * 100.0) / total : 0;
    
    // Round to nearest integer for display
    int displayActive = (int) Math.round(percentActive);
    int displaySocial = (int) Math.round(percentSocial);
    int displayMindful = (int) Math.round(percentMindful);
    int displayAvoidant = (int) Math.round(percentAvoidant);
    
    // Determine element type(s)
    Map<String, Double> elements = new LinkedHashMap<>();
    elements.put("Active", percentActive);
    elements.put("Social", percentSocial);
    elements.put("Mindful", percentMindful);
    elements.put("Avoidant", percentAvoidant);
    
    // Find the element with the highest percentage
    String topElement = "";
    double maxPercent = 0;
    for (Map.Entry<String, Double> entry : elements.entrySet()) {
        if (entry.getValue() > maxPercent) {
            maxPercent = entry.getValue();
            topElement = entry.getKey();
        }
    }
    
    // Check if any other element has more than 40%
    List<String> resultElements = new ArrayList<>();
    resultElements.add(topElement);
    
    for (Map.Entry<String, Double> entry : elements.entrySet()) {
        if (!entry.getKey().equals(topElement) && entry.getValue() > 40.0) {
            resultElements.add(entry.getKey());
        }
    }
    
    // Build the result string
    StringBuilder elementTypeBuilder = new StringBuilder();
    if (resultElements.size() == 1) {
        elementTypeBuilder.append(resultElements.get(0));
    } else {
        // Sort by percentage descending
        resultElements.sort((e1, e2) -> Double.compare(elements.get(e2), elements.get(e1)));
        for (int i = 0; i < resultElements.size(); i++) {
            if (i > 0) elementTypeBuilder.append(" and ");
            elementTypeBuilder.append(resultElements.get(i));
        }
    }
    
    String elementType = elementTypeBuilder.toString();
    
    // Generate fun result based on element type
    String funResult = "";
    if (elementType.contains("Active")) {
        funResult = "You're a dynamic force of nature! Like fire, you're passionate, energetic, and always ready for action.";
    } else if (elementType.contains("Social")) {
        funResult = "You're a natural connector! Like water, you flow easily between social situations and bring people together.";
    } else if (elementType.contains("Mindful")) {
        funResult = "You have a grounded presence! Like earth, you're stable, thoughtful, and deeply connected to your surroundings.";
    } else if (elementType.contains("Avoidant")) {
        funResult = "You value your independence! Like air, you're free-spirited, adaptable, and prefer to go with the flow.";
    } else {
        funResult = "You have a unique elemental balance! Embrace your distinctive blend of natural energies.";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Natural Element Type Result 🌿</title>
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
        .no-data-message {
            background-color: #fff3cd;
            border: 1px solid #ffeeba;
            color: #856404;
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
            text-align: center;
        }
    </style>
    <script>
        function confirmQuit() {
            if (confirm("Are you sure you want to quit?")) {
                window.location.href = "second.jsp";
            }
        }
    </script>
</head>
<body>
<div class="navbar">
    <h1>Natural Element Type Quiz</h1>
    <button class="logout-btn" onclick="confirmQuit()">Quit</button>
</div>
<div class="result-container">
    <div class="result-icon">🌿</div>
    <h1>Your Natural Element Type</h1>
    <h2><%= elementType %></h2>
    <p><%= funResult %></p>
    
    <div class="element-display">
        <div class="element-item">
            <div class="element-icon">🔥</div>
            <div>Active</div>
            <div class="element-bar">
                <div class="element-fill" style="width: <%= displayActive %>%; background-color: #ff9a9e;"></div>
            </div>
            <div><%= displayActive %>%</div>
        </div>
        <div class="element-item">
            <div class="element-icon">💧</div>
            <div>Social</div>
            <div class="element-bar">
                <div class="element-fill" style="width: <%= displaySocial %>%; background-color: #fad0c4;"></div>
            </div>
            <div><%= displaySocial %>%</div>
        </div>
        <div class="element-item">
            <div class="element-icon">🌱</div>
            <div>Mindful</div>
            <div class="element-bar">
                <div class="element-fill" style="width: <%= displayMindful %>%; background-color: #a18cd1;"></div>
            </div>
            <div><%= displayMindful %>%</div>
        </div>
        <div class="element-item">
            <div class="element-icon">💨</div>
            <div>Avoidant</div>
            <div class="element-bar">
                <div class="element-fill" style="width: <%= displayAvoidant %>%; background-color: #fbc2eb;"></div>
            </div>
            <div><%= displayAvoidant %>%</div>
        </div>
    </div>
    
    <div class="fun-facts">
        💡 Fun Fact: Ancient cultures believed that understanding your natural element could help you live in harmony with the world around you!<br>
        🌍 The four elements (fire, water, earth, air) are found in many cultural traditions as a way to understand personality types.
    </div>
    
    <button class="home-btn" onclick="window.location.href='second.jsp'">🏠 Go to Home</button>
</div>
</body>
</html>