<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Search Train Schedules</title>
        <style>
            table {
                border-collapse: collapse;
                width: 100%;
            }
            table, th, td {
                border: 1px solid black;
            }
            th, td {
                text-align: left;
                padding: 8px;
            }
            th {
                background-color: #f2f2f2;
            }
        </style>
    </head>
    <body>
        <h2>Search Train Schedules</h2>

        <!-- Search Form -->
        <form method="post" action="search.jsp">
            <label>Origin:</label>
            <input type="text" name="origin"><br>
            <label>Destination:</label>
            <input type="text" name="destination"><br>
            <label>Date:</label>
            <input type="date" name="travel_date"><br>
            <label>Sort By:</label>
            <select name="sort_by">
                <option value="Departure_Datetime">Departure Time</option>
                <option value="Arrival_Datetime">Arrival Time</option>
                <option value="Fare">Fare</option>
            </select><br>
            <label>Order:</label>
            <select name="sort_order">
                <option value="ASC">Ascending</option>
                <option value="DESC">Descending</option>
            </select><br><br>
            <button type="submit">Search</button>
        </form>

        <h3>Available Train Schedules</h3>

        <%
            String URL = "jdbc:mysql://localhost:3306/railwaysystem";
            String User = "root";  
            String Password = "fl3xwm3";  

            String origin = request.getParameter("origin");
            String destination = request.getParameter("destination");
            String travelDate = request.getParameter("travel_date");
            String sortBy = request.getParameter("sort_by");
            String sortOrder = request.getParameter("sort_order");

            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(URL, User, Password);

                String sql = "SELECT Train_No, Transit_Line_Name, Origin, Destination, Departure_Datetime, Arrival_Datetime, Fare, Stops " +
                             "FROM Train_Schedule";

                // Build query based on filters
                if (origin != null && destination != null && travelDate != null && !origin.isEmpty() && !destination.isEmpty() && !travelDate.isEmpty()) {
                    sql += " WHERE Origin = ? AND Destination = ? AND DATE(Departure_Datetime) = ?";
                }

                if (sortBy != null && !sortBy.isEmpty() && sortOrder != null && !sortOrder.isEmpty()) {
                    sql += " ORDER BY " + sortBy + " " + sortOrder;
                }

                stmt = conn.prepareStatement(sql);

                if (origin != null && destination != null && travelDate != null && !origin.isEmpty() && !destination.isEmpty() && !travelDate.isEmpty()) {
                    stmt.setString(1, origin);
                    stmt.setString(2, destination);
                    stmt.setString(3, travelDate);
                }

                rs = stmt.executeQuery();

                // Display Results
                out.println("<table>");
                out.println("<tr><th>Train No</th><th>Transit Line</th><th>Origin</th><th>Destination</th><th>Departure</th><th>Arrival</th><th>Fare</th><th>Stops</th></tr>");
                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getString("Train_No") + "</td>");
                    out.println("<td>" + rs.getString("Transit_Line_Name") + "</td>");
                    out.println("<td>" + rs.getString("Origin") + "</td>");
                    out.println("<td>" + rs.getString("Destination") + "</td>");
                    out.println("<td>" + rs.getString("Departure_Datetime") + "</td>");
                    out.println("<td>" + rs.getString("Arrival_Datetime") + "</td>");
                    out.println("<td>$" + rs.getFloat("Fare") + "</td>");
                    out.println("<td>" + rs.getString("Stops") + "</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
            } catch (Exception e) {
                out.println("<p style='color:red;'>Database error: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>
    </body>
</html>
