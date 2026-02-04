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

@WebServlet("/deleteUserServlet")
public class deleteUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public deleteUserServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String jdbcURL = "jdbc:mysql://localhost:3306/mydb1";
        String dbUser = "root";
        String dbPassword = "";

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String email = request.getParameter("email");

        if (email == null || email.isEmpty()) {
            out.println("Error: Email parameter is missing.");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
                 PreparedStatement stmt = conn.prepareStatement("DELETE FROM users WHERE email=?")) {

                stmt.setString(1, email);
                int rowsAffected = stmt.executeUpdate();

                if (rowsAffected > 0) {
                    System.out.println("User deleted successfully.");
                } else {
                    System.out.println("No user found with the provided email.");
                }

                response.sendRedirect("/QuizApp/admin/viewUsers.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("Error: " + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
