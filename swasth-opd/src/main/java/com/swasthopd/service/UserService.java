package com.swasthopd.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.swasthopd.model.User;
import com.swasthopd.repo.UserRepo;

@Service
public class UserService {
	
	@Autowired
	private UserRepo userRepo;

	public User login(String username, String password) {
		
		return userRepo.findByUsernameAndPassword(username, password);
	}

	public void save(User user) {
		userRepo.save(user);
	}

	public List<User> findByStatus(String status) {
		
		return userRepo.findByStatus(status);
	}

	public int countByStatus(String status) {
		
		return userRepo.countByStatus(status);
	}

	public long countAll() {
		
		return userRepo.count();
	}

	public void updateStatus(int userId, String status) {
		User user = userRepo.findById(userId).orElse(null);
		if(user != null) {
			user.setStatus(status);
			userRepo.save(user);
		}
		
	}

	public void deleteById(int userId) {
		userRepo.deleteById(userId);
		
	}
}
