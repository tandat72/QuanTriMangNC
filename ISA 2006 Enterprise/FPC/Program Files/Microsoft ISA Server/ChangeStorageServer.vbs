'******************************************************************************
'*
'* Copyright (c) Microsoft Corporation. All rights reserved.
'*
'* Module Name:    ChangeStorageServer.vbs
'*
'* Abstract:       Enables an ISA Server 2004 Enterprise Edition administrator
'*                 to change the Configuration Storage server when the current
'*                 one is no longer accessible from the ISA Server computers.
'*
'******************************************************************************

'******************************************************************************
' Begin localization
'******************************************************************************
const L_Prefix_ErrorMessage                      = "ERROR: "
const L_ConnectLocalStorage_ErrorMessage         = "Unable to connect to local storage"
const L_CreateObject_ErrorMessage                = "Unable to create object "
const L_GetArrayObject_ErrorMessage              = "Unable to get Array object"
const L_GetServerObject_ErrorMessage             = "Unable to get Server object "
const L_GetStorageServerObject_ErrorMessage      = "Unable to get Configuration Storage server object "
const L_CannotSaveNewServer_ErrorMessage         = "Cannot save new server"
const L_StopRemoteAccess_ErrorMessage            = "Cannot stop Remote Access Service"
const L_StopFirewall_ErrorMessage                = "Cannot stop Firewall service"
const L_StopJobScheduler_ErrorMessage            = "Cannot stop Job Scheduler service"
const L_StopControl_ErrorMessage                 = "Cannot stop Control service"
const L_StartFirewall_ErrorMessage               = "Cannot start Firewall service"
const L_StartJobScheduler_ErrorMessage           = "Cannot start Job Scheduler service"
const L_StartControl_ErrorMessage                = "Cannot start Control service"
const L_WriteRegistry_ErrorMessage               = "Cannot write to registry"
const L_ReadRegistry_ErrorMessage                = "Cannot read from registry"

const L_WarningPrefix_Text                       = "WARNING: "
const L_StorageConnectivityWarning_Text          = "The new Configuration Storage server could not be accessed. Make sure that the server is running and that the server name was typed correctly."

const L_MustUseCscript_Text               = "This script should be executed from the command prompt using CSCRIPT.EXE."
const L_AuthWindows_Text                  = "Windows authentication"
const L_AuthCertificate_Text              = "Certificate authentication"
const L_WrongAuthType_Text                = "Wrong authentication type"
const L_ChangingServer_Text               = "Changing Configuration Storage server to: "
const L_ConnectLocal_Text                 = "Connecting to local storage"
const L_CreatingObjects_Text              = "Creating ISA Admin objects"
const L_StopRemoteAccess_Text             = "Stopping Remote Access service..."
const L_StopFirewall_Text                 = "Stopping Firewall service..."
const L_StopJobScheduler_Text             = "Stopping Job Scheduler service..."
const L_StopControl_Text                  = "Stopping Control service..."
const L_StartFirewall_Text                = "Starting Firewall service..."
const L_StartJobScheduler_Text            = "Starting Job Scheduler service..."
const L_StartControl_Text                 = "Starting Control service..."
const L_ServiceStopSuccess_Text           = "Service stopped successfully"
const L_ServiceAlreadyStopped_Text        = "Service is already stopped"
const L_ServiceStartSuccess_Text          = "Service started successfully"
const L_ServiceAlreadyStarted_Text        = "Service is already started"
const L_CurrentRegistryStorageServer_Text = "Current effective Configuration Storage server: "
const L_CurrentStorageServer_Text         = "Current Configuration Storage server: "
const L_CurrentAuthType_Text              = "Current Configuration Storage server authentication: "
const L_ChangedServer_Text                = "Changed Configuration Storage server to: "
const L_ScriptDone_Text                   = "Script done"

const L_Usage_Text                        = "Usage:"
const L_UsageServer_Text                 = "New Configuration Storage server name"
const L_UsageType_Text                   = "Authentication type, can be 'windows' or 'certificate'"
const L_UsageServerParamName_Text            = "server"
const L_UsageTypeParamName_Text              = "type"




'******************************************************************************
' End localization
'******************************************************************************


'******************************************************************************
' Constants
'******************************************************************************

' Script type
CONST CONST_CSCRIPT              = 2

' enum: FpcConfigurationStorageServerConnectionType
const AUTH_WINDOWS               = 0
const AUTH_CERTIFICATE           = 1

' Service status constants
Const SERVICE_STOPPED            = 1
Const SERVICE_START_PENDING      = 2
Const SERVICE_STOP_PENDING       = 3
Const SERVICE_RUNNING            = 4
Const SERVICE_CONTINUE_PENDING   = 5
Const SERVICE_PAUSE_PENDING      = 6
Const SERVICE_PAUSED             = 7
Const SERVICE_ERROR              = 8

const WAIT_FOR_SERVICE           = 1000

const REG_STORAGE_SERVER         = "HKLM\SOFTWARE\Microsoft\Fpc\ADAMStorageServer"
const CONTROL_SERVICE            = "isactrl"

'******************************************************************************
' Begin main script
'******************************************************************************

on error resume next
Err.Clear

' create the object for commom module
Set objCmdLib = CreateObject("Microsoft.CmdLib")

' check if the commom module(CmdLib.wsc) is not registered
CheckError L_CreateObject_ErrorMessage & "Microsoft.CmdLib"

' set the scripting host to WScript
Set objCmdLib.ScriptingHost = WScript.Application

' Check whether the script is run using CScript
If CInt(objCmdLib.checkScript) <> CONST_CSCRIPT Then
    WScript.Echo L_MustUseCscript_Text
    WScript.Quit(EXIT_UNEXPECTED)
End If

'Validate script arguments
If Wscript.Arguments.Count = 0 Then
   usage=true
ElseIf Wscript.Arguments.Count <> 2 Or Wscript.Arguments(0) = "/?" Then
   usage=true
Else
   usage=false
End IF

' Display usage
If usage Then
   Wscript.Echo L_Usage_Text
   Wscript.Echo
   Wscript.Echo "    " & Wscript.ScriptName & " <" & L_UsageServerParamName_Text & "> <" & L_UsageTypeParamName_Text & ">"
   Wscript.Echo
   Wscript.Echo "    " & L_UsageServerParamName_Text & "   " & L_UsageServer_Text
   Wscript.Echo "    " & L_UsageTypeParamName_Text & "     " & L_UsageType_Text
   Wscript.Quit(EXIT_UNEXPECTED)
End If

' First argument: server name
NewServer=Wscript.Arguments(0)

' Second argument: authentication type
if Wscript.Arguments(1) = "windows" Then
   NewServerAuthType=AUTH_WINDOWS
ElseIf Wscript.Arguments(1) = "certificate" Then
   NewServerAuthType=AUTH_CERTIFICATE
Else
   Wscript.Echo L_Prefix_ErrorMessage & L_WrongAuthType_Text
   Wscript.Quit(EXIT_UNEXPECTED)
End If

' Strat doing what we're here for
Trace L_ChangingServer_Text & NewServer

' Create root object
Trace L_CreatingObjects_Text
Set objFpcRoot=CreateObject("FPC.Root")
CheckError L_CreateObject_ErrorMessage & "FPC.Root"

'Connect root to local storage
Trace L_ConnectLocal_Text
objFpcRoot.ConnectToLocalStorage
CheckError L_ConnectLocalStorage_ErrorMessage

'Create rest of the objects
Set objFpcArray=objFpcRoot.GetContainingArray
CheckError L_GetArrayObject_ErrorMessage
Set objFpcServer=objFpcRoot.GetContainingServer
CheckError L_GetServerObject_ErrorMessage
Set objFpcStorageServer=objFpcArray.ConfigurationStorageServerConnection
CheckError L_GetStorageServerObject_ErrorMessage

' Stop services
If objFpcServer.RemoteAccessServiceStatus Then
    Trace L_StopRemoteAccess_Text
    objFpcServer.StopRemoteAccessService
    CheckError L_StopRemoteAccess_ErrorMessage
    Trace L_ServiceStopSuccess_Text
End If

If objFpcServer.FirewallServiceStatus Then
      Trace L_StopFirewall_Text
      objFpcServer.StopFirewallService
      CheckError L_StopFirewall_ErrorMessage
      Trace L_ServiceStopSuccess_Text
End If

If objFpcServer.JobSchedulerServiceStatus Then
      Trace L_StopJobScheduler_Text
      objFpcServer.StopJobSchedulerService
      CheckError L_StopJobScheduler_ErrorMessage
      Trace L_ServiceStopSuccess_Text
End If

' Stop IsaCtrl service
Trace L_StopControl_Text
StopService(CONTROL_SERVICE)
CheckError L_StopControl_ErrorMessage

' Print the current configuration
Trace L_CurrentStorageServer_Text & objFpcStorageServer.PrimaryConfigurationStorageServer

If objFpcStorageServer.ConfigurationStorageServerConnectionType = AUTH_WINDOWS Then
   strAuthType=L_AuthWindows_Text
Else
   strAuthType=L_AuthCertificate_Text
End If
Trace L_CurrentAuthType_Text & strAuthType

' Change the storage server in the local storage
objFpcStorageServer.PrimaryConfigurationStorageServer=NewServer
objFpcStorageServer.ConfigurationStorageServerConnectionType=NewServerAuthType
objFpcStorageServer.Save
CheckError L_CannotSaveNewServer_ErrorMessage

' Change storage server in registry
Set WshShell = WScript.CreateObject("WScript.Shell")
Trace L_CurrentRegistryStorageServer_Text & WshShell.RegRead(REG_STORAGE_SERVER)
CheckError L_ReadRegistry_ErrorMessage
WshShell.RegWrite REG_STORAGE_SERVER, NewServer
CheckError L_WriteRegistry_ErrorMessage

' Finished
Trace L_ChangedServer_Text & NewServer & "(" & strAuthType & ")"

' Restart services
Trace L_StartControl_Text
StartService(CONTROL_SERVICE)
CheckError L_StartControl_ErrorMessage

Trace L_StartFirewall_Text
objFpcServer.StartFirewallService
CheckError L_StartFirewall_ErrorMessage
Trace L_ServiceStartSuccess_Text

Trace L_StartJobScheduler_Text
objFpcServer.StartJobSchedulerService
CheckError L_StartJobScheduler_ErrorMessage
Trace L_ServiceStartSuccess_Text

' Check if the new storage server is accisible and warn if it isn't
CheckStorageConnectivity NewServer

Trace L_ScriptDone_Text

' ****************************************
' StartService() subroutine
' Start a service
' ****************************************
Sub StartService(strService)
   on error goto 0

   Set objComputer = GetObject("WinNT://.,computer")
   Set objService = objComputer.GetObject("Service", strService)

   If (objService.Status <> SERVICE_RUNNING) Then
      objService.Start
      Wscript.Sleep WAIT_FOR_SERVICE
      While objService.Status <> SERVICE_RUNNING:
         Wscript.Sleep WAIT_FOR_SERVICE
      Wend
      Trace L_ServiceStartSuccess_Text
   Else
      Trace L_ServiceAlreadyStarted_Text
   End If

End Sub


' ****************************************
' StopService() subroutine
' Stop a service
' ****************************************
Sub StopService(strService)
   on error goto 0
   Set objComputer = GetObject("WinNT://.,computer")
   Set objService = objComputer.GetObject("Service", strService)

   If (objService.Status <> SERVICE_STOPPED) Then
      objService.Stop
      Do
         Wscript.Sleep WAIT_FOR_SERVICE
         on error resume next
         Status = objService.Status
         ErrorNum = Err.Number
         on error goto 0
      Loop Until ErrorNum = 0 AND Status = SERVICE_STOPPED
      Trace L_ServiceStopSuccess_Text
   Else
      Trace L_ServiceAlreadyStopped_Text
   End If

End Sub


sub CheckStorageConnectivity(ServerName)
   ISA_STORAGE_PORT_NUMBER = "2171"

   ConnectionString = "LDAP://" & ServerName & ":" & ISA_STORAGE_PORT_NUMBER & "/CN=Array-root,CN=FPC2"

   on error resume next
   Err.Clear

   Set FpcArrayRoot = GetObject(ConnectionString)

   if Err.Number then
      WScript.Echo L_WarningPrefix_Text & L_StorageConnectivityWarning_Text
      Err.Clear
   end if

end sub


' ****************************************
' Trace() subroutine
' outputs time and trace information
' ****************************************
Sub Trace(strText)
  WScript.Echo Now & " : " & strText
End Sub


' ****************************************
' CheckError() subroutine
' Checks error code
' ****************************************
Sub CheckError(strErrorText)

  if Err.Number then
     WScript.Echo L_Prefix_ErrorMessage & strErrorText
     WScript.Echo "       0x" & Hex(Err.Number) & " - " & Err.Description
     WScript.Quit(EXIT_METHOD_FAIL)
  end if

End Sub

