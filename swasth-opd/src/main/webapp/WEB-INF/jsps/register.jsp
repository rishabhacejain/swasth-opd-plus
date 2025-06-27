<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Registration | SWASTH OPD+</title>
    <link rel="stylesheet" href="/css/login.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', sans-serif; background: #f4f4f4; }
        .card { max-width: 600px; margin: auto; margin-top: 50px; padding: 30px; box-shadow: 0 0 10px rgba(0,0,0,0.1); background: white; border-radius: 10px; }
        .form-group { margin-bottom: 15px; }
    </style>
</head>
<body>

<div class="card">
    <h3 class="text-center mb-4">User Registration - SWASTH OPD+</h3>

    <form action="/register" method="post">
        <div class="form-group">
            <label>Name</label>
            <input type="text" name="name" class="form-control" required>
        </div>

        <div class="form-group">
            <label>Username</label>
            <input type="text" name="username" class="form-control" required>
        </div>

        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" class="form-control" required>
        </div>

        <div class="form-group">
            <label>Role</label>
            <select name="role" class="form-select" required>
                <option value="">Select Role</option>
                <option value="DOCTOR">Doctor</option>
                <option value="NURSE">Nurse</option>
                <option value="LAB">Lab Technician</option>
            </select>
        </div>

        <div class="form-group">
            <label>Department</label>
            <input type="text" name="department" class="form-control" placeholder="e.g. General, ENT, Pathology" required>
        </div>

        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" class="form-control">
        </div>

        <div class="form-group">
            <label>Contact Number</label>
            <input type="text" name="contactNumber" class="form-control">
        </div>

        <!-- Optional: ID Upload -->
        <!-- <div class="form-group">
            <label>Govt ID (optional)</label>
            <input type="file" name="idProof" class="form-control">
        </div> -->

        <div class="text-center mt-4">
            <button type="submit" class="btn btn-primary w-100">Submit for Approval</button>
        </div>
    </form>
</div>

</body>
</html>
