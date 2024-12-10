<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Revenue Report</title>
</head>
<body>
    <h2>Revenue Report</h2>

    <form method="post" action="revenueReport.jsp">
        <label for="reportType">Select Report Type:</label>
        <select name="reportType" required>
            <option value="transitLine">By Transit Line</option>
            <option value="customerName">By Customer</option>
        </select>
        <button type="submit">Generate Report</button>
    </form>

    <%
        String URL = "jdbc:mysql://localhost:3306/railwaysystem";
        String User = "root";
        String Password = "fl3xwm3";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String reportType = request.getParameter("reportType");

        if (reportType != null) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(URL, User, Password);

                String sql = "";

                if (reportType.equals("transitLine")) {
                    sql = "SELECT ts.Transit_Line_Name, SUM(r.Total_Fare) AS TotalRevenue " +
                          "FROM Reservations r " +
                          "JOIN Train_Schedule ts ON DATE(r.Date) = DATE(ts.Departure_Datetime) " +
                          "GROUP BY ts.Transit_Line_Name";
                } else if (reportType.equals("customerName")) {
                    sql = "SELECT r.Passenger AS CustomerName, SUM(r.Total_Fare) AS TotalRevenue " +
                          "FROM Reservations r " +
                          "GROUP BY r.Passenger";
                }

                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();

                if (reportType.equals("transitLine")) {
                    out.println("<h3>Revenue by Transit Line</h3>");
                    out.println("<table border='1'>");
                    out.println("<tr><th>Transit Line</th><th>Total Revenue ($)</th></tr>");
                    while (rs.next()) {
                        out.println("<tr>");
                        out.println("<td>" + rs.getString("Transit_Line_Name") + "</td>");
                        out.println("<td>" + rs.getDouble("TotalRevenue") + "</td>");
                        out.println("</tr>");
                    }
                    out.println("</table>");
                } else if (reportType.equals("customerName")) {
                    out.println("<h3>Revenue by Customer</h3>");
                    out.println("<table border='1'>");
                    out.println("<tr><th>Customer Name</th><th>Total Revenue ($)</th></tr>");
                    while (rs.next()) {
                        out.println("<tr>");
                        out.println("<td>" + rs.getString("CustomerName") + "</td>");
                        out.println("<td>" + rs.getDouble("TotalRevenue") + "</td>");
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
