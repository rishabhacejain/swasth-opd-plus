package com.swasthopd.repo;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import com.swasthopd.model.LabRequest;

public interface LabRequestRepo extends JpaRepository<LabRequest, Long> {
    List<LabRequest> findByStatus(String status);

	List<LabRequest> findByRequestedBy(String doctorName);
}
