package com.increff.invoice.formdata;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class InvoiceItem {
    private String name;
    private Integer quantity;
    private Double sellingPrice;
}
