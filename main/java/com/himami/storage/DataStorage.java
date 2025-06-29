package com.himami.storage;

import com.himami.model.Participant;
import com.himami.model.User;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

public class DataStorage {
    
    private static DataStorage instance;
    private final Map<String, User> users;
    private final List<Participant> participants;
    private final AtomicInteger participantIdCounter;
    private final AtomicInteger userIdCounter;
    
    private DataStorage() {
        users = new HashMap<>();
        participants = new ArrayList<>();
        participantIdCounter = new AtomicInteger(1);
        userIdCounter = new AtomicInteger(1);
        
        // Initialize with default users
        initializeDefaultUsers();
        
        // Initialize with sample participants
        initializeSampleParticipants();
    }
    
    public static synchronized DataStorage getInstance() {
        if (instance == null) {
            instance = new DataStorage();
        }
        return instance;
    }
    
    private void initializeDefaultUsers() {
        // Admin user
        User admin = new User();
        admin.setId(userIdCounter.getAndIncrement());
        admin.setUsername("admin");
        admin.setEmail("admin@hima-mi.polsri.ac.id");
        admin.setFullName("Administrator HIMA MI");
        admin.setRole("admin");
        admin.setActive(true);
        users.put("admin", admin);
        
        // Member user
        User member = new User();
        member.setId(userIdCounter.getAndIncrement());
        member.setUsername("member");
        member.setEmail("member@hima-mi.polsri.ac.id");
        member.setFullName("Member HIMA MI");
        member.setRole("member");
        member.setActive(true);
        users.put("member", member);
    }
    
    private void initializeSampleParticipants() {
        // Sample participant 1
        Participant p1 = new Participant();
        p1.setId(participantIdCounter.getAndIncrement());
        p1.setNamaLengkap("Ahmad Rizki Pratama");
        p1.setProdi("Manajemen Informatika");
        p1.setEmail("ahmad.rizki@student.polsri.ac.id");
        p1.setNomorHP("081234567890");
        p1.setProgramHimpunan("coding");
        p1.setTanggalDaftar(LocalDate.now().minusDays(5));
        participants.add(p1);
        
        // Sample participant 2
        Participant p2 = new Participant();
        p2.setId(participantIdCounter.getAndIncrement());
        p2.setNamaLengkap("Siti Nurhaliza");
        p2.setProdi("Teknik Komputer");
        p2.setEmail("siti.nurhaliza@student.polsri.ac.id");
        p2.setNomorHP("081234567891");
        p2.setProgramHimpunan("volley");
        p2.setTanggalDaftar(LocalDate.now().minusDays(3));
        participants.add(p2);
        
        // Sample participant 3
        Participant p3 = new Participant();
        p3.setId(participantIdCounter.getAndIncrement());
        p3.setNamaLengkap("Budi Santoso");
        p3.setProdi("Sistem Informasi");
        p3.setEmail("budi.santoso@student.polsri.ac.id");
        p3.setNomorHP("081234567892");
        p3.setProgramHimpunan("futsal");
        p3.setTanggalDaftar(LocalDate.now().minusDays(1));
        participants.add(p3);
    }
    
    // User methods
    public User getUserByUsername(String username) {
        return users.get(username);
    }
    
    public boolean isUsernameExists(String username) {
        return users.containsKey(username);
    }
    
    public boolean isEmailExists(String email) {
        return users.values().stream()
                .anyMatch(user -> user.getEmail().equals(email));
    }
    
    public boolean addUser(User user) {
        if (isUsernameExists(user.getUsername()) || isEmailExists(user.getEmail())) {
            return false;
        }
        user.setId(userIdCounter.getAndIncrement());
        users.put(user.getUsername(), user);
        return true;
    }
    
    public boolean authenticateUser(String username, String password) {
        // Simple authentication logic
        if ("admin".equals(username) && "admin123".equals(password)) {
            return true;
        }
        if ("member".equals(username) && "member123".equals(password)) {
            return true;
        }
        return false;
    }
    
    // Participant methods
    public List<Participant> getAllParticipants() {
        return new ArrayList<>(participants);
    }
    
    public boolean addParticipant(Participant participant) {
        // Check if email already exists
        if (isParticipantEmailExists(participant.getEmail())) {
            return false;
        }
        participant.setId(participantIdCounter.getAndIncrement());
        participant.setTanggalDaftar(LocalDate.now());
        participants.add(participant);
        return true;
    }
    
    public boolean isParticipantEmailExists(String email) {
        return participants.stream()
                .anyMatch(p -> p.getEmail().equals(email));
    }
    
    public Participant getParticipantById(int id) {
        return participants.stream()
                .filter(p -> p.getId() == id)
                .findFirst()
                .orElse(null);
    }
    
    public int getParticipantCount() {
        return participants.size();
    }
    
    public boolean removeParticipant(int id) {
        return participants.removeIf(p -> p.getId() == id);
    }
}
