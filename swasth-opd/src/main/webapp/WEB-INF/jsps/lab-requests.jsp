<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.swasthopd.model.LabRequest" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
  <title>Lab Requests | SWASTH OPD+</title>
  <link rel="stylesheet" href="/css/dashboard.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
  <style>
    #dropzone {
      border: 2px dashed #007bff;
      border-radius: 6px;
      padding: 40px;
      text-align: center;
      cursor: pointer;
    }
    #dropzone:hover {
      background-color: #f8f9fa;
    }
    .file-preview {
      border: 1px solid #dee2e6;
      padding: 8px 12px;
      border-radius: 4px;
      margin-top: 10px;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }
    .progress-bar {
      transition: width 0.4s ease;
    }
  </style>
</head>
<body>

<div class="container-fluid">
  <div class="row">
    <!-- Sidebar -->
    <nav class="col-md-2 sidebar d-flex flex-column">
      <h4 class="text-center my-4">SWASTH OPD+</h4>
      <a href="/lab/requests" class="active"><i class="bi bi-upload me-2"></i>Lab Requests</a>
      <a href="/logout" class="mt-auto"><i class="bi bi-box-arrow-right me-2"></i>Logout</a>
    </nav>

    <!-- Main Content -->
    <main class="col-md-10 p-4">
    <!-- Success / Error Alert -->
		<c:if test="${not empty msg}">
		    <div class="alert alert-success alert-dismissible fade show" role="alert">
		        ✅ ${msg}
		        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
		    </div>
		</c:if>
		<c:if test="${not empty error}">
		    <div class="alert alert-danger alert-dismissible fade show" role="alert">
		        ❌ ${error}
		        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
		    </div>
		</c:if>
		    
      <h4 class="mb-4">Pending Lab Requests</h4>

      <c:if test="${not empty labRequests}">
        <table class="table table-bordered table-hover bg-white">
          <thead class="table-light">
            <tr>
              <th>Patient Name</th>
              <th>Department</th>
              <th>Doctor</th>
              <th>Lab Type</th>
              <th>Instructions</th>
              <th>Upload Report</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="req" items="${labRequests}">
              <tr>
                <td>${req.patient.name}</td>
                <td>${req.visit.department}</td>
                <td>${req.visit.doctorName}</td>
                <td>${req.labType}</td>
                <td>${req.instructions}</td>
                <td>
                  <button type="button"
                          class="btn btn-sm btn-primary"
                          data-bs-toggle="modal"
                          data-bs-target="#uploadModal"
                          data-request-id="${req.id}">
                    Upload
                  </button>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </c:if>
      <c:if test="${empty labRequests}">
        <p class="text-muted">No pending lab requests.</p>
      </c:if>
    </main>
  </div>
</div>

<!-- Upload Modal -->
<div class="modal fade" id="uploadModal" tabindex="-1" aria-labelledby="uploadModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">
      <form id="uploadForm" method="post" enctype="multipart/form-data">
        <div class="modal-header">
          <h5 class="modal-title">Upload Lab Report</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>

        <div class="modal-body">
          <!-- Dropzone -->
          <div id="dropzone" onclick="document.getElementById('reportFile').click()">
            <i class="bi bi-cloud-arrow-up fs-1 text-primary"></i>
            <p class="mt-2 mb-1">Drag your file(s) here</p>
            <p class="text-muted small">or <strong>Browse Files</strong></p>
            <input type="file" name="reportFile" id="reportFile" class="form-control d-none" accept=".jpg,.jpeg,.pdf" required />
          </div>

          <!-- Preview -->
          <div id="preview" class="file-preview mt-3 d-none">
            <span id="fileName" class="text-truncate"></span>
            <button type="button" class="btn btn-sm btn-outline-danger" onclick="clearFile()">×</button>
          </div>
        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary">Upload</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
document.addEventListener('DOMContentLoaded', function () {
  const uploadModal = document.getElementById('uploadModal');
  const uploadForm = document.getElementById('uploadForm');
  const fileInput = document.getElementById('reportFile');
  const preview = document.getElementById('preview');
  const fileName = document.getElementById('fileName');

  uploadModal.addEventListener('show.bs.modal', function (event) {
    const button = event.relatedTarget;
    const requestId = button.getAttribute('data-request-id');
    uploadForm.action = '/lab/upload-report/' + requestId;
    clearFile();
  });

  fileInput.addEventListener('change', function () {
    if (fileInput.files.length > 0) {
      fileName.textContent = fileInput.files[0].name;
      preview.classList.remove('d-none');
    }
  });
});

function clearFile() {
  const fileInput = document.getElementById('reportFile');
  const preview = document.getElementById('preview');
  fileInput.value = '';
  preview.classList.add('d-none');
}


</script>

</body>
</html>
