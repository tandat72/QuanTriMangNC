<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl">

<!-- ReportContents.xsl -->

<xsl:template match="/">

        <HTML>
        <HEAD>
                <meta http-equiv="Content-Language" content="en-us"/>
                <meta http-equiv="Content-Type" content="text/html; charset=windows-1252"/>
                <title>Report Contents</title>
                <base target="contents"/>

        <STYLE TYPE="text/css"><xsl:comment>

                BODY { font-family:verdana; font-size:70%; }
                H1 { font-size:120%; font-style:italic; }

                UL { margin-left:0px; margin-bottom:5px; }
                LI UL { display:block; margin-left:16px; }
                LI { font-weight:bold; list-style-type:square; cursor:default; }
                LI.clsHasKids { list-style-type:none; }
                LI.clsHasKids SPAN { cursor:hand; }

                A:link, A:visited, A:active { font-weight:normal; color:navy; }
                A:hover { text-decoration:none; }

        </xsl:comment></STYLE>

        <SCRIPT LANGUAGE="javascript"><xsl:comment><![CDATA[

                function GetChildElem(eSrc,sTagName)
                {
                        var cKids = eSrc.children;
                        for (var i=0;i<cKids.length;i++)
                        {
                                if (sTagName == cKids[i].tagName) return cKids[i];
                        }
                        return false;
                }

                function List_click()
                {
                        var eSrc = window.event.srcElement;
                        if ("SPAN" == eSrc.tagName && "clsHasKids" == eSrc.parentElement.className)
                        {
                                var eChild = GetChildElem(eSrc.parentElement,"UL");
                                eChild.style.display = ("none" == eChild.style.display ? "block" : "none");
                        }
                }

                function List_over()
                {
                        var eSrc = window.event.srcElement;
                        if ("SPAN" == eSrc.tagName && "clsHasKids" == eSrc.parentElement.className)
                        {
                                eSrc.style.color = "maroon";
                        }
                }

                function List_out()
                {
                        var eSrc = window.event.srcElement;
                        if ("SPAN" == eSrc.tagName && "clsHasKids" == eSrc.parentElement.className)
                        {
                                eSrc.style.color = "";
                        }
                }

        ]]>//</xsl:comment></SCRIPT>

        </HEAD>
        <BODY>

        <!-- BUILD LIST -->

        <UL ONMOUSEOVER="List_over();" ONMOUSEOUT="List_out();" ONCLICK="List_click();">
                <xsl:apply-templates select="ReportRoot/Category" />
        </UL>

        </BODY>
        </HTML>

</xsl:template>

<xsl:template match="Category">
        <LI CLASS="clsHasKids"><SPAN><xsl:value-of select="CategoryName" /></SPAN>
        <UL>
        <xsl:for-each select="Report">
                <LI>
                        <A TARGET="Reports">
                                <xsl:attribute name="HREF">
                                        Reportsdata.htm#<xsl:value-of select="../CategoryName"/><xsl:value-of select="ReportTitle"/>
                                </xsl:attribute>
                                <xsl:value-of select="ReportTitle" />
                        </A>
                </LI>
        </xsl:for-each>
        <xsl:apply-templates select="Category" />
        </UL>
        </LI>
</xsl:template>

</xsl:stylesheet>
