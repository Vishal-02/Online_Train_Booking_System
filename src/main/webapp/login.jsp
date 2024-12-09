<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<!DOCTYPE html>
<html>
<link href='https://fonts.googleapis.com/css?family=Poppins' rel='stylesheet'>

<style>
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@700&display=swap');
</style>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>Login Page</title>
        <link rel="stylesheet" type="text/css" href="css/style.css">
    </head>
    
    <body>
        <h2>Log in to your account to
        	<br>
        	<span class="shifted-text">access our services</span>
        </h2>
        
        <div class="login-container">

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
                            session.setAttribute("customerName", username);
                            System.out.println("Customer Username: " + username);
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

                        try {
                            // Query to fetch the employee's details
                            String employeeSQL = "SELECT SSN FROM employee WHERE username = ? AND pswd = ?";
                            PreparedStatement employeeStmt = conn.prepareStatement(employeeSQL);
                            employeeStmt.setString(1, username);
                            employeeStmt.setString(2, password);
                            rs = employeeStmt.executeQuery();

                            if (rs.next()) {
                                // Get the SSN of the logged-in employee
                                String ssn = rs.getString("SSN");

                                // Check if the SSN exists in the manager_admin table
                                String adminCheckSQL = "SELECT * FROM manager_admin WHERE SSN = ?";
                                PreparedStatement adminStmt = conn.prepareStatement(adminCheckSQL);
                                adminStmt.setString(1, ssn);
                                ResultSet adminRs = adminStmt.executeQuery();

                                if (adminRs.next()) {
                                    // If SSN matches in manager_admin table, redirect to admin homepage
                                    session.setAttribute("employeeName", username);
                                    response.sendRedirect("admin_homepage.jsp");
                                } else {
                                    // Check if the SSN exists in the customer_representative table
                                    String custRepCheckSQL = "SELECT * FROM customer_representative WHERE SSN = ?";
                                    PreparedStatement custRepStmt = conn.prepareStatement(custRepCheckSQL);
                                    custRepStmt.setString(1, ssn);
                                    ResultSet custRepRs = custRepStmt.executeQuery();

                                    if (custRepRs.next()) {
                                        // If SSN matches in customer_representative table, redirect to customer representative homepage
                                        session.setAttribute("employeeName", username);
                                        response.sendRedirect("customer_rep_homepage.jsp");
                                    } else {
                                        // If SSN doesn't match either table, show an error
                                        out.println("<p style='color:red;'>Access Denied: Unauthorized SSN.</p>");
                                    }
                                }
                            } else {
                                // If no employee is found with the given username and password
                                out.println("<p style='color:red;'>Invalid username or password. Please try again.</p>");
                            }
                        } catch (SQLException e) {
                            e.printStackTrace();
                            out.println("<p style='color:red;'>An error occurred. Please try again later.</p>");
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
            
			<hr style="border: 1px solid #aaa; margin: 20px 0;">
			
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
