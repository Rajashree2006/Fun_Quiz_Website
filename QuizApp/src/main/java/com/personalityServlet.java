package com;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/personalityServlet")
public class personalityServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String DB_URL = "jdbc:mysql://localhost:3306/mydb1";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";
    private static final int TOTAL_QUESTIONS = 20; // Changed from 10 to 20
    
    public personalityServlet() {
        super();
    }
    
    @Override
    public void init() throws ServletException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ServletException("MySQL Driver not found", e);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("/QuizApp/pages/login.jsp");
            return;
        }
        
        try {
            String selectedGenre = request.getParameter("answer");
            Integer questionId = getIntegerParameter(request, "questionId");
            Integer currentQuestion = getIntegerParameter(request, "currentQuestion");
            String submitType = request.getParameter("submitType");
            
            if (selectedGenre == null || questionId == null || currentQuestion == null) {
                throw new ServletException("Missing required parameters");
            }
            
            @SuppressWarnings("unchecked")
            Map<Integer, String> userAnswers = (Map<Integer, String>) session.getAttribute("userAnswers");
            if (userAnswers == null) {
                userAnswers = new HashMap<>();
                session.setAttribute("userAnswers", userAnswers);
            }
            userAnswers.put(questionId, selectedGenre);
            
            @SuppressWarnings("unchecked")
            Map<String, Integer> genreScores = (Map<String, Integer>) session.getAttribute("genreScores");
            if (genreScores == null) {
                genreScores = new HashMap<>();
                session.setAttribute("genreScores", genreScores);
            }
            
            // Initialize the genre if not present
            if (!genreScores.containsKey(selectedGenre)) {
                genreScores.put(selectedGenre, 0);
            }
            genreScores.put(selectedGenre, genreScores.get(selectedGenre) + 1);
            
            int nextQuestion = currentQuestion + 1;
            session.setAttribute("currentQuestion", nextQuestion);
            
            if ("finish".equals(submitType) || nextQuestion > TOTAL_QUESTIONS) {
                storeResultsInDatabase(session, genreScores);
                session.removeAttribute("currentQuestion");
                session.removeAttribute("userAnswers");
                session.removeAttribute("genreScores");
                response.sendRedirect("/QuizApp/pages/psresult.jsp");
            } else {
                response.sendRedirect("/QuizApp/pages/personalityQuiz.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?msg=" + URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }
    
    private Integer getIntegerParameter(HttpServletRequest request, String name) {
        try {
            return Integer.parseInt(request.getParameter(name));
        } catch (Exception e) {
            return null;
        }
    }
    
    private void storeResultsInDatabase(HttpSession session, Map<String, Integer> genreScores) {
        String username = (String) session.getAttribute("username");
        
        // Get all possible genres from the personality_quiz table
        Map<String, Integer> dbGenres = new HashMap<>();
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            // Get distinct genres from the personality_quiz table
            try (PreparedStatement genreStmt = conn.prepareStatement(
                    "SELECT DISTINCT genreA, genreB, genreC, genreD FROM personality_quiz")) {
                try (ResultSet genreRs = genreStmt.executeQuery()) {
                    while (genreRs.next()) {
                        String genreA = genreRs.getString("genreA");
                        String genreB = genreRs.getString("genreB");
                        String genreC = genreRs.getString("genreC");
                        String genreD = genreRs.getString("genreD");
                        
                        if (genreA != null && !genreA.isEmpty()) dbGenres.put(genreA, 0);
                        if (genreB != null && !genreB.isEmpty()) dbGenres.put(genreB, 0);
                        if (genreC != null && !genreC.isEmpty()) dbGenres.put(genreC, 0);
                        if (genreD != null && !genreD.isEmpty()) dbGenres.put(genreD, 0);
                    }
                }
            }
            
            // Now get the actual counts from the genreScores map
            int genreA = 0, genreB = 0, genreC = 0, genreD = 0;
            int index = 0;
            
            for (Map.Entry<String, Integer> entry : genreScores.entrySet()) {
                int count = entry.getValue();
                switch (index) {
                    case 0: genreA = count; break;
                    case 1: genreB = count; break;
                    case 2: genreC = count; break;
                    case 3: genreD = count; break;
                }
                index++;
            }
            
            // Store in database
            try (PreparedStatement checkStmt = conn.prepareStatement("SELECT username FROM quiz_results WHERE username = ?")) {
                checkStmt.setString(1, username);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) {
                        try (PreparedStatement updateStmt = conn.prepareStatement(
                                "UPDATE quiz_results SET quiztype = ?, genreA = ?, genreB = ?, genreC = ?, genreD = ?, total_questions = ? WHERE username = ?")) {
                            updateStmt.setString(1, "personality");
                            updateStmt.setInt(2, genreA);
                            updateStmt.setInt(3, genreB);
                            updateStmt.setInt(4, genreC);
                            updateStmt.setInt(5, genreD);
                            updateStmt.setInt(6, TOTAL_QUESTIONS); // Now 20
                            updateStmt.setString(7, username);
                            updateStmt.executeUpdate();
                        }
                    } else {
                        try (PreparedStatement insertStmt = conn.prepareStatement(
                                "INSERT INTO quiz_results (username, quiztype, genreA, genreB, genreC, genreD, total_questions) VALUES (?, ?, ?, ?, ?, ?, ?)")) {
                            insertStmt.setString(1, username);
                            insertStmt.setString(2, "personality");
                            insertStmt.setInt(3, genreA);
                            insertStmt.setInt(4, genreB);
                            insertStmt.setInt(5, genreC);
                            insertStmt.setInt(6, genreD);
                            insertStmt.setInt(7, TOTAL_QUESTIONS); // Now 20
                            insertStmt.executeUpdate();
                        }
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to store results in DB", e);
        }
    }
}