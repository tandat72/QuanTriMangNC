//--------------------------------------------------------
// Defining a pane object type
//--------------------------------------------------------
function Pane(sTitle, nColumn, nPosition, bOpened, sTabGUID, nHeightMust, nHeightNicetohave, iStatus)
{
    // Properties
    this.sTitle = sTitle;
    this.nColumn = nColumn;
    this.nPosition = nPosition;
    this.bOpened = parseInt(bOpened); // -1 or 0
    this.sTabGUID = sTabGUID;
    this.nHeightMust = nHeightMust;
    this.nHeightNicetohave = nHeightNicetohave;
    this.iStatus = iStatus;

    this.ObjectsArr = new Array();
    this.nInnerRows = 1;
    this.nInnerCols = 1;

    // Methods
    this.GetControlName = PaneControlName
    this.GetMustHeight = PaneMustHeight;
    this.AddObject = PaneAddObject;
    this.GetObjectString = PaneGetObjectString;
    this.GetObjectsString = PaneGetObjectsString;
    this.UpdateObjectsString = PaneUpdateObjectsString;
}
//--------------------------------------------------------
// Implementation of the methods
//--------------------------------------------------------
function PaneControlName()
{
    return "Pane" + this.nColumn + "" + this.nPosition;
}

function PaneMustHeight()
{
    return document.getElementById(this.GetControlName()).TitleHeight +
            ((this.bOpened == -1) ? this.nHeightMust + document.getElementById(this.GetControlName()).BottomHeight : 0);
}

function PaneAddObject(PaneObj)
{
    this.ObjectsArr.push(PaneObj);
    if (PaneObj.nRow >= this.nInnerRows)
        this.nInnerRows = PaneObj.nRow + 1;
    if (PaneObj.nCol >= this.nInnerCols)
        this.nInnerCols = PaneObj.nCol + 1;
}

function PaneGetObjectString(index)
{
    if (index < 0 || index >= this.ObjectsArr.length)
        return "";
    // IsaList gets tab index, the rest don't
    return "<object TestKey='ISA_LIST_CONTROL"+this.ObjectsArr[index].sGUID+"' "+
            ((this.ObjectsArr[index].sActiveX != "{7B800019-6212-41DC-B208-520B501FBFB2}") ? "tabindex='-1' " : "") +
            "classid='clsid:"+this.ObjectsArr[index].sActiveX+"' "+
            "id='"+this.ObjectsArr[index].sGUID+"' width='100%' height='100%'>"+
            this.ObjectsArr[index].sParams+
            "</object>";
}

function PaneGetObjectsString()
{
    if (this.ObjectsArr.length == 0)
        return "";
    if (this.ObjectsArr.length == 1)
        return this.GetObjectString(0);

	return ""; // will create a container to be filled later
}

function PaneUpdateObjectsString()
{
    if (this.ObjectsArr.length <= 1)
        return;

	// The only pane that gets here is the performance monitor,
	// so this is custom made for it: 
	// first add a table with the perfmons, then another table with the legend.
	// the idea is to have to scrol down in order to get to the legend	
	
    var sObjectString = "<table border='0' width='100%' height='100px'><tr>";
    var iIndex;
    for (var j = 0; j < this.nInnerCols; ++j)
    {	// row is 0
        for (var index = 0, iIndex = -1; index < this.ObjectsArr.length; ++index)
        {
            if (this.ObjectsArr[index].nRow == 0 && this.ObjectsArr[index].nCol == j)
            {
                iIndex = index;
                break;
            }
        }
        if (j == this.nInnerCols - 1)
            sObjectString = sObjectString + "<td>";
        else               
            sObjectString = sObjectString + "<td width='"+(100/this.nInnerCols)+"%'>";
        if (iIndex > -1)
            sObjectString = sObjectString + this.GetObjectString(iIndex);
        sObjectString = sObjectString + "</td>";
    }
    sObjectString = sObjectString + "</tr></table><br/><table width='100%' height='1px'><tr><td>";
    
    for (var index = 0, iIndex = -1; index < this.ObjectsArr.length; ++index)
    {	// index is 1,0
        if (this.ObjectsArr[index].nRow == 1 && this.ObjectsArr[index].nCol == 0)
        {
            iIndex = index;
            break;
        }
    }
    if (iIndex > -1)
        sObjectString = sObjectString + this.GetObjectString(iIndex);
    sObjectString = sObjectString + "</td></tr></table>";
    
	document.getElementById(this.GetControlName()).ContainedHtml = sObjectString;
}
//--------------------------------------------------------
// Defining a pane-object object type
//--------------------------------------------------------
function PaneObject(sGUID, sActiveX, sParams, nCol, nRow)
{
    // Properties
    this.sGUID = sGUID;
    this.sActiveX = sActiveX;
    this.sParams = sParams;
    this.nCol = nCol;
    this.nRow = nRow;
}
//--------------------------------------------------------
// Panes array sorting functions
//--------------------------------------------------------
function PaneSortByPositionAsc(Pane1, Pane2)
{
    if (Pane1.nPosition > Pane2.nPosition)
        return 1;
    return -1;
}

function PaneSortByPositionDesc(Pane1, Pane2)
{
    return PaneSortByPositionAsc(Pane2, Pane1);
}

//--------------------------------------------------------
// Panes array - retrieval functions
//--------------------------------------------------------
function GetIndexByGUID(Panes, sGUID)
{
    for (var i = 0; i < Panes.length; ++i)
    {
        for (var j = 0; j < Panes[i].ObjectsArr.length; ++j)
        {
            if (Panes[i].ObjectsArr[j].sGUID == sGUID)
            {
                return i;
            }
        }
    }
    return -1;
}

function GetIndexByColAndRow(Panes, nCol, nRow)
{
    for (var i = 0; i < g_Panes.length; i++)
    {
        if (g_Panes[i].nColumn == nCol && g_Panes[i].nPosition == nRow)
        {
            return i;
        }
    }
    return -1;
}
//--------------------------------------------------------
