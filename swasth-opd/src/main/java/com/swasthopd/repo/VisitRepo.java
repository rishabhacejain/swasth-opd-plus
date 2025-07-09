package com.swasthopd.repo;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;


import com.swasthopd.model.Visit;

@Repository
public interface VisitRepo extends JpaRepository<Visit, Long> {

    // Fetch all visits for a patient (sorted by newest first)
    List<Visit> findByPatientIdOrderByIdDesc(Long patientId);

    // Optional: Fetch today's visits
    List<Visit> findByVisitTimeStartingWith(String datePrefix);
    
    List<Visit> findByVisitTimeContainingOrderByIdDesc(String dateSubstring);
    
    boolean existsByPatientIdAndVisitTimeBefore(Long patientId, String visitTimePrefix);
    
    
    // Optional but useful
    Visit findTopByPatientIdOrderByIdDesc(Long patientId); // Alt for latestVisit


    @Query("SELECT v FROM Visit v " +
    	       "JOIN FETCH v.doctor d " +
    	       "JOIN FETCH d.user " +
    	       "WHERE v.patient.id = :patientId " +
    	       "ORDER BY v.id DESC")
    	List<Visit> findVisitsWithDoctorUserByPatientIdOrderByIdDesc(@Param("patientId") Long patientId);

}
