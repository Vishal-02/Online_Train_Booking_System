<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Reservations List</title>
</head>
<body>
    <h2>Reservations List</h2>

    <form method="post" action="reservationsList.jsp">
        <label for="filterType">Select Filter Type:</label>
        <select name="filterType" required>
            <option value="transitLine">By Transit Line</option>
            <option value="customerName">By Customer</option>
        </select>
        <button type="submit">Generate List</button>
    </form>

    <%
        String URL = "jdbc:mysql://localhost:3306/railwaysystem";
        String User = "root";
        String Password = "fl3xwm3";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String filterType = request.getParameter("filterType");

        if (filterType != null) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(URL, User, Password);

                String sql = "";

                if (filterType.equals("transitLine")) {
                    sql = "SELECT ts.Transit_Line_Name, r.Reservation_No, r.Passenger, r.Date, r.No_of_Tickets, r.Total_Fare " +
                          "FROM Reservations r " +
                          "JOIN Train_Schedule ts ON DATE(r.Date) = DATE(ts.Departure_Datetime) " +
                          "ORDER BY ts.Transit_Line_Name, r.Date";
                } else if (filterType.equals("customerName")) {
                    sql = "SELECT r.Passenger AS CustomerName, r.Reservation_No, ts.Transit_Line_Name, r.Date, r.No_of_Tickets, r.Total_Fare " +
                          "FROM Reservations r " +
                          "JOIN Train_Schedule ts ON DATE(r.Date) = DATE(ts.Departure_Datetime) " +
                          "ORDER BY r.Passenger, r.Date";
                }

                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();

                if (filterType.equals("transitLine")) {
                    out.println("<h3>Reservations by Transit Line</h3>");
                    out.println("<table border='1'>");
                    out.println("<tr><th>Transit Line</th><th>Reservation No</th><th>Passenger</th><th>Date</th><th>Tickets</th><th>Total Fare ($)</th></tr>");
                    while (rs.next()) {
                        out.println("<tr>");
                        out.println("<td>" + rs.getString("Transit_Line_Name") + "</td>");
                        out.println("<td>" + rs.getString("Reservation_No") + "</td>");
                        out.println("<td>" + rs.getString("Passenger") + "</td>");
                        out.println("<td>" + rs.getDate("Date") + "</td>");
                        out.println("<td>" + rs.getInt("No_of_Tickets") + "</td>");
                        out.println("<td>" + rs.getDouble("Total_Fare") + "</td>");
                        out.println("</tr>");
                    }
                    out.println("</table>");
                } else if (filterType.equals("customerName")) {
                    out.println("<h3>Reservations by Customer</h3>");
                    out.println("<table border='1'>");
                    out.println("<tr><th>Customer Name</th><th>Reservation No</th><th>Transit Line</th><th>Date</th><th>Tickets</th><th>Total Fare ($)</th></tr>");
                    while (rs.next()) {
                        out.println("<tr>");
                        out.println("<td>" + rs.getString("CustomerName") + "</td>");
                        out.println("<td>" + rs.getString("Reservation_No") + "</td>");
                        out.println("<td>" + rs.getString("Transit_Line_Name") + "</td>");
                        out.println("<td>" + rs.getDate("Date") + "</td>");
                        out.println("<td>" + rs.getInt("No_of_Tickets") + "</td>");
                        out.println("<td>" + rs.getDouble("Total_Fare") + "</td>");
                        out.println("</tr>");
                    }
                    out.println("</table>");
                }

            } catch (Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        }
    %>
</body>
</html>
