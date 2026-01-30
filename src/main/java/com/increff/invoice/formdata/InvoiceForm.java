package com.increff.invoice.formdata;

import lombok.Getter;
import lombok.Setter;
import java.util.List;

@Getter
@Setter
public class InvoiceForm {
    private Long orderId;
    private List<InvoiceItem> items;
}
