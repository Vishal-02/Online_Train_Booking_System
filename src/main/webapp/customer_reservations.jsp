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
    <link href="css/customer_reservations.css" rel="stylesheet">
</head>
<body>
    <header>
        <a href="customer_rep_homepage.jsp" class="logout-btn">Home</a>
        <a href="login.jsp" class="logout-btn">Logout</a>
    </header>

    <main>
        <div class="form-container">
            <h2>Check Train Reservations</h2>
            <form action="ViewReservationsServlet" method="post">
                <label for="trainLine">Train Line:</label>
                <select name="trainLine" id="trainLine" required>
                    <option value="" disabled selected>Select a train line</option>
                    <option value="Red Line">Red Line</option>
                    <option value="Blue Line">Blue Line</option>
                    <option value="Green Line">Green Line</option>
                    <option value="Yellow Line">Yellow Line</option>
                </select>
                
                <label for="reservationDate">Reservation Date:</label>
                <input type="date" id="reservationDate" name="reservationDate" required>
                
                <button type="submit" class="submit-btn">Check Reservations</button>
            </form>
        </div>
    </main>
</body>
</html>