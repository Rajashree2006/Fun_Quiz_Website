<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null || username.trim().equals("")) {
        response.sendRedirect("admin_login.jsp");
        return; 
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View All Users</title>
    <style>
        body {
            font-family: sans-serif;
            padding: 20px;
        }
        .top-buttons {
            text-align: right;
            margin-bottom: 15px;
        }
        .top-buttons a {
            text-decoration: none;
            padding: 6px 12px;
            margin-left: 10px;
            background-color: #ddd;
            color: black;
            border: 1px solid #aaa;
            border-radius: 4px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        table, th, td {
            border: 1px solid #aaa;
        }
        th, td {
            padding: 8px;
            text-align: left;
        }
        input[type="submit"] {
            background-color: #d9534f;
            color: white;
            border: none;
            padding: 6px 10px;
            border-radius: 4px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #c9302c;
        }
    </style>
</head>
<body>
<div class="top-buttons">
    <a href="/QuizApp/admin/admin_home.jsp">🏠 Home</a>
    <a href="LogoutAdmin.jsp">🚪 Logout</a>
</div>
<h3>Registered Users</h3>
<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mydb1", "root", "");
        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users");
        ResultSet rs = stmt.executeQuery();
%>
        <table>
            <tr>
                <th>Username</th>
                <th>Email</th>
                <th>Delete</th>
            </tr>
<%
        while (rs.next()) {
%>
            <tr>
                <td><%= rs.getString("username") %></td>
                <td><%= rs.getString("email") %></td>
                <td>
                    <form action="/QuizApp/deleteUserServlet" method="post" onsubmit="return confirm('Delete this user?');">
                        <input type="hidden" name="email" value="<%= rs.getString("email") %>">
                        <input type="submit" value="Delete">
                    </form>
                </td>
            </tr>
<%
        }
        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
%>
        <p style="color: red;">Error: <%= e.getMessage() %></p>
<%
    }
%>
</table>
</body>
</html>