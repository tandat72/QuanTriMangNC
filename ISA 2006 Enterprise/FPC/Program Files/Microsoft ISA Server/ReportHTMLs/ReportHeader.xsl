<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> 
        <xsl:template match="/ReportRoot">              
                <HTML>           
                        <head>  
                        <base target="header"/>
                                <style type="text/css"><xsl:comment>
            .heading1 {
                                font-family: arial, helvetica;
                                font-size: 12pt;
                                font-weight: bold;
                                color: #000066;
                                align: center;
                        }
                        .date {
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

				<body bgcolor="white" topmargin="0" leftmargin="0">
			<table border="0" width="100%" cellspacing="0" cellpadding="0">
				<tr>
					<td valign="bottom" align="right">
						<img border="0" src="logo.jpg" hspace="5" width="175" height="78"/>
					</td>
					<td width="100%" valign="bottom" align="middle"> 
						<font face="Arial, Helvetica" color="#000066">
						<b>
						<font size="5">
							<xsl:value-of select="Array"/>
						</font>
						</b>
						<br>
							<font size="2">
								<xsl:value-of select="ReportStart"/> to <xsl:value-of select="ReportEnd"/>
							</font>
						</br>
						<br>
							<font size="2">
								Participating servers: <xsl:value-of select="ReportServers"/> 
							</font>
						</br>	
						</font>
					</td>
				</tr>
			</table>
	</body>

                </HTML> 
        </xsl:template> 
</xsl:stylesheet>
