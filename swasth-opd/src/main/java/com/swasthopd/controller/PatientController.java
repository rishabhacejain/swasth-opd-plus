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
import com.swasthopd.model.Visit;
import com.swasthopd.service.PatientService;
import com.swasthopd.service.VisitService;

import jakarta.servlet.http.HttpSession;

@Controller
public class PatientController {

    private static final String UPLOAD_DIR = "src/main/resources/static/uploads/";

    @Autowired
    private PatientService patientService;
    
    @Autowired
    private VisitService visitService;

    // Show patient registration form
    @GetMapping("/register-patient")
    public String showPatientForm(Model model, HttpSession session) {
        if (session.getAttribute("loggedInUser") == null) {
            return "redirect:/login";
        }

        model.addAttribute("patient", new Patient());
        model.addAttribute("recentPatients", patientService.getRecentPatients());

        return "register-patient";
    }

    @PostMapping("/register-patient")
    public String registerPatient(@ModelAttribute Patient patient,
                                  @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                                  @RequestParam("symptoms") String symptoms,
                                  @RequestParam("caseType") String caseType,
                                  @RequestParam("department") String department,
                                  @RequestParam("doctor") String doctor,
                                  RedirectAttributes redirectAttributes) {

        Patient existing = patientService.findByAadharId(patient.getAadharId());

        Patient savedPatient;
        if (existing != null) {
            savedPatient = existing; // Use existing patient
        } else {
            // Handle image upload
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
                patient.setImageUrl("/images/default-avatar.png");
            }

            patient.setCreatedAt(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
            savedPatient = patientService.save(patient); // Save new patient
        }

        // Create visit
        Visit visit = new Visit();
        visit.setPatient(savedPatient);
        visit.setVisitTime(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        visit.setSymptoms(symptoms);
        visit.setCaseType(caseType);
        visit.setDepartment(department);
        visit.setDoctor(doctor);
        visit.setStatus("Waiting");

        visitService.save(visit);

        redirectAttributes.addFlashAttribute("msg", "Patient visit recorded successfully");
        return "redirect:/register-patient";
    }


    // View all patients
    @GetMapping("/view-patients")
    public String viewAllPatients(Model model, HttpSession session) {
        if (session.getAttribute("loggedInUser") == null) {
            return "redirect:/login";
        }

        List<Visit> visits = visitService.getTodayVisits(); // Not patientService
        model.addAttribute("visits", visits);
        return "view-patients";
    }
    
    @GetMapping("/patient/aadhar/{aadharId}")
    @ResponseBody
    public Patient getPatientByAadhar(@PathVariable String aadharId) {
        return patientService.findByAadharId(aadharId);
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
        List<Visit> history = visitService.getVisitsByPatientId(id);
        model.addAttribute("history", history); // Replace with actual history list if available
        return "fragments/patient-history :: historyModalContent";
    }

}
