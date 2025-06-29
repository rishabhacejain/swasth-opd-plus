package com.swasthopd.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;


import com.swasthopd.model.Patient;
import com.swasthopd.model.User;
import com.swasthopd.service.PatientService;

import jakarta.servlet.http.HttpSession;

@Controller
public class DoctorController {
	
	@Autowired
	private PatientService patientService;

	
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

	     List<Patient> patients = patientService.getTodayPatients();

	     model.addAttribute("doctor", doctor);
	     model.addAttribute("patients", patients);
	     return "dashboard";
	 }


}
