package com;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/AddQuizServlet")
public class AddQuizServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AddQuizServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String subject = request.getParameter("subject");

        if (subject == null || subject.trim().isEmpty()) {
            response.sendRedirect("/QuizApp/admin/addQuiz.jsp");
            return;
        }

        switch (subject) {
            case "Movies & TV":
                response.sendRedirect("/QuizApp/admin/addMoviesQuiz.jsp");
                break;
            case "History & Geography":
                response.sendRedirect("/QuizApp/admin/addHistoryQuiz.jsp");
                break;
            case "Science & Tech":
                response.sendRedirect("/QuizApp/admin/addScienceQuiz.jsp");
                break;
            case "Sports":
                response.sendRedirect("/QuizApp/admin/addSportsQuiz.jsp");
                break;
            case "Celebrity and Gossip":
                response.sendRedirect("/QuizApp/admin/addGossipQuiz.jsp");
                break;
            case "Personality":
                response.sendRedirect("/QuizApp/admin/addPersonalityQuiz.jsp");
                break;
            default:
                response.sendRedirect("/QuizApp/admin/addQuiz.jsp");
                break;
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
