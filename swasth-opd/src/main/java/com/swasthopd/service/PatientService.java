package com.swasthopd.service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.swasthopd.model.Patient;
import com.swasthopd.model.Visit;
import com.swasthopd.repo.PatientRepo;
import com.swasthopd.repo.VisitRepo;

@Service
public class PatientService {

    @Autowired
    private PatientRepo patientRepo;
    @Autowired
    private VisitRepo visitRepo;

    public List<Patient> getTodayPatients() {
        String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        List<Visit> visits = visitRepo.findByVisitTimeStartingWith(today);
        
        return visits.stream()
                     .map(Visit::getPatient)
                     .distinct()
                     .toList();
    }


    // Save new patient
    public Patient save(Patient patient) {
        return patientRepo.save(patient);
    }

    

    // Get all patients in descending order
    public List<Patient> getAllPatients() {
        return patientRepo.findAllByOrderByIdDesc();
    }

    // Get last 5 registered patients
    public List<Patient> getRecentPatients() {
        return patientRepo.findTop5ByOrderByIdDesc();
    }

    // Get patient by ID (used in AJAX & modal)
    public Patient getPatientById(Long id) {
        return patientRepo.findById(id).orElse(null);
    }

    // (Optional Future) Get patient medical history
    public List<String> getPatientHistory(Long id) {
        // Placeholder for future audit log integration
        return List.of("Diagnosis: Viral Fever", "Prescription: Paracetamol", "Follow-up in 5 days");
    }
    public Patient findByAadharId(String aadharId) {
        return patientRepo.findByAadharId(aadharId).orElse(null);
    }

}
