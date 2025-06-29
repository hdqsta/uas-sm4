package com.himami.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {
    
    private static final int SALT_ROUNDS = 12;
    
    /**
     * Hash a password using BCrypt
     * @param plainPassword The plain text password
     * @return The hashed password
     */
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(SALT_ROUNDS));
    }
    
    /**
     * Verify a password against its hash
     * @param plainPassword The plain text password
     * @param hashedPassword The hashed password
     * @return true if password matches, false otherwise
     */
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * Check if password meets minimum requirements
     * @param password The password to check
     * @return true if password is valid, false otherwise
     */
    public static boolean isValidPassword(String password) {
        if (password == null || password.length() < 6) {
            return false;
        }
        
        // Check for at least one letter and one number
        boolean hasLetter = password.matches(".*[a-zA-Z].*");
        boolean hasNumber = password.matches(".*\\d.*");
        
        return hasLetter && hasNumber;
    }
    
    /**
     * Generate a random password
     * @param length The length of the password
     * @return A random password
     */
    public static String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder password = new StringBuilder();
        
        for (int i = 0; i < length; i++) {
            int index = (int) (Math.random() * chars.length());
            password.append(chars.charAt(index));
        }
        
        return password.toString();
    }
}
