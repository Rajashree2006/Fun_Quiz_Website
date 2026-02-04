package com;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Properties;
import java.util.UUID;

import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;



@WebServlet("/ForgetPasswordServlet")
public class ForgetPasswordServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/mydb";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String email = request.getParameter("contactinfo");

        try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
            PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE email=?");
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                request.setAttribute("message", "No account found with this email.");
                request.getRequestDispatcher("forgotPassword.jsp").forward(request, response);
                return;
            }

            // Generate reset token
            String token = UUID.randomUUID().toString();
            long expiryTime = System.currentTimeMillis() + (15 * 60 * 1000); // 15 minutes

            PreparedStatement ps2 = con.prepareStatement("UPDATE users SET reset_token=?, token_expiry=? WHERE email=?");
            ps2.setString(1, token);
            ps2.setTimestamp(2, new Timestamp(expiryTime));
            ps2.setString(3, email);
            ps2.executeUpdate();

            // Send email
            //String resetLink = "/quiz/resetPassword.jsp?token=" + token;
            //sendEmail(email, resetLink);

            //-----------------------------------------------------------------
            String to=email;
    		Properties props=new Properties();
    		props.put("mail.smtp.host","smtp.gmail.com");
    		props.put("mail.smtp.socketFactory.port","465");
    		props.put("mail.smtp.socketFactory.class","javax.net.ssl.SSLSocketFactory");
    		props.put("mail.smtp.auth","true");
    		props.put("mail.smtp.port","465");
    		
    		
    		Session session=Session.getDefaultInstance(props,new javax.mail.Authenticator()
    													{
    														protected PasswordAuthentication getPasswordAuthentication()
    														{
    					 										return new PasswordAuthentication("mscbscmsc@gmail.com","gosling123");
    														}
    													}
    												  );
    		//compose message
    		try
    		{
    			MimeMessage message = new MimeMessage(session);
    			message.setFrom(new InternetAddress("mscbscmsc@gmail.com"));
    			message.addRecipient(Message.RecipientType.TO,new InternetAddress(to));
    			message.setSubject("Hello");
    			message.setText("Salute to java");
    			//send message
    			Transport.send(message);
    			System.out.println("Message sent successfully");
    			
    		}			
    		catch(Exception me) 
    		{
    			throw new RuntimeException(me);
    		}
            
            //-----------------------------------------------------------------
            
            request.setAttribute("message", "Password reset link sent to your email.");
            request.getRequestDispatcher("message.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }

    /*
    private void sendEmail(String to, String resetLink) throws MessagingException {
        final String from = "yourgmail@gmail.com";  // put your email
        final String password = "your-app-password"; // generate password

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        MimeMessage session = Session.getInstance(props, new Au thenticator() 
        {
            protected PasswordAuthentication getPasswordAuthentication() 
            {
                return new PasswordAuthentication(from, password);
            }
        });

        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(from));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        msg.setSubject("Password Reset - Quiz Master");
        msg.setText("Click the link to reset your password:\n" + resetLink);

        Transport.send(msg);
    }
    */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}