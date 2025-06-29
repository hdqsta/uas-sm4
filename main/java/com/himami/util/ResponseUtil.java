package com.himami.util;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ResponseUtil {
    
    public static void sendJsonResponse(HttpServletResponse response, Map<String, Object> data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
        
        String jsonResponse = JsonUtil.toJson(data);
        
        try (PrintWriter out = response.getWriter()) {
            out.print(jsonResponse);
            out.flush();
        }
    }
    
    public static Map<String, Object> createSuccessResponse(Object data) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        
        if (data instanceof List) {
            response.put("data", listToJsonArray((List<?>) data));
        } else {
            response.put("data", data);
        }
        
        return response;
    }
    
    public static Map<String, Object> createSuccessResponse(Object data, String message) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", message);
        
        if (data instanceof List) {
            response.put("data", listToJsonArray((List<?>) data));
        } else {
            response.put("data", data);
        }
        
        return response;
    }
    
    public static Map<String, Object> createErrorResponse(String error) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("error", error);
        return response;
    }
    
    public static Map<String, Object> createErrorResponse(String error, int errorCode) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("error", error);
        response.put("errorCode", errorCode);
        return response;
    }

    public static Map<String, Object> createValidationErrorResponse(Map<String, String> validationErrors) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("validationErrors", validationErrors);
        return response;
    }
    
    private static String listToJsonArray(List<?> list) {
        StringBuilder json = new StringBuilder("[");
        boolean first = true;
        
        for (Object item : list) {
            if (!first) {
                json.append(",");
            }
            json.append(objectToJson(item));
            first = false;
        }
        
        json.append("]");
        return json.toString();
    }
    
    private static String objectToJson(Object obj) {
        if (obj == null) {
            return "null";
        }
        
        // Handle Participant objects
        if (obj.getClass().getSimpleName().equals("Participant")) {
            return participantToJson(obj);
        }
        
        // Handle other objects as string
        return "\"" + obj.toString() + "\"";
    }
    
    private static String participantToJson(Object participant) {
        try {
            // Use reflection to get participant data
            Class<?> clazz = participant.getClass();
            
            StringBuilder json = new StringBuilder("{");
            json.append("\"id\":").append(clazz.getMethod("getId").invoke(participant)).append(",");
            json.append("\"namaLengkap\":\"").append(clazz.getMethod("getNamaLengkap").invoke(participant)).append("\",");
            json.append("\"prodi\":\"").append(clazz.getMethod("getProdi").invoke(participant)).append("\",");
            json.append("\"email\":\"").append(clazz.getMethod("getEmail").invoke(participant)).append("\",");
            json.append("\"nomorHP\":\"").append(clazz.getMethod("getNomorHP").invoke(participant)).append("\",");
            json.append("\"programHimpunan\":\"").append(clazz.getMethod("getProgramHimpunan").invoke(participant)).append("\",");
            json.append("\"tanggalDaftar\":\"").append(clazz.getMethod("getTanggalDaftar").invoke(participant)).append("\"");
            json.append("}");
            
            return json.toString();
        } catch (Exception e) {
            return "{}";
        }
    }
}
