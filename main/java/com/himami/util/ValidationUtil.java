package com.himami.util;

import java.util.regex.Pattern;

public class ValidationUtil {
    
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
        "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$"
    );
    
    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[a-zA-Z0-9_]{3,20}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^(\\+62|62|0)[0-9]{9,13}$");
    
    /**
     * Validate email format
     */
    public static boolean isValidEmail(String email) {
        return email != null && EMAIL_PATTERN.matcher(email).matches();
    }
    
    /**
     * Validate username format
     */
    public static boolean isValidUsername(String username) {
        return username != null && USERNAME_PATTERN.matcher(username).matches();
    }
    
    /**
     * Validate Indonesian phone number
     */
    public static boolean isValidPhoneNumber(String phone) {
        return phone != null && PHONE_PATTERN.matcher(phone).matches();
    }
    
    /**
     * Validate required field
     */
    public static boolean isNotEmpty(String value) {
        return value != null && !value.trim().isEmpty();
    }
    
    /**
     * Validate string length
     */
    public static boolean isValidLength(String value, int minLength, int maxLength) {
        if (value == null) return false;
        int length = value.trim().length();
        return length >= minLength && length <= maxLength;
    }
    
    /**
     * Sanitize input string
     */
    public static String sanitizeInput(String input) {
        if (input == null) return null;
        return input.trim().replaceAll("[<>\"'&]", "");
    }
    
    /**
     * Check if string contains only letters and spaces
     */
    public static boolean isValidName(String name) {
        return name != null && name.matches("^[a-zA-Z\\s]{2,50}$");
    }
}
