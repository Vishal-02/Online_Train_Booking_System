<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, java.util.*" %>
<html>
<head>
    <title>Customer Reservations</title>
</head>
<body>
    <h2>Customer Reservations</h2>
    
    <!-- Form for selecting transit line and date -->
    <form action="customer_reservations.jsp" method="GET">
        <label for="transit_line">Select Transit Line:</label>
        <select name="transit_line" id="transit_line" required>
            <option value="">-- Select Transit Line --</option>
            <%
                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;
                try {
                    // Step 1: Connect to the database
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/railwaysystem", "root", "fl3xwm3");
                    
                    // Step 2: Prepare SQL query to fetch transit lines
                    String query = "SELECT DISTINCT Transit_Line_Name FROM train_schedule";
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery(query);
                    
                    // Step 3: Populate dropdown with transit lines
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
        <br><br>
        
        <label for="date">Select Date:</label>
        <input type="date" name="date" id="date" required>
        <br><br>
        
        <input type="submit" value="Search">
    </form>

    <%
        // Fetch the form parameters
        String transitLine = request.getParameter("transit_line");
        String date = request.getParameter("date");

        // Print out parameters for debugging purposes
        if (transitLine != null && date != null) {
            out.println("<p><strong>Selected Transit Line:</strong> " + transitLine + "</p>");
            out.println("<p><strong>Selected Date:</strong> " + date + "</p>");

            // Database variables
            conn = null;
            PreparedStatement ps = null;
            rs = null;

            try {
                // Step 1: Connect to the database
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/railwaysystem", "root", "fl3xwm3");

                // Step 2: SQL query to fetch reservations for selected transit line and date
                String query = "SELECT r.Passenger, r.Reservation_No, r.Date, r.Total_Fare, r.No_of_Tickets " +
                               "FROM reservations r " +
                               "JOIN train_schedule ts ON DATE(ts.Departure_Datetime) = ? " +
                               "WHERE ts.Transit_Line_Name = ?";
                
                ps = conn.prepareStatement(query);
                ps.setString(1, date);  // Set the date parameter
                ps.setString(2, transitLine);  // Set the transit line parameter

                // Step 3: Execute query
                rs = ps.executeQuery();
                boolean hasResults = false;

                // Step 4: Process the results
                while (rs.next()) {
                    hasResults = true;
                    String passenger = rs.getString("Passenger");
                    String reservationNo = rs.getString("Reservation_No");
                    java.sql.Date reservationDate = rs.getDate("Date");
                    float totalFare = rs.getFloat("Total_Fare");
                    int noOfTickets = rs.getInt("No_of_Tickets");

                    // Display the reservation details
                    out.println("<div class='reservation-item'>");
                    out.println("<p><strong>Passenger:</strong> " + passenger + "</p>");
                    out.println("<p><strong>Reservation No:</strong> " + reservationNo + "</p>");
                    out.println("<p><strong>Reservation Date:</strong> " + reservationDate + "</p>");
                    out.println("<p><strong>Total Fare:</strong> $" + totalFare + "</p>");
                    out.println("<p><strong>No of Tickets:</strong> " + noOfTickets + "</p>");
                    out.println("</div>");
                }

                // If no results were found
                if (!hasResults) {
                    out.println("<p>No reservations found for this transit line on the selected date.</p>");
                }
            } catch (SQLException e) {
                // Handle SQL exceptions
                out.println("<p>Error connecting to the database: " + e.getMessage() + "</p>");
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
    %>
</body>
</html>
