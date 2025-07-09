<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.swasthopd.model.Visit" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Patients | SWASTH OPD+</title>
    <link rel="icon" type="image/x-icon" href="/images/favicon.ico">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="/css/dashboard.css">
    <link rel="stylesheet" href="/css/view-patient.css">
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <nav class="col-md-2 sidebar d-flex flex-column">
            <h4 class="text-center my-4">SWASTH OPD+</h4>
            <a href="/dashboard"><i class="bi bi-speedometer2 me-2"></i>Dashboard</a>
            <a href="/patient/register-patient"><i class="bi bi-person-plus me-2"></i>Register Patient</a>
            <a href="/patient/view-patients" class="active"><i class="bi bi-people-fill me-2"></i>View Patients</a>
            <a href="/lab-reports"><i class="bi bi-flask me-2"></i>Lab Reports</a>
            <a href="/refer-cases"><i class="bi bi-arrow-repeat me-2"></i>Refer Cases</a>
            <a href="/history"><i class="bi bi-clock-history me-2"></i>History</a>
            <a href="/logout" class="mt-auto"><i class="bi bi-box-arrow-right me-2"></i>Logout</a>
        </nav>

        <!-- Main Content -->
        <main class="col-md-10 p-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4>Today's Patient Queue</h4>
                <div>
                    <input type="text" class="form-control d-inline-block" placeholder="Search Patient..." style="width: 250px;">
                </div>
            </div>

            <div class="row">
                <!-- Patient Table -->
                <div class="col-md-8">
                    <div class="card-box d-flex flex-column" style="height: 600px;">
                        <h5 class="mb-3">Today's Patient Queue</h5>
                        <div class="table-responsive" style="flex: 1 1 auto; overflow-y: auto;">
                            <table class="table table-hover align-middle">
                                <thead class="table-light sticky-top">
                                    <tr>
                                        <th>No</th>
                                        <th>Visit Date & Time</th>
                                        <th>Patient Name</th>
                                        <th>Department</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="v" items="${visits}" varStatus="loop">
                                        <tr onclick="updateProfile(
                                                '${v.patient.name}', 
                                                '${v.doctorName}', 
                                                '${v.patient.phone}', 
                                                '${v.patient.address}', 
                                                '${v.visitTime}', 
                                                '${v.patient.id}', 
                                                '${v.patient.gender}', 
                                                '${v.caseType}', 
                                                '${v.patient.dob}', 
                                                '${v.patient.maskedAadharId}', 
                                                '${v.patient.imageUrl}')">
                                            <td>${loop.index + 1}</td>
                                            <td>${v.visitTime}</td>
                                            <td>${v.patient.name}</td>
                                            <td>${v.department}</td>
                                            <td><span class="badge bg-info text-dark">${v.status}</span></td>
                                            <td><i class="bi bi-three-dots-vertical"></i></td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty visits}">
                                        <tr>
                                            <td colspan="6" class="text-center text-muted">No patients found today.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination (Optional) -->
                        <div class="mt-auto">
                            <nav aria-label="Pagination">
                                <ul class="pagination justify-content-end mt-3 mb-0">
                                    <li class="page-item disabled"><a class="page-link" href="#">Previous</a></li>
                                    <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                                    <li class="page-item"><a class="page-link" href="#">Next</a></li>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>

                <!-- Patient Profile -->
<div class="col-md-4">
    <div class="card-box text-center p-4">
        <h5 class="mb-4">Patient Profile</h5>
        <div class="mx-auto rounded-circle overflow-hidden mb-3"
             style="width: 120px; height: 120px; background-color: #e0e0e0;">
            <img id="patientImg" src="/images/default-avatar.png" alt="Avatar" class="img-fluid"
                 style="width: 100%; height: 100%; object-fit: cover;">
        </div>
         <h6 id="patientName" class="fw-bold mb-1">—</h6>
        <p class="fw-bold" id="doctorName">Admitted by: —</p>
        <div class="text-start mb-3">
            <p><strong>Aadhar ID:</strong> <span id="aadharId">—</span></p>
            <p><strong>Patient ID:</strong> <span id="patientId">—</span></p>
            <p><strong>DOB:</strong> <span id="dob">—</span></p>
            <p><strong>Phone:</strong> <span id="phone">—</span></p>
            <p><strong>Address:</strong> <span id="address">—</span></p>
        </div>

        <!-- View Full Records Button -->
        <a id="viewDetailsBtn" href="#" class="btn btn-outline-primary w-100">
            <i class="bi bi-journal-text me-1"></i> View Full Records
        </a>
    </div>
</div>

<!-- JS for Profile Update -->
<script>

    function maskAadhar(aadhar) {
         if (!aadhar || aadhar.length < 4) return '—';
         const last4 = aadhar.slice(-4);
       return "XXXX XXXX " + last4;
}

    function updateProfile(name, doctorName, phone, address, visitTime,
                           patientId, gender, caseType, dob, aadharId, imageUrl) {
        document.getElementById("doctorName").innerText = "Admitted by: Dr. " + doctorName;
        document.getElementById("patientName").innerText = name;
        document.getElementById("phone").innerText = phone;
        document.getElementById("address").innerText = address;
        document.getElementById("patientId").innerText = "RM" + (100000 + parseInt(patientId));
        document.getElementById("dob").innerText = dob && dob !== 'null' ? dob : '—';
        document.getElementById("aadharId").innerText = aadharId || '—';
        document.getElementById("patientImg").src = imageUrl || '/images/default-avatar.png';
        document.getElementById("viewDetailsBtn").href = "/patient/records/" + patientId;
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
