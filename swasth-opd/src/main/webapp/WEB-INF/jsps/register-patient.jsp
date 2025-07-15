<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
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
    
</head>
<body>
<div class="wrapper">
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
         <jsp:include page="/WEB-INF/jsps/fragments/sidebar.jsp" />

        <!-- Main Content -->
        <main class="col-md-10 p-4">
            <h4 class="mb-4">New Patient Registration</h4>

            <form action="/patient/register-patient" method="post" enctype="multipart/form-data">
                <div class="row g-4">

                
                   <!-- ================== Patient Info ================== -->
<h5>Patient Information</h5>

<div class="col-md-6 form-floating">
    <input type="text" name="aadharId" id="aadharId" class="form-control"
           placeholder="Aadhar ID" required maxlength="12" value="${patient.aadharId}">
    <label for="aadharId">Aadhar ID</label>
</div>

<div class="col-md-6 form-floating">
    <input type="text" name="name" id="name" class="form-control"
           placeholder="Patient Name" required value="${patient.name}">
    <label for="name">Patient Name</label>
</div>

<div class="col-md-6 form-floating">
    <input type="date" name="dob" id="dob" class="form-control"
           placeholder="Date of Birth" required value="${patient.dob}">
    <label for="dob">Date of Birth</label>
</div>

<!-- Hidden age field to send to backend -->
<input type="hidden" name="age" id="ageHidden" value="${patient.age}">
<div class="col-md-6 mt-2">
    <span id="ageDisplay" class="text-muted small">
        <c:if test="${not empty patient.age}">Age: ${patient.age} yrs</c:if>
    </span>
</div>

<div class="col-md-6 form-floating">
    <select name="gender" id="gender" class="form-select" required>
        <option value="" disabled ${empty patient.gender ? 'selected' : ''}>Select Gender</option>
        <option value="Male" ${patient.gender == 'Male' ? 'selected' : ''}>Male</option>
        <option value="Female" ${patient.gender == 'Female' ? 'selected' : ''}>Female</option>
        <option value="Other" ${patient.gender == 'Other' ? 'selected' : ''}>Other</option>
    </select>
    <label for="gender">Gender</label>
</div>

<div class="col-md-6 form-floating">
    <input type="text" name="address" id="address" class="form-control"
           placeholder="Address" required value="${patient.address}">
    <label for="address">Address</label>
</div>

<div class="col-md-6 form-floating">
    <input type="text" name="phone" id="phone" class="form-control"
           placeholder="Phone" required value="${patient.phone}">
    <label for="phone">Phone</label>
</div>
                   

                    <div class="col-md-6">
                        <label class="form-label mt-2">Patient Image (optional)</label>
                        <input type="file" name="imageFile" class="form-control">
                    </div>

                    <!-- ================== Visit Info ================== -->
                    <h5 class="mt-4">Visit Information</h5>

                    <div class="col-md-6 form-floating">
                        <input type="text" class="form-control" value="<%= visitTime %>" readonly>
                        <label>Visit Time</label>
                    </div>

                    <div class="col-md-6 form-floating">
                        <input type="text" name="symptoms" id="symptoms" class="form-control" placeholder="Symptoms" required>
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
                             <option>Cardiology</option>
                             <option>Neurology</option>
                             <option>Gynecology</option>
                             <option>Pediatrics</option>
                             <option>Urology</option>
                             <option>Oncology</option>
                             <option>Pulmonology</option>
                             <option>Dermatology</option>
                             <option>Ophthalmology</option>
                             <option>Psychiatry</option>
                             <option>Gastroenterology</option>
                             <option>Nephrology</option>	
                        </select>
                        <label for="department">Department</label>
                    </div>

                    <div class="col-md-6 form-floating">
                        <input type="text" name="doctorName" id="doctorName" class="form-control" placeholder="Doctor Name" required>
                        <label for="doctorName">Doctor</label>
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
                    <c:forEach var="v" items="${recentPatients}">
                        <li class="list-group-item d-flex justify-content-between">
                            <span>${v.name}</span>
                            <span>${v.createdAt}</span>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </main>
    </div>
</div>
</div>
<script>
    // Auto-fill fields if aadhar already exists
    document.getElementById("aadharId").addEventListener("blur", function () {
        const aadhar = this.value.trim();
        if (aadhar.length === 12) {
            fetch(`/patient/aadhar/` + aadhar)
                .then(response => {
                    if (!response.ok) throw new Error("Not found");
                    return response.json();
                })
                .then(patient => {
                    if (patient) {
                        document.getElementById("name").value = patient.name;
                        document.getElementById("dob").value = patient.dob;
                        document.getElementById("gender").value = patient.gender;
                        document.getElementById("address").value = patient.address;
                        document.getElementById("phone").value = patient.phone;

                        ["name", "dob", "gender", "address", "phone"].forEach(id => {
                            document.getElementById(id).readOnly = true;
                            document.getElementById(id).classList.add("bg-light");
                        });

                        alert("Existing patient found. New visit will be recorded.");
                    }
                })
                .catch(err => {
                    ["name", "dob", "gender", "address", "phone"].forEach(id => {
                        const field = document.getElementById(id);
                        field.readOnly = false;
                        field.classList.remove("bg-light");
                        field.value = "";
                    });
                });
        }
    });

    // Calculate age from DOB
    document.getElementById("dob").addEventListener("change", function () {
        const dob = new Date(this.value);
        const today = new Date();
        let age = today.getFullYear() - dob.getFullYear();
        const m = today.getMonth() - dob.getMonth();
        if (m < 0 || (m === 0 && today.getDate() < dob.getDate())) {
            age--;
        }
        document.getElementById("ageDisplay").innerText = "Age: " + age + " yrs";
        document.getElementById("ageHidden").value = age;
    });

    // Auto-fill aadhar if coming from dashboard
   window.addEventListener("load", function () {
    const aadhar = sessionStorage.getItem("searchAadhar");
    if (aadhar && aadhar.length === 12) {
        const input = document.getElementById("aadharId");
        if (input) {
            input.value = aadhar;
            sessionStorage.removeItem("searchAadhar");

            // Delay to ensure input is rendered
            setTimeout(() => {
                input.dispatchEvent(new Event("blur"));
            }, 100);
        }
    }
});
</script>
<script src="/js/script.js"></script>
</body>
</html>
