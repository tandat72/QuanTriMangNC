window.onresize = Slider_OnLoad;

//How many pixels should it move every step? 
var move=20;

//At what speed (in milliseconds, lower value is more speed)
menuSpeed=5;

spaceBeteenMenu = 10;

function makeMenu(obj){
    this.css = eval(obj+'.style');                  
    this.mOut = m_Out;
    this.mIn = m_In;
    this.menu = moveMenu;
    this.tim;
        
    this.width = eval(obj+'.style.pixelWidth');
    this.obj = obj + "Object";
    eval(this.obj + "=this");  
}

//  Sets the state of the menu. If the requested state is equal to current state,
//  the function does nothing. Otherwise the transition occurs.
function moveMenu(fVisible, fAnimation)
{
    //  Do nothing if the current state is equal to requested state
    if(this.state == 0)
    {       //  The taskbar is now visible
        if(fVisible)
            return;
    }
    else
    {
        if(!fVisible)
            return;
    }
    
    //  When one menu shows up, all other should be hidden. This code was adapted
    //  from http://toolbox. In ISA we have only one menu, which is a taskbar. So
    //  the code below does nothing.
    for(i=0; i < oMenu.length; i++)
    {
        if (oMenu[i].obj != this.obj)
        {
            if (oMenu[i].state == 0)
            {
                oMenu[i].state = 1;
                oMenu[i].css.pixelRight = -oMenu[i].width; //retracts any other menus that are open
            }
        }
    }

    if(fAnimation)
    {
        if(this.state == 0)
        {       //  Hide the taskbar
            clearTimeout(this.tim);
            this.mIn(); 
            htcToolsTabs.style.display = "none";
        }
        else
        {       //  Show the taskbar
            clearTimeout(this.tim);
            document.all.tdTasks.style.visibility = 'visible';
            document.all.tdWorkArea.style.pixelWidth = document.all.tblMain.offsetWidth - this.css.pixelWidth - spaceBeteenMenu;
            this.mOut();
            htcToolsTabs.style.display = "block";
        }
    }
    else
    {
        if(fVisible)
        {
            this.state = 0;
            document.all.tdTasks.style.visibility = 'visible';
            menuRelocate();
            htcToolsTabs.style.display = "block";
        }
        else
        {
            this.state = 1;
            menuRelocate();
            htcToolsTabs.style.display = "none";
        }
    }
}

//Move Menu out from the screen
function m_In()
{
    if(this.css.pixelRight > -this.width)
    {
        var curMove = move;
        if(this.css.pixelRight + this.width < move)
            curMove = this.css.pixelRight + this.width;
        this.css.pixelRight = this.css.pixelRight - curMove;        
        this.tim = setTimeout(this.obj+".mIn()", menuSpeed);
    }
    else
    {
        this.state=1;
        this.css.pixelRight = -this.width;
        document.all.imgTaskbarButton.Direction='left';
        hilightLever(false);
        document.all.tdWorkArea.style.pixelWidth = document.all.tblMain.offsetWidth - spaceBeteenMenu;
    }       
}

//Move Menu into the screen
function m_Out()
{
    if(this.css.pixelRight < 0)
    {
        var curMove = move;
        if (-this.css.pixelRight < move)
            curMove = -this.css.pixelRight;
        this.css.pixelRight = this.css.pixelRight + curMove;
        this.tim = setTimeout(this.obj+".mOut()",menuSpeed);
    }
    else
    {
        this.state=0;
        this.css.pixelRight = 0;
        document.all.imgTaskbarButton.Direction='right';
        hilightLever(false);
    }   
}

function setMenuPositions(){
    document.all.tdWorkArea.style.pixelWidth = document.all.tblMain.offsetWidth - spaceBeteenMenu;
    for(i=0; i < oMenu.length; i++){
        oMenu[i].css.pixelRight = -oMenu[i].width;
    }
}

//Keeps the slide menu in it's spot relative to the right side when page is resized
function menuRelocate(){
    
    for(i=0; i < oMenu.length; i++)
    {
        oMenu[i].width = oMenu[i].css.pixelWidth + 1;
        if (oMenu[i].state == 0)
        {
            document.all.imgTaskbarButton.Direction='right';
            hilightLever(false);
            oMenu[i].css.pixelRight = 0;
            document.all.tdWorkArea.style.pixelWidth = document.all.tblMain.offsetWidth - oMenu[i].css.pixelWidth - spaceBeteenMenu;
        }
        else
        {
            document.all.imgTaskbarButton.Direction='left';
            hilightLever(false);
            oMenu[i].css.pixelRight = -oMenu[i].width;
            document.all.tdWorkArea.style.pixelWidth = document.all.tblMain.offsetWidth - spaceBeteenMenu;
        }   
    }
}

function hilightLever(bhilight)
{
    if (bhilight) {
        if (document.all.imgTaskbarButton.Direction=='left') {
            document.all.imgTaskbarButton.src='_image/taskBar/tab-on-lt.png';
        } 
        if (document.all.imgTaskbarButton.Direction=='right') {
            document.all.imgTaskbarButton.src='_image/taskBar/tab-on-rt.png';
        }
    } else {
        if (document.all.imgTaskbarButton.Direction=='left') {
            document.all.imgTaskbarButton.src='_image/taskBar/tab-off-lt.png';
        } 
        if (document.all.imgTaskbarButton.Direction=='right') {
            document.all.imgTaskbarButton.src='_image/taskBar/tab-off-rt.png';
        }
    }
}

function menuInit(){
    oMenu=new Array();
    oMenu[0]=new makeMenu('divTasks');
    setMenuPositions();
    document.all.mainContentDiv.style.visibility = 'visible';
    
    document.all.imgTaskbarButton.Direction='left';
    hilightLever(false);
}

function Slider_OnLoad()
{
    var setHeight = document.body.offsetHeight - (document.all.trContent.offsetTop + 1);

    if(setHeight < 10)
    {
        setHeight = 10;
    }
        
    document.all.divTasks.style.top = trContent.offsetTop;
    document.all.divTasks.style.height = setHeight - 5;
    document.all.tblTasksControl.style.height = setHeight;
    
    if (event!= null && event.type == "load")
    {
        menuInit();
    }
    else
    {
        menuRelocate();
    }
}
