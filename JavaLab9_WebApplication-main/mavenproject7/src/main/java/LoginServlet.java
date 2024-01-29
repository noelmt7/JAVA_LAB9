/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Base64;
import java.util.Date;

public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/Login", "root", "");

            // Check if the user is already logged in
            HttpSession existingSession = request.getSession(false);
            if (existingSession != null && existingSession.getAttribute("username") != null) {
                // User is already logged in
                response.sendRedirect("alreadyLoggedIn.jsp");
                con.close();
                return;
            }

            PreparedStatement pst = con.prepareStatement("SELECT * FROM Log WHERE username=? AND password=?");
            pst.setString(1, username);
            pst.setString(2, password);

            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                byte[] imageData = rs.getBytes("image_data");
                String base64Image = Base64.getEncoder().encodeToString(imageData);
                session.setAttribute("profileImage", base64Image);
                session.setAttribute("loginTime", new Date());
                insertLoginRecord(con, username, false);
                response.sendRedirect("welcome.jsp");
            } else {
                // Login failed
                PrintWriter out = response.getWriter();
                out.println("Invalid username or password");
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void insertLoginRecord(Connection con, String username, boolean isLogout) throws Exception {
    String columnName = isLogout ? "logout_time" : "login_time";
    String query = "UPDATE user_sessions SET " + columnName + " = ? WHERE username = ?";
    try (PreparedStatement pst = con.prepareStatement(query)) {
        pst.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
        pst.setString(2, username);
        pst.executeUpdate();
    }
}


}
