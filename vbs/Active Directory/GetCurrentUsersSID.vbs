Option Explicit

Dim stUserAndDomain
Dim strUsername, strDomain
Dim arUserDomain
Dim wshShell  

Set wshShell = CreateObject("WScript.Shell")
strUsername = wshShell.ExpandEnvironmentStrings("%USERNAME%")
strDomain = wshShell.ExpandEnvironmentStrings("%USERDOMAIN%")

stUserAndDomain = InputBox("Username and Domain e.g, 'Bucees\Ralph' to query", "Please Enter Domain\Username", strDomain & "\" & strUsername)

If stUserAndDomain <> strDomain & "\" & strUsername Then 
	arUserDomain = Split(stUserAndDomain, "\") 
	If UBound(arUserDomain) < 1 Then 
		Err.Raise 1736, "GetSID", stUserAndDomain & " is not a valid 'USER\DOMAIN'" 
		'WScript.Echo stUserAndDomain & " is not a valid 'USER\DOMAIN'" 
		WScript.Quit
	Else 
		strDomain = arUserDomain(0)
		strUsername = arUserDomain(1)
	End If 
End If 

'use the user/domain information to retrieve the SID of the user and print it to the screen
'WScript.Echo getSid(strUsername, strDomain)
stUserAndDomain = InputBox("Sid for user " & stUserAndDomain , "Your SID sir", getSid(strUsername, strDomain) ) 

Private Function getSid(stUser, stDomain)

Dim strComputer, objWMIService, objAccount, strTemp 

	strComputer = "."
	Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
	On Error Resume Next 
	Set objAccount = objWMIService.Get("Win32_UserAccount.Name='" & stUser & "',Domain='" & stDomain & "'")
	strTemp = objAccount.SID
	If Err.Number <> 0 Then 
		strTemp = "SID was NOT found for " &  strDomain & "\" & strUsername
	End If
	On Error Goto 0  
	getSid = strTemp 
End Function

