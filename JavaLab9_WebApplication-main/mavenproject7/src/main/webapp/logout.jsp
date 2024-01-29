<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.Timestamp, java.util.Date"%>

<%
    HttpSession session1 = request.getSession(false);
    Timestamp Ttime = null; 

    if (session1 != null && session1.getAttribute("username") != null) {
        String username = (String) session1.getAttribute("username");

      
            Date loginTime = (Date) session1.getAttribute("loginTime");
            Ttime = new Timestamp(loginTime.getTime());
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/Login", "root", "");
            String query = "UPDATE user_sessions SET logout_time = ? WHERE username = ? AND login_time = ? ";
            try (PreparedStatement pst = con.prepareStatement(query)) {
                Timestamp currentTime = new Timestamp(System.currentTimeMillis());
                pst.setTimestamp(1, currentTime);
                pst.setString(2, username);
                pst.setTimestamp(3, Ttime);
                pst.executeUpdate();
            }
            con.close();
        } catch (Exception e) {
            // Print the stack trace for debugging
            e.printStackTrace();
        }
        session1.invalidate()
        response.sendRedirect("index.html"); 
    }
%>