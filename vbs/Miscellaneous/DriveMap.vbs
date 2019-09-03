' DriveMap.vbs
' Map a network drive 

' Usage
'    cscript DriveMap.vbs <drive> <fileshare> //NoLogo
'    cscript DriveMap.vbs H: \\MyServer\MyShare //NoLogo
'
' This script will remove any existing drive map to the same drive letter
' including persistent or remembered connections (Q303209)



Option Explicit

Call MapDrive( "k:", "\\HEBE\DOWNLOAD" )


Sub MapDrive(stDrive, stFileShare) 

'stDrive = "H:" 
'stFileShare = "\\UPSGRWDN9\IDDB$"  

Dim objNetwork, objDrives, objReg, i
Dim strLocalDrive, strRemoteShare, strShareConnected, strMessage
Dim bolFoundExisting, bolFoundRemembered
Const HKCU = &H80000001

strLocalDrive = UCase(Left(stDrive, 2))
strRemoteShare = stFileShare
bolFoundExisting = False

' Check parameters passed make sense
If Right(strLocalDrive, 1) <> ":" OR Left(strRemoteShare, 2) <> "\\" Then
 wscript.echo "Usage: cscript DriveMap.vbs <drive> <fileshare> //NoLogo"
  WScript.Quit(1)
End If

wscript.echo " - Mapping: " + strLocalDrive + " to " + strRemoteShare

Set objNetwork = WScript.CreateObject("WScript.Network")

' Loop through the network drive connections and disconnect any that match strLocalDrive
Set objDrives = objNetwork.EnumNetworkDrives
If objDrives.Count > 0 Then
  For i = 0 To objDrives.Count-1 Step 2
    If objDrives.Item(i) = strLocalDrive Then
      strShareConnected = objDrives.Item(i+1)
      objNetwork.RemoveNetworkDrive strLocalDrive, True, True
      i=objDrives.Count-1
      bolFoundExisting = True
    End If
  Next
End If

' If there's a remembered location (persistent mapping) delete the associated HKCU registry key
If bolFoundExisting <> True Then
  Set objReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv")
  objReg.GetStringValue HKCU, "Network\" & Left(strLocalDrive, 1), "RemotePath", strShareConnected
  If strShareConnected <> "" Then
    objReg.DeleteKey HKCU, "Network\" & Left(strLocalDrive, 1)
    Set objReg = Nothing
    bolFoundRemembered = True
  End If
End If

'Now actually do the drive map (not persistent)
Err.Clear
On Error Resume Next
objNetwork.MapNetworkDrive strLocalDrive, strRemoteShare, False

	'Error traps
	If Err <> 0 Then
	  Select Case Err.Number
	    Case -2147023694
	      'Persistent connection so try a second time
	      objNetwork.RemoveNetworkDrive strLocalDrive, True, True
	      objNetwork.MapNetworkDrive strLocalDrive, strRemoteShare, False
	      WScript.Echo "Second attempt to map drive " & strLocalDrive & " to " & strRemoteShare
	    Case Else
	      WScript.Echo Err.Description
	      WScript.Echo " - ERROR: Failed to map drive " & strLocalDrive & " to " & strRemoteShare
	  End Select
	  Err.Clear
	End If

On Error GoTo 0

Set objNetwork = Nothing

End Sub 





