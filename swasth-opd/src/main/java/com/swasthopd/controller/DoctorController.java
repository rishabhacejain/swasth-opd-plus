package com.swasthopd.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;


import com.swasthopd.model.Patient;
import com.swasthopd.model.User;
import com.swasthopd.model.Visit;
import com.swasthopd.service.PatientService;
import com.swasthopd.service.VisitService;

import jakarta.servlet.http.HttpSession;

@Controller
public class DoctorController {
	
	@Autowired
	private VisitService visitService;

	
//	 @GetMapping	("/dashboard")
//	    public String showDashboard() {
//	        return "dashboard"; // points to dashboard.jsp
//	    }
	 
	 @GetMapping("/dashboard")
	 public String showDashboard(Model model, HttpSession session) {
		 User doctor = (User) session.getAttribute("loggedInUser");
	     if (doctor == null || !doctor.getRole().equalsIgnoreCase("DOCTOR")) {
	         return "redirect:/login"; // fallback if session expired
	     }

	     List<Visit> visits = visitService.getTodayVisits();
	     model.addAttribute("doctor", doctor);
	     model.addAttribute("visits", visits);

	     return "dashboard";
	 }


}
