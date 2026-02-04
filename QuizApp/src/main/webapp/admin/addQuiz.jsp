<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Select Quiz Subject</title>
</head>
<body style="display: flex; justify-content: center; align-items: center; height: 100vh; font-family: Arial, sans-serif; font-size: 18px;">

    <div style="text-align: center;">
        <h2>Select Subject to Add Questions</h2>

        <form action="/QuizApp/AddQuizServlet" method="post">
            <label for="subject">Select Subject:</label><br>
            <select name="subject" id="subject" required style="font-size: 16px; padding: 5px;">
                <option value="">--Select--</option>
                <option value="Movies & TV">Movies & TV</option>
                <option value="History & Geography">History & Geography</option>
                <option value="Science & Tech">Science & Tech</option>
                <option value="Sports">Sports</option>
                <option value="Celebrity and Gossip">Celebrity and Gossip</option>
                <option value="Personality">Personality</option>
            </select>
            <br><br>
            <input type="submit" value="Proceed" style="font-size: 16px; padding: 8px 16px;">
        </form>
    </div>

</body>
</html>
