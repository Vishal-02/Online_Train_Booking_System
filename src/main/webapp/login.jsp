<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>Login Page</title>
        <link rel="stylesheet" type="text/css" href="css/style.css">
    </head>
    
    <body>
        <div class="login-container">
            <h2>Login Page</h2>

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

                    if (request.getParameter("customerSubmit") != null) {
                        boolean custFlag = false;
                        String username = request.getParameter("username");
                        String password = request.getParameter("password");

                        String customerSQL = "SELECT * FROM customer WHERE username = '" + username + "' AND pswd = '" + password + "'";
                        rs = stmt.executeQuery(customerSQL);

                        if (rs.next()) {
                            custFlag = true;

                            // Store username in the session
                            session.setAttribute("username", username);
                        }

                        if (custFlag) {
                            response.sendRedirect("customer_homepage.jsp");
                        } else {
                            out.println("<p style='color:red;'>Invalid customer username or password. Please try again.</p>");
                        }
                    }

                    if (request.getParameter("employeeSubmit") != null) {
                        String username = request.getParameter("username");
                        String password = request.getParameter("password");

                        // Special case for manager1
                        if ("manager1".equals(username) && "m1pass".equals(password)) {
                            session.setAttribute("username", username);
                            response.sendRedirect("admin_homepage.jsp");
                        } else {
                            boolean empFlag = false;

                            String employeeSQL = "SELECT * FROM employee WHERE username = '" + username + "' AND pswd = '" + password + "'";
                            rs = stmt.executeQuery(employeeSQL);

                            if (rs.next()) {
                                empFlag = true;

                                // Store username in the session
                                session.setAttribute("username", username);
                            }

                            if (empFlag) {
                                response.sendRedirect("customer_rep_homepage.jsp");
                            } else {
                                out.println("<p style='color:red;'>Invalid employee username or password. Please try again.</p>");
                            }
                        }
                    }
                } catch (Exception e) {
                    out.println("<p style='color:red;'>Database connection error: " + e.getMessage() + "</p>");
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

            <h3>Customer Login</h3>
            <form method="post" action="login.jsp">
                <table>
                    <tr>
                        <td>Username:</td><td><input type="text" name="username" required></td>
                    </tr>
                    <tr>
                        <td>Password:</td><td><input type="password" name="password" required></td>
                    </tr>
                </table>
                <input type="submit" name="customerSubmit" value="Customer Login">
            </form>
            <br>

            <h3>Employee Login</h3>
            <form method="post" action="login.jsp">
                <table>
                    <tr>
                        <td>Username:</td><td><input type="text" name="username" required></td>
                    </tr>
                    <tr>
                        <td>Password:</td><td><input type="password" name="password" required></td>
                    </tr>
                </table>
                <input type="submit" name="employeeSubmit" value="Employee Login">
            </form>
        </div>
    </body>
</html>
