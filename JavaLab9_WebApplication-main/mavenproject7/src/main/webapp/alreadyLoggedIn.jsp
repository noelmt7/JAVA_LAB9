<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Already Logged In</title>
</head>
<body>
    <h2>You are already logged in!</h2>
    
    <p>Login Time: <%= session.getAttribute("loginTime") %></p>
    
    <img src="data:image/jpeg;base64, <%= session.getAttribute("profileImage") %>" alt="Profile Image" width="100" height="100">
</body>
</html>
