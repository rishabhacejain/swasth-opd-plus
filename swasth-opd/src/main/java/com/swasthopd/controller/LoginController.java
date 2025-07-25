package com.swasthopd.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.swasthopd.model.Doctor;
import com.swasthopd.model.User;
import com.swasthopd.repo.DoctorRepo;
import com.swasthopd.service.UserService;

import jakarta.servlet.http.HttpSession;

@Controller
public class LoginController {
	
	@Autowired
	private UserService userService;
	
	@GetMapping("/login")
	public String loginPage() {
		return "login";
		
	}
	
	@PostMapping("/login")
    public String doLogin(@RequestParam String username,
    		              @RequestParam String password,
    		              @RequestParam String role,
    		              HttpSession session,
    		              Model model) {
		System.out.println("Role from DB: " + username + ", Role from form: " + role);

    	User user = userService.login(username, password);
    	
    	if(user != null && user.getRole().equalsIgnoreCase(role)) {
    		session.setAttribute("loggedInUser", user);
    		
    		switch(role.toUpperCase()) {
    		case "DOCTOR": return "redirect:/dashboard";
    		case "NURSE": return "redirect:/nurse-dashboard";
    		case "LAB":   return "redirect:/lab/requests";
    		case "ADMIN": return "redirect:/admin/panel";
    		default: return "redirect:/login";

    		
    		}
    		
    	}else {
    		model.addAttribute("err", "Invalid Username or Password");
    		return "login";
    	
    	
    	}
    	
    	
    }
	
	@GetMapping("/logout")
	public String logout(HttpSession session) {
	    session.invalidate(); // Destroys session
	    return "redirect:/login?logout"; // Redirect to login with optional flag
	}

	

}
