<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="com.swasthopd.model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
String visitTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>New Patient Registration | SWASTH OPD+</title>
    <link rel="icon" type="image/x-icon" href="/images/favicon.ico">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="/css/dashboard.css">
    <link rel="stylesheet" href="/css/register-patient.css">
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <nav class="col-md-2 sidebar d-flex flex-column p-3">
            <h4 class="text-center mb-4">SWASTH OPD+</h4>
            <a href="/dashboard"><i class="bi bi-speedometer2 me-2"></i> Dashboard</a>
            <a href="/register-patient" class="active"><i class="bi bi-person-plus me-2"></i> Add Patient</a>
            <a href="/view-patients"><i class="bi bi-people me-2"></i> View Patients</a>
            <a href="/lab-reports"><i class="bi bi-flask me-2"></i> Lab Reports</a>
            <a href="/refer-cases"><i class="bi bi-arrow-repeat me-2"></i> Refer Cases</a>
            <a href="/history"><i class="bi bi-clock-history me-2"></i> History</a>
            <a href="/logout" class="mt-auto"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
        </nav>

        <!-- Main Content -->
        <main class="col-md-10 p-4">
            <h4 class="mb-4">New Patient Registration</h4>

            <!-- Registration Form -->
            <form action="/register-patient" method="post" enctype="multipart/form-data">
                <div class="row g-4">

                    <!-- Patient Info -->
                    <div class="col-md-6 form-floating">
                        <input type="text" name="name" id="name" class="form-control" placeholder="Patient Name" required>
                        <label for="name">Patient Name</label>
                    </div>

                    <div class="col-md-3 form-floating">
                        <input type="number" name="age" id="age" class="form-control" placeholder="Age" required>
                        <label for="age">Age</label>
                    </div>

                    <div class="col-md-3 form-floating">
                        <select name="gender" id="gender" class="form-select" required>
                            <option value="" disabled selected>Select Gender</option>
                            <option>Male</option>
                            <option>Female</option>
                            <option>Other</option>
                        </select>
                        <label for="gender">Gender</label>
                    </div>

                    <div class="col-md-6 form-floating">
                        <input type="text" name="address" id="address" class="form-control" placeholder="Address" required>
                        <label for="address">Address</label>
                    </div>

                    <div class="col-md-6 form-floating">
                        <input type="text" name="phone" id="phone" class="form-control" placeholder="Phone" required>
                        <label for="phone">Phone</label>
                    </div>

                    <!-- Visit Info -->
                    <div class="col-md-6 form-floating">
                        <input type="text" class="form-control" value="<%= visitTime %>" readonly>
                        <label>Visit Time</label>
                    </div>

                    <div class="col-md-6 form-floating">
                        <input type="text" name="symptoms" id="symptoms" class="form-control" placeholder="Symptoms">
                        <label for="symptoms">Symptoms</label>
                    </div>

                    <div class="col-md-6 form-floating">
                        <select name="caseType" id="caseType" class="form-select" required>
                            <option value="" disabled selected>Select Case Type</option>
                            <option>Elective</option>
                            <option>Emergency</option>
                        </select>
                        <label for="caseType">Case Type</label>
                    </div>

                    <div class="col-md-6 form-floating">
                        <select name="department" id="department" class="form-select" required>
                            <option>General</option>
                            <option>ENT</option>
                            <option>Ortho</option>
                        </select>
                        <label for="department">Department</label>
                    </div>

                    <div class="col-md-6 form-floating">
                        <input type="text" name="doctor" id="doctor" class="form-control" placeholder="Doctor Name" required>
                        <label for="doctor">Doctor</label>
                    </div>

                    <!-- Identity -->
                    <div class="col-md-6 form-floating">
                        <input type="text" name="aadharId" id="aadharId" class="form-control" placeholder="Aadhar ID">
                        <label for="aadharId">Aadhar ID</label>
                    </div>

                    <div class="col-md-6 form-floating">
                        <input type="date" name="dob" id="dob" class="form-control" placeholder="Date of Birth">
                        <label for="dob">Date of Birth</label>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label mt-2">Patient Image (optional)</label>
                        <input type="file" name="imageFile" class="form-control">
                    </div>
                </div>

                <!-- Submit Buttons -->
                <div class="mt-4">
                    <button type="submit" class="btn btn-primary px-4 me-2">Register</button>
                    <button type="reset" class="btn btn-outline-secondary px-4">Reset</button>
                </div>
            </form>

            <!-- Recent Visits -->
            <div class="mt-5">
                <h5>Recently Registered Patients</h5>
                <ul class="list-group">
                    <c:forEach var="v" items="${recentVisits}">
                        <li class="list-group-item d-flex justify-content-between">
                            <span>${v.patient.name}</span>
                            <span>${v.visitTime}</span>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </main>
    </div>
</div>
<script>
document.getElementById("aadharId").addEventListener("blur", function () {
    const aadhar = this.value.trim();

    if (aadhar.length === 12) {
        fetch(`/patient/aadhar/${aadhar}`)
            .then(response => {
                if (!response.ok) throw new Error("Not found");
                return response.json();
            })
            .then(patient => {
                if (patient) {
                    // Fill fields with existing data
                    document.getElementById("name").value = patient.name;
                    document.getElementById("age").value = patient.age;
                    document.getElementById("gender").value = patient.gender;
                    document.getElementById("address").value = patient.address;
                    document.getElementById("phone").value = patient.phone;
                    document.getElementById("dob").value = patient.dob;

                    // Make read-only
                    ["name", "age", "gender", "address", "phone", "dob"].forEach(id => {
                        document.getElementById(id).readOnly = true;
                        document.getElementById(id).classList.add("bg-light");
                    });

                    // Inform the user
                    alert("Existing patient found. Creating new visit only.");
                }
            })
            .catch(err => {
                console.log("No existing patient found.");
                // Clear fields and allow input
                ["name", "age", "gender", "address", "phone", "dob"].forEach(id => {
                    const field = document.getElementById(id);
                    field.value = "";
                    field.readOnly = false;
                    field.classList.remove("bg-light");
                });
            });
    }
});
</script>

</body>
</html>
