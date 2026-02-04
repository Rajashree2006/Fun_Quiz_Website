<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <title>Add Personality Quiz Question</title>
</head>
<body style="display: flex; justify-content: center; align-items: center; height: 100vh; font-family: Arial, sans-serif; font-size: 18px;">

    <div style="text-align: center;">
        <h2>Add Personality Quiz Question</h2>

        <form action="/QuizApp/InsertQuestionServlet" method="post">
            <input type="hidden" name="subject" value="Personality">

            <label for="question">Question:</label><br>
            <textarea name="question" id="question" rows="3" cols="50" required></textarea><br><br>

            <label for="optionA">Option A:</label><br>
            <input type="text" name="optionA" id="optionA" required><br><br>
            
            <label for="genreA">Genre/Personality for Option A:</label>
            <input type="text" name="genreA" id="genreA" required><br><br>

            <label for="optionB">Option B:</label><br>
            <input type="text" name="optionB" id="optionB" required><br><br>
            
            <label for="genreB">Genre/Personality for Option B:</label>
            <input type="text" name="genreB" id="genreB" required><br><br>

            <label for="optionC">Option C:</label><br>
            <input type="text" name="optionC" id="optionC" required><br><br>
            
            <label for="genreC">Genre/Personality for Option C:</label>
            <input type="text" name="genreC" id="genreC" required><br><br>

            <label for="optionD">Option D:</label><br>
            <input type="text" name="optionD" id="optionD" required><br><br>

            <label for="genreD">Genre/Personality for Option D:</label>
            <input type="text" name="genreD" id="genreD" required><br><br>

            <input type="submit" value="Add Question" style="font-size: 16px; padding: 8px 16px;">
        </form>
    </div>

</body>
</html>
