package com.swasthopd.model;

import jakarta.persistence.*;
import java.time.LocalTime;

@Entity
@Table(name = "patients")
public class Patient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name")
    private String name;

    @Column(name = "reason")
    private String reason;

    @Column(name = "visit_time")
    private String time; // You can use LocalTime if preferred

    @Column(name = "status")
    private String status; // e.g. "Checked-In", "Waiting", "Referred"
    
    
    
    
    
    // Constructors
    public Patient( ) {}

	public Patient(String name, String reason, String time, String status) {
		super();
		this.name = name;
		this.reason = reason;
		this.time = time;
		this.status = status;
	}
	
	//Getters And Setters
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

	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}

	public String getTime() {
		return time;
	}

	public void setTime(String time) {
		this.time = time;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
    
    
    
}
