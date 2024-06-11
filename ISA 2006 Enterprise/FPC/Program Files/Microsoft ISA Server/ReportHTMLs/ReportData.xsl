<xsl:stylesheet version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:user="http://microsoft.com"
      xmlns:msxsl="urn:schemas-microsoft-com:xslt">
<xsl:output method="html" encoding="us"/>

   <msxsl:script language="VBScript" implements-prefix="user">
   Function GetNumber(strNumber)
          GetNumber = FormatNumber(strNumber)
   End Function
   </msxsl:script>

   <xsl:variable name="BYTE">1</xsl:variable>
   <xsl:variable name="KB">1024</xsl:variable>
   <xsl:variable name="MB"><xsl:value-of select="1024*1024"/></xsl:variable>
   <xsl:variable name="GB"><xsl:value-of select="1024*1024*1024"/></xsl:variable>

   <xsl:template match="/ReportRoot">              
           <HTML>           
                   <head>          
                   <meta http-equiv="Content-Language" content="en-us"/>
                   <base target="main"/>
                   <style type="text/css"><xsl:comment>
                   .heading1 {
                           font-family: arial, helvetica;
                           font-size: 12pt;
                           font-weight: bold;
                           color: #000066;
                           align: center;
                   }
                   .legend {
                           font-family: arial, helvetica;
                           font-size: 9pt;
                           font-weight: bold;
                           align: center;
                           color: #000066;
                   }
                   .text {
                           font-family: verdana, arial, helvetica;
                           font-size: 8pt;
                           font-weight: normal;
                           color: #000066;
                   }
                   table.clsData {
                           font-family: verdana, arial, helvetica;
                           font-size: 8pt;
                           font-weight: bold;
                           align: center;
                           border: 0;
                           cellspacing: 1;
                           cellpadding: 2;
                   }
   
                   tr.clsData { background-color: #cccccc;
                           font-family: verdana, arial, helvetica;
                           font-size: 8pt;
                           font-weight: bold;
                           align: center;
                   }
                   td.clsData { background-color: #eeeeee;
                           font-family: verdana, arial, helvetica;
                           font-size: 8pt;
                           font-weight: normal;
                   }
                   tr.clsTotal { background-color: #eeeeee;
                           font-family: verdana, arial, helvetica;
                           font-size: 8pt;
                           font-weight: bold;
                   }
                   th.clsColumn {
                           bgcolor: #cccccc;
                           align: center;
                           width: 64;
                   font-size: 8pt;
                   font-weight: bold;
                   }
                   th.clsColumnNumber {
                           bgcolor: #cccccc;
                           align: center;
                           width: 40;
                   font-size: 8pt;
                   font-weight: bold;
                   }
                   th.clsColumnKey {
                           bgcolor: #cccccc;
                           align: center;
                           width: 101;
                   font-size: 8pt;
                   font-weight: bold;
                   }

                   </xsl:comment></style>
                   </head>                 
                   <BODY>                          
                           <!-- Show all the reports -->
                           <xsl:call-template name="ShowAllReportsData" />                 
                   </BODY>         
           </HTML> 
   </xsl:template> 
   
   <xsl:template name="ShowAllReportsData">                                        
           <xsl:for-each select="Category/Report">
                   <p><xsl:text  disable-output-escaping="yes">&amp;nbsp;</xsl:text></p>
                   <a>
                   <xsl:attribute name="name">
                           <xsl:value-of select="../CategoryName"/><xsl:value-of select="ReportTitle"/>
                   </xsl:attribute>                                                
                   </a>
                   <span class="heading1"><xsl:value-of select = "ReportTitle"/></span>
                   <br></br>
                   <span class="text"><xsl:value-of select = "ReportDescription"/></span>
                   <center>
                           <table>
                                   <tr>
                                           <td align="center">
                                           <xsl:text disable-output-escaping="yes">&lt;</xsl:text>img src="<xsl:value-of select="../CategoryName"/><xsl:value-of select="ReportTitle"/>.gif"<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
                                           </td>
                                   </tr>
                                   <tr>
                                           <td align="left">
                                                   <p align="center" class = "legend">
                                                           <xsl:value-of select="ChartData/ChartLegend"/>
                                                   </p>
                                           </td>
                                   </tr>
                           </table>
                   </center>
                   
                   <p></p>
                                                                   
                   <center>
                      <TABLE>
                         <tr>
                             <td align="center">
                                <xsl:call-template name="ShowSingleReportData" />                
                             </td>
                         </tr>
                         
                         <tr>
                           <td align="center">
                               <span class = "legend">
                                   <xsl:value-of select = "ReportTableLegend"/>
                               </span>
                           </td>
                        </tr>               
                      </TABLE>
                  </center>
           </xsl:for-each>
   </xsl:template> 
   
   <!-- Show a single report table -->
   <xsl:template name="ShowSingleReportData">                                      
           <table>                                 
                   <xsl:attribute name="class">clsData</xsl:attribute>                                     
                   
                   <!-- table header - columns -->
                   <tr class = "clsData">                                  
                           <xsl:for-each select="Columns/Column">                                                  
                             <th>
                                  <xsl:choose>
                                  <xsl:when test="@ColumnRole='ItemNo'">
                                   <xsl:attribute name="class">clsColumnNumber</xsl:attribute>
                                  </xsl:when>
                                  <xsl:when test="@ColumnRole='KeyValue'">
                                   <xsl:attribute name="class">clsColumnKey</xsl:attribute>
                                  </xsl:when>
                                  <xsl:otherwise>
                                     <xsl:attribute name="class">clsColumn</xsl:attribute>
                                  </xsl:otherwise>
                                  </xsl:choose>  
                                                            
                                  <xsl:value-of select="."/>
                              </th>
                           </xsl:for-each>                                 
                   </tr>                                  
                   
                   <!-- Output report data -->
                   <xsl:for-each select="ReportData">                                              
                           <tr>                                                    
                                   <xsl:for-each select = "*">             
                                     <xsl:variable name = "CurPos" select = "position()"/>                                         
                                        <td class = "clsData">                                                          
                                             <xsl:call-template name = "DisplayValue">
                                                 <xsl:with-param name = "value" select = "."/>
                                                 <xsl:with-param name = "valueFormat" select = "ancestor::Report[1]/Columns/Column[$CurPos]/@*"/>
                                             </xsl:call-template>
                                        </td>                                                 
                                   </xsl:for-each>
                           </tr>                                   
                   </xsl:for-each>                                 
                   
                   <!-- Output for Total record -->                                        
                   <xsl:for-each select = "AllOthers | Total">                                             
                           <tr class = "clsTotal">                                                 
                                   <!-- output all the field of the Total record -->                                                       
                                   <xsl:for-each select = "*">                                                             
                                           <td>
                                             <xsl:variable name = "CurPos" select = "position()"/>                                           
                                             <xsl:call-template name = "DisplayValue">
                                                 <xsl:with-param name = "value" select = "."/>
                                                 <xsl:with-param name = "valueFormat" select = "ancestor::Report[1]/Columns/Column[$CurPos]/@*"/>
                                             </xsl:call-template>
                                           </td>                                                   
                                   </xsl:for-each>                                         
                           </tr>                                   
                   </xsl:for-each>                         
           </table>                                        
   </xsl:template>
   
   
<!-- Emit value according to its attributes -->
<xsl:template name="DisplayValue">
   <xsl:param name = "value"/>
   <xsl:param name = "valueFormat"/>
   
   <!-- align the value -->
   <xsl:choose>
   <xsl:when test = "$valueFormat='KeyValue'">
           <xsl:attribute name = "align">left</xsl:attribute>
   </xsl:when>
   <xsl:when test = "$value='-'">
           <xsl:attribute name = "align">center</xsl:attribute>
           <xsl:value-of select = "$value"/>
   </xsl:when>
           <xsl:otherwise>
           <xsl:attribute name = "align">right</xsl:attribute>
   </xsl:otherwise>
   </xsl:choose>

   <xsl:if test = "$value != '-'">
           <!-- Format the value according to the attribute -->
           <xsl:choose>
           <!-- Format with units -->
           <xsl:when test="$valueFormat='Unit'">
               <xsl:call-template name = "DisplayWithUnits">
                       <xsl:with-param name="value" select="$value"/>
               </xsl:call-template>
           </xsl:when>
           
           <!-- Format percents -->
           <xsl:when test = "$valueFormat='Percent'">
             <xsl:value-of select="concat(user:GetNumber(number($value)), ' %')"/>                        
           </xsl:when>

           <!-- Format unknown tag, just concatenate it -->
           <xsl:when test="$valueFormat = 'sec'">
               <xsl:variable name="Unit" select="/ReportRoot/UnitNames/Sec"/>                               
               <xsl:value-of select="concat(user:GetNumber(number($value)), ' ', $Unit)"/>                        
           </xsl:when>
   
           <xsl:otherwise>
                   <xsl:value-of select = "$value"/>
           </xsl:otherwise>
           </xsl:choose>           
   </xsl:if>       
</xsl:template>
   
<!--
Calculate the number and the unit according to the number.
The units are Bytes, kilobytes, megabytes, gigabytes.
Input parameter - the value that should be formatted
-->        
   <xsl:template name="DisplayWithUnits">          
           <xsl:param name="value"/>               
           <xsl:choose>                    
                   <xsl:when test="number($value) &lt; 1000">                              
                           <xsl:variable name="CalculatedValue" select="$value"/>                          
                           <xsl:variable name="Unit" select="/ReportRoot/UnitNames/B"/>                               
                           <xsl:value-of select="concat(user:GetNumber(number($CalculatedValue)), ' ', $Unit)"/>                        
                   </xsl:when>                     
                   <xsl:when test="number($value) div $KB &lt; 1000">                             
                           <xsl:variable name="CalculatedValue" select="number($value) div $KB"/>                         
                           <xsl:variable name="Unit" select="/ReportRoot/UnitNames/KB"/>                              
                           <xsl:value-of select="concat(user:GetNumber(number($CalculatedValue)), ' ', $Unit)"/>                        
                   </xsl:when>                     
                   <xsl:when test="number($value) div $MB &lt; 1000">                          
                           <xsl:variable name="CalculatedValue" select="number($value) div $MB"/>                              
                           <xsl:variable name=  "Unit" select="/ReportRoot/UnitNames/MB"/>                              
                           <xsl:value-of select="concat(user:GetNumber(number($CalculatedValue)), ' ', $Unit)"/>                        
                   </xsl:when>                     
                   <xsl:otherwise>                         
                           <xsl:variable name="CalculatedValue" select="number($value) div $GB"/>                           
                           <xsl:variable name="Unit" select="/ReportRoot/UnitNames/GB"/>                              
                           <xsl:value-of select="concat(user:GetNumber(number($CalculatedValue)), ' ', $Unit)"/>                        
                   </xsl:otherwise>                
           </xsl:choose>   
   </xsl:template>
</xsl:stylesheet>
