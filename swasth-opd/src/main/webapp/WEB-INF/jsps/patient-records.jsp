<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.swasthopd.model.Visit" %>
<%@ page import="com.swasthopd.model.Patient" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Patient Medical Records | SWASTH OPD+</title>
    <link rel="icon" type="image/x-icon" href="/images/favicon.ico">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="/css/dashboard.css">
    <style>
        .card-box {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 0 10px rgba(0,0,0,0.08);
            padding: 20px;
            margin-bottom: 20px;
        }
        .label-title {
            font-weight: 600;
        }
    </style>
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
            <h4 class="mb-4">Patient Medical Records</h4>

            <!-- Patient Info Section -->
            <div class="card-box mb-4">
                <h5>Patient Profile</h5>
                <div class="row g-3">
                    <div class="col-md-4 text-center">
                        <img src="${patient.imageUrl}" class="rounded-circle" style="width: 120px; height: 120px; object-fit: cover;">
                    </div>
                    <div class="col-md-8">
                        <p><strong>Name:</strong> ${patient.name}</p>
                        <p><strong>Aadhar ID:</strong> ${patient.maskedAadharId}</p>
                        <p><strong>DOB:</strong> ${patient.dob}</p>
                        <p><strong>Phone:</strong> ${patient.phone}</p>
                        <p><strong>Address:</strong> ${patient.address}</p>
                    </div>
                </div>
            </div>

            <!-- Past Visits Section -->
            <div class="card-box">
                <h5 class="mb-3">Past Visit History</h5>
                <c:if test="${not empty history}">
                    <table class="table table-bordered table-sm">
                        <thead class="table-light">
                        <tr>
                            <th>Date</th>
                            <th>Department</th>
                            <th>Doctor</th>
                            <th>Case Type</th>
                            <th>Symptoms</th>
                            <th>Observation</th>
                            <th>Prescription</th>
                            <th>Comments</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="v" items="${history}">
                            <tr>
                                <td>${v.visitTime}</td>
                                <td>${v.department}</td>
                                <td>${v.doctorName}</td>
                                <td>${v.caseType}</td>
                                <td>${v.symptoms}</td>
                                <td>${v.observation}</td>
                                <td>${v.prescription}</td>
                                <td>${v.additionalComment}</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:if>
                <c:if test="${empty history}">
                    <p class="text-muted">No past visits found.</p>
                </c:if>
            </div>

            <!-- Current Visit Update -->
            <c:if test="${canEdit}">
            <div class="card-box">
                <h5>Update Current Visit</h5>
                <form action="/patient/visit/update/${latestVisit.id}" method="post">
                    <div class="row g-3">
                        <div class="col-12 form-floating">
                            <textarea name="observation" class="form-control" placeholder="Observation" style="height:100px;">${latestVisit.observation}</textarea>
                            <label>Observation</label>
                        </div>
                        <div class="col-12 form-floating">
                            <textarea name="prescription" class="form-control" placeholder="Prescription" style="height:100px;">${latestVisit.prescription}</textarea>
                            <label>Prescription</label>
                        </div>
                        <div class="col-12 form-floating">
                            <textarea name="additionalComment" class="form-control" placeholder="Comments" style="height:100px;">${latestVisit.additionalComment}</textarea>
                            <label>Additional Comments</label>
                        </div>
                    </div>

                    <div class="mt-3">
                        <button type="submit" class="btn btn-primary">Update Visit</button>
                        <a href="/patient/view-patients" class="btn btn-secondary ms-2">Back</a>
                    </div>
                </form>
            </div>
            </c:if>

            <c:if test="${not canEdit}">
            <div class="card-box">
                <h5>Current Visit Summary (Read-Only)</h5>
                <p><strong>Observation:</strong> ${latestVisit.observation}</p>
                <p><strong>Prescription:</strong> ${latestVisit.prescription}</p>
                <p><strong>Comments:</strong> ${latestVisit.additionalComment}</p>
            </div>
            </c:if>

            <!-- Request Lab Report -->
            <div class="card-box">
                <h5>Request Lab Test</h5>
                <form action="/lab/request" method="post">
                    <input type="hidden" name="patientId" value="${patient.id}" />
                    <input type="hidden" name="visitId" value="${latestVisit.id}" />

                    <div class="form-floating mb-3">
                        <select name="labType" class="form-select" required>
                            <option value="" disabled selected>Select Lab Type</option>
                            <option value="Pathology">Pathology</option>
                            <option value="Radiology">Radiology</option>
                            <option value="Scanning">Scanning</option>
                        </select>
                        <label for="labType">Lab Type</label>
                    </div>
                    <div class="form-floating">
                        <textarea name="labRequestDetails" class="form-control" style="height: 100px;" required></textarea>
                        <label>Lab Request Instructions</label>
                    </div>

                    <div class="mt-3">
                        <button type="submit" class="btn btn-warning">Send Lab Request</button>
                    </div>
                </form>
            </div>

        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
