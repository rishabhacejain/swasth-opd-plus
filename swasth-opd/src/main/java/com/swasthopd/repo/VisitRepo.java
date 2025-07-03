package com.swasthopd.repo;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


import com.swasthopd.model.Visit;

@Repository
public interface VisitRepo extends JpaRepository<Visit, Long> {

    // Fetch all visits for a patient (sorted by newest first)
    List<Visit> findByPatientIdOrderByIdDesc(Long patientId);

    // Optional: Fetch today's visits
    List<Visit> findByVisitTimeStartingWith(String datePrefix);
    
    List<Visit> findByVisitTimeContainingOrderByIdDesc(String dateSubstring);
}
