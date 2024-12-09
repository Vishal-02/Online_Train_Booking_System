<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Date, java.sql.Timestamp" %>
<html>
<head>
    <title>Manage Train Schedules</title>
</head>
<body>
    <h2>Manage Train Schedules</h2>

    <form action="edit_train_schedule.jsp" method="GET">
        <label for="transit_line">Select Transit Line:</label>
        <select name="transit_line" id="transit_line">
            <option value="">-- Select Transit Line --</option>
            <%
                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;
                try {
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/railwaysystem", "root", "fl3xwm3");
                    String query = "SELECT DISTINCT Transit_Line_Name FROM train_schedule";
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery(query);
                    while (rs.next()) {
                        String transitLineName = rs.getString("Transit_Line_Name");
                        out.println("<option value='" + transitLineName + "'>" + transitLineName + "</option>");
                    }
                } catch (SQLException e) {
                    out.println("<p>Error fetching transit lines: " + e.getMessage() + "</p>");
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        out.println("<p>Error closing database resources: " + e.getMessage() + "</p>");
                    }
                }
            %>
        </select>
        <input type="submit" value="Search">
    </form>

    <%
        String transitLine = request.getParameter("transit_line");
        
        // If a transit line is selected, fetch and display the schedule
        if (transitLine != null && !transitLine.isEmpty()) {
            out.println("<h3>Schedules for Transit Line: " + transitLine + "</h3>");

            // Fetch train schedules for the selected transit line
            conn = null;
            PreparedStatement ps = null;
            rs = null;

            try {
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/railwaysystem", "root", "fl3xwm3");
                String query = "SELECT * FROM train_schedule WHERE Transit_Line_Name = ?";
                ps = conn.prepareStatement(query);
                ps.setString(1, transitLine);
                rs = ps.executeQuery();

                // Display schedule in a table
                out.println("<table border='1'>");
                out.println("<tr><th>Train No</th><th>Origin</th><th>Departure Datetime</th><th>Destination</th><th>Fare</th><th>Action</th></tr>");

                while (rs.next()) {
                    String trainNo = rs.getString("Train_No");
                    String origin = rs.getString("Origin");
                    Timestamp departureDatetime = rs.getTimestamp("Departure_Datetime");
                    String destination = rs.getString("Destination");
                    float fare = rs.getFloat("Fare");

                    out.println("<tr>");
                    out.println("<td>" + trainNo + "</td>");
                    out.println("<td>" + origin + "</td>");
                    out.println("<td>" + departureDatetime + "</td>");
                    out.println("<td>" + destination + "</td>");
                    out.println("<td>" + fare + "</td>");
                    out.println("<td>");
                    out.println("<a href='edit_train_schedule.jsp?action=edit&departureDatetime=" + departureDatetime.getTime() + "'>Edit</a> | ");
                    out.println("<a href='edit_train_schedule.jsp?action=delete&departureDatetime=" + departureDatetime.getTime() + "'>Delete</a>");
                    out.println("</td>");
                    out.println("</tr>");
                }

                out.println("</table>");

            } catch (SQLException e) {
                out.println("<p>Error fetching train schedules: " + e.getMessage() + "</p>");
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    out.println("<p>Error closing database resources: " + e.getMessage() + "</p>");
                }
            }
        }

        // Handle Delete Action
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            String departureDatetimeStr = request.getParameter("departureDatetime");
            if (departureDatetimeStr != null) {
                // Convert departureDatetimeStr (milliseconds) to a java.sql.Timestamp
                long departureDatetimeMillis = Long.parseLong(departureDatetimeStr);
                Timestamp departureDatetime = new Timestamp(departureDatetimeMillis);

                // Delete the train schedule based on Departure Datetime
                conn = null;
                PreparedStatement ps = null;

                try {
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/railwaysystem", "root", "fl3xwm3");
                    String query = "DELETE FROM train_schedule WHERE Departure_Datetime = ?";
                    ps = conn.prepareStatement(query);
                    ps.setTimestamp(1, departureDatetime);  // Use Timestamp to match the column format
                    int rowsAffected = ps.executeUpdate();

                    if (rowsAffected > 0) {
                        out.println("<p>Train schedule deleted successfully.</p>");
                    } else {
                        out.println("<p>Error deleting train schedule.</p>");
                    }
                } catch (SQLException e) {
                    out.println("<p>Error deleting train schedule: " + e.getMessage() + "</p>");
                } finally {
                    try {
                        if (ps != null) ps.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        out.println("<p>Error closing database resources: " + e.getMessage() + "</p>");
                    }
                }
            }
        }

        // Handle POST requests for editing the train schedule
        if (request.getMethod().equalsIgnoreCase("POST")) {
            String departureDatetimeStr = request.getParameter("departureDatetime");
            if (departureDatetimeStr != null) {
                // Update train schedule logic here
            }
        }
    %>
</body>
</html>
