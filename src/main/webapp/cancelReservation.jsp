<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>Cancel Reservation</title>
    </head>
    <body>
        <%
            String reservationNo = request.getParameter("reservationNo");

            if (reservationNo == null || reservationNo.isEmpty()) {
                out.println("<p style='color:red;'>Invalid Reservation Number.</p>");
                return;
            }

            String URL = "jdbc:mysql://localhost:3306/railwaysystem";
            String User = "root";
            String Password = "fl3xwm3";
            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(URL, User, Password);

                String deleteQuery = "DELETE FROM Reservations WHERE Reservation_No = ?";
                pstmt = conn.prepareStatement(deleteQuery);
                pstmt.setString(1, reservationNo);

                int rowsAffected = pstmt.executeUpdate();
                if (rowsAffected > 0) {
                    out.println("<p style='color:green;'>Reservation " + reservationNo + " has been successfully canceled.</p>");
                } else {
                    out.println("<p style='color:red;'>Failed to cancel reservation. Please try again.</p>");
                }
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            } finally {
                try {
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException ex) {
                    out.println("<p style='color:red;'>Error closing resources: " + ex.getMessage() + "</p>");
                }
            }
        %>
        <form action="viewReservations.jsp" method="get" style="margin-top: 20px;">
            <button type="submit">Back to My Reservations</button>
        </form>
    </body>
</html>
