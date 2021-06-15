<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:fn="http://www.w3.org/2005/xpath-functions"
   xmlns:xsd="http://www.w3.org/2001/XMLSchema#">
    <xsl:output method="text" encoding="UTF-8" />
    <xsl:variable name="prefix">http://example.org/whiskeyman/</xsl:variable>
    
    <xsl:template match="customers">
    @prefix ex: &lt;http://example.org/whiskeyman/&gt; .
    @prefix whisky: &lt;https://vocab.org/whisky/terms/&gt; .
    @prefix xsd: &lt;http://www.w3.org/2001/XMLSchema#&gt; .
    @prefix schema: &lt;http://schema.org&gt; .
    @prefix rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt; .
    @prefix rdf: &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt; .
    @prefix cerif: &lt;http://www.eurocris.org/ontologies/cerif/1.3&gt; .

        # custom definitions
        ex:Customer rdfs:subClassOf schema:Person;
        rdf:type rdfs:Class;
        rdfs:label "A class containing all informations about customer"@en.

        ex:Distillery rdf:type rdfs:Class.

        ex:Bottle rdf:type rdfs:Class.

        ex:NfcTag rdf:type rdfs:Class.

        ex:Description rdf:type rdfs:Class.

        ex:Transaction rdf:type rdfs:Class.

        ex:Ownership rdf:type rdfs:Class.

        ex:SpecialPrice rdf:type rdfs:Class.

        ex:Region rdf:type rdfs:Class.



        ex:PriceForML rdf:type rdf:Property;
                rdfs:range	schema:Number.

        ex:PriceForBottle rdf:type rdf:Property;
                rdfs:range	schema:Number.

        ex:Owns rdf:type rdf:Property;
                rdfs:domain	ex:Customer;
                rdfs:range	ex:Ownership.

        ex:CSpecialPrice rdf:type rdf:Property;
                rdfs:domain	ex:Customer;
                rdfs:range	ex:SpecialPrice.

        ex:CNfcTag rdf:type rdf:Property;
                rdfs:domain	ex:Customer;
                rdfs:range	ex:NafcTag.

        ex:TransactionMadeBY rdf:type rdf:Property;
                rdfs:domain	ex:Transaction;
                rdfs:range	ex:Customer.

        ex:TransactionedBottle rdf:type rdf:Property;
                rdfs:domain	ex:Transaction;
                rdfs:range	ex:Bottle.

        ex:DescribedBy rdf:type rdf:Property;
                rdfs:domain	ex:Bottle;
                rdfs:range	ex:Description.

        ex:InStock rdf:type rdf:Property ;
                rdfs:domain	ex:Bottle ;
                rdfs:range	xsd:Boolean .

        ex:AmmountMl rdf:type rdf:Property ;
                rdfs:domain	schema:Transaction ;
                rdfs:range	schema:Number .

        ex:Founded rdf:type rdf:Property ;
                rdfs:domain     ex:Distillery ;
                rdfs:range      schema:Number.

        ex:Login rdf:type rdf:Property ;
                rdfs:domain     ex:Customer ;
                rdfs:range      schema:Text.        

        ex:Share rdf:type rdf:Property ;
                rdfs:domain     ex:Ownership ;
                rdfs:range      schema:Number.

        ex:OwnedBottle rdf:type rdf:Property ;
                rdfs:domain     ex:Ownership ;
                rdfs:range      ex:Bottle.

        ex:BottleID rdf:type rdf:Property;
                rdfs:domain     ex:Bottle;
                rdfs:range      schema:Number.

        ex:CustomerID rdf:type rdf:Property;
                rdfs:domain     ex:Customer;
                rdfs:range      schema:Number.

        ex:DistilledAt rdf:type rdf:Property;
                rdfs:domain     ex:Description;
                rdfs:range      schema:Distillery.

        ex:RegionOf rdf:type rdf:Property;
                rdfs:domain     ex:Distillery;
                rdfs:range      schema:Region.

        ex:SPBottle rdf:type rdf:Property;
                rdfs:domain     ex:SpecialPrice;
                rdfs:range      schema:Bottle.

    <xsl:apply-templates/>
    </xsl:template>


    

    <xsl:template match="customer">
    <xsl:variable name="customerIRI" select="concat($prefix, customerID)"/>
    &lt;<xsl:value-of select="$customerIRI"/>&gt; a ex:Customer ;
        schema:name         &quot;<xsl:value-of select="name"/>&quot; ;
        schema:givenName    &quot;<xsl:value-of select="givenName"/>&quot; ;
        schema:familyName   &quot;<xsl:value-of select="familyName"/>&quot; ;
        schema:email        &quot;<xsl:value-of select="email"/>&quot; ;
        ex:login            &quot;<xsl:value-of select="login"/>&quot; .
        <xsl:apply-templates>
                <xsl:with-param name="customerIRI" select="$customerIRI"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="nfcTags/nfcTag">
        <xsl:param name="customerIRI"/>
        <xsl:variable name="nfcTagIRI" select="concat($prefix, nfcTagID)"/>
        &lt;<xsl:value-of select="$customerIRI"/>&gt; ex:CNfcTag  &lt;<xsl:value-of select="$nfcTagIRI"/>&gt; .
        &lt;<xsl:value-of select="$nfcTagIRI"/>&gt; a ex:nfcTag ;
                schema:text             &quot;<xsl:value-of select="code"/>&quot; ;
                schema:purchaseDate     &quot;<xsl:value-of select="replace(creationTime, '&quot;', '\\&quot;')"/>&quot;^^xsd:dateTime .
    </xsl:template>

    <xsl:template match="transactions/transaction">
        <xsl:param name="customerIRI"/>
        <xsl:variable name="transIRI" select="concat($prefix, transactionID)"/>
        &lt;<xsl:value-of select="$transIRI"/>&gt; a ex:Transaction ;
                ex:AmmountMl            <xsl:value-of select="ammountML"/> ;
                schema:Price            <xsl:value-of select="price/value"/> ;
                cerif:currency          &quot;<xsl:value-of select="price/currency"/>&quot; ;
                schema:purchaseDate     &quot;<xsl:value-of select="replace(creationTime, '&quot;', '\\&quot;')"/>&quot;^^xsd:dateTime ;
                ex:TransactionedBottle  ex:<xsl:value-of select="bottleID"/> ;
                ex:TransactionMadeBY    ex:<xsl:value-of select="../../customerID"/> .
    </xsl:template>

    <xsl:template match="ownerships/ownership">
        <xsl:param name="customerIRI"/>
        <xsl:variable name="ownershipIRI" select="concat($prefix, ownershipID)"/>
        &lt;<xsl:value-of select="$customerIRI"/>&gt; ex:Owns &lt;<xsl:value-of select="$ownershipIRI"/>&gt; .
        &lt;<xsl:value-of select="$ownershipIRI"/>&gt; a ex:Ownership ;
                ex:Share        <xsl:value-of select="shareSize"/> ;
                ex:OwnedBottle  ex:<xsl:value-of select="bottleID"/>.
    </xsl:template>

    <xsl:template match="specialPrices/specialPrice">
        <xsl:param name="customerIRI"/>
        <xsl:variable name="sPriceIRI" select="concat($prefix, specialPriceID)"/>
        &lt;<xsl:value-of select="$customerIRI"/>&gt; ex:CSpecialPrice &lt;<xsl:value-of select="$sPriceIRI"/>&gt; .
        &lt;<xsl:value-of select="$sPriceIRI"/>&gt; a ex:SpecialPrice ;
                ex:PriceForML            <xsl:value-of select="price/value"/> ;
                cerif:currency          &quot;<xsl:value-of select="price/currency"/>&quot; ;
                ex:SPBottle             ex:<xsl:value-of select="bottleID"/>.
    </xsl:template>


    <xsl:template match="text()"/>
</xsl:stylesheet>