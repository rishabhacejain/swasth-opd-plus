package com.swasthopd.repo;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.swasthopd.model.User;

public interface UserRepo extends JpaRepository<User, Integer> {
	User findByUsernameAndPassword(String username, String password);
    List<User> findByStatus(String status);
	int countByStatus(String status);
	Optional<User> findById(Integer userId);
}
