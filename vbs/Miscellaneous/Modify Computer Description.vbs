'Prompts for computer name, then retrieves current computer description
' Populates inputbox with description, allowing you to overwrite the current
' setting.  XP, 2003 and below require a restart of the computer or server
' service to be restarted in order for the new name to take.
'
'Windows Vista/7 seems to take the change immediately.
'
'You must have remote registry and WMI permissions to make changes.
'
'The script will truncate to the first 48 characters of the description
' given in the inputbox.
'
'Author: Rob.Dunn (spiceworks ID)
'www.theitoolbox.com

Dim strDescription, strComputer, reg, objRegistry
Dim ret, msg, ValueName 

Const HKLM = &H80000002
strComputer = inputbox("Input a computer name.")


if strComputer = "" then wscript.quit

on error resume next

Set reg = GetObject("winmgmts:\\" & strComputer & "\root\default:StdRegProv")

if err.number <> 0 then 
  msgbox "There was an error while attempting to connect to " & strComputer & "'s WMI database.  Is the computer powered on?  If so, there may be an issue with your permissions.",16,"Error connecting to '" & strComputer & "'" 
  wscript.quit  
end if

on error goto 0 

Set objRegistry = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2").ExecQuery("Select Description FROM Win32_OperatingSystem")


For Each object In objRegistry
	strDescription = object.Description 
Next 

value = inputbox("Input a computer description for '" & strComputer & "':","Enter a new description",strDescription)

If value = strDescription then wscript.quit

key = "SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
ValueName = "srvcomment"

If Len(Value) > 48 Then Value = Left(Value, 48)
ret = reg.SetStringValue(HKLM, key, ValueName, value)

if ret <> 0 then msgbox "Remote update failed."
