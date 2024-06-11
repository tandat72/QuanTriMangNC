<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> 
        <xsl:template match="/ReportRoot">              
                <HTML>           

                <head>
                        <meta http-equiv="Content-Language" content="en-us"/>
                        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252"/>
                        <title>Microsoft ISA Server Report</title>
                </head>
                <frameset rows="85,*" frameborder="no">
                        <frame frameborder="no" marginheight="0" marginwidth="0" name="Header" scrolling="no" target="header" src="header.htm"/>
                        <frameset cols="180,*">
                                <frame frameborder="no" marginheight="8" marginwidth="0" name="contents" target="contents" src="contents.htm"/>
                                <frame frameborder="no" marginheight="8" marginwidth="8" name="Reports" src="reportsdata.htm" target="main"/>
                        </frameset>
                        <noframes>
                                <body>
                                        <p>This page uses frames, but your browser doesn't support them.</p>
                                </body>
                        </noframes>
                </frameset>


                </HTML> 
        </xsl:template> 
</xsl:stylesheet>
