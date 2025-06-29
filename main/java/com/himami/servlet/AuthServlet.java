package com.himami.servlet;

import com.himami.model.User;
import com.himami.storage.DataStorage;
import com.himami.util.JsonUtil;
import com.himami.util.ResponseUtil;
import com.himami.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/auth")
public class AuthServlet extends HttpServlet {
    
    private DataStorage dataStorage;
    
    @Override
    public void init() throws ServletException {
        super.init();
        dataStorage = DataStorage.getInstance();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Parse JSON request body
            Map<String, Object> requestData = JsonUtil.parseJsonRequest(request);
            
            String username = requestData.get("username").toString();
            String password = requestData.get("password").toString();
            String language = requestData.getOrDefault("language", "id").toString();
            
            // Validate required fields
            if (username == null || username.trim().isEmpty() || 
                password == null || password.trim().isEmpty()) {
                
                String errorMessage = language.equals("id") ? 
                    "Username dan password harus diisi" : 
                    "Username and password are required";
                    
                ResponseUtil.sendJsonResponse(response, 
                    ResponseUtil.createErrorResponse(errorMessage));
                return;
            }
            
            // Authenticate user using simple if-else logic
            if (!dataStorage.authenticateUser(username, password)) {
                String errorMessage = language.equals("id") ? 
                    "Username atau password salah" : 
                    "Invalid username or password";
                    
                ResponseUtil.sendJsonResponse(response, 
                    ResponseUtil.createErrorResponse(errorMessage));
                return;
            }
            
            // Get user data
            User user = dataStorage.getUserByUsername(username);
            if (user == null) {
                String errorMessage = language.equals("id") ? 
                    "User tidak ditemukan" : 
                    "User not found";
                    
                ResponseUtil.sendJsonResponse(response, 
                    ResponseUtil.createErrorResponse(errorMessage));
                return;
            }
            
            // Create session token
            String sessionToken = SessionUtil.generateSessionToken(user.getId());
            
            // Prepare response data
            Map<String, Object> userData = new HashMap<>();
            userData.put("id", user.getId());
            userData.put("username", user.getUsername());
            userData.put("email", user.getEmail());
            userData.put("fullName", user.getFullName());
            userData.put("role", user.getRole());
            
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("user", userData);
            responseData.put("token", sessionToken);
            
            String successMessage = language.equals("id") ? 
                "Login berhasil" : 
                "Login successful";
            
            ResponseUtil.sendJsonResponse(response, 
                ResponseUtil.createSuccessResponse(responseData, successMessage));
            
        } catch (Exception e) {
            e.printStackTrace();
            ResponseUtil.sendJsonResponse(response, 
                ResponseUtil.createErrorResponse("Internal server error"));
        }
    }
}
