<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Top 5 Most Active Transit Lines</title>
</head>
<body>
    <h2>Top 5 Most Active Transit Lines</h2>

    <%
        String URL = "jdbc:mysql://localhost:3306/railwaysystem";
        String User = "root";
        String Password = "fl3xwm3";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, User, Password);

            String sqlActiveLines = "SELECT ts.Transit_Line_Name, COUNT(r.Reservation_No) AS ReservationCount " +
                                    "FROM Reservations r " +
                                    "JOIN Train_Schedule ts ON DATE(r.Date) = DATE(ts.Departure_Datetime) " +
                                    "GROUP BY ts.Transit_Line_Name " +
                                    "ORDER BY ReservationCount DESC " +
                                    "LIMIT 5";

            pstmt = conn.prepareStatement(sqlActiveLines);
            rs = pstmt.executeQuery();

            out.println("<table border='1'>");
            out.println("<tr><th>Transit Line</th><th>Number of Reservations</th></tr>");
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getString("Transit_Line_Name") + "</td>");
                out.println("<td>" + rs.getInt("ReservationCount") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    %>
</body>
</html>
