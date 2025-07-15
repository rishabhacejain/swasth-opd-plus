package com.swasthopd.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
public class LabRequest {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@ManyToOne
	private Patient patient;

	@ManyToOne
	private Visit visit;

	private String labType;
	
	@Lob
	@Column(name = "instructions", columnDefinition = "TEXT")
	private String instructions;
	
	private String requestedBy;
	private String status;

	@Column(name = "report_path")
	private String reportPath;

	private String createdAt = LocalDateTime.now().toString();

	// --- Getters & Setters ---

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Patient getPatient() {
		return patient;
	}

	public void setPatient(Patient patient) {
		this.patient = patient;
	}

	public Visit getVisit() {
		return visit;
	}

	public void setVisit(Visit visit) {
		this.visit = visit;
	}

	public String getLabType() {
		return labType;
	}

	public void setLabType(String labType) {
		this.labType = labType;
	}

	public String getInstructions() {
		return instructions;
	}

	public void setInstructions(String instructions) {
		this.instructions = instructions;
	}

	public String getRequestedBy() {
		return requestedBy;
	}

	public void setRequestedBy(String requestedBy) {
		this.requestedBy = requestedBy;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getReportPath() {
		return reportPath;
	}

	public void setReportPath(String reportPath) {
		this.reportPath = reportPath;
	}

	public String getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}
}
