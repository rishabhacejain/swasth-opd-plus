package com.swasthopd.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.swasthopd.model.LabRequest;
import com.swasthopd.repo.LabRequestRepo;

@Service
public class LabRequestService {

    @Autowired
    private LabRequestRepo labRequestRepo;

    public void save(LabRequest labRequest) {
        labRequestRepo.save(labRequest);
    }
    
    public LabRequest getById(Long id) {
        return labRequestRepo.findById(id).orElse(null);
    }


    public List<LabRequest> getPendingRequests() {
        return labRequestRepo.findByStatus("Pending");
    }

    public List<LabRequest> getAllRequests() {
        return labRequestRepo.findAll();
    }
    
    public List<LabRequest> getReportsForDoctor(String doctorName) {
        return labRequestRepo.findByRequestedBy(doctorName);
    }
    
    

}
