<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Train Schedules</title>
    <link href="css/customer_reservations.css" rel="stylesheet">
</head>
<body>
    <header>
        <a href="customer_homepage.jsp" class="back-btn">Back to Homepage</a>
    </header>
    <main>
        <div class="reservation-container">
            <h1>Train Schedules</h1>
            <form method="GET">
                <label for="station">Select Station (Origin/Destination):</label>
                <select name="station" id="station" required>
                    <option value="">--Select a Station--</option>
                    <%
                        Connection conn = null;
                        Statement stmt = null;
                        ResultSet rs = null;
                        try {
                            // Load JDBC Driver
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/railwaysystem", "root", "fl3xwm3");

                            // Fetch stations for the dropdown
                            String stationQuery = "SELECT Name FROM station";
                            stmt = conn.createStatement();
                            rs = stmt.executeQuery(stationQuery);

                            while (rs.next()) {
                                String stationName = rs.getString("Name");
                                out.println("<option value=\"" + stationName + "\">" + stationName + "</option>");
                            }
                        } catch (ClassNotFoundException | SQLException e) {
                            e.printStackTrace();
                            out.println("<p style='color:red;'>Error loading station list.</p>");
                        } finally {
                            try {
                                if (rs != null) rs.close();
                                if (stmt != null) stmt.close();
                                if (conn != null) conn.close();
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        }
                    %>
                </select>
                <button type="submit">Search</button>
            </form>

            <div class="schedule-list">
                <%
                    String station = request.getParameter("station");
                    if (station != null && !station.isEmpty()) {
                        try {
                            // Reconnect to the database for fetching train schedules
                            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/railwaysystem", "root", "fl3xwm3");

                            // Query to get train schedules based on the selected station
                            String query = "SELECT ts.Train_No, ts.Transit_Line_Name, ts.Origin, ts.Departure_Datetime, " +
                                           "ts.Arrival_Datetime, ts.Destination, ts.Fare " +
                                           "FROM train_schedule ts " +
                                           "WHERE ts.Origin = ? OR ts.Destination = ?";
                            PreparedStatement pstmt = conn.prepareStatement(query);
                            pstmt.setString(1, station);
                            pstmt.setString(2, station);
                            rs = pstmt.executeQuery();

                            boolean hasResults = false;
                            while (rs.next()) {
                                hasResults = true;
                                String trainNo = rs.getString("Train_No");
                                String transitLine = rs.getString("Transit_Line_Name");
                                String origin = rs.getString("Origin");
                                Timestamp departureTime = rs.getTimestamp("Departure_Datetime");
                                Timestamp arrivalTime = rs.getTimestamp("Arrival_Datetime");
                                String destination = rs.getString("Destination");
                                float fare = rs.getFloat("Fare");

                                out.println("<div class='schedule-item'>");
                                out.println("<p><strong>Train No:</strong> " + trainNo + "</p>");
                                out.println("<p><strong>Transit Line:</strong> " + transitLine + "</p>");
                                out.println("<p><strong>Origin:</strong> " + origin + "</p>");
                                out.println("<p><strong>Destination:</strong> " + destination + "</p>");
                                out.println("<p><strong>Departure Time:</strong> " + departureTime + "</p>");
                                out.println("<p><strong>Arrival Time:</strong> " + arrivalTime + "</p>");
                                out.println("<p><strong>Fare:</strong> $" + fare + "</p>");
                                out.println("</div>");
                            }

                            if (!hasResults) {
                                out.println("<p>No train schedules found for the selected station.</p>");
                            }

                        } catch (SQLException e) {
                            e.printStackTrace();
                            out.println("<p style='color:red;'>Database error: " + e.getMessage() + "</p>");
                        } finally {
                            try {
                                if (rs != null) rs.close();
                                if (conn != null) conn.close();
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        }
                    }
                %>
            </div>
        </div>
    </main>
</body>
</html>
