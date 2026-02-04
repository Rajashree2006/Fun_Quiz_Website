<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Movie & TV Quiz Question</title>
</head>
<body style="font-family: Arial; font-size: 18px; display: flex; justify-content: center; align-items: center; height: 100vh;">
    <div>
        <h2 style="text-align: center;">Add Question - Movies & TV</h2>
        <form action="/QuizApp/InsertQuestionServlet" method="post">
            <!-- Hidden field to identify subject -->
            <input type="hidden" name="subject" value="Movies & TV">

            <label>Question:</label><br>
            <textarea name="question" rows="3" cols="50" required></textarea><br><br>

            <label>Option A:</label><br>
            <input type="text" name="optionA" required><br><br>
            
            <label for="genreA">Genre/Personality for Option A:</label><br>
            <input type="text" name="genreA" id="genreA" required><br><br>

            <label>Option B:</label><br>
            <input type="text" name="optionB" required><br><br>
            
            <label for="genreB">Genre/Personality for Option B:</label><br>
            <input type="text" name="genreB" id="genreB" required><br><br>

            <label>Option C:</label><br>
            <input type="text" name="optionC" required><br><br>
            
            <label for="genreC">Genre/Personality for Option C:</label><br>
            <input type="text" name="genreC" id="genreC" required><br><br>

            <label>Option D:</label><br>
            <input type="text" name="optionD" required><br><br>

            <label for="genreD">Genre/Personality for Option D:</label><br>
            <input type="text" name="genreD" id="genreD" required><br><br>

            <input type="submit" value="Add Question" style="padding: 8px 16px; font-size: 16px;">
        </form>
    </div>
</body>
</html>
