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
    <title>Admin Homepage</title>
    <link href="css/admin_homepage.css" rel="stylesheet">
</head>
<body>
    <header>
        <a href="login.jsp" class="logout-btn">Logout</a>
    </header>

    <main>
        <div class="welcome-container">
            <div class="welcome-btn">Welcome, admin <%= session.getAttribute("employeeName") %>!</div>
        </div>
        <div class="button-container">
            <a href="edit_customer_rep.jsp" class="btn">Edit Customer Rep Info</a>
            <a href="sales_report.jsp" class="btn">Sales Report</a>
            <a href="reservations_list.jsp" class="btn">List of Reservations</a>
            <a href="revenue_report.jsp" class="btn">Revenue Report</a>
            <a href="best_customer.jsp" class="btn">Best Customer</a>
            <a href="active_transit_lines.jsp" class="btn">Active Transit Lines</a>
        </div>
    </main>
</body>
</html>