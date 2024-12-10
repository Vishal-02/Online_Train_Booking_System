<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>Make a Reservation</title>
        <link rel="stylesheet" type="text/css" href="css/style.css">
        <script>
            function toggleDiscountField() {
                const discountCheckbox = document.getElementById("discountCheckbox");
                const discountField = document.getElementById("discountField");

                if (discountCheckbox.checked) {
                    discountField.style.display = "block";
                } else {
                    discountField.style.display = "none";
                    document.getElementById("discountCount").value = 0;
                }
            }

            function validateCounts() {
                const totalTickets = parseInt(document.getElementById("tickets").value || 0, 10);
                const discountCount = parseInt(document.getElementById("discountCount").value || 0, 10);

                if (discountCount > totalTickets) {
                    alert("The number of discounted passengers cannot exceed the total number of tickets.");
                    return false;
                }

                return true;
            }
        </script>
    </head>
    <body>
        <div class="reserve-container">
            <h2>Make a Reservation</h2>

            <%
                String username = (String) session.getAttribute("username");

                if (username == null) {
                    response.sendRedirect("login.jsp");
                }

                String URL = "jdbc:mysql://localhost:3306/railwaysystem";
                String User = "root";
                String Password = "fl3xwm3";
                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;
                String passengerName = "";

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(URL, User, Password);
                    stmt = conn.createStatement();

                    // Fetch passenger name from the customer table
                    String sql = "SELECT Firstname, lastname FROM customer WHERE username = '" + username + "'";
                    rs = stmt.executeQuery(sql);

                    if (rs.next()) {
                        passengerName = rs.getString("FirstName") + " " + rs.getString("LastName");
                    } else {
                        response.sendRedirect("login.jsp");
                    }
                } catch (Exception e) {
                    out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException ex) {
                        out.println("<p style='color:red;'>Error closing resources: " + ex.getMessage() + "</p>");
                    }
                }
            %>

            <form action="processReservation.jsp" method="post" onsubmit="return validateCounts()">
                <input type="hidden" name="passengerName" value="<%= passengerName %>">
                <p>Passenger Name: <%= passengerName %></p>

                <label for="route">Select Route (December 2024):</label>
                <select name="route" required>
                    <%
                        // Fetch all routes from Train_Schedule table where Departure_Datetime is in December 2024
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection(URL, User, Password);
                            stmt = conn.createStatement();

                            String routeQuery = "SELECT Train_No, Transit_Line_Name, Destination, Fare, Departure_Datetime " +
                                                "FROM Train_Schedule " +
                                                "WHERE Departure_Datetime >= '2024-12-01 00:00:00' AND Departure_Datetime < '2025-01-01 00:00:00'";
                            rs = stmt.executeQuery(routeQuery);

                            while (rs.next()) {
                                String trainNo = rs.getString("Train_No");
                                String transitLine = rs.getString("Transit_Line_Name");
                                String destination = rs.getString("Destination");
                                float fare = rs.getFloat("Fare");
                                String departureDatetime = rs.getString("Departure_Datetime");

                                // Display Transit_Line_Name, Destination, Fare, and Departure_Datetime in dropdown
                                out.println("<option value='" + trainNo + "|" + fare + "'>" + transitLine + " to " + destination + " ($" + fare + ") - " + departureDatetime + "</option>");
                            }
                        } catch (Exception e) {
                            out.println("<p style='color:red;'>Error loading routes: " + e.getMessage() + "</p>");
                        } finally {
                            try {
                                if (rs != null) rs.close();
                                if (stmt != null) stmt.close();
                                if (conn != null) conn.close();
                            } catch (SQLException ex) {
                                out.println("<p style='color:red;'>Error closing resources: " + ex.getMessage() + "</p>");
                            }
                        }
                    %>
                </select>

                <label for="tickets">Number of Tickets:</label>
                <input type="number" name="tickets" id="tickets" min="1" required>

                <label for="discountCheckbox">
                    <input type="checkbox" id="discountCheckbox" name="applyDiscount" onchange="toggleDiscountField()"> Apply Discount (Child/Senior/Disabled)
                </label>

                <div id="discountField" style="display: none;">
                    <label for="discountCount">Number of Discounted Passengers:</label>
                    <input type="number" id="discountCount" name="discountCount" min="0" value="0">
                </div>

                <button type="submit">Make Reservation</button>
            </form>

            <form action="viewReservations.jsp" method="get" style="margin-top: 20px;">
                <button type="submit">View My Reservations</button>
            </form>
        </div>
    </body>
</html>
