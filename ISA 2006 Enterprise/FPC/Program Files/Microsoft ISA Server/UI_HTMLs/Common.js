//this module should be included in any htm file

function put_defaultStatus(status)
{
	window.defaultStatus = status;
	window.top.defaultStatus = status;
}

function ClearStatus()
{
    if (window.status.search("#none")) 
    {
        window.status = "";
    }
}

function setEmptyView(ObjectGUID, fEmptyView, emptyViewTitle, emptyViewMessage)
{
    //
    // remove descritption if already existed
    //
    var TextElement = document.getElementById("EmptyViewDescription_" + ObjectGUID);
    if (TextElement != null)
    {
        TextElement.removeNode(true); //true for remove children (not that any exist currently...)
    }
	
    var HeaderElement=document.getElementById("EmptyViewHeader_" + ObjectGUID);
    if (HeaderElement != null)
    {
        HeaderElement.removeNode(true); //true for remove children (not that any exist currently...)
    }    


    if(fEmptyView)
    {
            //
            // First, we disable the objIsaList.
            //
            var IsaListobj = document.getElementById(ObjectGUID);
            if(IsaListobj == null)
            {
                debugger; //Can't handle (object required).
                return;
            }
            IsaListobj.style.display = "none";

            //
            // Then, we create an element (frame, with the text passed to us as
            // argument.
            //
            if(emptyViewTitle != "")
           	{
            	IsaListobj.insertAdjacentHTML("beforeBegin", "<table id='EmptyViewHeader_" + ObjectGUID + "' cellpadding='0' cellspacing='0' width='100%' > <tr><td width='100%' height='22'></td></tr> <tr> <td> <p class='header1' >" + emptyViewTitle + "</p> </td> </tr> </table>");
            }
            IsaListobj.insertAdjacentHTML("beforeBegin", "<table id='EmptyViewDescription_" + ObjectGUID + "' cellpadding='0' cellspacing='0' width='100%' > <tr> <td class = 'GSTDText'> <p  class='bodyCopy' >" + emptyViewMessage + "</p> </td></tr> </table> ");
    }
    else
    {
        //
        // First, we enable the objIsaList.
        //
        var IsaListobj = document.getElementById(ObjectGUID);
        IsaListobj.style.display = "block";



    }
}
