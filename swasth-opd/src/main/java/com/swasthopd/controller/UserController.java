package com.swasthopd.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.swasthopd.model.User;
import com.swasthopd.service.UserService;

@Controller
public class UserController {
	
	@Autowired
	private UserService userService;
     
	public String showRegisterPage() {
		return "register";
		
		
	}
	
	public String registerUser(@ModelAttribute User user, RedirectAttributes redirectAttributes ) {
		user.setStatus("PENDING");
		userService.save(user);
		
		
		
		return "redirect:/login";
	}

}
