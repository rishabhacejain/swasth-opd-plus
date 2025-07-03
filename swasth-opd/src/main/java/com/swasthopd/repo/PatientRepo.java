package com.swasthopd.repo;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.swasthopd.model.Patient;

public interface PatientRepo extends JpaRepository<Patient, Long> {
List<Patient> findAll();
List<Patient> findTop5ByOrderByIdDesc(); // For recent registrations
List<Patient> findAllByOrderByIdDesc();
Optional<Patient> findByAadharId(String aadharId);






}
