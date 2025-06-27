package com.swasthopd.repo;

import com.swasthopd.model.Doctor;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DoctorRepo extends JpaRepository<Doctor, Integer>
{
    Doctor findByUsernameAndPassword(String username, String password);
}
