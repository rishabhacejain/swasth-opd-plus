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

    // Save new patient
    public void save(Patient patient) {
        patientRepo.save(patient);
    }

    // Get all patients (currently used for dashboard)
    public List<Patient> getTodayPatients() {
        return patientRepo.findAll();
    }

    // Get last 5 registered patients (optional for right panel)
    public List<Patient> getRecentPatients() {
        return patientRepo.findTop5ByOrderByIdDesc();
    }
}
