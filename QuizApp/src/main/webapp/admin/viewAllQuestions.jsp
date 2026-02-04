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
    <title>View All Questions</title>
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
        select, input[type="submit"] {
            padding: 5px 10px;
            font-size: 14px;
        }
    </style>
</head>
<body>
<div class="top-buttons">
    <a href="/QuizApp/admin/admin_home.jsp">🏠 Home</a>
    <a href="/QuizApp/admin_login.jsp">🚪 Logout</a>
</div>
<h2>View All Questions</h2>
<form method="post" action="viewAllQuestions.jsp">
    <label for="subject">Select Subject:</label>
    <select name="subject" required>
        <option value="">--Select--</option>
        <option value="Movies & TV">Movies & TV</option>
        <option value="History & Geography">History & Geography</option>
        <option value="Science & Tech">Science & Tech</option>
        <option value="Sports">Sports</option>
        <option value="Celebrity and Gossip">Celebrity and Gossip</option>
        <option value="Personality">Personality</option>
    </select>
    <input type="submit" value="View">
</form>
<%
    String subject = request.getParameter("subject");
    if (subject != null && !subject.isEmpty()) {
        String tableName = "";
        switch (subject) {
            case "Movies & TV": tableName = "movies_quiz"; break;
            case "History & Geography": tableName = "history_quiz"; break;
            case "Science & Tech": tableName = "science_quiz"; break;
            case "Sports": tableName = "sports_quiz"; break;
            case "Celebrity and Gossip": tableName = "celebrity_quiz"; break;
            case "Personality": tableName = "personality_quiz"; break;
        }
        if (!tableName.isEmpty()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mydb1", "root", "");
                PreparedStatement stmt = conn.prepareStatement("SELECT * FROM " + tableName);
                ResultSet rs = stmt.executeQuery();
%>
                <h3>Questions: <%= subject %></h3>
                <table>
                    <tr>
                        <th>ID</th>
                        <th>Question</th>
                        <th>A</th>
                        <th>B</th>
                        <th>C</th>
                        <th>D</th>
                        <th>genreA</th>
                        <th>genreB</th>
                        <th>genreC</th>
                        <th>genreD</th>
                        <th>Edit</th>
                        <th>Delete</th>
                    </tr>
<%
                while (rs.next()) {
%>
                    <tr>
                        <td><%= rs.getInt("id") %></td>
                        <td><%= rs.getString("question") %></td>
                        <td><%= rs.getString("optionA") %></td>
                        <td><%= rs.getString("optionB") %></td>
                        <td><%= rs.getString("optionC") %></td>
                        <td><%= rs.getString("optionD") %></td>
                        <td><%= rs.getString("genreA") %></td>
                        <td><%= rs.getString("genreB") %></td>
                        <td><%= rs.getString("genreC") %></td>
                        <td><%= rs.getString("genreD") %></td>
                        <td>
                            <form action="/QuizApp/editQuestionServlet" method="post">
                                <input type="hidden" name="temp" value="<%= rs.getInt("id") + "-" + subject %>">
                                <input type="submit" value="Edit">
                            </form>
                       </td>
                        <td>
                            
                            <form method="post" action="/QuizApp/deleteQuestionServlet">
                                <input type="hidden" name="temp" value="<%= rs.getInt("id") + "-" + subject %>">
                                <input type="submit" value="Delete">
                            </form>
                        </td>
                    </tr>
<%
                }
                
                conn.close();
            } catch (Exception e) {
%>
                <p style="color: red;">Error: <%= e.getMessage() %></p>
<%
            }
        }
    }
%>
</body>
</html>