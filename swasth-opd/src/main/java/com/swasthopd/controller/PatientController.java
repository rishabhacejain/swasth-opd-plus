package com.swasthopd.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.swasthopd.model.Patient;
import com.swasthopd.service.PatientService;

@Controller
public class PatientController {
	
	@Autowired
	private PatientService patientService;
	
	@GetMapping("/register-patient")
	public String showPatientForm(Model model) {
	    model.addAttribute("patient", new Patient());
	    
	    List<Patient> recent = patientService.getRecentPatients();
	    model.addAttribute("recentPatients", recent);
		
		return "register-patient";
	}

	@PostMapping("/register-patient")
	public String registerPatient(@ModelAttribute Patient patient, RedirectAttributes redirectAttributes) {
	    patient.setStatus("Waiting");
		patientService.save(patient);
		
	    redirectAttributes.addFlashAttribute("msg", "Patient registered successfully");
	    return "redirect:/register-patient";
	}


}
