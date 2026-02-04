package com;

import java.io.IOException;
import java.net.URLEncoder;
import java.sql.*;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/celebrityServlet")
public class celebrityServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String DB_URL = "jdbc:mysql://localhost:3306/mydb1";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";
    private static final int TOTAL_QUESTIONS = 20;   // ✅ 20 questions

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
            // Get parameters from request
            String selectedGenre = request.getParameter("answer");
            Integer questionId = getIntegerParameter(request, "questionId");
            Integer currentQuestion = getIntegerParameter(request, "currentQuestion");
            String submitType = request.getParameter("submitType");

            if (selectedGenre == null || questionId == null || currentQuestion == null) {
                throw new ServletException("Missing required parameters");
            }

            // Store answers in session
            @SuppressWarnings("unchecked")
            Map<Integer, String> userAnswers = (Map<Integer, String>) session.getAttribute("userAnswers");
            if (userAnswers == null) {
                userAnswers = new HashMap<>();
                session.setAttribute("userAnswers", userAnswers);
            }
            userAnswers.put(questionId, selectedGenre);

            // Track genre scores
            @SuppressWarnings("unchecked")
            Map<String, Integer> genreScores = (Map<String, Integer>) session.getAttribute("genreScores");
            if (genreScores == null) {
                genreScores = new HashMap<>();
                session.setAttribute("genreScores", genreScores);
            }
            genreScores.put(selectedGenre, genreScores.getOrDefault(selectedGenre, 0) + 1);

            // Move to next question
            int nextQuestion = currentQuestion + 1;
            session.setAttribute("currentQuestion", nextQuestion);

            // ✅ If quiz finished (20 questions or "finish" button)
            if ("finish".equals(submitType) || nextQuestion > TOTAL_QUESTIONS) {
                storeResultsInDatabase(session, genreScores);
                session.removeAttribute("currentQuestion");
                session.removeAttribute("userAnswers");
                session.removeAttribute("genreScores");
                response.sendRedirect("/QuizApp/pages/result.jsp");
            } else {
                response.sendRedirect("/QuizApp/pages/celebQuiz.jsp?question=" + nextQuestion);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("/QuizApp/pages/error.jsp?msg=" + URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }

    private Integer getIntegerParameter(HttpServletRequest request, String name) {
        try {
            return Integer.parseInt(request.getParameter(name));
        } catch (Exception e) {
            return null;
        }
    }

    // ✅ Store 20-question quiz results in DB
    private void storeResultsInDatabase(HttpSession session, Map<String, Integer> genreScores) {
        String username = (String) session.getAttribute("username");

        int genreA = genreScores.getOrDefault("Fine", 0);
        int genreB = genreScores.getOrDefault("Medium", 0);
        int genreC = genreScores.getOrDefault("Coarse", 0);
        int genreD = genreScores.getOrDefault("Very Coarse", 0);

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            // Check if user already has results
            try (PreparedStatement checkStmt = conn.prepareStatement("SELECT username FROM quiz_results WHERE username = ?")) {
                checkStmt.setString(1, username);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) {
                        // Update existing record
                        try (PreparedStatement updateStmt = conn.prepareStatement(
                                "UPDATE quiz_results SET quiztype = ?, genreA = ?, genreB = ?, genreC = ?, genreD = ?, total_questions = ? WHERE username = ?")) {
                            updateStmt.setString(1, "celeb");
                            updateStmt.setInt(2, genreA);
                            updateStmt.setInt(3, genreB);
                            updateStmt.setInt(4, genreC);
                            updateStmt.setInt(5, genreD);
                            updateStmt.setInt(6, TOTAL_QUESTIONS); // ✅ Save 20 total questions
                            updateStmt.setString(7, username);
                            updateStmt.executeUpdate();
                        }
                    } else {
                        // Insert new record
                        try (PreparedStatement insertStmt = conn.prepareStatement(
                                "INSERT INTO quiz_results (username, quiztype, genreA, genreB, genreC, genreD, total_questions) VALUES (?, ?, ?, ?, ?, ?, ?)")) {
                            insertStmt.setString(1, username);
                            insertStmt.setString(2, "celeb");
                            insertStmt.setInt(3, genreA);
                            insertStmt.setInt(4, genreB);
                            insertStmt.setInt(5, genreC);
                            insertStmt.setInt(6, genreD);
                            insertStmt.setInt(7, TOTAL_QUESTIONS);
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
