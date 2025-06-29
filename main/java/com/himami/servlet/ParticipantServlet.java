package com.himami.servlet;

import com.himami.model.Participant;
import com.himami.storage.DataStorage;
import com.himami.util.JsonUtil;
import com.himami.util.ResponseUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/api/participants")
public class ParticipantServlet extends HttpServlet {
    
    private DataStorage dataStorage;
    
    @Override
    public void init() throws ServletException {
        super.init();
        dataStorage = DataStorage.getInstance();
        System.out.println("ParticipantServlet initialized");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("GET /api/participants called");
        
        try {
            List<Participant> participants = dataStorage.getAllParticipants();
            System.out.println("Found " + participants.size() + " participants");
            ResponseUtil.sendJsonResponse(response, ResponseUtil.createSuccessResponse(participants));
        } catch (Exception e) {
            System.err.println("Error in GET /api/participants: " + e.getMessage());
            e.printStackTrace();
            ResponseUtil.sendJsonResponse(response, 
                ResponseUtil.createErrorResponse("Failed to fetch participants"));
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("POST /api/participants called");
        
        try {
            // Parse JSON request body
            Map<String, Object> requestData = JsonUtil.parseJsonRequest(request);
            System.out.println("Received data: " + requestData);
            
            // Validate required fields
            String[] requiredFields = {"namaLengkap", "prodi", "email", "nomorHP", "programHimpunan"};
            for (String field : requiredFields) {
                if (!requestData.containsKey(field) || 
                    requestData.get(field) == null || 
                    requestData.get(field).toString().trim().isEmpty()) {
                    
                    System.err.println("Missing required field: " + field);
                    ResponseUtil.sendJsonResponse(response, 
                        ResponseUtil.createErrorResponse("Field " + field + " is required"));
                    return;
                }
            }
            
            // Check if email already exists
            String email = requestData.get("email").toString();
            if (dataStorage.isParticipantEmailExists(email)) {
                System.err.println("Email already exists: " + email);
                ResponseUtil.sendJsonResponse(response, 
                    ResponseUtil.createErrorResponse("Email already registered"));
                return;
            }
            
            // Create participant object
            Participant participant = new Participant();
            participant.setNamaLengkap(requestData.get("namaLengkap").toString());
            participant.setProdi(requestData.get("prodi").toString());
            participant.setEmail(email);
            participant.setNomorHP(requestData.get("nomorHP").toString());
            participant.setProgramHimpunan(requestData.get("programHimpunan").toString());
            
            System.out.println("Creating participant: " + participant.getNamaLengkap());
            
            // Save to storage
            boolean success = dataStorage.addParticipant(participant);
            
            if (success) {
                System.out.println("Participant saved successfully with ID: " + participant.getId());
                ResponseUtil.sendJsonResponse(response, 
                    ResponseUtil.createSuccessResponse("Participant registered successfully"));
            } else {
                System.err.println("Failed to save participant");
                ResponseUtil.sendJsonResponse(response, 
                    ResponseUtil.createErrorResponse("Failed to register participant"));
            }
            
        } catch (Exception e) {
            System.err.println("Error in POST /api/participants: " + e.getMessage());
            e.printStackTrace();
            ResponseUtil.sendJsonResponse(response, 
                ResponseUtil.createErrorResponse("Internal server error: " + e.getMessage()));
        }
    }
    
    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Handle CORS preflight request
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
        response.setStatus(HttpServletResponse.SC_OK);
    }
}
