<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    xmlns="http://purl.oclc.org/dsdl/schematron">
    <ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>
    <sch:pattern>
        
        <!-- 
            
            New rules to write:
        
        - Check for missing AND: prefixes on <term key="">
        - Test duplicate @n on <pb/> as this does not seem to be working
        - Check for milestone types and enforce spellings without making values compulsory - point at list
        - Find a way to ensure that milestones appear immediately after, not immediately before, <pb/>s  

        -->

        <!-- Page beginnings and column beginnings -->
        
        <sch:rule context="tei:pb">
            <sch:let name="pageNumber" value="@n"/>
            <sch:assert test="count(preceding-sibling::tei:pb[@n=$pageNumber])=0">         
                Page number must be unique within the document.
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="tei:cb">
            <sch:let name="columnNumber" value="@n"/>
            <sch:assert test="count(preceding-sibling::tei:cb[@n=$columnNumber])=0">         
                Column number must be unique within the document.
            </sch:assert>
        </sch:rule>
        
        <!-- Paragraphs -->

        <sch:rule context="tei:p">
            <sch:let name="paragraphNumber" value="@n"/>
            <sch:assert test="count(preceding-sibling::tei:p[@n=$paragraphNumber])=0">         
                Paragraph number must be unique within the document.
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="tei:p">
            <sch:assert test="count(tei:choice) gt 0">
                There must be at least one choice element within a paragraph.
            </sch:assert>
        </sch:rule> 
        
        <!-- Milestones -->
        
        <sch:rule context="tei:body">
            <sch:assert test="count(tei:milestone) gt 0">
                There must be at least one milestone element within a body.
            </sch:assert>
        </sch:rule> 

        <sch:rule context="tei:milestone">
            <sch:assert test="@unit='theme'">
                A milestone must have a @unit="theme".
            </sch:assert>
        </sch:rule> 
       
        <sch:rule context="tei:milestone">
            <sch:assert test="count(@unit) = 1">
                A milestone cannot have more than one @unit.
            </sch:assert>
        </sch:rule> 
        
        <sch:rule context="tei:milestone">
            <sch:assert test="@type">
                A milestone must have a @type.
            </sch:assert>
        </sch:rule> 
        
        <sch:rule context="tei:milestone">
            <sch:assert test="count(@type) = 1">
                A milestone cannot have more than one @type.
            </sch:assert>
        </sch:rule> 
        
        <sch:rule context="tei:milestone">
            <sch:let name="milestoneType" value="@type"/>
            <sch:assert test="count(preceding::tei:milestone[@type=$milestoneType])=0">         
                Milestone type must be unique within the document.
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="tei:milestone">
            <sch:assert test="count(@subtype) = 1">
                A milestone cannot have more than one @subtype.
            </sch:assert>
        </sch:rule> 
        
        <!-- Line groups and line numbers -->
        
        <sch:rule context="tei:lg">
            <sch:assert test="count(tei:l) gt 0">
                There must be at least one line element within a line group.
            </sch:assert>
        </sch:rule>
     
        <sch:rule context="tei:l">
            <sch:let name="lineNumber" value="@n"/>
            <sch:assert test="count(preceding::tei:l[@n=$lineNumber])=0">         
                Line number must be unique within the document.
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="tei:l">
            <sch:assert test="count(tei:choice) gt 0">
                There must be at least one choice element within a line.
            </sch:assert>
        </sch:rule> 
        
        <!-- Inline elements -->

        <!-- Choices -->
        
        <sch:rule context="tei:choice">
            <sch:assert test="tei:orig|tei:reg|tei:sic|tei:corr">
                Choice must contain an orig, reg, sic or corr.
            </sch:assert>
         </sch:rule>
        
        <!-- Terms and glosses -->

        <sch:rule context="tei:term">
            <sch:assert test="(@xml:id and @key)">
                A term must have an @xml:id and a @key.
            </sch:assert>
        </sch:rule> 
        
        <sch:rule context="tei:gloss">
            <sch:assert test="(@xml:lang and @target)">
                A gloss must have an @xml:lang and a @target.
            </sch:assert>
        </sch:rule> 

    </sch:pattern>
</sch:schema>
