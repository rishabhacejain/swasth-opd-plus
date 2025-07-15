<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Patient History | SWASTH OPD+</title>
    <link rel="icon" type="image/x-icon" href="/images/favicon.ico">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="/css/dashboard.css">
</head>
<body>
<div class="wrapper">
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar Include -->
        <jsp:include page="/WEB-INF/jsps/fragments/sidebar.jsp" />

        <!-- Main Content Area -->
        <main class="col-md-10 p-4">
            <div class="container mt-4">
    <div class="card shadow p-4">
        <h4 class="mb-4">All Patient Visit History</h4>

        <!-- Filters -->
        <form method="get" action="/patient/history" class="row g-3 align-items-center mb-3">
            <div class="col-auto">
                <input type="date" name="fromDate" class="form-control" placeholder="From" />
            </div>
            <div class="col-auto">
                <input type="date" name="toDate" class="form-control" placeholder="To" />
            </div>
            <div class="col-auto">
                <button type="submit" class="btn btn-primary">Filter</button>
            </div>
            <div class="col-auto ms-auto">
                <a href="/patient/export/excel" class="btn btn-success">Export to Excel</a>
            </div>
        </form>

        <!-- Visit Table -->
        <div class="table-responsive">
            <table class="table table-bordered table-hover align-middle text-center">
                <thead class="table-light">
                    <tr>
                        <th>Date</th>
                        <th>Patient</th>
                        <th>Doctor</th>
                        <th>Department</th>
                        <th>Case Type</th>
                        <th>Symptoms</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="v" items="${visits}">
                    <tr>
                        <td>${v.visitTime}</td>
                        <td><a href="/patient/records/${v.patient.id}" class="text-primary fw-semibold">${v.patient.name}</a></td>
                        <td>${v.doctorName}</td>
                        <td>${v.department}</td>
                        <td>${v.caseType}</td>
                        <td>${v.symptoms}</td>
                        <td>
                            <span class="badge status-${v.status.toLowerCase()}">${v.status}</span>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
            
        </main>
    </div>
</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="/js/script.js"></script>
</body>
</html>
