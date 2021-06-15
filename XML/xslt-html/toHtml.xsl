<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>List of customers</title>
            </head>
            <body>
                <table border="1">
                <tr>
                    <th>Given name</th>
                    <th>Family name</th>
                    <th>login</th>
                    <th>price</th>
                    <th>Date</th>
                </tr>
                <xsl:for-each select="customers/customer/transactions/transaction">
                <tr>
                    <td><xsl:value-of select="../../givenName"/></td>
                    <th><xsl:value-of select="../../familyName"/></th>
                    <th><xsl:value-of select="../../login"/></th>
                    <th><xsl:value-of select="price"/></th>
                    <th><xsl:value-of select="creationTime"/></th>
                </tr>
                </xsl:for-each>
                </table>
            </body>
        </html>
    </xsl:template>
    
</xsl:stylesheet>