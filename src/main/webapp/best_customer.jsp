<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Best Customer</title>
</head>
<body>
    <h2>Best Customer</h2>
    <%
        String URL = "jdbc:mysql://localhost:3306/railwaysystem";
        String User = "root";
        String Password = "fl3xwm3";

        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, User, Password);
            stmt = conn.createStatement();

            String sql = "SELECT Passenger, SUM(Total_Fare) AS TotalSpent " +
                         "FROM Reservations " +
                         "GROUP BY Passenger ORDER BY TotalSpent DESC LIMIT 1";
            rs = stmt.executeQuery(sql);

            if (rs.next()) {
                out.println("<p>Best Customer: " + rs.getString("Passenger") + "</p>");
                out.println("<p>Total Spent: $" + rs.getDouble("TotalSpent") + "</p>");
            }
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    %>
</body>
</html>
