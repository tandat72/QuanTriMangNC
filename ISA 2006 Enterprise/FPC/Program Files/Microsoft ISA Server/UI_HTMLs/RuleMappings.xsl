<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- Output to HTML. HTML elements can't be generated from a malformed input XML  -->
    <xsl:output method="html" encoding="utf-16" />
    <xsl:template match="/">
        <html>       
            <head>
                <!-- The "<title>" should not be localized. Localize just the data: "Applied Link Translation Mappings" -->
                <ID id="L_SSLT_TITLE"><title>Applied Link Translation Mappings</title></ID>
                <script type="text/VBScript">
                    sub ViewAllMappings()
                        set rdMainMappingsOnly = document.GetElementById("MainMappingsOnly")
                        set rdAllMappings = document.GetElementById("AllMappings")
                        For Each aTr In document.body.getElementsByTagName("tr") 
                            IsMainMapping = aTr.getAttribute("IsMainMapping")
                            If IsMainMapping = "false" then 
                                if rdMainMappingsOnly.checked = true then
                                    aTr.style.display = "none"
                                else
                                    aTr.style.display = "block"
                                End if		
                            End If
                        next  		        
                    end sub
                </script>
            </head>
            <body>                
                <p><font size="4"><ID id="L_SSLT_Heading">Applied Link Translation Mappings (Rule: </ID><xsl:value-of select="RuleMappings/RuleName"/><ID id="L_SSLT_Bracket">)</ID></font></p>
                <b><ID id="L_SSLT_ViewMode">View Mode:</ID></b>&#160;
                <input type="radio" ID="MainMappingsOnly" name="rdViewMode" onclick="ViewAllMappings()" checked="checked"><ID id="L_SSLT_MainMappings">Main Mappings Only</ID></input>&#160;
                <input type="radio" ID="AllMappings" onclick="ViewAllMappings()" name="rdViewMode"><ID id="L_SSLT_AllMappings">All Mappings</ID></input>
                <xsl:for-each select="RuleMappings/PublicName">
                    <p><font size="3"><b><ID id="L_SSLT_PublicName">Public Name:</ID></b>&#160; <xsl:value-of select="@name"/></font></p>
                    <table border="1">
                        <tr bgcolor="#9acd32">
                            <th align="left"><ID id="L_SSLT_OriginalURL">Original URL</ID></th>
                            <th align="left"><ID id="L_SSLT_TranslatedURL">Translated URL</ID></th>
                            <th align="left"><ID id="L_SSLT_MappingDetails">Mapping Details</ID></th>
                            <th align="left"><ID id="L_SSLT_SameWebListener">Same Web Listener</ID></th>
                            <th align="left"><ID id="L_SSLT_CommonDNSSuffix">Common DNS Suffix</ID></th>
                            <xsl:if test="/RuleMappings/IsaEdition='EE'">
                                <th align="left"><ID id="L_SSLT_ArrayName">Array Name</ID></th>
                            </xsl:if>	
                        </tr>
                        <xsl:for-each select="Mapping">
                            <tr>
                                <xsl:attribute name="IsMainMapping"><xsl:value-of select="@IsMainMapping"/></xsl:attribute> 
                                <xsl:attribute name="style"><xsl:value-of select="@style"/></xsl:attribute>                                       
                                <td><xsl:value-of select="From"/></td>
                                <td><xsl:value-of select="To"/></td>
                                <td><xsl:value-of select="GeneralDescription"/></td>
                                <xsl:choose>
                                    <xsl:when test="ListenerDescription!='-'">
                                        <td><xsl:value-of select="ListenerDescription"/></td>									
                                    </xsl:when>									
                                    <xsl:otherwise>
                                        <td>&#160;</td>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:choose>
                                    <xsl:when test="CommonDnsDescription!='-'">
                                        <td><xsl:value-of select="CommonDnsDescription"/></td>									
                                    </xsl:when>									
                                    <xsl:otherwise>
                                        <td>&#160;</td>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:if test="/RuleMappings/IsaEdition='EE'"> 
                                    <xsl:choose>
                                        <xsl:when test="ArrayDescription!='-'">
                                            <td><xsl:value-of select="ArrayDescription"/></td>									
                                        </xsl:when>									
                                        <xsl:otherwise>
                                            <td>&#160;</td>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:if>
                            </tr>
                        </xsl:for-each>
                    </table>
                </xsl:for-each>
                <p><font size="3"><ID id="L_SSLT_NOTE">
                <b>Note:</b>
                <p>Displayed mappings always show the HTTP protocol. However, if the Web listener used in a publishing rule also specifies an SSL connection, the mappings for this rule will be translated according to the request connection type (HTTP or HTTPS).</p>
                <p>For rules that specify an additional character set for link translation (in addition to UTF-8), some mappings may appear twice in the mapping table.</p>
                </ID></font></p>
                <h4><ID id="L_SSLT_Legend">Legend</ID></h4>		
                <ul>
                    <li><ID id="L_SSLT_OriginalURLLegend"><b>Original URL</b> - The URL being searched.</ID></li>
                    <li><ID id="L_SSLT_TranslatedURLLegend"><b>Translated URL</b> - The URL that replaces the original URL.</ID></li>
                    <li><ID id="L_SSLT_MappingDetailsLegend"><b>Mapping Details</b> - Specifies if the mapping is user defined or automatically created by a rule. Also indicates if the mapping is applied at the rule level or array level.</ID></li>
                    <li><ID id="L_SSLT_SameWebListenerLegend"><b>Same Web Listener</b> - Indicates if both rules (the currently selected rule and the rule defining the mapping) use the same Web listener (Value = Yes), or different Web listeners (Value = No).</ID></li>
                    <li><ID id="L_SSLT_CommonDNSSuffixLegend"><b>Common DNS Suffix</b> - The common DNS suffix of the published URLs. "Empty" indicates that the URLs do not have any DNS suffix.</ID></li>
                    <xsl:if test="/RuleMappings/IsaEdition='EE'"> 
                        <li><ID id="L_SSLT_ArrayNameLegend"><b>Array Name</b> - The name of the Array that contains the rule for the specified mapping. Same indicates that both rules are from the same array.</ID></li>
                    </xsl:if>    
                </ul>
            </body> 
        </html>
    </xsl:template>
</xsl:stylesheet>
