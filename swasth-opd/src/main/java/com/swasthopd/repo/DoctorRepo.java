package com.swasthopd.repo;

import com.swasthopd.model.Doctor;
import com.swasthopd.model.User;

import org.springframework.data.jpa.repository.JpaRepository;

public interface DoctorRepo extends JpaRepository<Doctor, Integer>
{
   
	
	Doctor findByUser(User user);

}
