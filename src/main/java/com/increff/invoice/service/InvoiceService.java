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
    private static final String INVOICE_DIR = "/tmp/invoices/";

    @Autowired
    private PdfGenerator pdfGenerator;

    public String generateAndSaveInvoice(InvoiceForm form) {
        Long orderId = form.getOrderId();
        List<InvoiceItem> items = form.getItems();

        try {
            byte[] pdfBytes = pdfGenerator.generate(orderId, items);
            Files.createDirectories(Paths.get(INVOICE_DIR));
            Path path = Paths.get(
                    INVOICE_DIR + "INV-" + orderId + ".pdf"
            );
            Files.write(path, pdfBytes);

            return Base64.getEncoder().encodeToString(pdfBytes);
        } catch (Exception e) {
            throw new ApiException("Invoice generation failed", e);
        }
    }
}