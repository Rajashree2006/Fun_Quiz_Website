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

@WebServlet("/InsertQuestionServlet")
public class InsertQuestionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public InsertQuestionServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String subject = request.getParameter("subject");
        String question = request.getParameter("question");
        String optionA = request.getParameter("optionA");
        String optionB = request.getParameter("optionB");
        String optionC = request.getParameter("optionC");
        String optionD = request.getParameter("optionD");
        String genreA = request.getParameter("genreA");
        String genreB = request.getParameter("genreB");
        String genreC = request.getParameter("genreC"); // fixed here
        String genreD = request.getParameter("genreD");

        String addAnother = request.getParameter("addAnother");

        String tableName;

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

            String sql = "INSERT INTO " + tableName +
                    " (question, optionA, optionB, optionC, optionD, genreA, genreB, genreC, genreD) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, question);
            stmt.setString(2, optionA);
            stmt.setString(3, optionB);
            stmt.setString(4, optionC);
            stmt.setString(5, optionD);
            stmt.setString(6, genreA);
            stmt.setString(7, genreB);
            stmt.setString(8, genreC);
            stmt.setString(9, genreD);

            int rowsInserted = stmt.executeUpdate();
            conn.close();

            if (rowsInserted > 0) {
                request.setAttribute("subject", subject);
                request.setAttribute("message", "Question added successfully!");

                if ("yes".equalsIgnoreCase(addAnother)) {
                    request.getRequestDispatcher("/admin/add" + subject.replaceAll("\\s+", "") + "Quiz.jsp")
                           .forward(request, response);
                } else {
                    request.getRequestDispatcher("/admin/addQuestionSuccess.jsp")
                           .forward(request, response);
                }
            } else {
                out.println("Failed to add the question.");
            }

        } catch (Exception e) {
            e.printStackTrace(out);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
