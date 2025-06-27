<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.swasthopd.model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | SWASTH OPD+</title>
    <link rel="icon" href="/images/favicon.ico">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="/css/dashboard.css">
</head>

<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <nav class="col-md-2 sidebar d-flex flex-column">
            <h4 class="text-center my-4">SWASTH OPD+</h4>
            <a href="/admin/panel"><i class="bi bi-speedometer2 me-2"></i>Dashboard</a>
            <a href="/admin/users"><i class="bi bi-person-check me-2"></i>Approve Users</a>
            <a href="/admin/logs"><i class="bi bi-file-earmark-text me-2"></i>System Logs</a>
            <a href="/admin/settings"><i class="bi bi-gear me-2"></i>System Settings</a>
            <a href="/logout" class="mt-auto"><i class="bi bi-box-arrow-right me-2"></i>Logout</a>
        </nav>

        <!-- Main Content -->
        <main class="col-md-10 p-4">
            <!-- Top Bar -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3>Welcome, <span class="text-primary">Admin</span></h3>
                <div class="d-flex align-items-center">
                    <input type="text" class="form-control" placeholder="Search..." style="width: 200px;">
                    <img src="/images/admin-avatar.png" alt="avatar" class="rounded-circle ms-3" width="40">
                </div>
            </div>

            <!-- Summary Cards -->
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="card-box text-center">
                        <h6 class="text-muted">Pending Approvals</h6>
                        <h2 class="fw-bold text-warning">${pendingCount}</h2>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card-box text-center">
                        <h6 class="text-muted">Active Users</h6>
                        <h2 class="fw-bold text-success">${activeCount}</h2>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card-box text-center">
                        <h6 class="text-muted">Total Registered</h6>
                        <h2 class="fw-bold text-primary">${totalCount}</h2>
                    </div>
                </div>
            </div>

            <!-- Pending User Approval Table -->
            <div class="card-box">
                <h5 class="mb-3">Users Awaiting Approval</h5>

                <c:if test="${empty pendingUsers}">
                    <div class="alert alert-success">No users pending approval 🎉</div>
                </c:if>

                <c:if test="${not empty pendingUsers}">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Username</th>
                                <th>Role</th>
                                <th>Department</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${pendingUsers}">
                                <tr>
                                    <td>${user.name}</td>
                                    <td>${user.username}</td>
                                    <td>${user.role}</td>
                                    <td>${user.department}</td>
                                    <td>
                                        <form action="/admin/approve-user" method="post" style="display:inline;">
                                            <input type="hidden" name="userId" value="${user.id}">
                                            <button type="submit" class="btn btn-success btn-sm">Approve</button>
                                        </form>
                                        <form action="/admin/reject-user" method="post" style="display:inline;">
                                            <input type="hidden" name="userId" value="${user.id}">
                                            <button type="submit" class="btn btn-danger btn-sm">Reject</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>
            </div>
        </main>
    </div>
</div>
</body>
</html>
