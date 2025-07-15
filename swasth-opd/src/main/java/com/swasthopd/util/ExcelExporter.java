package com.swasthopd.util;

import com.swasthopd.model.Visit;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.util.List;

public class ExcelExporter {
    private List<Visit> visits;
    private XSSFWorkbook workbook;
    private Sheet sheet;

    public ExcelExporter(List<Visit> visits) {
        this.visits = visits;
        workbook = new XSSFWorkbook();
        sheet = workbook.createSheet("Visits");
    }

    private void writeHeaderRow() {
        Row row = sheet.createRow(0);

        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true);
        style.setFont(font);

        String[] headers = {"Date", "Patient Name", "Doctor", "Department", "Case Type", "Symptoms", "Status"};

        for (int i = 0; i < headers.length; i++) {
            Cell cell = row.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(style);
        }
    }

    private void writeDataRows() {
        int rowCount = 1;

        for (Visit visit : visits) {
            Row row = sheet.createRow(rowCount++);

            row.createCell(0).setCellValue(visit.getVisitTime());
            row.createCell(1).setCellValue(visit.getPatient().getName());
            row.createCell(2).setCellValue(visit.getDoctorName());
            row.createCell(3).setCellValue(visit.getDepartment());
            row.createCell(4).setCellValue(visit.getCaseType());
            row.createCell(5).setCellValue(visit.getSymptoms());
            row.createCell(6).setCellValue(visit.getStatus());
        }

        for (int i = 0; i < 7; i++) {
            sheet.autoSizeColumn(i);
        }
    }

    public void export(HttpServletResponse response) throws IOException {
        writeHeaderRow();
        writeDataRows();

        ServletOutputStream outputStream = response.getOutputStream();
        workbook.write(outputStream);
        workbook.close();
        outputStream.close();
    }
}
