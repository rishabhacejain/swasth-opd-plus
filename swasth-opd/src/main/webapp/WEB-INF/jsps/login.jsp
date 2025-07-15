<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login | SWASTH OPD+</title>
    <link rel="stylesheet" href="/css/login.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link rel="icon" type="image/png" href="/images/favicon.png">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap/bootstrap-icons.css">
    </head>
<body>
    <nav class="navbar">
        <div class="navbar-logo">
            <img src="/images/hospital-illustration.png" alt="SWASTH OPD+ Logo">
            <span>SWASTH OPD+</span>
        </div>
    </nav>

    <div class="main-content">
        <div class="login-container">
            <div class="login-form-left">
                <h2>Welcome Back</h2>
                <c:if test="${not empty msg}">
                    <div class="alert alert-success">${msg}</div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${err}</div>
                </c:if>
                
                <form action="/login" method="post" id="loginForm"> <div class="form-group">
                        <label for="username">Username</label>
                        <div class="input-icon">
                            <i class="bi bi-person-fill"></i>
                            <input type="text" id="username" name="username" placeholder="Enter your username" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <div class="input-icon">
                            <i class="bi bi-lock-fill"></i>
                            <input type="password" id="password" name="password" placeholder="Enter your password" required>
                        </div>
                        <div class="forgot-link">
                            <a href="#">Forgot Password?</a>
                        </div>
                    </div>

                    <input type="hidden" name="role" id="selectedRole" required> 

                    <button type="submit" class="login-btn" disabled>Login</button> <div class="signup-link">
                        <span>No account?</span> <a href="/register">Signup</a>
                    </div>
                </form>
            </div>

            <div class="role-selection-right">
                <label>Login as:</label>
                <div class="role-card-group">
                    <div class="role-card" data-role="DOCTOR">
                        <img src="/images/role-doctor.png" alt="Doctor">
                        <span>Doctor</span>
                        <div class="checkmark"><i class="bi bi-check-circle-fill"></i></div>
                    </div>
                    <div class="role-card" data-role="NURSE">
                        <img src="/images/role-nurse.png" alt="Nurse">
                        <span>Nurse</span>
                        <div class="checkmark"><i class="bi bi-check-circle-fill"></i></div>
                    </div>
                    <div class="role-card" data-role="LAB">
                        <img src="/images/role-lab.png" alt="Lab Technician">
                        <span>Lab Technician</span>
                        <div class="checkmark"><i class="bi bi-check-circle-fill"></i></div>
                    </div>
                    <div class="role-card" data-role="ADMIN">
                        <img src="/images/role-admin.png" alt="Admin">
                        <span>Admin</span>
                        <div class="checkmark"><i class="bi bi-check-circle-fill"></i></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer>
        SWASTH OPD+ | Empowering Government Healthcare
    </footer>

    <script>
        const loginBtn = document.querySelector('.login-btn');
        const roleCards = document.querySelectorAll('.role-card');
        const selectedRoleInput = document.getElementById('selectedRole');
        
        // Initial state: login button is disabled (already set in HTML)
        
        roleCards.forEach(card => {
            card.addEventListener('click', () => {
                roleCards.forEach(c => c.classList.remove('selected'));
                card.classList.add('selected');
                selectedRoleInput.value = card.getAttribute('data-role');
                
                // Enable login button when a role is selected
                if (loginBtn) {
                    loginBtn.disabled = false;
                }  
            });
        });

      
        const loginForm = document.getElementById('loginForm');
        if (loginForm) {
            loginForm.addEventListener('submit', function(event) {
               
            });
        }
    </script>
</body>
</html>