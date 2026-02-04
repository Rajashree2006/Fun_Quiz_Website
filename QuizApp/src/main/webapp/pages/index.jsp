<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quiz Master</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #d8f3dc, #b7e4c7);
            color: #1b4332;
        }

        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 25px 80px;
            background: #ffffff;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
            flex-wrap: wrap;
        }

        .logo {
            font-size: 1.8rem;
            font-weight: bold;
            color: #1b4332;
        }

        nav {
            display: flex;
            gap: 30px;
            align-items: center;
        }

        nav a {
            text-decoration: none;
            color: #1b4332;
            font-weight: 500;
            font-size: 1rem;
        }

        .auth-buttons {
            display: flex;
            gap: 15px;
            align-items: center;
            margin-top: 10px;
        }

        .auth-buttons a {
            text-decoration: none;
            padding: 8px 20px;
            border-radius: 20px;
            font-weight: 600;
            transition: 0.3s;
            border: 2px solid transparent;
        }

        .auth-buttons .login {
            border: 2px solid #2d6a4f;
            color: #2d6a4f;
            background: transparent;
        }

        .auth-buttons .signup {
            background: #2d6a4f;
            color: #fff;
        }

        .main {
            padding: 60px 80px;
            background: #f0fdf4;
            text-align: center;
        }

        .main h1 {
            font-size: 3rem;
            color: #1b4332;
            margin-bottom: 20px;
        }

        .main p {
            font-size: 1.15rem;
            color: #344e41;
            max-width: 700px;
            margin: 0 auto 40px auto;
            line-height: 1.6;
        }

        .cta-buttons {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-bottom: 50px;
            flex-wrap: wrap;
        }

        .cta-buttons a {
            text-decoration: none;
            padding: 12px 28px;
            border-radius: 30px;
            font-weight: 600;
            font-size: 1rem;
            transition: 0.3s;
        }

        .play-now {
            background: #2d6a4f;
            color: #fff;
        }

        .create-quiz {
            background: #e9f5ee;
            color: #2d6a4f;
            border: 2px solid #2d6a4f;
        }

        .category-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
            gap: 20px;
            margin-top: 30px;
            padding: 0 10%;
        }

        .category-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 20px 10px;
            text-align: center;
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.08);
            transition: 0.3s;
            cursor: pointer;
        }

        .category-card:hover {
            transform: translateY(-5px);
        }

        .category-card img {
            width: 60px;
            height: 60px;
            object-fit: contain;
            margin-bottom: 10px;
        }

        .category-card span {
            font-size: 0.95rem;
            font-weight: 500;
            color: #1b4332;
        }

        @media screen and (max-width: 768px) {
            header {
                flex-direction: column;
                align-items: flex-start;
                padding: 20px;
            }

            .main h1 {
                font-size: 2.2rem;
            }

            .cta-buttons {
                flex-direction: column;
                gap: 15px;
            }
        }
        .category-card {
    		display: flex;
    		flex-direction: column;
    		align-items: center;
    		text-decoration: none;
    		background: white;
    		padding: 20px;
    		border-radius: 12px;
    		box-shadow: 0 4px 20px rgba(0,0,0,0.1);
    		color: #000;
    		transition: transform 0.3s ease;
		}

		.category-card:hover {
    		transform: scale(1.05);
	}
        
    </style>
</head>
<body>
    <!-- Header -->
    <header>
        <div class="logo">Quiz Master</div>
        <nav>
            <a href="review.jsp">Reviews</a>
            <a href="about.jsp">About</a>
            <a href="review.jsp">More Quizes</a>
        </nav>
        <div class="auth-buttons">
            <a href="login.jsp" class="login">Log In</a>
            <a href="register.jsp" class="signup">Sign Up</a>
        </div>
    </header>

    <!-- Main Content -->
    <section class="main">
        <h1>🚀 Dive into a World of Interesting Quizes</h1>
        <p>
            Get ready for an epic journey filled with exciting challenges and mind-boggling questions. Whether you're a casual player or a seasoned quiz master, there’s always something new to discover about yourself!
        </p>

        <div class="cta-buttons">
            
            
            
            
        </div>

        <!-- Quiz Categories -->
        <div class="category-grid">
            <a href="guest.jsp" class="category-card">
    			<img src="https://img.icons8.com/color/96/earth-planet.png" alt="Movies">
    			<span>Natural Element Type</span>
		</a>

		 <a href="guest.jsp" class="category-card">
   		 	<img src="https://img.icons8.com/color/96/open-book.png" alt="History">
    	 	<span>Novel Type</span>
		</a>

		<a href="guest.jsp" class="category-card">
    		<img src="https://img.icons8.com/color/96/olympic-torch.png" alt="Sports">
    		<span>Mythology</span>
		</a>

		<a href="guest.jsp" class="category-card">
   		    <img src="https://img.icons8.com/color/96/barber-scissors.pn" alt="Science">
    		<span>Hair Strand Type</span>
		</a>

		

		<a href="guest.jsp" class="category-card">
    		<img src="https://img.icons8.com/color/96/theatre-mask.png" alt="Personality">
    		<span>Personality</span>
		</a>

        </div>
    </section>
</body>
</html>
