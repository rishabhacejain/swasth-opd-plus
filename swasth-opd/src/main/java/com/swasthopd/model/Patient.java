package com.swasthopd.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

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

    @Column(name = "aadhar_id", unique = true)
    private String aadharId;

    @Column(name = "address")
    private String address;

    @Column(name = "phone")
    private String phone;

    

    // Optional future-use fields
    @Column(name = "image_url")
    private String imageUrl;

    @Column(name = "created_at")
    private String createdAt;
    
    
    
    @OneToMany(mappedBy = "patient", cascade = CascadeType.ALL,fetch = FetchType.LAZY)
    private List<Visit> visits;


    public Patient() {
    }

    public Patient(String name, int age, String gender, LocalDate dob, String aadharId, String address, String phone,
                   String imageUrl, String createdAt) {
        this.name = name;
        this.age = age;
        this.gender = gender;
        this.dob = dob;
        this.aadharId = aadharId;
        this.address = address;
        this.phone = phone;
        this.imageUrl = imageUrl;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
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
    
    public List<Visit> getVisits() {
		return visits;
	}

	public void setVisits(List<Visit> visits) {
		this.visits = visits;
	}
    
    @Transient
    public String getDobFormatted() {
        if (dob == null) return "";
        return dob.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }
    
    @Transient
    public String getMaskedAadharId() {
        if (aadharId == null || aadharId.length() < 4) return "XXXX XXXX";
        return "XXXX XXXX " + aadharId.substring(aadharId.length() - 4);
    }


}
