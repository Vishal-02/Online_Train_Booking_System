<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Employees</title>
</head>
<body>
    <h2>Manage Employees</h2>
    <form method="post" action="employeeManagement.jsp">
        <label>SSN:</label><input type="text" name="ssn" required><br>
        <label>Action:</label>
        <select name="action">
            <option value="add">Add</option>
            <option value="edit">Edit</option>
            <option value="delete">Delete</option>
        </select><br>
        <label>First Name:</label><input type="text" name="first_name"><br>
        <label>Last Name:</label><input type="text" name="last_name"><br>
        <label>Username:</label><input type="text" name="username"><br>
        <label>Password:</label><input type="text" name="password"><br>
        <label>New SSN (For Edit):</label><input type="text" name="new_ssn"><br>
        <button type="submit">Submit</button>
    </form>

    <%
        String action = request.getParameter("action");
        String ssn = request.getParameter("ssn");
        String newSsn = request.getParameter("new_ssn");
        String firstName = request.getParameter("first_name");
        String lastName = request.getParameter("last_name");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        String URL = "jdbc:mysql://localhost:3306/railwaysystem";
        String User = "root";
        String Password = "fl3xwm3";

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            if (action != null) {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(URL, User, Password);

                if ("add".equals(action)) {
                    String sql = "INSERT INTO Employee (SSN, username, pswd, FirstName, LastName) VALUES (?, ?, ?, ?, ?)";
                    stmt = conn.prepareStatement(sql);
                    stmt.setString(1, ssn);
                    stmt.setString(2, username);
                    stmt.setString(3, password);
                    stmt.setString(4, firstName);
                    stmt.setString(5, lastName != null && !lastName.isEmpty() ? lastName : null);
                    stmt.executeUpdate();
                    out.println("<p>Employee added successfully.</p>");
                } else if ("edit".equals(action)) {
                    String sql = "UPDATE Employee SET SSN = ?, username = ?, pswd = ?, FirstName = ?, LastName = ? WHERE SSN = ?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setString(1, newSsn != null && !newSsn.isEmpty() ? newSsn : ssn);
                    stmt.setString(2, username);
                    stmt.setString(3, password);
                    stmt.setString(4, firstName);
                    stmt.setString(5, lastName != null && !lastName.isEmpty() ? lastName : null);
                    stmt.setString(6, ssn);
                    stmt.executeUpdate();
                    out.println("<p>Employee information updated successfully.</p>");
                } else if ("delete".equals(action)) {
                    String sql = "DELETE FROM Employee WHERE SSN = ?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setString(1, ssn);
                    stmt.executeUpdate();
                    out.println("<p>Employee deleted successfully.</p>");
                }
            }
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    %>
</body>
</html>
