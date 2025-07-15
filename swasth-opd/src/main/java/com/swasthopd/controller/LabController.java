package com.swasthopd.controller;

import com.swasthopd.model.LabRequest;
import com.swasthopd.model.Patient;
import com.swasthopd.model.User;
import com.swasthopd.model.Visit;
import com.swasthopd.service.LabRequestService;
import com.swasthopd.service.PatientService;
import com.swasthopd.service.VisitService;
import java.nio.file.*;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/lab")
public class LabController {

    @Autowired
    private LabRequestService labRequestService;

    @Autowired
    private PatientService patientService;

    @Autowired
    private VisitService visitService;

    @PostMapping("/request")
    public String requestLabTest(@RequestParam("patientId") Long patientId,
                                 @RequestParam("visitId") Long visitId,
                                 @RequestParam("labType") String labType,
                                 @RequestParam("labRequestDetails") String labRequestDetails,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        Object user = session.getAttribute("loggedInUser");
        if (user == null) {
            return "redirect:/login";
        }

        Patient patient = patientService.getPatientById(patientId);
        Visit visit = visitService.getVisitById(visitId);

        if (patient == null || visit == null) {
            redirectAttributes.addFlashAttribute("error", "Invalid patient or visit");
            return "redirect:/patient/view-patients";
        }

        LabRequest labRequest = new LabRequest();
        labRequest.setPatient(patient);
        labRequest.setVisit(visit);
        labRequest.setLabType(labType);
        labRequest.setInstructions(labRequestDetails);
        labRequest.setStatus("Pending");
        labRequest.setRequestedBy(((User) user).getName());

        labRequestService.save(labRequest);

        redirectAttributes.addFlashAttribute("msg", "Lab test request sent successfully");
        return "redirect:/patient/records/" + patientId;
    }
    
    
    
    @PostMapping("/upload-report/{id}")
    public String uploadLabReport(@PathVariable Long id,
                                  @RequestParam("reportFile") MultipartFile file,
                                  RedirectAttributes redirectAttributes) {
        try {
            LabRequest req = labRequestService.getById(id);
            if (req == null) {
                redirectAttributes.addFlashAttribute("error", "Request not found.");
                return "redirect:/lab/requests";
            }

            // Save the file
            String fileName = "lab_" + id + "_" + file.getOriginalFilename();
            Path path = Paths.get("src/main/resources/static/reports/", fileName);
            Files.createDirectories(path.getParent());
            Files.write(path, file.getBytes());

            // Update record
            req.setReportPath("/reports/" + fileName);
            req.setStatus("Completed");
            labRequestService.save(req);

            redirectAttributes.addFlashAttribute("msg", "Report uploaded.");
        }catch (MaxUploadSizeExceededException e) {
            redirectAttributes.addFlashAttribute("error", "Upload failed: File is too large.");
        
        }catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Upload failed: " + e.getMessage());
        }
        return "redirect:/lab/requests";
    }

    
    @GetMapping("/lab-reports")
    public String showLabReports(Model model, HttpSession session) {
        String doctorName = (String) session.getAttribute("doctorName"); // or however you're storing
        List<LabRequest> reports = labRequestService.getReportsForDoctor(doctorName);
        model.addAttribute("reports", reports);
        return "lab-reports"; // JSP page name
    }
    
    @GetMapping("/requests")
    public String viewAllLabRequests(Model model) {
        List<LabRequest> allRequests = labRequestService.getAllRequests();
        System.out.println("Total Lab Requests Found: " + allRequests.size()); // ✅ check size
        for (LabRequest r : allRequests) {
            System.out.println("Request: " + r.getPatient().getName() + ", Status: " + r.getStatus());
        }
        model.addAttribute("labRequests", allRequests);
        return "lab-requests";
    }

}
