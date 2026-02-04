<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String username = (String) session.getAttribute("username");
    if (username == null || username.trim().equals("")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Welcome - Quiz Master</title>
    <style>
        /* --- Root Variables --- */
        :root {
            --primary: #34d399;
            --primary-dark: #059669;
            --text: #064e3b;
            --bg: #f0fdfa;
            --white: #ffffff;
        }

        /* --- Global Reset --- */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: "Segoe UI", Tahoma, sans-serif;
            background-color: var(--bg);
            color: var(--text);
            line-height: 1.6;
        }

        /* --- Header --- */
        header {
            background-color: var(--primary);
            padding: 15px 40px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 4px solid var(--primary-dark);
        }

        .brand {
            font-size: 28px;
            font-weight: bold;
            color: var(--white);
        }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .nav-links img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
        }

        .nav-links a {
            text-decoration: none;
            color: var(--white);
            background: var(--primary-dark);
            padding: 8px 18px;
            border-radius: 6px;
            font-weight: 500;
            transition: background 0.3s ease;
        }

        .nav-links a:hover {
            background-color: #047857;
        }

        /* --- Main Section --- */
        main {
            padding: 50px 20px;
            text-align: center;
        }

        h1 {
            font-size: 32px;
            margin-bottom: 10px;
        }

        p {
            font-size: 18px;
            margin-bottom: 40px;
            color: var(--primary-dark);
        }

        /* --- Topics Grid --- */
        .topics {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 25px;
            max-width: 1000px;
            margin: 0 auto;
        }

        .topic {
            background: var(--white);
            border: 2px solid var(--primary-dark);
            padding: 25px 20px;
            border-radius: 14px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            transition: transform 0.25s ease, box-shadow 0.25s ease;
        }

        .topic:hover {
            transform: translateY(-6px);
            box-shadow: 0 8px 18px rgba(0,0,0,0.15);
        }

        .topic a {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-decoration: none;
            color: var(--text);
            font-weight: 600;
            gap: 10px;
        }

        .topic img {
            width: 65px;
            height: 65px;
        }
    </style>
</head>
<body>

    <header>
        <div class="brand">Quiz Master</div>
        <div class="nav-links">
			<a href="del.jsp">Delete Account</a>        
            <a href="logout.jsp">Logout</a>
        </div>
    </header>

    <main>
        <h1>Welcome, <%= username %> 👋</h1>
        <p>Choose a quiz topic to begin your challenge!</p>

        <div class="topics">
            <div class="topic">
                <a href="moviesQuiz.jsp">
                    <img src="https://img.icons8.com/color/96/earth-planet.png" alt="">
                    Natural Element Type
                </a>
            </div>

            <div class="topic">
                <a href="scienceQuiz.jsp">
                    <img src="https://img.icons8.com/color/96/open-book.png" alt="">
                    Novel Type
                </a>
            </div>

            <div class="topic">
                <a href="sportsQuiz.jsp">
                    <img src="https://img.icons8.com/color/96/olympic-torch.png" alt="">
                    Mythology
                </a>
            </div>

            <div class="topic">
                <a href="celebQuiz.jsp">
                    <img src="https://img.icons8.com/color/96/barber-scissors.png" alt="">
                    Hair Strand Type
                </a>
            </div>

            <div class="topic">
                <a href="personalityQuiz.jsp">
                    <img src="https://img.icons8.com/color/96/theatre-mask.png" alt="">
                    Personality
                </a>
            </div>
        </div>
    </main>

</body>
</html>
