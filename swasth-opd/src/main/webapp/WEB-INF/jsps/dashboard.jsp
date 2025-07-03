<%@page import="com.swasthopd.model.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="com.swasthopd.model.Visit"%>

<%
    User doctor = (User) request.getAttribute("doctor");
    List<Visit> visits = (List<Visit>) request.getAttribute("visits");
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
            <a href="/register-patient"><i class="bi bi-person-plus me-2"></i>Register Patient</a>
            <a href="/view-patients"><i class="bi bi-people-fill me-2"></i> View Patients</a>
            <a href="/lab-request"><i class="bi bi-cloud-arrow-down me-2"></i>Lab Requests</a>
            <a href="/refer-patient"><i class="bi bi-arrow-right-circle me-2"></i>Referrals</a>
            <a href="/history"><i class="bi bi-clock-history me-2"></i>History</a>
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
                        <h2 class="fw-bold text-success">—</h2>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card-box text-center">
                        <h6 class="text-muted">Old Patients</h6>
                        <h2 class="fw-bold text-danger">—</h2>
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
                        <p><strong>Observation:</strong> —</p>
                        <p><strong>Prescription:</strong> —</p>
                        <% } else { %>
                            <p class="text-muted">No consultations yet today.</p>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Calendar & News -->
            <div class="row">
                <div class="col-md-6">
                    <div class="card-box">
                        <h5>Calendar</h5>
                        <p>Upcoming: Monthly doctor’s meet at 4 PM</p>
                        <div class="calendar-wrapper">
                            <div class="calendar-header">
                                <span class="calendar-nav" onclick="changeMonth(-1)"><i class="bi bi-chevron-left"></i></span>
                                <span class="calendar-month-year" id="monthYear">September 2025</span>
                                <span class="calendar-nav" onclick="changeMonth(1)"><i class="bi bi-chevron-right"></i></span>
                            </div>
                            <div class="calendar-days">
                                <div>SUN</div><div>MON</div><div>TUE</div><div>WED</div>
                                <div>THU</div><div>FRI</div><div>SAT</div>
                            </div>
                            <div class="calendar-grid" id="calendarGrid"></div>
                            <div class="calendar-events-header">
                                <span>Upcoming Events</span>
                                <a href="#" class="view-all">View All</a>
                            </div>
                            <div class="calendar-event">
                                <div class="event-icon">M</div>
                                <div class="event-info">
                                    <strong>Monthly doctor’s meet</strong><br>
                                    <small>4 PM, 28 Jul</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- News Section -->
                <div class="col-md-6">
                    <div class="card-box">
                        <h5>Updates</h5>
                        <p>No recent updates available</p>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Calendar Script -->
<script>
    const calendarGrid = document.getElementById("calendarGrid");
    const monthYear = document.getElementById("monthYear");
    let currentDate = new Date();

    const eventDates = [7, 8, 21, 22, 28]; // example events

    function renderCalendar(date) {
        const year = date.getFullYear();
        const month = date.getMonth();
        const today = new Date();
        const firstDay = new Date(year, month, 1).getDay();
        const daysInMonth = new Date(year, month + 1, 0).getDate();
        const daysInPrevMonth = new Date(year, month, 0).getDate();

        const totalCells = 42;
        calendarGrid.innerHTML = "";
        monthYear.innerText = date.toLocaleString("default", { month: "long" }) + " " + year;

        for (let i = 0; i < totalCells; i++) {
            const dayCell = document.createElement("div");
            let dayNum, isCurrentMonth = true;

            if (i < firstDay) {
                dayNum = daysInPrevMonth - firstDay + i + 1;
                isCurrentMonth = false;
            } else if (i >= firstDay + daysInMonth) {
                dayNum = i - (firstDay + daysInMonth) + 1;
                isCurrentMonth = false;
            } else {
                dayNum = i - firstDay + 1;
            }

            dayCell.innerText = dayNum;
            if (!isCurrentMonth) dayCell.classList.add("other-month");
            if (isCurrentMonth && dayNum === today.getDate() && month === today.getMonth() && year === today.getFullYear()) {
                dayCell.classList.add("current-day");
            }
            if (eventDates.includes(dayNum) && isCurrentMonth) {
                dayCell.classList.add("event-day");
            }
            calendarGrid.appendChild(dayCell);
        }
    }

    function changeMonth(offset) {
        currentDate.setMonth(currentDate.getMonth() + offset);
        renderCalendar(currentDate);
    }

    renderCalendar(currentDate);
</script>

</body>
</html>
