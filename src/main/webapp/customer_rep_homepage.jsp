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
    <title>Customer Representative Homepage</title>
    <link href="css/customer_rep_homepage.css" rel="stylesheet">
</head>
<body>
    <header>
        <a href="login.jsp" class="logout-btn">Logout</a>
    </header>

    <main>
        <div class="welcome-container">
            <div class="welcome-btn">Welcome, Customer Rep <%= session.getAttribute("employeeName") %>!</div>
        </div>
        <div class="button-container">
            <a href="edit_train_schedule.jsp" class="btn">Edit Train Schedule</a>
            <a href="get_station_schedule.jsp" class="btn">Get Station Schedule</a>
            <a href="customer_reservations.jsp" class="btn">Customer Reservations</a>
            <a href="cust_rep_faq.jsp?username=<%= session.getAttribute("employeeUsername") %>" class="btn" id="faq-button">
            	Customer FAQ
            </a>
        </div>
    </main>
</body>
</html>