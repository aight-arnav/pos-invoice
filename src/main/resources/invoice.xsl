<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <xsl:template match="/">

        <fo:root>

            <!-- Page layout -->
            <fo:layout-master-set>
                <fo:simple-page-master
                        master-name="A4"
                        page-height="29.7cm"
                        page-width="21cm"
                        margin="2cm">
                    <fo:region-body/>
                </fo:simple-page-master>
            </fo:layout-master-set>

            <fo:page-sequence master-reference="A4">
                <fo:flow flow-name="xsl-region-body">

                    <!-- INVOICE TITLE -->
                    <fo:block
                            font-size="18pt"
                            font-weight="bold"
                            text-align="center"
                            margin-bottom="15pt">
                        INVOICE
                    </fo:block>

                    <!-- ORDER INFO -->
                    <fo:block font-size="10pt">
                        Order ID:
                        <xsl:value-of select="invoice/orderId"/>
                    </fo:block>

                    <fo:block font-size="10pt" margin-bottom="15pt">
                        Date:
                        <xsl:value-of select="invoice/date"/>
                    </fo:block>

                    <!-- ITEMS TABLE -->
                    <fo:table width="100%"
                              border="1pt solid black"
                              border-collapse="collapse">

                        <!-- Table Header -->
                        <fo:table-header>
                            <fo:table-row background-color="#eeeeee">

                                <fo:table-cell padding="6pt" border="1pt solid black">
                                    <fo:block font-weight="bold">Item</fo:block>
                                </fo:table-cell>

                                <fo:table-cell padding="6pt" border="1pt solid black"
                                               text-align="center">
                                    <fo:block font-weight="bold">Qty</fo:block>
                                </fo:table-cell>

                                <fo:table-cell padding="6pt" border="1pt solid black"
                                               text-align="right">
                                    <fo:block font-weight="bold">Price</fo:block>
                                </fo:table-cell>

                                <fo:table-cell padding="6pt" border="1pt solid black"
                                               text-align="right">
                                    <fo:block font-weight="bold">Total</fo:block>
                                </fo:table-cell>

                            </fo:table-row>
                        </fo:table-header>

                        <!-- Table Body -->
                        <fo:table-body>
                            <xsl:for-each select="invoice/items/item">

                                <fo:table-row>

                                    <fo:table-cell padding="6pt" border="1pt solid black">
                                        <fo:block>
                                            <xsl:value-of select="name"/>
                                        </fo:block>
                                    </fo:table-cell>

                                    <fo:table-cell padding="6pt" border="1pt solid black"
                                                   text-align="center">
                                        <fo:block>
                                            <xsl:value-of select="quantity"/>
                                        </fo:block>
                                    </fo:table-cell>

                                    <fo:table-cell padding="6pt" border="1pt solid black"
                                                   text-align="right">
                                        <fo:block>
                                            Rs. <xsl:value-of select="price"/>
                                        </fo:block>
                                    </fo:table-cell>

                                    <fo:table-cell padding="6pt" border="1pt solid black"
                                                   text-align="right">
                                        <fo:block>
                                            Rs. <xsl:value-of select="total"/>
                                        </fo:block>
                                    </fo:table-cell>

                                </fo:table-row>

                            </xsl:for-each>
                        </fo:table-body>
                    </fo:table>

                    <!-- GRAND TOTAL -->
                    <fo:block
                            text-align="right"
                            font-size="11pt"
                            font-weight="bold"
                            margin-top="12pt">
                        Grand Total: Rs. <xsl:value-of select="invoice/grandTotal"/>
                    </fo:block>

                </fo:flow>
            </fo:page-sequence>

        </fo:root>

    </xsl:template>
</xsl:stylesheet>