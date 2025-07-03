package com.swasthopd.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.swasthopd.model.Visit;
import com.swasthopd.repo.VisitRepo;

@Service
public class VisitService {

    @Autowired
    private VisitRepo visitRepo;

    public void save(Visit visit) {
        visitRepo.save(visit);
    }
    
    public List<Visit> getTodayVisits() {
        String todayDatePrefix = java.time.LocalDate.now()
            .format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd"));

        return visitRepo.findByVisitTimeStartingWith(todayDatePrefix);
    }


    public List<Visit> getVisitsByPatientId(Long patientId) {
        return visitRepo.findByPatientIdOrderByIdDesc(patientId);
    }

    public List<Visit> getAllVisits() {
        return visitRepo.findAll();
    }
}
