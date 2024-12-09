<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer FAQ</title>
    <link href="css/customer_rep_faq.css" rel="stylesheet">
</head>
<body>	
    <header>
        <a href="customer_rep_homepage.jsp" class="back-btn">Back to Homepage</a>
    </header>
    <main>
        <div class="faq-container">
            <h1>Customer FAQ</h1>
            <form method="GET" action="cust_rep_faq.jsp">
                <input type="text" name="search" placeholder="Search questions..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>" />
                <button type="submit">Search</button>
            </form>

            <div class="faq-list">
                <%
                    Connection conn = null;
                    PreparedStatement stmt = null, updateStmt = null;
                    ResultSet rs = null;
                    String searchQuery = request.getParameter("search");

                    try {
                        // Load JDBC Driver
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/railwaysystem", "root", "fl3xwm3");

                        // Reply to a question if the form is submitted
                        if (request.getParameter("replySubmit") != null) {
                            String reply = request.getParameter("reply");
                            int questionId = Integer.parseInt(request.getParameter("questionId"));
                            String username = (String) session.getAttribute("employeeName");

                            String updateQuery = "UPDATE questions SET reply = ?, cust_rep_username = ? WHERE question_id = ?";
                            updateStmt = conn.prepareStatement(updateQuery);
                            updateStmt.setString(1, reply);
                            updateStmt.setString(2, username);
                            updateStmt.setInt(3, questionId);
                            updateStmt.executeUpdate();

                            out.println("<p style='color:green;'>Reply submitted successfully!</p>");
                        }

                        // Fetch questions based on search or show all
                        String query = "SELECT * FROM questions";
                        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                            query += " WHERE question LIKE ? OR reply LIKE ?";
                            stmt = conn.prepareStatement(query);
                            stmt.setString(1, "%" + searchQuery + "%");
                            stmt.setString(2, "%" + searchQuery + "%");
                        } else {
                            stmt = conn.prepareStatement(query);
                        }
                        rs = stmt.executeQuery();

                        // Display Questions
                        boolean hasResults = false;
                        while (rs.next()) {
                            hasResults = true;
                            int id = rs.getInt("question_id");
                            String question = rs.getString("question");
                            String reply = rs.getString("reply");
                            String customerUsername = rs.getString("customer_username");
                            String custRepUsername = rs.getString("cust_rep_username");

                            out.println("<div class='faq-item'>");
                            out.println("<p><strong>Customer:</strong> " + customerUsername + "</p>");
                            out.println("<p><strong>Question:</strong> " + question + "</p>");
                            if (reply == null || reply.trim().isEmpty()) {
                                // Unanswered Question
                                out.println("<form method='POST' action='cust_rep_faq.jsp'>");
                                out.println("<textarea name='reply' placeholder='Write your reply here...' required></textarea>");
                                out.println("<input type='hidden' name='questionId' value='" + id + "' />");
                                out.println("<button type='submit' name='replySubmit'>Submit Reply</button>");
                                out.println("</form>");
                            } else {
                                // Answered Question
                                out.println("<p><strong>Answer:</strong> " + reply + "</p>");
                                out.println("<p><strong>Answered by:</strong> " + custRepUsername + "</p>");
                            }
                            out.println("</div>");
                        }

                        if (!hasResults) {
                            out.println("<p>No questions found.</p>");
                        }
                    } catch (ClassNotFoundException e) {
                        e.printStackTrace();
                        out.println("<p style='color:red;'>JDBC Driver not found. Ensure MySQL connector is in the classpath.</p>");
                    } catch (SQLException e) {
                        e.printStackTrace();
                        out.println("<p style='color:red;'>Database error: " + e.getMessage() + "</p>");
                    } finally {
                        try {
                            if (rs != null) rs.close();
                            if (stmt != null) stmt.close();
                            if (updateStmt != null) updateStmt.close();
                            if (conn != null) conn.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                            out.println("<p style='color:red;'>Error closing database resources: " + e.getMessage() + "</p>");
                        }
                    }
                %>
            </div>
        </div>
    </main>
</body>
</html>


