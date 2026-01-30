package com.increff.invoice.controller;

import com.increff.invoice.dto.InvoiceDto;
import com.increff.invoice.formdata.InvoiceData;
import com.increff.invoice.formdata.InvoiceForm;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/invoice")
public class InvoiceController {
    @Autowired
    private InvoiceDto invoiceDto;

    @PostMapping("/generate")
    public ResponseEntity<InvoiceData> generateInvoice(
            @RequestBody InvoiceForm form
    ) {
        InvoiceData data = invoiceDto.generate(form);
        return ResponseEntity.ok(data);
    }
}