package com.increff.invoice.formdata;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class InvoiceData {
    private Long orderId;
    private String base64Pdf;
}