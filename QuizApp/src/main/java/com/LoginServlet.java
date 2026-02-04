package com;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public LoginServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String username = request.getParameter("username"); 
        String password = request.getParameter("password");

        String jdbcURL = "jdbc:mysql://localhost:3306/mydb1";
        String dbUser = "root";
        String dbPassword = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            String sql = "SELECT username FROM users WHERE (username = ? OR email = ?) AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, username); 
            stmt.setString(3, password);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
            	 String actualUsername = rs.getString("username");
                HttpSession session = request.getSession();
                session.setAttribute("username", actualUsername);

                response.sendRedirect("pages/second.jsp");
            } else {
                response.sendRedirect("/QuizApp/pages/error.jsp");
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println(e.getMessage());
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("/QuizApp/pages/login.jsp");
    }
}
