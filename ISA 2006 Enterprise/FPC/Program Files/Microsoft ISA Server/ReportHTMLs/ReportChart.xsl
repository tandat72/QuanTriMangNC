<?xml version="1.0"?>
<!--
This stylesheet is intended to convert XML containing report data
to the XML containing a data for chart generation. The XML will
contain only the data that essential for chart generation in order
to simplify code development
Each Chart data is eclosed by <ChartData> tag. Each chart contains
chart title that serves as a filename for output GIF file, chart
values and categories, chart captions and chart type

Author: Alexandra Faynburd
Date:   02-Dec-2002
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
        <xsl:output method="xml"/>
        
        <xsl:variable name="BYTE">1</xsl:variable>
        <xsl:variable name="KB">1024</xsl:variable>
        <xsl:variable name="MB"><xsl:value-of select="1024*1024"/></xsl:variable>
        <xsl:variable name="GB"><xsl:value-of select="1024*1024*1024"/></xsl:variable>
        
        <xsl:template match="/">
            <ReportRoot>
            <xsl:for-each select="ReportRoot/Category/Report">
                        <ChartData>
                            <ChartTitle>
                            <xsl:value-of select="ancestor::Category[1]/CategoryName"/><xsl:value-of select="ReportTitle"/>
                            </ChartTitle>
                                  <!--categories -->
                            <xsl:variable name="Category" select="ChartData/ChartCategories"/>
                                <xsl:for-each select="ReportData/*[name() = $Category]">
                                        <ChartCategory>
                                                <xsl:value-of select="."/>
                                        </ChartCategory>
                                  </xsl:for-each>
                                   
                                   <!--values-->
                                   <!--
                                   We want to output the values that will be used in the chart values series.
                                   Here we have too cases - the simpler one when we output data as it is, the the
                                   more complex one, when we should adjust data to the unit.
                                   Why and how should we adjust data to the unit?
                                   Let's consider TotalBytes series that should be charted. In the XML the values are
                                   in bytes, and they can be quite large, we want to present them in KB, MB or GB.
                                   But in order the chart to be consistent, all of them should have the same unit
                                   (imagine how we display 1 B and 1 MB on the same chart)
                                   The algorithm is as following:
                                   1. Find maximum value in the list of values
                                   2. Calculate the unit corresponding to this value
                                   3. Divide all the values to a multiple corresponding to the unit
                                   4. Add [<Unit>] to caption of the values axis
                                   -->

                                   <xsl:variable name="Values" select="ChartData/ChartValues"/>                         
                                   <!-- Check if we need to enter to the complex case
                                        Check if the column has Unit attribute
                                    -->
                                   <xsl:variable name="ValuesColumnPosition" select="count(ReportData[1]/child::*)- count(ReportData[1]/*[name() = string($Values)]/following-sibling::*)"/>
                                   <xsl:choose>
                                   <xsl:when test="Columns/Column[$ValuesColumnPosition]/@ColumnRole = 'Unit'">
                                     <xsl:variable name="MaxValue">
                                                    <xsl:call-template name="maxNum">
                                                    <xsl:with-param name="list" select = "ReportData/*[name()=$Values]"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                
                                        <Max><xsl:value-of select="$MaxValue"/></Max>
                                   
                                           <!-- Calculate multiplier of the unit-->
                                                 <xsl:variable name="UnitMultiply">
                                                   <xsl:call-template name="CalcUnit">
                                                   <xsl:with-param name="value" select="$MaxValue"/>
                                                   </xsl:call-template>
                                           </xsl:variable>
                                                                                                                
                                           <!--divide all the series to the unit -->
                                           <xsl:for-each select="ReportData/*[name()=$Values]">
                                                   <ChartValue>
                                                   <xsl:value-of select=". div $UnitMultiply"/>
                                                   </ChartValue>
                                           </xsl:for-each>
                                        
                                           <!--calculate the name of the unit-->
                                           <xsl:variable name="UnitName">
                                                   <xsl:call-template name="CalcUnitName">
                                                   <xsl:with-param name="value" select="$UnitMultiply"/>
                                                   </xsl:call-template>
                                           </xsl:variable>
                                        
                                            <ValuesCaption>
                                                                        <xsl:value-of select="ChartData/ValuesCaption"/><xsl:value-of select="$UnitName"/>
                                                  </ValuesCaption>
                                  </xsl:when>
                                  <xsl:otherwise>
                                      <!--display the values as they are -->
                                                  <xsl:for-each select="ReportData/*[name()=$Values]">
                                                   <ChartValue>
                                                           <xsl:value-of select="."/>
                                                   </ChartValue>
                                           </xsl:for-each>
                                           
                                           <ValuesCaption>
                                                                        <xsl:value-of select="ChartData/ValuesCaption"/>
                                                  </ValuesCaption>
                                  </xsl:otherwise>
                                  </xsl:choose>
                                
                        
                                        <ChartLegend><xsl:value-of select="ChartData/ChartLegend"/></ChartLegend>
                                        <ChartType><xsl:value-of select="ChartData/ChartType"/></ChartType>
                                        <CategoriesCaption><xsl:value-of select="ChartData/CategoriesCaption"/></CategoriesCaption>
        
                </ChartData>
                </xsl:for-each>
  </ReportRoot>         
        </xsl:template>

<!--
Template for calculation of Unit (Byte, KB, MB, GB)
-->
        <xsl:template name="CalcUnit">
                <xsl:param name="value"/>
            <!--
             Calculate the number and the unit according to the number.
             The units are Bytes, kilobytes, megabytes, gigabytes
            -->
                <xsl:choose>
                        <xsl:when test="number($value) &lt; 1000">
                                <xsl:value-of select="$BYTE"/>
                        </xsl:when>
                        <xsl:when test="number($value) div $KB &lt; 1000">
                                <xsl:value-of select="$KB"/>
                        </xsl:when>
                        <xsl:when test="number($value) div $MB &lt; 1000">
                                <xsl:value-of select="$MB"/>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:value-of select="$GB"/>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>

<!--
Template for calculation of the name of the unit (to be added to chart caption)
-->
        <xsl:template name="CalcUnitName">
        <xsl:param name="value"/>
                        <xsl:choose>
                        <xsl:when test="number($value) = $BYTE">[<xsl:value-of select="/ReportRoot/UnitNames/Bytes"/>]</xsl:when>
                        <xsl:when test="number($value) = $KB">[<xsl:value-of select="/ReportRoot/UnitNames/KB"/>]</xsl:when>
                        <xsl:when test="number($value) = $MB">[<xsl:value-of select="/ReportRoot/UnitNames/MB"/>]</xsl:when>
                        <xsl:otherwise>[<xsl:value-of select="/ReportRoot/UnitNames/GB"/>]</xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        

<!--
This template will recursively
determine the maximim value in a nodeset
-->
        <xsl:template name="maxNum">
                <xsl:param name="list" />
                <xsl:param name="nMax" select="'0'"/>

                <xsl:choose>
                        <xsl:when test="$list">
                                <!--
                                Store the remaining list into a variable for subsequent 
                                recursive calls to this template                                
                                -->
                                <xsl:variable name="remainingList" select="$list[position() != 1]" />

                                <!--
                                Calculate the new minimum value.  The value is set to
                                the currently passed in value, or the value in the node
                                set, whichever is lower                                 
                                -->
                                <xsl:variable name="nNewMax">
                                        <xsl:choose>
                                                <xsl:when test="$list[1] &gt; $nMax">
                                                        <xsl:value-of select="$list[1]" />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                        <xsl:value-of select="$nMax"    />
                                                </xsl:otherwise>
                                        </xsl:choose>
                                </xsl:variable>

                                <!--
                                Recursively call the current template with the newly     
                                calculated minimum value                                                                
                                -->
                                <xsl:call-template name="maxNum">
                                        <xsl:with-param name="list" select="$remainingList"/>
                                        <xsl:with-param name="nMax" select="$nNewMax"/>
                                </xsl:call-template>

                </xsl:when>

                <xsl:otherwise>
                <!--
                         If we have hit this section in the template, it indicates
                         that no more elements need to be processed and that we 
                         return the maximum value instead of making any further
                         recursive calls
                -->
                        <xsl:value-of select="$nMax" />
                </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        
</xsl:stylesheet>
