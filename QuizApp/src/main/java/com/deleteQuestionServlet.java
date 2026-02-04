package com;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/deleteQuestionServlet")
public class deleteQuestionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public deleteQuestionServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String temp = request.getParameter("temp");
        if (temp == null || !temp.contains("-")) {
            out.println("Invalid request.");
            return;
        }

        String part1 = temp.substring(0, temp.indexOf('-'));
        int id = Integer.parseInt(part1);
        String subject = temp.substring(temp.indexOf('-') + 1).trim();
        System.out.println("Delete Requested -> ID: " + id + ", Subject: " + subject);

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
                out.println("Invalid subject: " + subject);
                return;
        }

        String jdbcURL = "jdbc:mysql://localhost:3306/mydb1";
        String dbUser = "root";
        String dbPassword = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
            String sql = "DELETE FROM " + tableName + " WHERE id=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Question deleted successfully.");
                response.sendRedirect("/QuizApp/admin/viewAllQuestions.jsp");
            } else {
                out.println("No question found with ID: " + id);
            }
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("Error: " + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}