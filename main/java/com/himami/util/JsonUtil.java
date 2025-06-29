package com.himami.util;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class JsonUtil {
    
    public static String toJson(Object object) {
        if (object instanceof Map) {
            return mapToJson((Map<String, Object>) object);
        }
        return "{}";
    }
    
    private static String mapToJson(Map<String, Object> map) {
        StringBuilder json = new StringBuilder("{");
        boolean first = true;
        
        for (Map.Entry<String, Object> entry : map.entrySet()) {
            if (!first) {
                json.append(",");
            }
            json.append("\"").append(entry.getKey()).append("\":");
            
            Object value = entry.getValue();
            if (value instanceof String) {
                json.append("\"").append(escapeJson((String) value)).append("\"");
            } else if (value instanceof Number || value instanceof Boolean) {
                json.append(value);
            } else if (value == null) {
                json.append("null");
            } else {
                json.append("\"").append(value.toString()).append("\"");
            }
            first = false;
        }
        json.append("}");
        return json.toString();
    }
    
    private static String escapeJson(String str) {
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
    
    public static Map<String, Object> parseJsonRequest(HttpServletRequest request) throws IOException {
        StringBuilder jsonBuilder = new StringBuilder();
        String line;
        
        try (BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                jsonBuilder.append(line);
            }
        }
        
        String jsonString = jsonBuilder.toString().trim();
        if (jsonString.isEmpty()) {
            throw new IOException("Empty JSON request body");
        }
        
        return parseJsonString(jsonString);
    }
    
    private static Map<String, Object> parseJsonString(String json) throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        // Remove outer braces
        json = json.trim();
        if (!json.startsWith("{") || !json.endsWith("}")) {
            throw new IOException("Invalid JSON format");
        }
        
        json = json.substring(1, json.length() - 1).trim();
        
        if (json.isEmpty()) {
            return result;
        }
        
        // Split by comma (simple parsing)
        String[] pairs = json.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)");
        
        for (String pair : pairs) {
            String[] keyValue = pair.split(":", 2);
            if (keyValue.length != 2) {
                continue;
            }
            
            String key = keyValue[0].trim();
            String value = keyValue[1].trim();
            
            // Remove quotes from key
            if (key.startsWith("\"") && key.endsWith("\"")) {
                key = key.substring(1, key.length() - 1);
            }
            
            // Remove quotes from value if it's a string
            if (value.startsWith("\"") && value.endsWith("\"")) {
                value = value.substring(1, value.length() - 1);
                // Unescape JSON
                value = value.replace("\\\"", "\"")
                            .replace("\\\\", "\\")
                            .replace("\\n", "\n")
                            .replace("\\r", "\r")
                            .replace("\\t", "\t");
            }
            
            result.put(key, value);
        }
        
        return result;
    }
    
    public static boolean isValidJson(String jsonString) {
        try {
            parseJsonString(jsonString);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}
