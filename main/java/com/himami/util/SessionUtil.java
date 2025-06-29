package com.himami.util;

import java.security.SecureRandom;
import java.util.Base64;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

public class SessionUtil {
    
    private static final ConcurrentMap<String, Integer> activeSessions = new ConcurrentHashMap<>();
    private static final SecureRandom secureRandom = new SecureRandom();
    
    public static String generateSessionToken(int userId) {
        byte[] tokenBytes = new byte[32];
        secureRandom.nextBytes(tokenBytes);
        String token = Base64.getUrlEncoder().withoutPadding().encodeToString(tokenBytes);
        
        // Store session
        activeSessions.put(token, userId);
        
        return token;
    }
    
    public static Integer getUserIdFromToken(String token) {
        return activeSessions.get(token);
    }
    
    public static boolean isValidSession(String token) {
        return activeSessions.containsKey(token);
    }
    
    public static void invalidateSession(String token) {
        activeSessions.remove(token);
    }
    
    public static void clearAllSessions() {
        activeSessions.clear();
    }
    
    public static int getActiveSessionCount() {
        return activeSessions.size();
    }
}
