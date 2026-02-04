package com;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/changeAdminPasswordServlet")
public class changeAdminPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public changeAdminPasswordServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Input validation
        if (oldPassword == null || newPassword == null || confirmPassword == null ||
            oldPassword.trim().isEmpty() || newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
            response.sendRedirect("/QuizApp/admin/changeAdminPassword.jsp");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect("/QuizApp/admin/changeAdminPassword.jsp");
            return;
        }

        String jdbcURL = "jdbc:mysql://localhost:3306/mydb1";
        String dbUser = "root";
        String dbPassword = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            // First, check if the old password exists
            String checkQuery = "SELECT * FROM admin WHERE password = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
            checkStmt.setString(1, oldPassword);

            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                // Old password exists, proceed to update
                String updateQuery = "UPDATE admin SET password = ? WHERE password = ?";
                PreparedStatement updateStmt = conn.prepareStatement(updateQuery);
                updateStmt.setString(1, newPassword);
                updateStmt.setString(2, oldPassword);

                int rn = updateStmt.executeUpdate();

                updateStmt.close();
                conn.close();

                if (rn >= 1) {
                    System.out.println("Password updated successfully.");
                    response.sendRedirect("/QuizApp/admin/admin_login.jsp");
                } else {
                    System.out.println("Password update failed.");
                    response.sendRedirect("/QuizApp/admin/adminerror.jsp");
                }

            } 
            else {
                conn.close();
                System.out.println("Old password incorrect.");
                response.sendRedirect("/QuizApp/admin/adminerror.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("Error: " + e.getMessage());
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
