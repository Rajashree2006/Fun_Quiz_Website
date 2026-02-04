package com;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
@WebServlet("/editQuestionServlet")
public class editQuestionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    public editQuestionServlet() {
        super();
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out=response.getWriter();
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        String temp = request.getParameter("temp");
        String[] parts = temp.split("-");
        int id = Integer.parseInt(parts[0]);
        String subject = parts[1];
        
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
                response.getWriter().println("Invalid subject.");
        }
        
        String jdbcURL = "jdbc:mysql://localhost:3306/mydb1";
        String dbUser = "root";
        String dbPassword = "";
        
        try 
        {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
                
            String sql = "SELECT * FROM " + tableName + " WHERE id=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) 
            {
                request.setAttribute("id", rs.getInt("id"));
                request.setAttribute("subject", subject);
                request.setAttribute("question", rs.getString("question"));
                request.setAttribute("optionA", rs.getString("optionA"));
                request.setAttribute("optionB", rs.getString("optionB"));
                request.setAttribute("optionC", rs.getString("optionC"));
                request.setAttribute("optionD", rs.getString("optionD"));
                request.setAttribute("genreA", rs.getString("genreA"));
                request.setAttribute("genreB", rs.getString("genreB"));
                request.setAttribute("genreC", rs.getString("genreC"));
                request.setAttribute("genreD", rs.getString("genreD"));
                conn.close();
                request.getRequestDispatcher("/admin/editQuestion.jsp").forward(request, response);
            } 
            else 
            {
                out.println("No question found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}