package com.swasthopd.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.swasthopd.model.Doctor;
import com.swasthopd.model.User;
import com.swasthopd.repo.DoctorRepo;

@Service
	public class DoctorService {

	    @Autowired
	    private DoctorRepo doctorRepo;

	    public Doctor findByUser(User user) {
	        return doctorRepo.findByUser(user);
	    }
	}



