<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:fn="http://www.w3.org/2005/xpath-functions"
   xmlns:xsd="http://www.w3.org/2001/XMLSchema#">
    <xsl:output method="text" encoding="UTF-8" />
    <xsl:variable name="prefix">http://example.org/whiskeyman/</xsl:variable>
    
    <xsl:template match="bottles">
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


    

    <xsl:template match="bottle">
    <xsl:variable name="bottleIRI" select="concat($prefix, bottleID)"/>
    &lt;<xsl:value-of select="$bottleIRI"/>&gt; a ex:Bottle ;
        ex:PriceForML <xsl:value-of select="shotPrice/value"/> ;
        cerif:currency  &quot;<xsl:value-of select="shotPrice/currency"/>&quot; ;
        ex:PriceForBottle <xsl:value-of select="bottlePrice/value"/> ;
        schema:purchaseDate  &quot;<xsl:value-of select="replace(purchaseDate, '&quot;', '\\&quot;')"/>&quot;^^xsd:dateTime ;
        ex:inStock  <xsl:value-of select="inStock"/> ;
        schema:barcode  <xsl:value-of select="barcode"/> .
        <xsl:apply-templates>
                <xsl:with-param name="bottleIRI" select="$bottleIRI"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="bottleDescription">
        <xsl:param name="bottleIRI"/>
        <xsl:variable name="bottleDescriptionIRI" select="concat($prefix, bottleDescriptionID)"/>
        &lt;<xsl:value-of select="$bottleIRI"/>&gt; ex:DescribedBy &lt;<xsl:value-of select="$bottleDescriptionIRI"/>&gt; .
        &lt;<xsl:value-of select="$bottleDescriptionIRI"/>&gt; a ex:Description ;
                schema:name &quot;<xsl:value-of select="name"/>&quot; ;
                whisky:age <xsl:value-of select="age"/> ;
                whisky:abv <xsl:value-of select="voltage"/> .
                <xsl:apply-templates>
                        <xsl:with-param name="bottleDescriptionIRI" select="$bottleDescriptionIRI"/>
                </xsl:apply-templates>
    </xsl:template>

        <xsl:template match="distillery">
        <xsl:param name="bottleDescriptionIRI"/>
        <xsl:variable name="distilleryIRI" select="concat($prefix, distilleryID)"/>
        &lt;<xsl:value-of select="$bottleDescriptionIRI"/>&gt; ex:DistilledAt &lt;<xsl:value-of select="$distilleryIRI"/>&gt; .
        &lt;<xsl:value-of select="$distilleryIRI"/>&gt; a ex:Distillery ;
        schema:name  &quot;<xsl:value-of select="replace(name, '&quot;', '\\&quot;')"/>&quot;@en ;
        ex:founded  <xsl:value-of select="founded"/> .
        <xsl:apply-templates>
                <xsl:with-param name="distilleryIRI" select="$distilleryIRI"/>
        </xsl:apply-templates>
        </xsl:template>
    
    <xsl:template match="region">
        <xsl:param name="distilleryIRI"/>
        <xsl:variable name="regionIRI" select="concat($prefix, regionID)"/>
        &lt;<xsl:value-of select="$distilleryIRI"/>&gt; ex:RegionOf &lt;<xsl:value-of select="$regionIRI"/>&gt; .
        &lt;<xsl:value-of select="$regionIRI"/>&gt; a ex:Region ;
                schema:name &quot;<xsl:value-of select="replace(name, '&quot;', '\\&quot;')"/>&quot;@en .
    </xsl:template>

    <xsl:template match="transactions/transaction">
        <xsl:param name="bottleIRI"/>
        <xsl:variable name="transIRI" select="concat($prefix, transactionID)"/>
        &lt;<xsl:value-of select="$transIRI"/>&gt; a ex:Transaction ;
                ex:AmmountMl            <xsl:value-of select="ammountML"/> ;
                schema:Price            <xsl:value-of select="price/value"/> ;
                cerif:currency          &quot;<xsl:value-of select="price/currency"/>&quot; ;
                schema:purchaseDate     &quot;<xsl:value-of select="replace(creationTime, '&quot;', '\\&quot;')"/>&quot;^^xsd:dateTime ;
                ex:TransactionedBottle  ex:<xsl:value-of select="../../bottleID"/> ;
                ex:TransactionMadeBY    ex:<xsl:value-of select="customerID"/> .
    </xsl:template>

    <xsl:template match="ownerships/ownership">
        <xsl:param name="bottleIRI"/>
        <xsl:variable name="ownershipIRI" select="concat($prefix, ownershipID)"/>
        &lt;<xsl:value-of select="$ownershipIRI"/>&gt; ex:Ownership ;
                ex:Share        <xsl:value-of select="shareSize"/> ;
                ex:OwnedBottle  ex:<xsl:value-of select="../../bottleID"/>.
    </xsl:template>

    <xsl:template match="specialPrices/specialPrice">
        <xsl:param name="bottleIRI"/>
        <xsl:variable name="sPriceIRI" select="concat($prefix, specialPriceID)"/>
        &lt;<xsl:value-of select="$sPriceIRI"/>&gt; a ex:SpecialPrice ;
                ex:PriceForML            <xsl:value-of select="price/value"/> ;
                cerif:currency          &quot;<xsl:value-of select="price/currency"/>&quot; ;
                ex:SPBottle             ex:<xsl:value-of select="../../bottleID"/>.
    </xsl:template>


    <xsl:template match="text()"/>
</xsl:stylesheet>