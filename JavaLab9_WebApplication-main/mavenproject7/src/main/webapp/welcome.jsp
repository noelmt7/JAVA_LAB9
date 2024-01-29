<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date, java.text.SimpleDateFormat, java.util.Base64" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <title>Welcome Page</title>
</head>
<body>
    <%
        if (request.getSession(false) != null && request.getSession(false).getAttribute("username") != null) {
            String username = (String) request.getSession(false).getAttribute("username");
            Date loginTime = (Date) request.getSession(false).getAttribute("loginTime");
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String formattedLoginTime = sdf.format(loginTime);
            // Retrieve base64-encoded profile image from the session
            String base64Image = (String) request.getSession(false).getAttribute("profileImage");
    %>
            <h2>Welcome, <%= username %></h2>
            <p>Login Time: <%= formattedLoginTime %></p>
            
            <% 
            if (base64Image != null && !base64Image.isEmpty()) {
            %>
                <img src="data:image/jpeg;base64,<%= base64Image %>" alt="Profile Image">
            <% } else { %>
                <p>No profile picture available.</p>
            <% } %>
            <a href="logout.jsp">Logout</a>
    <%
        } else {
            // Redirect to login page if the user is not logged in
            response.sendRedirect("index.html"); // Change to the appropriate page
        }
    %>
</body>
</html>