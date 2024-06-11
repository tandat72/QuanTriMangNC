
//
// This is generated file from Commands.xml and CommandstoJs.xsl
// Any new commads should be added to that file.
//

//  Holds transformation between
var g_oNotifications        = new Object();
var g_HelpInvokeString      = 'ACTIVATE_HELP::/';

//  Type of the array may affect the way a page looks.
var g_TypeStandardEdition   = 0x10;     //  CometStandardEdition
var g_TypeEnterpriseEdition = 0x20;     //  CometEnterpriseEdition


RegisterNotification("IDR_PAGE_LOADED", 11001);
RegisterNotification("IDR_PAGE_SELECTED", 11002);
RegisterNotification("IDR_PAGE_RESIZED", 11003);
RegisterNotification("IDR_TOGGLE_TASKBAR", 11004);
RegisterNotification("IDR_PAGE_UNLOADED", 11006);
RegisterNotification("IDR_APPLY_CHANGES", 11009);
RegisterNotification("IDR_DISCARD_CHANGES", 11010);
RegisterNotification("IDR_NETWORK_TEMPLATE_SELECT", 11011);
RegisterNotification("IDR_DASHBOARD_TITLE_CLICKED", 11013);
RegisterNotification("IDR_DASHBOARD_PANE_MINIMIZED", 11014);
RegisterNotification("IDR_DASHBOARD_PANE_MAXIMIZED", 11015);
RegisterNotification("IDR_HELP", 11101);
RegisterNotification("IDR_PROPERTY", 11102);
RegisterNotification("IDR_GS_LINK_ROOT", 11103);
RegisterNotification("IDR_GS_LINK_NETWORK_CONFIG", 11104);
RegisterNotification("IDR_GS_LINK_FW_PROTECTION", 11105);
RegisterNotification("IDR_GS_LINK_CACHE", 11106);
RegisterNotification("IDR_GS_LINK_VPN", 11107);
RegisterNotification("IDR_GS_LINK_MONITORING", 11108);
RegisterNotification("IDR_GS_SCW", 11109);
RegisterNotification("IDR_BACK_TO_GETTINGSTARTED", 11110);
RegisterNotification("IDR_SQM_OPTIN", 11111);
RegisterNotification("IDR_LINK_NETWORKS", 11201);
RegisterNotification("IDR_LINK_GENERAL", 11202);
RegisterNotification("IDR_LINK_ADDINS", 11203);
RegisterNotification("IDR_LINK_CACHE", 11204);
RegisterNotification("IDR_LINK_FW_PROTECTION", 11205);
RegisterNotification("IDR_LINK_SERVERS", 11206);
RegisterNotification("IDR_EDIT_FILTER", 11301);
RegisterNotification("IDR_START_QUERY", 11302);
RegisterNotification("IDR_DELEGATE_CONTROL", 11303);
RegisterNotification("IDR_APPLICATION_SETTINGS", 11304);
RegisterNotification("IDR_SERVER_INFO", 11305);
RegisterNotification("IDR_DIALUP", 11306);
RegisterNotification("IDR_CONNECTION_QUOTA", 11307);
RegisterNotification("IDR_IP_OPTIONS", 11308);
RegisterNotification("IDR_INTRUSION_DETECTION", 11309);
RegisterNotification("IDR_RADIUS_SERVERS", 11310);
RegisterNotification("IDR_FIREWALL_CHAINING", 11311);
RegisterNotification("IDR_CONTENT_GROUPS", 11312);
RegisterNotification("IDR_CRL_PROPS", 11313);
RegisterNotification("IDR_QOS_PROPS", 11314);
RegisterNotification("IDR_NEW", 11408);
RegisterNotification("IDR_HARDENING", 12120);
RegisterNotification("IDR_GETTING_STARTED", 12125);
RegisterNotification("IDR_VPN_ACCESS_POINTS", 12131);
RegisterNotification("IDR_VPN_ADDRESS_ASSIGNMENT", 12132);
RegisterNotification("IDR_VPN_NEW_REMOTE_SITE", 12137);
RegisterNotification("IDR_VPN_USERS", 12140);
RegisterNotification("IDR_VPN_RADIUS_USAGE", 12141);
RegisterNotification("IDR_VPN_PROTOCOLS", 12142);
RegisterNotification("IDR_VPN_S2S_HELP", 12144);
RegisterNotification("IDR_DISABLE_CACHE", 12188);
RegisterNotification("IDR_CONFIGURE_CACHE_DRIVES", 12189);
RegisterNotification("IDR_CONF_REPORT_JOBS", 12190);
RegisterNotification("IDR_NEW_REPORT", 12191);
RegisterNotification("IDR_ASSIGN_POLICY_FOR_ARRAYS", 12193);
RegisterNotification("IDR_ASSIGN_RULE_TYPES_FOR_ARRAYS", 12194);
RegisterNotification("IDR_NEW_ENTERPRISE_POLICY", 12198);
RegisterNotification("IDR_ENTERPRISE_POLICY_PROPERTY", 12199);
RegisterNotification("IDR_NEW_ARRAY", 12200);
RegisterNotification("IDR_DISABLE_NLB", 12201);
RegisterNotification("IDR_ENABLE_NLB", 12202);
RegisterNotification("IDR_ENTERPRISE_READ_ABOUT", 12205);
RegisterNotification("IDR_ENTERPRISE_ADMINISTRATIVE_ROLES", 12206);
RegisterNotification("IDR_ENTERPRISE_ENTERPRISE_NETWORKS", 12207);
RegisterNotification("IDR_ENTERPRISE_ENTERPRISE_POLICIES", 12208);
RegisterNotification("IDR_ENTERPRISE_ARRAY_SETTINGS", 12209);
RegisterNotification("IDR_HELP_ABOUT_ARRAY_RULES", 12212);
RegisterNotification("IDR_HELP_ABOUT_ENTERPRISE_POLICIES", 12213);
RegisterNotification("IDR_HTTP_COMPRESSION_PROPS", 12214);
RegisterNotification("IDR_NLB_CONTEXT_MENU", 12215);
RegisterNotification("IDR_NLB_TASKBAR", 12216);
RegisterNotification("IDR_CREATE_VPN_ANSWER_FILE", 12218);

function RegisterNotification(sID,iID)
{
    g_oNotifications[sID] = iID;
}

//we are activted by mmc
function WithinSnapin()
{
    if (window.top == undefined) return false;
    if (window.top.MMCCtrl == undefined) return false;
    return (window.top.MMCCtrl.object != undefined);
}

function IsHelpInvoke(NotificationId)
{
        return (NotificationId.indexOf(g_HelpInvokeString) == 0 );
}

//use this to notify the snapin on events in the HTML
//NotificationId is either a the CommandId as known by the Snapin code
//or a string that is one of the Restered notifiaction - see RegisterNotification above
//the sContext is the GUID of the snapin node that should handel the notification.
function NotifySnapin(NotificationId,sContext)
{
    if (this != window.top)
    {
        window.top.NotifySnapin(NotificationId,sContext);
    } else {
        if (WithinSnapin())
        {
            var sId = NotificationId;
            if (typeof(NotificationId)=="string" && IsHelpInvoke(NotificationId) == false)
            {
                sId = g_oNotifications[NotificationId]
            }
            MMCCtrl.TaskNotify(g_SnapinClsid,sId,sContext);
        }
        Debug.writeln("Notify id=" + NotificationId + "("+ sId+ ") context=" + sContext);
    }
}

// Use this to notify the snapin to invoke ISA help. The name of the help is the parameter
function InvokeISAHelp(HelpTopicName)
{
    var ArrayRootGuid = "{43E06AFC-729B-49AB-8BC2-33A9E35BB12D}";
    HelpTopicNameParamter = g_HelpInvokeString + HelpTopicName;
             
   NotifySnapin(HelpTopicNameParamter ,ArrayRootGuid );
}



