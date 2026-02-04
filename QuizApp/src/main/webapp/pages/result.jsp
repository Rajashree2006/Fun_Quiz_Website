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
    int fine = 0, medium = 0, coarse = 0, veryCoarse = 0;
    int total = 0;
    
    // Get the latest quiz result for this user and quiz type 'celeb'
    try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mydb1?useSSL=false&serverTimezone=UTC", "root", "");
         PreparedStatement stmt = conn.prepareStatement(
             "SELECT genreA, genreB, genreC, genreD, total_questions FROM quiz_results " +
             "WHERE username = ? AND quiztype = 'celeb' ORDER BY attempt_date DESC LIMIT 1")) {
        
        stmt.setString(1, username);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                fine = rs.getInt("genreA");
                medium = rs.getInt("genreB");
                coarse = rs.getInt("genreC");
                veryCoarse = rs.getInt("genreD");
                total = rs.getInt("total_questions");
            }
        }
    } catch (Exception e) {
        // Handle database error
        request.setAttribute("errorMessage", "Database error: " + e.getMessage());
        request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        return;
    }
    
    // Calculate percentages
    double percentFine = (total > 0) ? (fine * 100.0) / total : 0;
    double percentMedium = (total > 0) ? (medium * 100.0) / total : 0;
    double percentCoarse = (total > 0) ? (coarse * 100.0) / total : 0;
    double percentVeryCoarse = (total > 0) ? (veryCoarse * 100.0) / total : 0;
    
    // Round to nearest integer for display
    int displayFine = (int) Math.round(percentFine);
    int displayMedium = (int) Math.round(percentMedium);
    int displayCoarse = (int) Math.round(percentCoarse);
    int displayVeryCoarse = (int) Math.round(percentVeryCoarse);
    
    // Determine hair type(s)
    Map<String, Double> genres = new LinkedHashMap<>();
    genres.put("Fine", percentFine);
    genres.put("Medium", percentMedium);
    genres.put("Coarse", percentCoarse);
    genres.put("Very Coarse", percentVeryCoarse);
    
    // Find the genre with the highest percentage
    String topGenre = "";
    double maxPercent = 0;
    for (Map.Entry<String, Double> entry : genres.entrySet()) {
        if (entry.getValue() > maxPercent) {
            maxPercent = entry.getValue();
            topGenre = entry.getKey();
        }
    }
    
    // Check if any other genre has more than 40%
    List<String> resultGenres = new ArrayList<>();
    resultGenres.add(topGenre);
    
    for (Map.Entry<String, Double> entry : genres.entrySet()) {
        if (!entry.getKey().equals(topGenre) && entry.getValue() > 40.0) {
            resultGenres.add(entry.getKey());
        }
    }
    
    // Build the result string
    StringBuilder hairTypeBuilder = new StringBuilder();
    if (resultGenres.size() == 1) {
        hairTypeBuilder.append(resultGenres.get(0));
    } else {
        // Sort by percentage descending
        resultGenres.sort((g1, g2) -> Double.compare(genres.get(g2), genres.get(g1)));
        for (int i = 0; i < resultGenres.size(); i++) {
            if (i > 0) hairTypeBuilder.append(" and ");
            hairTypeBuilder.append(resultGenres.get(i));
        }
    }
    
    String hairType = hairTypeBuilder.toString();
    
    // Generate fun result based on hair type
    String funResult = "";
    if (hairType.contains("Fine")) {
        funResult = "Your hair is delicate and silky! Treat it with gentle care and sulfate-free products.";
    } else if (hairType.contains("Medium")) {
        funResult = "Your hair is versatile and easy to style! It holds styles well and responds to various treatments.";
    } else if (hairType.contains("Coarse")) {
        funResult = "Your hair is strong and resilient! It can handle more heat and styling products.";
    } else if (hairType.contains("Very Coarse")) {
        funResult = "Your hair is very strong and can handle bold styles! It benefits from rich moisturizing treatments.";
    } else {
        funResult = "You have a unique hair type! Experiment to find what works best for you.";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Quiz Result 🎉</title>
    <style>
        body {
            font-family: 'Segoe UI Emoji', 'Noto Color Emoji', Arial, sans-serif;
            background: linear-gradient(135deg, #ffdde1, #ee9ca7, #a1c4fd, #c2e9fb);
            background-size: 300% 300%;
            animation: gradientBG 10s ease infinite;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        @keyframes gradientBG {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        .result-card {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 20px;
            padding: 30px;
            width: 480px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            text-align: center;
            backdrop-filter: blur(10px);
            animation: fadeIn 1.5s ease;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        h1 {
            color: #ff4081;
            font-size: 30px;
            margin-bottom: 15px;
            text-shadow: 2px 2px #ffe0f0;
        }
        h2 {
            color: #4CAF50;
            margin: 12px 0;
            font-size: 22px;
        }
        p {
            color: #333;
            font-size: 16px;
            margin-bottom: 15px;
        }
        .fun-facts {
            margin-top: 15px;
            font-size: 15px;
            color: #444;
            background: linear-gradient(135deg, #fceabb, #f8b500);
            padding: 12px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            animation: bounceIn 1s ease;
        }
        @keyframes bounceIn {
            0% { transform: scale(0.8); opacity: 0; }
            50% { transform: scale(1.05); opacity: 1; }
            100% { transform: scale(1); }
        }
        .home-btn {
            background: linear-gradient(135deg, #42e695, #3bb2b8);
            color: white;
            border: none;
            border-radius: 15px;
            padding: 12px 24px;
            font-size: 16px;
            cursor: pointer;
            transition: 0.3s;
            margin-top: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            font-family: inherit;
            font-weight: bold;
        }
        .home-btn:hover {
            background: linear-gradient(135deg, #3bb2b8, #42e695);
            transform: scale(1.05);
        }
        .percentage-display {
            display: flex;
            justify-content: space-between;
            margin: 15px 0;
            font-size: 14px;
        }
        .percentage-item {
            text-align: center;
            flex: 1;
        }
        .percentage-bar {
            height: 8px;
            background: #e0e0e0;
            border-radius: 4px;
            margin-top: 5px;
            overflow: hidden;
        }
        .percentage-fill {
            height: 100%;
            border-radius: 4px;
        }
        .result-icon {
            font-size: 40px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="result-card">
        <h1>🎉 Your Hair Type Result 🎉</h1>
        <div class="result-icon">💇‍♀️💇‍♂️</div>
        <h2><%= hairType %></h2>
        <p><%= funResult %> 🌟</p>
        
        <div class="percentage-display">
            <div class="percentage-item">
                <div>Fine</div>
                <div class="percentage-bar">
                    <div class="percentage-fill" style="width: <%= displayFine %>%; background-color: #ff9a9e;"></div>
                </div>
                <div><%= displayFine %>%</div>
            </div>
            <div class="percentage-item">
                <div>Medium</div>
                <div class="percentage-bar">
                    <div class="percentage-fill" style="width: <%= displayMedium %>%; background-color: #fad0c4;"></div>
                </div>
                <div><%= displayMedium %>%</div>
            </div>
            <div class="percentage-item">
                <div>Coarse</div>
                <div class="percentage-bar">
                    <div class="percentage-fill" style="width: <%= displayCoarse %>%; background-color: #a18cd1;"></div>
                </div>
                <div><%= displayCoarse %>%</div>
            </div>
            <div class="percentage-item">
                <div>Very Coarse</div>
                <div class="percentage-bar">
                    <div class="percentage-fill" style="width: <%= displayVeryCoarse %>%; background-color: #fbc2eb;"></div>
                </div>
                <div><%= displayVeryCoarse %>%</div>
            </div>
        </div>
        
        <div class="fun-facts">
            💡 Fun Fact: Hair is made of keratin, the same protein as nails! ✨<br>
            🌍 Red hair is the rarest, only about 2% of the world's population has it! 🔥
        </div>
        
        <!-- Home button -->
        <form action="second.jsp">
            <button type="submit" class="home-btn">🏠 Go to Home</button>
        </form>
    </div>
</body>
</html>