<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>My Reservations</title>
        <link rel="stylesheet" type="text/css" href="css/style.css">
    </head>
    <body>
        <div class="reservations-container">
            <h2>My Reservations</h2>

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

                    // Fetch passenger name
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

            <h3>Passenger: <%= passengerName %></h3>

            <!-- Display Current Reservations -->
            <h3>Current Reservations</h3>
            <table border="1">
                <tr>
                    <th>Reservation No</th>
                    <th>Date</th>
                    <th>Tickets</th>
                    <th>Total Fare</th>
                    <th>Action</th>
                </tr>
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(URL, User, Password);
                        stmt = conn.createStatement();

                        String currentReservationsQuery = "SELECT Reservation_No, Date, No_of_Tickets, Total_Fare " +
                                                          "FROM Reservations WHERE Passenger = '" + passengerName + "' AND Date >= CURDATE()";
                        rs = stmt.executeQuery(currentReservationsQuery);

                        while (rs.next()) {
                            String reservationNo = rs.getString("Reservation_No");
                            out.println("<tr>");
                            out.println("<td>" + reservationNo + "</td>");
                            out.println("<td>" + rs.getDate("Date") + "</td>");
                            out.println("<td>" + rs.getInt("No_of_Tickets") + "</td>");
                            out.println("<td>$" + rs.getFloat("Total_Fare") + "</td>");
                            out.println("<td>");
                            out.println("<form action='cancelReservation.jsp' method='post' style='display:inline;'>");
                            out.println("<input type='hidden' name='reservationNo' value='" + reservationNo + "'>");
                            out.println("<button type='submit'>Cancel</button>");
                            out.println("</form>");
                            out.println("</td>");
                            out.println("</tr>");
                        }
                    } catch (Exception e) {
                        out.println("<p style='color:red;'>Error loading current reservations: " + e.getMessage() + "</p>");
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
            </table>

            <!-- Display Past Reservations -->
            <h3>Past Reservations</h3>
            <table border="1">
                <tr>
                    <th>Reservation No</th>
                    <th>Date</th>
                    <th>Tickets</th>
                    <th>Total Fare</th>
                </tr>
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(URL, User, Password);
                        stmt = conn.createStatement();

                        String pastReservationsQuery = "SELECT Reservation_No, Date, No_of_Tickets, Total_Fare " +
                                                       "FROM Reservations WHERE Passenger = '" + passengerName + "' AND Date < CURDATE()";
                        rs = stmt.executeQuery(pastReservationsQuery);

                        while (rs.next()) {
                            out.println("<tr>");
                            out.println("<td>" + rs.getString("Reservation_No") + "</td>");
                            out.println("<td>" + rs.getDate("Date") + "</td>");
                            out.println("<td>" + rs.getInt("No_of_Tickets") + "</td>");
                            out.println("<td>$" + rs.getFloat("Total_Fare") + "</td>");
                            out.println("</tr>");
                        }
                    } catch (Exception e) {
                        out.println("<p style='color:red;'>Error loading past reservations: " + e.getMessage() + "</p>");
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
            </table>

            <form action="menu.jsp" method="get" style="margin-top: 20px;">
                <button type="submit">Back to Menu</button>
            </form>
        </div>
    </body>
</html>
