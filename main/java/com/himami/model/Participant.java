package com.himami.model;

import java.time.LocalDate;

public class Participant {
    private int id;
    private String namaLengkap;
    private String prodi;
    private String email;
    private String nomorHP;
    private String programHimpunan;
    private LocalDate tanggalDaftar;
    private String status;
    
    // Constructors
    public Participant() {
        this.tanggalDaftar = LocalDate.now();
        this.status = "active";
    }
    
    public Participant(String namaLengkap, String prodi, String email, 
                      String nomorHP, String programHimpunan) {
        this();
        this.namaLengkap = namaLengkap;
        this.prodi = prodi;
        this.email = email;
        this.nomorHP = nomorHP;
        this.programHimpunan = programHimpunan;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getNamaLengkap() {
        return namaLengkap;
    }
    
    public void setNamaLengkap(String namaLengkap) {
        this.namaLengkap = namaLengkap;
    }
    
    public String getProdi() {
        return prodi;
    }
    
    public void setProdi(String prodi) {
        this.prodi = prodi;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getNomorHP() {
        return nomorHP;
    }
    
    public void setNomorHP(String nomorHP) {
        this.nomorHP = nomorHP;
    }
    
    public String getProgramHimpunan() {
        return programHimpunan;
    }
    
    public void setProgramHimpunan(String programHimpunan) {
        this.programHimpunan = programHimpunan;
    }
    
    public LocalDate getTanggalDaftar() {
        return tanggalDaftar;
    }
    
    public void setTanggalDaftar(LocalDate tanggalDaftar) {
        this.tanggalDaftar = tanggalDaftar;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    @Override
    public String toString() {
        return "Participant{" +
                "id=" + id +
                ", namaLengkap='" + namaLengkap + '\'' +
                ", prodi='" + prodi + '\'' +
                ", email='" + email + '\'' +
                ", nomorHP='" + nomorHP + '\'' +
                ", programHimpunan='" + programHimpunan + '\'' +
                ", tanggalDaftar=" + tanggalDaftar +
                ", status='" + status + '\'' +
                '}';
    }
}
