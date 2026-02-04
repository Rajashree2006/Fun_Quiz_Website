<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*" %>
<%
    // Ensure user is logged in
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String message = "";
    boolean deleted = false;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String confirm = request.getParameter("confirm");
        if ("yes".equals(confirm)) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/mydb", "root", "yourpassword");

                PreparedStatement ps = con.prepareStatement("DELETE FROM users WHERE username=?");
                ps.setString(1, username);
                int rows = ps.executeUpdate();

                if (rows > 0) {
                    session.invalidate(); // logout after deletion
                    message = "✅ Your account has been deleted successfully. Redirecting to homepage...";
                    deleted = true;
                } else {
                    message = "⚠️ Account not found or already deleted.";
                }
                con.close();
            } catch (Exception e) {
                message = "❌ Error: " + e.getMessage();
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Delete Account</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #f06292, #e57373);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .delete-container {
            background: #fff;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0px 10px 30px rgba(0,0,0,0.25);
            text-align: center;
            width: 400px;
        }
        h2 {
            color: #c62828;
        }
        form {
            margin-top: 20px;
        }
        button {
            background: #c62828;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 10px;
            font-size: 16px;
            cursor: pointer;
        }
        button:hover {
            background: #b71c1c;
        }
        .cancel {
            background: gray;
            margin-left: 10px;
        }
        .message {
            margin-top: 20px;
            font-weight: bold;
            color: #2e7d32;
        }
    </style>
    <% if (deleted) { %>
    <meta http-equiv="refresh" content="2;URL=index.jsp">
    <% } %>
</head>
<body>
    <div class="delete-container">
        <h2>⚠️ Delete Account</h2>
        <% if (!deleted) { %>
        <p>Are you sure you want to delete your account, <b><%= username %></b>?</p>
        <form method="post">
            <input type="hidden" name="confirm" value="yes">
            <button type="submit">Yes, Delete My Account</button>
            <a href="account.jsp"><button type="button" class="cancel">Cancel</button></a>
        </form>
        <% } %>
        <div class="message"><%= message %></div>
    </div>
</body>
</html>
