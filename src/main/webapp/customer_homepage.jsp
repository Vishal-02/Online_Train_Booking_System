<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<!DOCTYPE html>
<html lang="en">
<link href='https://fonts.googleapis.com/css?family=Poppins' rel='stylesheet'>

<style>
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@700&display=swap');
</style>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Homepage</title>
    <link href="css/customer_homepage.css" rel="stylesheet">
</head>
<body>
    <header>
        <a href="login.jsp" class="logout-btn">Logout</a>
    </header>
    
    <main>
        <div class="welcome-container">
            <div class="welcome-btn">Welcome, <%= session.getAttribute("customerName") %>!</div>
        </div>
        <div class="button-container">
            <a href="make_reservation.jsp" class="btn">Make a Train Reservation</a>
            <a href="reservation_history.jsp" class="btn">View Reservation History</a>
            <a href="faq.jsp" class="btn">FAQ</a>
        </div>
    </main>
</body>
</html>