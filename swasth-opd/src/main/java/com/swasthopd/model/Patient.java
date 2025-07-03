package com.swasthopd.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Entity
@Table(name = "patients")
public class Patient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name")
    private String name;

    @Column(name = "age")
    private Integer age;

    @Column(name = "gender")
    private String gender;

    @Column(name = "dob")
    private LocalDate dob;

    @Column(name = "aadhar_id")
    private String aadharId;

    @Column(name = "address")
    private String address;

    @Column(name = "phone")
    private String phone;

    @Column(name = "visit_time")
    private String visitTime;

    @Column(name = "symptoms")
    private String symptoms;

    @Column(name = "case_type")
    private String caseType;

    @Column(name = "department")
    private String department;

    @Column(name = "doctor")
    private String doctor;

    @Column(name = "status")
    private String status;

    // Optional future-use fields
    @Column(name = "image_url")
    private String imageUrl;

    @Column(name = "created_at")
    private String createdAt;

    public Patient() {
    }

    public Patient(String name, int age, String gender, LocalDate dob, String aadharId, String address, String phone,
                   String visitTime, String symptoms, String caseType,
                   String department, String doctor, String status, String imageUrl, String createdAt) {
        this.name = name;
        this.age = age;
        this.gender = gender;
        this.dob = dob;
        this.aadharId = aadharId;
        this.address = address;
        this.phone = phone;
        this.visitTime = visitTime;
        this.symptoms = symptoms;
        this.caseType = caseType;
        this.department = department;
        this.doctor = doctor;
        this.status = status;
        this.imageUrl = imageUrl;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public LocalDate getDob() {
        return dob;
    }

    public void setDob(LocalDate dob) {
        this.dob = dob;
    }

    public String getAadharId() {
        return aadharId;
    }

    public void setAadharId(String aadharId) {
        this.aadharId = aadharId;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getVisitTime() {
        return visitTime;
    }

    public void setVisitTime(String visitTime) {
        this.visitTime = visitTime;
    }

    public String getSymptoms() {
        return symptoms;
    }

    public void setSymptoms(String symptoms) {
        this.symptoms = symptoms;
    }

    public String getCaseType() {
        return caseType;
    }

    public void setCaseType(String caseType) {
        this.caseType = caseType;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getDoctor() {
        return doctor;
    }

    public void setDoctor(String doctor) {
        this.doctor = doctor;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }
    
    @Transient
    public String getDobFormatted() {
        if (dob == null) return "";
        return dob.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }

}
