	package com.swasthopd.controller;
	
	import java.io.IOException;
	import java.nio.file.*;
	import java.time.LocalDateTime;
	import java.time.format.DateTimeFormatter;
	import java.util.List;
	import java.util.Map;
	
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.http.HttpStatus;
	import org.springframework.http.ResponseEntity;
	import org.springframework.stereotype.Controller;
	import org.springframework.ui.Model;
	import org.springframework.web.bind.annotation.*;
	import org.springframework.web.multipart.MultipartFile;
	import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.swasthopd.model.Doctor;
import com.swasthopd.model.Patient;
import com.swasthopd.model.User;
import com.swasthopd.model.Visit;
import com.swasthopd.service.DoctorService;
import com.swasthopd.service.PatientService;
	import com.swasthopd.service.VisitService;
	
	import jakarta.servlet.http.HttpSession;
	
	@Controller
	@RequestMapping("/patient")
	public class PatientController {
	
	    private static final String UPLOAD_DIR = "src/main/resources/static/uploads/";
	
	    @Autowired
	    private PatientService patientService;
	    
	    @Autowired
	    private VisitService visitService;
	    
	    @Autowired
	    private DoctorService doctorService;
	
	    // Show patient registration form
	    @GetMapping("/register-patient")
	    public String showPatientForm(@RequestParam(value = "patientId", required = false) Long patientId,Model model, HttpSession session) {
	        if (session.getAttribute("loggedInUser") == null) {
	            return "redirect:/login";
	        }
	        
	        Patient patient;
	        if (patientId != null) {
	            patient = patientService.getPatientById(patientId);
	            model.addAttribute("existing", true);
	        } else {
	            patient = new Patient();
	            model.addAttribute("existing", false);
	        }
	
	        model.addAttribute("patient", patient);
	        model.addAttribute("recentPatients", patientService.getRecentPatients());
	
	        return "register-patient";
	    }
	
	    @PostMapping("/register-patient")
	    public String registerPatient(@ModelAttribute Patient patient,
	                                  @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
	                                  @RequestParam("symptoms") String symptoms,
	                                  @RequestParam("caseType") String caseType,
	                                  @RequestParam("department") String department,
	                                  @RequestParam("doctorName") String doctorName,
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
	        visit.setDoctorName(doctorName);
	        visit.setStatus("Waiting");
	
	        visitService.save(visit);
	
	        redirectAttributes.addFlashAttribute("msg", "Patient visit recorded successfully");
	        return "redirect:/patient/register-patient";
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
	    
	    @GetMapping("/aadhar/{aadharId}")
	    @ResponseBody
	    public Patient getPatientByAadhar(@PathVariable String aadharId) {
			/* System.out.println("Received Aadhar in controller: [" + aadharId + "]"); */
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
	    
	    @PostMapping("/register-visit")
	    @ResponseBody
	    public ResponseEntity<String> registerVisit(@RequestBody Map<String, Object> payload, HttpSession session) {
	        Object user = session.getAttribute("loggedInUser");
	        if (user == null) {
	            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User not logged in");
	        }
	
	        try {
	            Long patientId = Long.parseLong(payload.get("patientId").toString());
	
	            Patient patient = patientService.getPatientById(patientId);
	            if (patient == null) {
	                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Patient not found");
	            }
	
	            Visit visit = new Visit();
	            visit.setPatient(patient);
	            visit.setVisitTime(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
	            visit.setDoctorName(((com.swasthopd.model.User) user).getName());
	            visit.setDepartment("General Medicine");
	            visit.setCaseType("Elective");
	            visit.setSymptoms("Follow-up");
	            visit.setStatus("Active");
	
	            visitService.save(visit);
	            return ResponseEntity.ok("Visit registered");
	        } catch (Exception e) {
	            e.printStackTrace();
	            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed: " + e.getMessage());
	        }
	    }
	
	
	    
	 // Show full patient record (current + past visits)
	    @GetMapping("/records/{id}")
	    public String showPatientRecords(@PathVariable Long id, Model model, HttpSession session) {
	        Object userObj = session.getAttribute("loggedInUser");
	        if (userObj == null) {
	            return "redirect:/login";
	        }

	        Patient patient = patientService.getPatientById(id);
	        List<Visit> history = visitService.getVisitsByPatientId(id);
	        Visit latestVisit = visitService.getLatestVisitByPatientId(id);

	        // ❌ Removed doctor check — always allow edit
	        boolean canEdit = true;

	        model.addAttribute("patient", patient);
	        model.addAttribute("history", history);
	        model.addAttribute("latestVisit", latestVisit);
	        model.addAttribute("canEdit", canEdit);
	        
	        System.out.println(latestVisit);

	        return "patient-records";
	    }

	    
	    
	    
	    @PostMapping("/visit/update/{id}")
	    public String updateVisit(@PathVariable Long id,
	                              @RequestParam("observation") String observation,
	                              @RequestParam("prescription") String prescription,
	                              @RequestParam(value = "additionalComment", required = false) String additionalComment,
	                              HttpSession session,
	                              RedirectAttributes redirectAttributes) {
	        
	        Visit visit = visitService.getVisitById(id);
	        if (visit == null) {
	            redirectAttributes.addFlashAttribute("error", "Visit not found");
	            return "redirect:/patient/view-patients";
	        }

	        // Restrict to assigned doctor only
	        User loggedInUser = (User) session.getAttribute("loggedInUser");
	        Doctor currentDoctor = doctorService.findByUser(loggedInUser);
	        
	        if (visit.getDoctor() != null && currentDoctor != null &&
	        	    visit.getDoctor().getDocID() != currentDoctor.getDocID()) {

	        	    redirectAttributes.addFlashAttribute("error", "Access denied. You are not assigned to this patient.");
	        	    return "redirect:/patient/records/" + visit.getPatient().getId();
	        	}


	        visit.setObservation(observation);
	        visit.setPrescription(prescription);
	        visit.setAdditionalComment(additionalComment != null ? additionalComment : "");
	        visit.setStatus("Consulted");

	        visitService.save(visit);
	        redirectAttributes.addFlashAttribute("msg", "Visit updated successfully");
	        return "redirect:/patient/records/" + visit.getPatient().getId();
	    }



	
	}
