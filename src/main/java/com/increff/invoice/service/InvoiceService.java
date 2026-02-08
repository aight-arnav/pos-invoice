package com.increff.invoice.service;

import com.increff.invoice.formdata.InvoiceForm;
import com.increff.invoice.formdata.InvoiceItem;
import com.increff.invoice.utils.ApiException;
import com.increff.invoice.utils.PdfGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Base64;
import java.util.List;

@Service
public class InvoiceService {
    private static final String INVOICE_DIR = "/invoices/";

    @Autowired
    private PdfGenerator pdfGenerator;

    public String generateOrGetInvoice(InvoiceForm form) {
        Long orderId = form.getOrderId();
        Path invoicePath = Paths.get(INVOICE_DIR, "INV-" + orderId + ".pdf");

        try {
            Files.createDirectories(invoicePath.getParent());

            byte[] pdfBytes;

            if (Files.exists(invoicePath)) {
                pdfBytes = Files.readAllBytes(invoicePath);
            } else {
                pdfBytes = pdfGenerator.generate(orderId, form.getItems());
                Files.write(invoicePath, pdfBytes);
            }

            return Base64.getEncoder().encodeToString(pdfBytes);

        } catch (Exception e) {
            throw new ApiException("Invoice processing failed: ", e);
        }
    }
}