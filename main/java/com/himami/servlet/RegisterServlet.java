package com.himami.servlet;

import com.himami.model.User;
import com.himami.storage.DataStorage;
import com.himami.util.JsonUtil;
import com.himami.util.PasswordUtil;
import com.himami.util.ResponseUtil;
import com.himami.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/register")
public class RegisterServlet extends HttpServlet {
    
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
            String language = requestData.getOrDefault("language", "id").toString();
            
            // Extract user data
            String username = (String) requestData.get("username");
            String email = (String) requestData.get("email");
            String password = (String) requestData.get("password");
            String confirmPassword = (String) requestData.get("confirmPassword");
            String fullName = (String) requestData.get("fullName");
            
            // Validate input
            Map<String, String> validationErrors = validateRegistrationData(
                username, email, password, confirmPassword, fullName, language
            );
            
            if (!validationErrors.isEmpty()) {
                ResponseUtil.sendJsonResponse(response, 
                    ResponseUtil.createValidationErrorResponse(validationErrors));
                return;
            }
            
            // Check if username already exists
            if (dataStorage.isUsernameExists(username)) {
                String errorMessage = language.equals("id") ? 
                    "Username sudah digunakan" : 
                    "Username already exists";
                ResponseUtil.sendJsonResponse(response, 
                    ResponseUtil.createErrorResponse(errorMessage));
                return;
            }
            
            // Check if email already exists
            if (dataStorage.isEmailExists(email)) {
                String errorMessage = language.equals("id") ? 
                    "Email sudah terdaftar" : 
                    "Email already registered";
                ResponseUtil.sendJsonResponse(response, 
                    ResponseUtil.createErrorResponse(errorMessage));
                return;
            }
            
            // Create new user
            User newUser = new User();
            newUser.setUsername(username);
            newUser.setEmail(email);
            newUser.setPasswordHash(PasswordUtil.hashPassword(password));
            newUser.setFullName(fullName);
            newUser.setRole("member"); // Default role
            
            // Save user to storage
            boolean success = dataStorage.addUser(newUser);
            
            if (success) {
                // Prepare response data (without password hash)
                Map<String, Object> userData = new HashMap<>();
                userData.put("id", newUser.getId());
                userData.put("username", newUser.getUsername());
                userData.put("email", newUser.getEmail());
                userData.put("fullName", newUser.getFullName());
                userData.put("role", newUser.getRole());
                
                String successMessage = language.equals("id") ? 
                    "Registrasi berhasil! Silakan login dengan akun Anda." : 
                    "Registration successful! Please login with your account.";
                
                ResponseUtil.sendJsonResponse(response, 
                    ResponseUtil.createSuccessResponse(userData, successMessage));
            } else {
                String errorMessage = language.equals("id") ? 
                    "Gagal membuat akun. Silakan coba lagi." : 
                    "Failed to create account. Please try again.";
                ResponseUtil.sendJsonResponse(response, 
                    ResponseUtil.createErrorResponse(errorMessage));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            String errorMessage = "Internal server error";
            ResponseUtil.sendJsonResponse(response, 
                ResponseUtil.createErrorResponse(errorMessage));
        }
    }
    
    private Map<String, String> validateRegistrationData(String username, String email, 
            String password, String confirmPassword, String fullName, String language) {
        
        Map<String, String> errors = new HashMap<>();
        
        // Validate username
        if (username == null || username.trim().isEmpty()) {
            errors.put("username", language.equals("id") ? 
                "Username harus diisi" : "Username is required");
        } else if (username.length() < 3) {
            errors.put("username", language.equals("id") ? 
                "Username minimal 3 karakter" : "Username must be at least 3 characters");
        } else if (!ValidationUtil.isValidUsername(username)) {
            errors.put("username", language.equals("id") ? 
                "Username hanya boleh mengandung huruf, angka, dan underscore" : 
                "Username can only contain letters, numbers, and underscores");
        }
        
        // Validate email
        if (email == null || email.trim().isEmpty()) {
            errors.put("email", language.equals("id") ? 
                "Email harus diisi" : "Email is required");
        } else if (!ValidationUtil.isValidEmail(email)) {
            errors.put("email", language.equals("id") ? 
                "Format email tidak valid" : "Invalid email format");
        }
        
        // Validate full name
        if (fullName == null || fullName.trim().isEmpty()) {
            errors.put("fullName", language.equals("id") ? 
                "Nama lengkap harus diisi" : "Full name is required");
        } else if (fullName.length() < 2) {
            errors.put("fullName", language.equals("id") ? 
                "Nama lengkap minimal 2 karakter" : "Full name must be at least 2 characters");
        }
        
        // Validate password
        if (password == null || password.trim().isEmpty()) {
            errors.put("password", language.equals("id") ? 
                "Password harus diisi" : "Password is required");
        } else if (!PasswordUtil.isValidPassword(password)) {
            errors.put("password", language.equals("id") ? 
                "Password minimal 6 karakter dan mengandung huruf serta angka" : 
                "Password must be at least 6 characters with letters and numbers");
        }
        
        // Validate confirm password
        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            errors.put("confirmPassword", language.equals("id") ? 
                "Konfirmasi password harus diisi" : "Confirm password is required");
        } else if (!password.equals(confirmPassword)) {
            errors.put("confirmPassword", language.equals("id") ? 
                "Konfirmasi password tidak cocok" : "Passwords do not match");
        }
        
        return errors;
    }
}
