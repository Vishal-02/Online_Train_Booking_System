<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FAQ Page</title>
    <link rel="stylesheet" type="text/css" href="css/faq.css">
</head>
<body>
    <header class="header-container">
        <a href="customer_rep_homepage.jsp" class="home-btn">Home</a>
        <h1>Frequently Asked Questions</h1>
        <a href="login.jsp" class="logout-btn">Logout</a>
    </header>

    <main>
        <div class="faq-container">
            <div class="search-container">
                <input type="text" id="searchInput" placeholder="Search questions...">
                <button onclick="searchQuestions()">Search</button>
            </div>

            <div id="faqList">
                <!-- FAQ items will be dynamically loaded here -->
            </div>

            <%
                // Placeholder for backend logic to determine user role
                boolean isCustomerRep = true; // This should be dynamically set based on user role
            %>

            <% if (isCustomerRep) { %>
                <div class="reply-section">
                    <h3>Reply to a Question</h3>
                    <select id="questionSelect">
                        <option value="">Select a question</option>
                        <!-- Options will be dynamically populated -->
                    </select>
                    <textarea id="replyText" placeholder="Type your reply here..."></textarea>
                    <button onclick="submitReply()">Submit Reply</button>
                </div>
            <% } else { %>
                <div class="ask-question-section">
                    <h3>Ask a New Question</h3>
                    <textarea id="newQuestion" placeholder="Type your question here..."></textarea>
                    <button onclick="submitQuestion()">Submit Question</button>
                </div>
            <% } %>
        </div>
    </main>

    <script>
        function searchQuestions() {
            // Placeholder for search functionality
            console.log("Searching questions...");
        }

        function submitReply() {
            // Placeholder for reply submission
            console.log("Submitting reply...");
        }

        function submitQuestion() {
            // Placeholder for question submission
            console.log("Submitting question...");
        }

        // Placeholder for loading FAQ items
        window.onload = function() {
            const faqList = document.getElementById('faqList');
            // This would typically be loaded from a backend API
            const faqItems = [
                { question: "How do I book a ticket?", answer: "You can book a ticket through our website or mobile app." },
                { question: "What is the refund policy?", answer: "Refunds are available up to 24 hours before departure." }
            ];

            faqItems.forEach(item => {
                const faqItem = document.createElement('div');
                faqItem.className = 'faq-item';
                faqItem.innerHTML = `
                    <h3>${item.question}</h3>
                    <p>${item.answer}</p>
                `;
                faqList.appendChild(faqItem);
            });
        };
    </script>
</body>
</html>