'//This first section will check if it's running under the 'cscript' context. If not
'//it will call itself again using cscript.    
Dim oShell
Dim sExecutable : sExecutable = LCase(Mid(Wscript.FullName, InstrRev(Wscript.FullName,"\")+1)) 
If sExecutable <> "cscript.exe" Then 
  Set oShell = CreateObject("wscript.shell") 
  oShell.Run "cscript.exe /nologo """ & Wscript.ScriptFullName & """" 
  Wscript.Quit 
End If

Wscript.Echo getExtIP

'//Obtain External IP from web service. 
Function getExtIP()

	Dim stResponse
	Dim o
	Set o = CreateObject("Msxml2.ServerXMLHTTP.6.0") 
	'//These have to rely on an external service to return your IP.  
	o.open "GET", "https://api.ipify.org/", False
	o.send
	stResponse = o.responseText
	getExtIP = stResponse

End Function 
