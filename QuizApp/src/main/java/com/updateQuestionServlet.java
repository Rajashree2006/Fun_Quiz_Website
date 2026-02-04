package com;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection; 
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/updateQuestionServlet")
public class updateQuestionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public updateQuestionServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        PrintWriter out = response.getWriter();

        int id = Integer.parseInt(request.getParameter("id"));
        String subject = request.getParameter("subject");
        String question = request.getParameter("question");
        String optionA = request.getParameter("optionA");
        String optionB = request.getParameter("optionB");
        String optionC = request.getParameter("optionC");
        String optionD = request.getParameter("optionD");
        String correctAnswer = request.getParameter("correctAnswer");

        String tableName = "";
        switch (subject) {
            case "Movies & TV":
                tableName = "movies_quiz";
                break;
            case "History & Geography":
                tableName = "history_quiz";
                break;
            case "Science & Tech":
                tableName = "science_quiz";
                break;
            case "Sports":
                tableName = "sports_quiz";
                break;
            case "Celebrity and Gossip":
                tableName = "celebrity_quiz";
                break;
            case "Personality":
                tableName = "personality_quiz";
                break;
            default:
                out.println("Invalid subject.");
                return;
        }

        String jdbcURL = "jdbc:mysql://localhost:3306/mydb1";
        String dbUser = "root";
        String dbPassword = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword); 

            String sql = "UPDATE " + tableName + " SET question=?, optionA=?, optionB=?, optionC=?, optionD=?, correctAnswer=? WHERE id=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, question);
            stmt.setString(2, optionA);
            stmt.setString(3, optionB);
            stmt.setString(4, optionC);
            stmt.setString(5, optionD);
            stmt.setString(6, correctAnswer);
            stmt.setInt(7, id);

            int rn = stmt.executeUpdate();
            if (rn > 0) {
                System.out.println("Question updated successfully.");
                response.sendRedirect("/QuizApp/admin/viewAllQuestions.jsp");
            } else {
                out.println("Failed to update question.");
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("Error: " + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
