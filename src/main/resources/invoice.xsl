<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <xsl:template name="soft-wrap">
        <xsl:param name="text"/>
        <xsl:param name="limit" select="15"/>

        <xsl:choose>
            <xsl:when test="string-length($text) &lt;= $limit">
                <xsl:value-of select="$text"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="substring($text, 1, $limit)"/>
                <xsl:text>&#8203;</xsl:text>
                <xsl:call-template name="soft-wrap">
                    <xsl:with-param name="text" select="substring($text, $limit + 1)"/>
                    <xsl:with-param name="limit" select="$limit"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="/">

        <fo:root>

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

                    <!-- COLORED HEADER -->
                    <fo:block background-color="#2c3e50"
                              color="white"
                              padding="12pt"
                              margin-bottom="15pt">

                        <fo:table width="100%">
                            <fo:table-body>
                                <fo:table-row>

                                    <!-- COMPANY DETAILS -->
                                    <fo:table-cell>
                                        <fo:block font-size="14pt" font-weight="bold">
                                            <xsl:value-of select="invoice/company/name"/>
                                        </fo:block>
                                        <fo:block font-size="9pt">
                                            <xsl:value-of select="invoice/company/address"/>
                                        </fo:block>
                                        <fo:block font-size="9pt">
                                            Phone: <xsl:value-of select="invoice/company/phone"/>
                                        </fo:block>
                                        <fo:block font-size="9pt">
                                            Email: <xsl:value-of select="invoice/company/email"/>
                                        </fo:block>
                                    </fo:table-cell>

                                    <!-- INVOICE META -->
                                    <fo:table-cell text-align="right">
                                        <fo:block font-size="24pt" font-weight="bold">
                                            INVOICE
                                        </fo:block>
                                        <fo:block font-size="9pt">
                                            Invoice #: <xsl:value-of select="invoice/invoiceNumber"/>
                                        </fo:block>
                                        <fo:block font-size="9pt">
                                            Order ID: <xsl:value-of select="invoice/orderId"/>
                                        </fo:block>
                                        <fo:block font-size="9pt">
                                            Date: <xsl:value-of select="invoice/date"/>
                                        </fo:block>
                                    </fo:table-cell>

                                </fo:table-row>
                            </fo:table-body>
                        </fo:table>
                    </fo:block>

                    <!-- BILLED TO -->
                    <fo:block margin-bottom="15pt">
                        <fo:block font-weight="bold" font-size="11pt">
                            Billed To
                        </fo:block>
                        <fo:block font-size="10pt">
                            <xsl:value-of select="invoice/billedTo/name"/>
                        </fo:block>
                        <fo:block font-size="10pt">
                            <xsl:value-of select="invoice/billedTo/address"/>
                        </fo:block>
                        <fo:block font-size="10pt">
                            Phone: <xsl:value-of select="invoice/billedTo/phone"/>
                        </fo:block>
                        <fo:block font-size="10pt">
                            Email: <xsl:value-of select="invoice/billedTo/email"/>
                        </fo:block>
                    </fo:block>

                    <!-- ITEMS TABLE -->
                    <fo:table width="100%"
                              table-layout="fixed"
                              border="1pt solid #444"
                              border-collapse="collapse">

                        <fo:table-column column-width="45%"/>
                        <fo:table-column column-width="15%"/>
                        <fo:table-column column-width="20%"/>
                        <fo:table-column column-width="20%"/>

                        <fo:table-header>
                            <fo:table-row background-color="#ecf0f1">

                                <fo:table-cell padding="6pt" border="1pt solid #444">
                                    <fo:block font-weight="bold">Item</fo:block>
                                </fo:table-cell>

                                <fo:table-cell padding="6pt" border="1pt solid #444" text-align="center">
                                    <fo:block font-weight="bold">Qty</fo:block>
                                </fo:table-cell>

                                <fo:table-cell padding="6pt" border="1pt solid #444" text-align="right">
                                    <fo:block font-weight="bold">Price</fo:block>
                                </fo:table-cell>

                                <fo:table-cell padding="6pt" border="1pt solid #444" text-align="right">
                                    <fo:block font-weight="bold">Total</fo:block>
                                </fo:table-cell>

                            </fo:table-row>
                        </fo:table-header>

                        <fo:table-body>
                            <xsl:for-each select="invoice/items/item">
                                <fo:table-row>

                                    <!-- ONLY MODIFIED CELL -->
                                    <fo:table-cell padding="6pt" border="1pt solid #444">
                                        <fo:block>
                                            <xsl:call-template name="soft-wrap">
                                                <xsl:with-param name="text" select="name"/>
                                            </xsl:call-template>
                                        </fo:block>
                                    </fo:table-cell>

                                    <fo:table-cell padding="6pt" border="1pt solid #444" text-align="center">
                                        <fo:block><xsl:value-of select="quantity"/></fo:block>
                                    </fo:table-cell>

                                    <fo:table-cell padding="6pt" border="1pt solid #444" text-align="right">
                                        <fo:block>Rs. <xsl:value-of select="price"/></fo:block>
                                    </fo:table-cell>

                                    <fo:table-cell padding="6pt" border="1pt solid #444" text-align="right">
                                        <fo:block>Rs. <xsl:value-of select="total"/></fo:block>
                                    </fo:table-cell>

                                </fo:table-row>
                            </xsl:for-each>
                        </fo:table-body>
                    </fo:table>

                    <!-- GRAND TOTAL -->
                    <fo:block text-align="right"
                              font-size="12pt"
                              font-weight="bold"
                              margin-top="12pt">
                        Grand Total: Rs. <xsl:value-of select="invoice/grandTotal"/>
                    </fo:block>

                </fo:flow>
            </fo:page-sequence>

        </fo:root>

    </xsl:template>
</xsl:stylesheet>
