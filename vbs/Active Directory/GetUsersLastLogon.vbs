
Option Explicit

Const c_ENABLED = 2

Dim strTempOutput
Dim i
Dim strOutput
Dim dtmDate 
Dim bEnabled 
Dim stTemp

Dim intDays : intDays = 90
Dim bShowEnabledOnly : bShowEnabledOnly = True 
Dim stSplitter : stSplitter = vbTab 

Dim objShell : Set objShell = CreateObject("Wscript.Shell")
Dim stTempDir : stTempDir = objShell.ExpandEnvironmentStrings("%TEMP%" & "\")
Dim stFileName : stFileName = stTempDir & "Results.txt"
' Create File System objects for writing text file. 
Dim oFSO : Set oFSO = CreateObject("Scripting.FileSystemObject")
Dim oOutFile : Set oOutFile = oFSO.OpenTextFile(stFileName, 2, True)

Dim intBias : intBias = TimeZoneBias
Dim arrAttributes : arrAttributes = Array("lastLogonTimeStamp","SamAccountName", "displayname","mail","userAccountControl", "DistinguishedName") 
Dim adoCommand : Set adoCommand = CreateObject("ADODB.Command")
Dim adoConnection : Set adoConnection = CreateObject("ADODB.Connection")

adoConnection.Provider = "ADsDSOObject"
adoConnection.Open "Active Directory Provider"
adoCommand.ActiveConnection = adoConnection

Dim objRootDSE : Set objRootDSE = GetObject("LDAP://RootDSE")
Dim strBase : strBase = "<LDAP://" & objRootDSE.Get("defaultNamingContext") & ">"
Set objRootDSE = Nothing

Dim strFilter : strFilter = "(&(objectCategory=person)(objectClass=user))"
Dim strAttributes : strAttributes = Join(arrAttributes,",")
'//oOutFile.WriteLine  "The following accounts are enabled, and have not been used in over 90 days..." 
oOutFile.WriteLine  Join(arrAttributes,stSplitter) 
Dim strQuery : strQuery = strBase & ";" & strFilter & ";" & strAttributes & ";subtree"
adoCommand.CommandText = strQuery
adoCommand.Properties("Page Size") = 100
adoCommand.Properties("Timeout") = 30
adoCommand.Properties("Cache Results") = False
Dim adoRecordset : Set adoRecordset = adoCommand.Execute
Do Until adoRecordset.EOF
	On Error Resume Next
	strTempOutput = ""
	
	
	For i = 1 To Ubound(arrAttributes)
		strTempOutput =  strTempOutput & stSplitter & adoRecordset.Fields(arrAttributes(i)).Value
		strOutput = Mid(Ltrim(strTempOutput),2)
	Next
	Dim objDate : Set objDate = adoRecordset.Fields(arrAttributes(0)).Value
	If (Err.Number <> 0) Then
        dtmDate = #1/1/1900  12:00:00#
    Else
		dtmDate = ((((objDate.Highpart * (2^32)) + objDate.LowPart)/(600000000 - intBias))/1440) + #1/1/1601#
	End If
	Set objDate = Nothing
	
	'//Check the UAC to see if the account is currently enabled.
	'//WScript.Echo adoRecordSet.Fields("userAccountControl").Value
	
	
	'//bEnabled = CBool(NOT(CLng(adoRecordSet.Fields("userAccountControl").Value)  &  c_ENABLED))
	bEnabled = (adoRecordSet.Fields("userAccountControl").Value  And c_ENABLED) = 0 

' 	If bEnabled = False Then 
' 		WScript.Echo "Disabled: " & strOutput 
' 	Else 
' 		WScript.Echo "Enabled: " & strOutput 
' 	End If 
	If bShowEnabledOnly = False Then 
		'//Mark all as enabled so they'll show up.   
		bEnabled = True
	End If 
	
	If DateDiff("d", dtmDate, Now) > intDays And bEnabled  Then  
		stTemp = DateDiff("d", dtmDate, Now)
		'//WScript.echo stTemp & " - " & bEnabled & " - " & adoRecordset.Fields("SamAccountName").Value
		oOutFile.WriteLine dtmDate & stSplitter & strOutput
	End If 
	adoRecordset.MoveNext
Loop
adoRecordset.Close
adoConnection.Close
Set adoRecordset = Nothing
Set adoConnection = Nothing
Set adoCommand = Nothing

oOutFile.Close

objShell.Run ("Excel.exe " & stFileName)


'// ======================== TimeZoneBias ========================
Function TimeZoneBias

	Dim strComputer : strComputer = "."
	Dim objWMIService : Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
	Dim colTimeZone : Set colTimeZone = objWMIService.ExecQuery("Select * from Win32_TimeZone")
	Dim objTimeZone
	For Each objTimeZone in colTimeZone
		TimeZoneBias = objTimeZone.Bias
	Next
	Set colTimeZone = Nothing
	Set objWMIService = Nothing
End Function
