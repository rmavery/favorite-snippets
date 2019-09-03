' DriveType2.vbs
' Sample VBScript to discover the drive type with WMI
' Author Guy Thomas http://computerperformance.co.uk/
' Version 1.6 - November 2005
' -------------------------------------------------------------' 
Option Explicit
Dim objWMIService, objItem, colItems, strComputer
Dim strDriveType, strDiskSize
'//On Error Resume Next



strComputer = WScript.Arguments(0) 

Set objWMIService = GetObject _
("winmgmts:\\" & strComputer & "\root\cimv2")
Set colItems = objWMIService.ExecQuery _
("Select * from Win32_LogicalDisk")

For Each objItem in colItems
Select Case objItem.DriveType
Case 1 strDriveType = "Drive could not be determined."
Case 2 strDriveType = "Removable Drive"
Case 3 strDriveType = "Local hard disk."
Case 4 strDriveType = "Network disk." 
Case 5 strDriveType = "Compact disk (CD)" 
Case 6 strDriveType = "RAM disk." 
Case Else strDriveType = "Drive type Problem."
End Select

If objItem.DriveType =2 Then 
	strDiskSize = Int(objItem.Size /1048576) & " MB " 	
Else
	strDiskSize = Int(objItem.Size /1073741824) & " GB " 
End If 

WScript.Echo "Computer: " & objItem.SystemName & VbCr & _ 
" ==================================" & VbCr & _ 
"Drive Letter: " & objItem.Name & vbCr & _ 
"Drive Type : " & strDriveType & " " & strDiskSize & vbCr & _
"Free Space: " & Int(objItem.FreeSpace /1073741824) & _
" GB" & vbCr & _ 
"" 
Next

WSCript.Quit

' End of Sample DiskDrive VBScript
