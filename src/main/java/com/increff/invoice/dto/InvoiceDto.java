package com.increff.invoice.dto;

import com.increff.invoice.formdata.InvoiceData;
import com.increff.invoice.formdata.InvoiceForm;
import com.increff.invoice.formdata.InvoiceItem;
import com.increff.invoice.service.InvoiceService;
import com.increff.invoice.utils.ApiException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class InvoiceDto {
    @Autowired
    private InvoiceService invoiceService;

    public InvoiceData generate(InvoiceForm form) {
        validate(form);

        String base64Pdf = invoiceService.generateOrGetInvoice(form);

        InvoiceData data = new InvoiceData();
        data.setOrderId(form.getOrderId());
        data.setBase64Pdf(base64Pdf);

        return data;
    }

    private void validate(InvoiceForm form) {
        if (form == null) {
            throw new ApiException("Invoice form cannot be null");
        }

        if (form.getOrderId() == null) {
            throw new ApiException("OrderId is required");
        }

        List<InvoiceItem> items = form.getItems();

        if (items == null || items.isEmpty()) {
            throw new ApiException("Invoice must have at least one item");
        }

        for (InvoiceItem item : items) {

            if (item.getQuantity() <= 0) {
                throw new ApiException(
                        "Invalid quantity for item: " + item.getName()
                );
            }

            if (item.getSellingPrice() < 0) {
                throw new ApiException(
                        "Invalid selling price for item: " + item.getName()
                );
            }
        }
    }
}