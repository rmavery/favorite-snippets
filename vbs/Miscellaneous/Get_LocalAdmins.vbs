'//Option Explicit
'//Connect to remove computers and create a report of the local admins on each computer.  
'//It writes it to a local file @ CURRENT_DIRECTORY\LocalAdminsReport.csv and then emails it to the 'str
sExecutable = LCase(Mid(Wscript.FullName, InstrRev(Wscript.FullName,"\")+1)) 
If sExecutable <> "cscript.exe" Then 
  Set oShell = CreateObject("wscript.shell") 
  oShell.Run "cscript.exe """ & Wscript.ScriptFullName & """" 
  Wscript.Quit 
End If

Dim lngBias : lngBias = getBias 

Dim ADRoot : ADRoot = "DC=DOMDOMAIN,DC=LOCAL"
Dim SMTPServer : SMTPServer = "mailbox.domdomain.local"
Dim strSender : strSender = "fromemail@domdomain.com"
Dim strRecipient : strRecipient = "toemail@domdomain.com"
'Dim strREcipient : strRecipient = InputBox("Enter the email address for report or" & vbcrlf & "press cancel to just generate a local file.", "Input required") 
Const ForAppending = 8
Dim WshNetwork : Set WshNetwork = WScript.CreateObject("WScript.Network")
Dim objFSO : Set objFSO = CreateObject("Scripting.FileSystemObject")
Dim WshShell : Set WshShell = CreateObject("WScript.Shell")
Dim strFileName : strFileName =  CurDir & "\LocalAdminsReport.csv"

Dim stMsg '\\Used to capture error messages and pass on for logging etc. 
Dim counter  '\\Counts the number of computers.  
Dim failedPings 
 
If objFSO.FileExists(strFileName) Then
    objFSO.DeleteFile(strFileName)
End If
 
Dim objFile : Set objFile = objFSO.OpenTextFile(strFileName, ForAppending, True)
objFile.WriteLine "ComputerName,Administrators,ComputerLastLogon,ComputerDescription"
 
GetLocalAdmins 
 
msgbox Counter & " computers were counted." & vbcrlf & "See " & strFileName & " for details."
'If strRecipient = False then
    'user didn't enter an email address
'    wscript.quit
'Else
'    SendEmail
'End If
   
'//=============================================================================================================
Private Function GetLocalAdmins
    Const ADS_SCOPE_SUBTREE = 2
    Dim objConnection : Set objConnection = CreateObject("ADODB.Connection")
    Dim objCommand : Set objCommand =   CreateObject("ADODB.Command")
    objConnection.Provider = "ADsDSOObject"
    objConnection.Open "Active Directory Provider"
 
    Set objCommand.ActiveConnection = objConnection
    objCommand.CommandText = "Select Name, LastLogon, LastLogonTimeStamp, description from 'LDAP://" & ADRoot & "' " & "Where objectClass='computer'" 
    objCommand.Properties("Page Size") = 1000
    objCommand.Properties("Searchscope") = ADS_SCOPE_SUBTREE 
    Dim objRecordSet : Set objRecordSet = objCommand.Execute
    
    Dim iTest
    
    Dim name 
    Dim PingFlag 
    Dim objDate
    Dim lastLogon
    Dim descArray, description

    objRecordSet.MoveFirst
 
    Do Until objRecordSet.EOF
        name = objRecordSet.Fields("Name").Value
        descArray = objRecordSet.Fields("description").Value
        
        On Error Resume Next 
        iTest = UBound(descArray) 
        If Err.Number <> 0 Then 
        	description = "" 
        Else 
        	description = descArray(0)
        End If 
        On Error Goto 0 

        
        On Error Resume Next 
	        Set objDate = objRecordSet.Fields("LastLogon").Value 
	        If Err.Number <> 0 Then 
	        	lastLogon = #1/1/1900 12:00 AM#
	        Else
	        	lastLogon = TimeStampToDate(objDate)
	        End If 
        On Error Goto 0 
        '//Second Chance.  If "LastLogon" is old, check LastLogonTimeStamp. 
        If DateDiff("d", lastLogon, Now()) > 8 Then 
        	On Error Resume Next 
		        Set objDate = objRecordSet.Fields("LastLogonTimeStamp").Value 
		        If Err.Number <> 0 Then 
		        	lastLogon = #1/1/1601#
		        Else
		        	lastLogon = TimeStampToDate(objDate)
		        End If 
	        On Error Goto 0 
        End If 

        PingFlag = Not CBool(WshShell.run("ping -w 500 -n 1 " & name,0,True))
        If PINGFlag = False Then
        	failedPings = failedPings + 1 
            WScript.Echo failedPings & " - Failed Ping : " & name & " => LastLogon = " & LastLogon
            objFile.WriteLine name & ",Did Not Ping," & lastLogon & "," & description
            Else
                'Get the local administrators
                counter = counter + 1 
                WScript.Echo Counter & " - Processing: " & name & " => LastLogon = " & LastLogon
                On Error Resume Next 
	                Set objGroup = GetObject("WinNT://" & name & "/Administrators,group")
	                If Err.Number <> 0 Then 
	                	stMsg = Err.Description
	                	objFile.WriteLine name & "," &  Err.Description
	                Else 
		                For Each objMember In objGroup.Members
		                    If objMember.Name <> "Administrator" and objMember.Name <> "Domain Admins" Then
		                        objFile.WriteLine name & "," & (objMember.Name) 
		                    End If
		                Next                	
	                End If
                On Error Goto 0  
                	
        End If
        objRecordSet.MoveNext
    Loop
End Function
'//=============================================================================================================

Function CurDir 

	Dim sFullPath : sFullPath = WScript.ScriptFullName
	Dim sRev : sRev = StrReverse(sFullPath) 
	Dim iLastSlash : iLastSlash = InStr(1, sRev, "\", vbTextCompare) 
	Dim ScriptPath : ScriptPath = Left(sFullPath, Len(sFullPath) - iLastSlash) 
	CurDir = ScriptPath

End Function 

'//=============================================================================================================
Private Function SendEmail
    Dim objEmail : Set objEmail = CreateObject("CDO.Message")
    objEmail.From = strSender
    objEmail.To = strRecipient
    objEmail.Subject = "Local Admins Account"
    objEmail.Textbody = Counter & " computers were counted. See attached log file for details."
    objEmail.AddAttachment(strFileName)
    objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
    objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = SMTPServer
    objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
    objEmail.Configuration.Fields.Update
    objEmail.Send
End Function
'//=============================================================================
Function TimeStampToDate(objDate)
    ' Convert Integer8 value to date/time in current time zone.

    lngHigh = objDate.HighPart
    lngLow = objDate.LowPart
    If (lngLow < 0) Then
        lngHigh = lngHigh + 1
    End If
    If (lngHigh = 0) And (lngLow = 0) Then
        dtmDate = #1/1/1601#
    Else
        dtmDate = #1/1/1601# + (((lngHigh * (2 ^ 32)) _
            + lngLow)/600000000 - lngBias)/1440
    End If

	TimeStampToDate =  dtmDate       
	

End Function 
'//=============================================================================
Function getBias()

	Dim lng
	Dim objShell : Set objShell = CreateObject("Wscript.Shell")
	Dim lngBiasKey : lngBiasKey = objShell.RegRead("HKLM\System\CurrentControlSet\Control\TimeZoneInformation\ActiveTimeBias")
	If (UCase(TypeName(lngBiasKey)) = "LONG") Then
	    lng = lngBiasKey
	ElseIf (UCase(TypeName(lngBiasKey)) = "VARIANT()") Then
	    lng = 0
	    For k = 0 To UBound(lngBiasKey)
	        lng = lng + (lngBiasKey(k) * 256^k)
	    Next
	End If
	Set objShell = Nothing
	getBias = lng 
	
End Function 