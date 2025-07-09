<%@page import="com.swasthopd.model.User"%>
<%@page import="com.swasthopd.model.Visit"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="java.time.*"%>
<%@ page import="java.time.format.DateTimeFormatter"%>

<%
    User doctor = (User) request.getAttribute("doctor");
    List<Visit> visits = (List<Visit>) request.getAttribute("visits");

    int newPatients = 0;
    int oldPatients = 0;

    Set<Long> countedPatients = new HashSet<>();

    for (Visit v : visits) {
        Long patientId = v.getPatient().getId();

        if (!countedPatients.contains(patientId)) {
            countedPatients.add(patientId);

            List<Visit> allVisits = v.getPatient().getVisits();
            if (allVisits != null && allVisits.size() > 1) {
                oldPatients++;
            } else {
                newPatients++;
            }
        }
    }
%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SWASTH OPD+ Dashboard</title>
    <link rel="icon" type="image/x-icon" href="/images/favicon.ico">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="/css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
</head>

<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <nav class="col-md-2 sidebar d-flex flex-column">
            <h4 class="text-center my-4">SWASTH OPD+</h4>
            <a href="/dashboard"><i class="bi bi-speedometer2 me-2"></i>Dashboard</a>
            <a href="/patient/register-patient"><i class="bi bi-person-plus me-2"></i>Register Patient</a>
            <a href="/patient/view-patients"><i class="bi bi-people-fill me-2"></i> View Patients</a>
            <a href="/patient/lab-request"><i class="bi bi-cloud-arrow-down me-2"></i>Lab Requests</a>
            <a href="/patient/refer-patient"><i class="bi bi-arrow-right-circle me-2"></i>Referrals</a>
            <a href="/patient/history"><i class="bi bi-clock-history me-2"></i>History</a>
            <a href="/logout" class="mt-auto"><i class="bi bi-box-arrow-right me-2"></i>Logout</a>
        </nav>

        <!-- Main Content -->
        <main class="col-md-10 p-4">
            <!-- Top Bar -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3>Good Morning, <span class="text-primary">Dr. <%= doctor.getName() %></span></h3>
                <div class="d-flex align-items-center">
                    <input type="text" class="form-control" placeholder="Search..." style="width: 200px;">
                    <img src="/images/doctor-avatar.png" alt="avatar" class="rounded-circle ms-3" width="40">
                </div>
            </div>

            <!-- Aadhar Search Panel -->
            <div class="card-box p-4 mb-4">
                <h5 class="mb-3">Search Patient by Aadhar</h5>
                <div class="d-flex gap-3 align-items-center">
                    <input type="text" id="searchAadhar" maxlength="12" class="form-control" placeholder="Enter 12-digit Aadhar ID" style="width: 250px;">
                    <button class="btn btn-primary" onclick="searchByAadhar()">Search</button>
                </div>

                <div id="searchResult" class="mt-3 d-none">
                    <div class="card p-3">
                        <h6 class="mb-2">Patient Found:</h6>
                        <p><strong>Patient ID:</strong> <span id="resultPatientId">—</span></p>
                        <p><strong>Masked Aadhar:</strong> <span id="maskedAadhar">—</span></p>
                        <div class="mt-2">
                            <button class="btn btn-success" onclick="registerVisit()">Register Visit</button>
                        </div>
                    </div>
                </div>

                <div id="notFound" class="mt-3 d-none">
                    <div class="alert alert-warning">
                        No patient found. <button class="btn btn-outline-primary btn-sm" onclick="openRegisterPage()">Register New Patient</button>
                    </div>
                </div>
            </div>

            <!-- Summary Cards -->
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="card-box text-center">
                        <h6 class="text-muted">Visits for Today</h6>
                        <h2 class="fw-bold"><%= visits.size() %></h2>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card-box text-center">
                        <h6 class="text-muted">New Patients</h6>
                        <h2 class="fw-bold text-success"><%= newPatients %></h2>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card-box text-center">
                        <h6 class="text-muted">Old Patients</h6>
                        <h2 class="fw-bold text-danger"><%= oldPatients %></h2>
                    </div>
                </div>
            </div>

            <!-- Patient List & Consultation -->
            <div class="row mb-4">
                <!-- Patient List -->
                <div class="col-md-6">
                    <div class="card-box">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="mb-0">Patient List</h5>
                            <span class="text-muted">Today</span>
                        </div>
                        <ul class="list-group">
                            <%
                                for (Visit v : visits) {
                                    String[] nameParts = v.getPatient().getName().split(" ");
                                    String initials = nameParts[0].substring(0, 1);
                                    if (nameParts.length > 1) {
                                        initials += nameParts[1].substring(0, 1);
                                    }
                            %>
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <div class="d-flex align-items-center">
                                    <div class="rounded-circle bg-secondary text-white d-flex justify-content-center align-items-center me-3"
                                         style="width: 40px; height: 40px;">
                                        <%= initials.toUpperCase() %>
                                    </div>
                                    <div>
                                        <strong><%= v.getPatient().getName() %></strong><br>
                                        <small class="text-muted"><%= v.getSymptoms() %></small>
                                    </div>
                                </div>
                                <span class="badge bg-light text-dark"><%= v.getVisitTime() %></span>
                            </li>
                            <% } %>
                            <% if (visits.isEmpty()) { %>
                                <li class="list-group-item text-center text-muted">No visits today</li>
                            <% } %>
                        </ul>
                    </div>
                </div>

                <!-- Consultation Summary -->
                <div class="col-md-6">
                    <div class="card-box">
                        <h5 class="mb-3">Consultation Summary</h5>
                        <%
                            if (!visits.isEmpty()) {
                                Visit recent = visits.get(0);
                                String fullName = recent.getPatient().getName();
                                int age = recent.getPatient().getAge();
                                String gender = recent.getPatient().getGender();
                                String recentSymptoms = recent.getSymptoms();
                                String observation = recent.getObservation() != null ? recent.getObservation() : "—";
                                String prescription = recent.getPrescription() != null ? recent.getPrescription() : "—";
                                String comments = recent.getAdditionalComment() != null ? recent.getAdditionalComment() : "—";
                        %>
                        <div class="d-flex align-items-center mb-3">
                            <div class="rounded-circle bg-info text-white d-flex justify-content-center align-items-center me-3"
                                 style="width: 50px; height: 50px;">
                                <%= fullName.substring(0, 1).toUpperCase() %>
                            </div>
                            <div>
                                <strong><%= fullName %></strong><br>
                                <small class="text-muted">Age: <%= age %> • <%= gender %></small>
                            </div>
                        </div>
                        <p><strong>Last Checked:</strong> <%= recent.getVisitTime() %></p>
                        <p><strong>Symptoms:</strong> <%= recentSymptoms %></p>
                        <p><strong>Observation:</strong> <%= observation %></p>
                        <p><strong>Prescription:</strong> <%= prescription %></p>
                        <p><strong>Additional Comments:</strong> <%= comments %></p>
                        <% } else { %>
                            <p class="text-muted">No consultations yet today.</p>
                        <% } %>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script>
function searchByAadhar() {
    const aadhar = document.getElementById("searchAadhar").value.trim();
    if (aadhar.length !== 12) {
        alert("Enter a valid 12-digit Aadhar number");
        return;
    }

    fetch(`/patient/aadhar/` + aadhar)
        .then(res => {
            if (!res.ok) throw new Error("Not Found");
            return res.json();
        })
        .then(patient => {
            if (!patient || !patient.aadharId) throw new Error("Not Found");

            const masked = "XXXX XXXX " + patient.aadharId.slice(-4);
            const rmId = "RM" + (100000 + patient.id);

            document.getElementById("resultPatientId").innerText = rmId;
            document.getElementById("maskedAadhar").innerText = masked;

            document.getElementById("searchResult").classList.remove("d-none");
            document.getElementById("notFound").classList.add("d-none");

            sessionStorage.setItem("searchAadhar", aadhar);
            sessionStorage.setItem("patientId", patient.id);
        })
        .catch(err => {
            document.getElementById("searchResult").classList.add("d-none");
            document.getElementById("notFound").classList.remove("d-none");
        });
}

function openRegisterPage() {
    window.location.href = "/patient/register-patient";
}
function registerVisit() {
    window.location.href = "/patient/register-patient";
}
</script>
</body>
</html>
