<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String username = (String) session.getAttribute("username");
    if (username == null || username.trim().equals("")) {
        response.sendRedirect("admin_login.jsp");
        return; 
    }
%>
<%
    String id = String.valueOf(request.getAttribute("id"));
    String subject = (String) request.getAttribute("subject");
    String question = (String) request.getAttribute("question");
    String optionA = (String) request.getAttribute("optionA");
    String optionB = (String) request.getAttribute("optionB");
    String optionC = (String) request.getAttribute("optionC");
    String optionD = (String) request.getAttribute("optionD");
    String genreA = (String) request.getAttribute("genreA");
    String genreB = (String) request.getAttribute("genreB");
    String genreC = (String) request.getAttribute("genreC");
    String genreD = (String) request.getAttribute("genreD");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Question</title>
    <style>
        input[type="text"] {
            padding: 10px;
            font-size: 16px;
            margin-top: 5px;
            border-radius: 6px;
            border: 1px solid #ccc;
            width: 100%; /* Make the input field take the full width */
        }
        button {
            margin-top: 30px;
            padding: 12px;
            font-size: 18px;
            background-color: #00796b;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
        }
    </style>
</head>
<body>
<div class="navbar">
    <h1>Edit Question</h1>
    <div>
        <a href="/QuizApp/admin/viewAllQuestions.jsp" style="font-size: 22px;">Back</a>
        
    </div>
</div>
<div class="edit-container">
    <h2>Edit Question Details</h2>
    <form action="updateQuestionServlet" method="post">
        <input type="hidden" name="id" value="<%= id %>">
        <input type="hidden" name="subject" value="<%= subject %>">
        <label>Question:</label>
        <input type="text" name="question" value="<%= question %>" required style="width: 100%; height: 100px; resize: vertical;">
        <label>Option A:</label>
        <input type="text" name="optionA" value="<%= optionA %>" required>
        <label>Option B:</label>
        <input type="text" name="optionB" value="<%= optionB %>" required>
        <label>Option C:</label>
        <input type="text" name="optionC" value="<%= optionC %>" required>
        <label>Option D:</label>
        <input type="text" name="optionD" value="<%= optionD %>" required>
        <label>Genre A:</label>
        <input type="text" name="genreA" value="<%= genreA %>" required>
        <label>Genre B:</label>
        <input type="text" name="genreB" value="<%= genreB %>" required>
        <label>Genre C:</label>
        <input type="text" name="genreC" value="<%= genreC %>" required>
        <label>Genre D:</label>
        <input type="text" name="genreD" value="<%= genreD %>" required>
        <button type="submit">Update Question</button>
    </form>
</div>
</body>
</html>