package com.increff.invoice.utils;

import com.increff.invoice.formdata.InvoiceItem;
import org.apache.fop.apps.*;
import org.springframework.stereotype.Component;

import javax.xml.transform.*;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.List;

@Component
public class PdfGenerator {
    private final FopFactory fopFactory;
    private final TransformerFactory transformerFactory;

    public PdfGenerator() {
        try {
            this.fopFactory = FopFactory.newInstance(new File(".").toURI());
            this.transformerFactory = TransformerFactory.newInstance();
        } catch (Exception e) {
            throw new ApiException("Failed to initialize PDF generator", e);
        }
    }

    public byte[] generate(Long orderId, List<InvoiceItem> items) {

        if (orderId == null) {
            throw new ApiException("OrderId cannot be null");
        }

        if (items == null || items.isEmpty()) {
            throw new ApiException("Invoice items cannot be empty");
        }

        try (ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            FOUserAgent foUserAgent = fopFactory.newFOUserAgent();
            Fop fop = fopFactory.newFop(
                    MimeConstants.MIME_PDF,
                    foUserAgent,
                    out
            );

            String xml = buildXml(orderId, items);
            Source xmlSource = new StreamSource(
                    new ByteArrayInputStream(xml.getBytes(StandardCharsets.UTF_8))
            );

            InputStream xslStream =
                    getClass().getClassLoader().getResourceAsStream("invoice.xsl");

            if (xslStream == null) {
                throw new ApiException("invoice.xsl not found in resources");
            }

            Transformer transformer = transformerFactory.newTransformer(new StreamSource(xslStream));
            transformer.transform(
                    xmlSource,
                    new SAXResult(fop.getDefaultHandler())
            );

            return out.toByteArray();
        } catch (Exception e) {
            throw new ApiException("Failed to generate invoice PDF", e);
        }
    }

    private String buildXml(Long orderId, List<InvoiceItem> items) {
        double grandTotal = 0.0;
        StringBuilder itemsXml = new StringBuilder();

        for (InvoiceItem item : items) {
            if (item.getQuantity() <= 0 || item.getSellingPrice() < 0) {
                throw new ApiException("Invalid quantity or price for item: " + item.getName());
            }

            double total = item.getQuantity() * item.getSellingPrice();
            grandTotal += total;

            itemsXml.append("""
                <item>
                    <name>%s</name>
                    <quantity>%d</quantity>
                    <price>%.2f</price>
                    <total>%.2f</total>
                </item>
                """.formatted(
                    escapeXml(item.getName()),
                    item.getQuantity(),
                    item.getSellingPrice(),
                    total
            ));
        }

        return """
            <?xml version="1.0" encoding="UTF-8"?>
            <invoice>
                <orderId>%d</orderId>
                <date>%s</date>

                <items>
                    %s
                </items>

                <grandTotal>%.2f</grandTotal>
            </invoice>
            """.formatted(
                orderId,
                LocalDate.now(),
                itemsXml,
                grandTotal
        );
    }

    private String escapeXml(String value) {
        if (value == null) return "";
        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&apos;");
    }
}
