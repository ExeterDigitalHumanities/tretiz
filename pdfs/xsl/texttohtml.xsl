<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"> 
    
    <xsl:variable name="themes" select="doc('../../metadata/themes.xml')"/>
    
    <xsl:template match="tei:TEI">
        <html lang="en">
            <head>
                <!-- Bootstrap -->        
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-gH2yIJqKdNHPEq0n4Mqa/HGKIhSkIHeL5AyhkYV8i59U5AR6csBvApHHNl/vI1Bx" crossorigin="anonymous"/>
                
                <!-- Google Fonts -->
                <link rel="preconnect" href="https://fonts.googleapis.com"/>
                <link rel="preconnect" href="https://fonts.gstatic.com"/>
                <link href="https://fonts.googleapis.com/css2?family=Roboto+Condensed&amp;family=Roboto&amp;display=swap" rel="stylesheet"/>
                
                <link rel="stylesheet" type="text/css" href="../css/style.css"/>
                
                <title>Learning French in Medieval England - <xsl:apply-templates select="tei:teiHeader"/></title>
            </head>
            <body>
                <div class="container">
                    <div class="row">
                        <div class="col">
                            <h4>Learning French in Medieval England</h4>
                            <h1><xsl:apply-templates select="tei:teiHeader"/></h1>
                            <xsl:apply-templates select="tei:text/tei:body"/>
                            <xsl:call-template name="notes">
                                <xsl:with-param name="body" select="tei:text/tei:body"/>
                            </xsl:call-template>
                        </div>
                    </div>
                </div>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="tei:teiHeader">
        <xsl:value-of select="tei:fileDesc/tei:titleStmt/tei:title"/>
    </xsl:template>
    
    <xsl:template match="tei:body">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:cb">
        <h3>[<xsl:value-of select="@n"/>]</h3>
    </xsl:template>
    
    <xsl:template match="tei:milestone[@unit = 'theme']">
        <xsl:variable name="type" select="@type"/>
        <xsl:variable name="subtype" select="@subtype"/>
        <h2>
            <xsl:attribute name="class"><xsl:text>mb-3</xsl:text></xsl:attribute>
            <xsl:text>[</xsl:text>
            <xsl:value-of select="$themes/taxonomy/category[@xml:id = $type]/catDesc"/>
            <xsl:if test="$subtype != ''">
                <xsl:text> (</xsl:text>
                <xsl:for-each select="tokenize($subtype, ' ')">
                    <xsl:sort select="."/>
                    <xsl:variable name="st" select="."/>
                    <xsl:value-of select="$themes/taxonomy/category[@xml:id = $type]/category[@xml:id = $st]/catDesc"/>
                    <xsl:if test="position() != last()">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                </xsl:for-each> 
                <xsl:text>)</xsl:text>
            </xsl:if>
            <xsl:text>]</xsl:text>
        </h2>
    </xsl:template>
    
    <xsl:template match="tei:p">
        <p><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="tei:ab">
        <p><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="tei:lg">
        <p><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="tei:l">
        <span class="d-inline-block w-100">
            <xsl:choose>
                <xsl:when test="number(@n) = @n">
                    <xsl:if test="@n mod 4 = 0">
                        <small class="line-number d-inline-block">
                            <xsl:value-of select="@n"/>
                        </small>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <small class="line-number d-inline-block">
                        <xsl:value-of select="@n"/>
                    </small>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </span>
        <br/>
    </xsl:template>
    
    <xsl:template match="tei:hi[@rend = 'large']">
        <span class="fw-bold"><xsl:apply-templates/></span>
    </xsl:template>
    
    <xsl:template match="tei:lb"/>
    
    <xsl:template match="tei:sic"/>
    
    <xsl:template match="tei:corr">
        <xsl:apply-templates/>
        <xsl:text> (ms. </xsl:text>
        <xsl:value-of select="parent::tei:choice/tei:sic"/>
        <xsl:text>)</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:add[@rend = '0'] | tei:add[@rend = '1']">
        <xsl:text>\</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>/</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:add[@rend = '2']">
        <xsl:text>`</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>´</xsl:text>
    </xsl:template>

    <xsl:template match="tei:supplied">
        <xsl:text>[</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>]</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:gap">
        <xsl:choose>
            <xsl:when test="@unit = 'page'">
                <p><xsl:text>Page missing</xsl:text></p>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="not(ancestor::tei:ab) and not(ancestor::tei:p) and not(ancestor::tei:l) and not(ancestor::tei:note)">
                        <p><xsl:text>[...]</xsl:text></p>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>[...]</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:reg">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:orig"/>

    <xsl:template match="tei:note">
        <xsl:choose>
            <xsl:when test="not(ancestor::tei:ab) and not(ancestor::tei:p) and not(ancestor::tei:l)">
                <p><sup><xsl:text>[</xsl:text><xsl:value-of select="count(preceding::tei:note) +1"/><xsl:text>]</xsl:text></sup></p>
            </xsl:when>
            <xsl:otherwise>
                <sup><xsl:text>[</xsl:text><xsl:value-of select="count(preceding::tei:note) +1"/><xsl:text>]</xsl:text></sup>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:foreign">
        <span class="fst-italic"><xsl:apply-templates/></span>
    </xsl:template>
    
    <xsl:template match="tei:term">
        <xsl:variable name="termid" select="@xml:id"/>
        <xsl:apply-templates/>
        <xsl:apply-templates select="//tei:gloss[@target = concat('#', $termid)]" mode="after-term"/>
    </xsl:template>
    
    <xsl:template match="tei:gloss"/>
    
    <xsl:template match="tei:gloss" mode="after-term">
        <xsl:choose>
            <xsl:when test="@place = 'endline'">
                <span class="float-end ms-3"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:when test="@place = 'interlinear'">
                <sup class="ms-1"><xsl:apply-templates/></sup>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:said">
        <xsl:choose>
            <xsl:when test="@next and not(@prev)">
                <xsl:text>"</xsl:text>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="not(@next) and not(@prev)">
                <xsl:text>"</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>"</xsl:text>
            </xsl:when>
            <xsl:when test="not(@next) and @prev">
                <xsl:apply-templates/>
                <xsl:text>"</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:quote">
        <xsl:text>"</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>"</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:mentioned">
        <xsl:text>'</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>'</xsl:text>     
    </xsl:template>
    
    <xsl:template match="tei:soCalled">
        <xsl:text>'</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>'</xsl:text>
    </xsl:template>
    
    <xsl:template name="notes">
        <xsl:param name="body"/>
        
        <h2>Notes</h2>
        
        <xsl:for-each select="$body//tei:note">
            <p>
                <xsl:value-of select="count(preceding::tei:note) +1"/>
                <xsl:text>. </xsl:text>
                <xsl:value-of select="."/>
                <xsl:text> </xsl:text>
                <small>
                    <xsl:text>[</xsl:text>
                    <xsl:value-of select="substring-after(@resp, '#')"/>
                    <xsl:text>]</xsl:text>
                </small>
            </p>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>