<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.swasthopd.model.LabRequest" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
   <!-- This Is Doctors View -->
<head>
    <title>My Patient Lab Reports | SWASTH OPD+</title>
     <title>SWASTH OPD+ Dashboard</title>
    <link rel="icon" type="image/x-icon" href="/images/favicon.ico">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="/css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="wrapper">
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <jsp:include page="/WEB-INF/jsps/fragments/sidebar.jsp" />


        <!-- Main Content -->
        <main class="col-md-10 p-4">
            <h4 class="mb-4">Lab Reports for Your Patients</h4>

            <c:if test="${not empty reports}">
                <table class="table table-bordered table-hover bg-white">
                    <thead class="table-light">
                        <tr>
                            <th>Patient Name</th>
                            <th>Lab Type</th>
                            <th>Status</th>
                            <th>Instructions</th>
                            <th>Download</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="report" items="${reports}">
                            <tr>
                                <td>${report.patient.name}</td>
                                <td>${report.labType}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${report.status == 'Completed'}">
                                            <span class="badge bg-success">Completed</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-warning text-dark">Pending</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${report.instructions}</td>
                                <td>
                                    <c:if test="${report.status == 'Completed'}">
                                        <a href="${report.reportPath}" target="_blank" class="btn btn-sm btn-outline-primary">Download</a>
                                    </c:if>
                                    <c:if test="${report.status != 'Completed'}">
                                        <span class="text-muted">Not Available</span>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
            <c:if test="${empty reports}">
                <p class="text-muted">No lab reports found.</p>
            </c:if>
        </main>
    </div>
</div>
</div>
<script src="/js/script.js"></script>
</body>
</html>
