package com.swasthopd.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.swasthopd.model.Patient;
import com.swasthopd.repo.PatientRepo;

@Service
public class PatientService {
	
	@Autowired
	private PatientRepo patientRepo;
	
	public List<Patient> getTodayPatients(){
		return patientRepo.findAll();
		
		
	}
	

}
