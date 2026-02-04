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

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public RegisterServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm");

        String jdbcURL = "jdbc:mysql://localhost:3306/mydb1";
        String dbUser = "root";
        String dbPassword = "";

        if (!password.equals(confirmPassword)) {
            response.sendRedirect("/QuizApp/pages/error.jsp");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            String checkSql = "SELECT * FROM users WHERE username = ? OR email = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, username);
            checkStmt.setString(2, email);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                response.sendRedirect("/QuizApp/pages/error.jsp");
            } 
            else {
                String sql = "INSERT INTO users (username, password, email) VALUES (?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, username);
                stmt.setString(2, password);
                stmt.setString(3, email);

                int rowsInserted = stmt.executeUpdate();

                if (rowsInserted > 0) {
                	HttpSession session = request.getSession();
                    session.setAttribute("username", username);

                    response.sendRedirect("pages/second.jsp");
                } else {
                    response.sendRedirect("/QuizApp/pages/error.jsp");
                }
            }

            conn.close();
        } 
        catch (Exception e) {
            System.out.println(e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
