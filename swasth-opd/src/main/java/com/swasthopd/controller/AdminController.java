package com.swasthopd.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.swasthopd.model.User;
import com.swasthopd.service.UserService;

@Controller
@RequestMapping("/admin")
public class AdminController {
	
	@Autowired
	private UserService userService;
	
	
	
	@GetMapping("/panel")
	public String showAdminDashboard(Model model) {
		List<User> pendingUsers = userService.findByStatus("PENDING");
		long activeCount = userService.countByStatus("ACTIVE");
	    long pendingCount = userService.countByStatus("PENDING");
	    long totalCount = userService.countAll();
	    
	    model.addAttribute("pendingUsers", pendingUsers);
        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("activeCount", activeCount);
        model.addAttribute("totalCount", totalCount);
        
		return "admin-panel";
		
	}
	 // For User Approval
	@PostMapping("/approve-user")
	public String approveUser(@RequestParam int userId) {
		userService.updateStatus(userId, "ACTIVE");
		return "redirect:/admin/panel";
	}
	
	//Reject a user Due to some Compliances
	@PostMapping("/reject-user")
	public String rejectUser(@RequestParam int userId) {
		userService.deleteById(userId);
		return "redirect:/admin/panel";
		
	}

}
