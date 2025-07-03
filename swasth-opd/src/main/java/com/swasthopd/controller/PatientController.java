package com.swasthopd.controller;

import java.io.IOException;
import java.nio.file.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.swasthopd.model.Patient;
import com.swasthopd.service.PatientService;

import jakarta.servlet.http.HttpSession;

@Controller
public class PatientController {

    private static final String UPLOAD_DIR = "src/main/resources/static/uploads/";

    @Autowired
    private PatientService patientService;

    // Show patient registration form
    @GetMapping("/register-patient")
    public String showPatientForm(Model model, HttpSession session) {
        if (session.getAttribute("loggedInUser") == null) {
            return "redirect:/login";
        }

        model.addAttribute("patient", new Patient());
        List<Patient> recent = patientService.getRecentPatients();
        model.addAttribute("recentPatients", recent);

        return "register-patient";
    }

    // Register new patient
    @PostMapping("/register-patient")
    public String registerPatient(@ModelAttribute Patient patient,
                                  @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                                  RedirectAttributes redirectAttributes,Model model) {
    	System.out.println("DOB Received: " + patient.getDob());

        // Set default status
        patient.setStatus("Waiting");
        
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        patient.setVisitTime(LocalDateTime.now().format(formatter));
        
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        String formattedDob = patient.getDob().format(dateFormatter);
        model.addAttribute("formattedDob", formattedDob);


        // Handle image upload if available
        if (imageFile != null && !imageFile.isEmpty()) {
            try {
                String filename = "patient_" + System.currentTimeMillis() + "_" + imageFile.getOriginalFilename();
                Path filepath = Paths.get(UPLOAD_DIR, filename);
                Files.createDirectories(filepath.getParent());
                Files.write(filepath, imageFile.getBytes());

                patient.setImageUrl("/uploads/" + filename);
            } catch (IOException e) {
                e.printStackTrace();
                redirectAttributes.addFlashAttribute("error", "Image upload failed");
            }
        } else {
            // Set default image if not uploaded
            patient.setImageUrl("/images/default-avatar.png");
        }

        // Save patient
        patientService.save(patient);
        redirectAttributes.addFlashAttribute("msg", "Patient registered successfully");

        return "redirect:/register-patient";
    }

    // View all patients
    @GetMapping("/view-patients")
    public String viewAllPatients(Model model, HttpSession session) {
        if (session.getAttribute("loggedInUser") == null) {
            return "redirect:/login";
        }

        List<Patient> patients = patientService.getTodayPatients(); // Show only today’s patients
        model.addAttribute("patients", patients);
        return "view-patients";
    }

    // Get patient profile via AJAX
    @GetMapping("/patient/{id}")
    @ResponseBody
    public Patient getPatientDetails(@PathVariable Long id) {
        return patientService.getPatientById(id);
    }

    // Medical history modal content (optional if loading separately)
    @GetMapping("/patient/{id}/history")
    public String showMedicalHistory(@PathVariable Long id, Model model) {
        Patient patient = patientService.getPatientById(id);
        model.addAttribute("history", patient.getSymptoms()); // Replace with actual history list if available
        return "fragments/patient-history :: historyModalContent";
    }

}
