package com.swasthopd.model;

import java.util.Date;

import jakarta.persistence.*;

@Entity
@Table(name="doctor")
public class Doctor {
	
	  @Id
	    @GeneratedValue(strategy = GenerationType.IDENTITY)
	    @Column(name="DocID")
	    private int docID;

	    @Column(name="name")
	    private String name;

	    @Column(name="email")
	    private String email;

	    @Column(name="contact_number")
	    private String contactNumber;

	    @Column(name="department")
	    private String department;

	    @Temporal(TemporalType.TIMESTAMP)
	    @Column(name = "created_at", updatable = false)
	    private Date createdAt;

	    @Temporal(TemporalType.TIMESTAMP)
	    @Column(name = "updated_at")
	    private Date updatedAt;

	    // Optional: link to User if needed
	    @OneToOne
	    @JoinColumn(name = "user_id") // FK in doctor table
	    private User user;


	public int getDocID() {
		return docID;
	}

	public void setDocID(int docID) {
		this.docID = docID;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	

	

	public String getDepartment() {
		return department;
	}

	public void setDepartment(String department) {
		this.department = department;
	}

	

	public String getContactNumber() {
		return contactNumber;
	}

	public void setContactNumber(String contactNumber) {
		this.contactNumber = contactNumber;
	}

	

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	public Date getUpdatedAt() {
		return updatedAt;
	}

	public void setUpdatedAt(Date updatedAt) {
		this.updatedAt = updatedAt;
	}
	
	
	
	
	@PrePersist
	protected void onCreate() {
	    this.createdAt = new Date();
	    this.updatedAt = new Date();
	}

	@PreUpdate
	protected void onUpdate() {
	    this.updatedAt = new Date();
	}

	
	

}
