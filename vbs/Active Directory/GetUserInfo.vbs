'========================================================================== 
'
' NAME:   GetUserInfo.vbs 
'
' AUTHOR: Ralph M Avery
' DATE  : 2/16/11 
'
' COMMENT:  This is a pretty basic script.   
'			It creates a report from AD on a user based on the LANID.   
'			(It's like Net User xxxx /domain) except it's a little simpler, 
'			it dumps it to a text file, and it doesn't truncate the group membership.   
'			(Groups can be copied and pasted into a spreadsheet)  

'			Double click the script.   An input box pops up asking for a LAN ID.  
'			You enter the LAN ID and it generates a report for that user 
'			(based on the domain you're logged into at the time) 
Option Explicit


Const ADS_UF_PASSWD_CANT_CHANGE = &H40
Const ADS_UF_DONT_EXPIRE_PASSWD = &H10000

'Declare public variables
Dim oFSO 
Dim oOutFile
Dim oGroupList
Dim iDistinctGroups
Dim iTokenSize 
Dim GroupMaxLength : GroupMaxLength = 40 
'
'===========================================================================================================================

Main

Private Sub Main()

' Obtain local time zone bias from machine registry.
Dim lngBiasKey, objShell, k, lngBias, stTempDir, stFileName
Dim stInputMessage
Dim strUserID

Set objShell = CreateObject("Wscript.Shell")
stTempDir = objShell.ExpandEnvironmentStrings("%TEMP%" & "\")
stFileName = stTempDir & "Results.txt"

'Attempt to collect the time bias information from the users machine
'if it fails, capture the U.S. Central time bias 300
On Error Resume Next

    lngBiasKey = objShell.RegRead("HKLM\System\" _
      & "CurrentControlSet\Control\" _
      & "TimeZoneInformation\ActiveTimeBias")
    If UCase(TypeName(lngBiasKey)) = "LONG" Then
      lngBias = lngBiasKey
    ElseIf UCase(TypeName(lngBiasKey)) = "VARIANT()" Then
      lngBias = 0
      For k = 0 To UBound(lngBiasKey)
        lngBias = lngBias + (lngBiasKey(k) * 256 ^ k)
      Next
    End If
    
    If Err.Number = -2147024891 Then
        lngBiasKey = 300
        lngBias = 300
    End If

On Error GoTo 0

Dim oConnection, oCommand, oRoot, sDNSDomain
Dim strBase, strFilter, strScope, strQuery
Dim oResults, sAdsPath, oADObject, oGroup, i, stGroup, stDesc
Dim strAttributes1, strAttributes2, bLastLogonTimeStamp
Dim stThisDomain

Dim UserInfo, stThisUser
Dim bShowNested , bInclDescription


Set UserInfo = CreateObject("WScript.Network")
stThisUser = UserInfo.UserName

' AD Connection information

Set oConnection = CreateObject("ADODB.Connection")
Set oCommand = CreateObject("ADODB.Command")
oConnection.Provider = "ADsDSOObject"
oConnection.Open "Active Directory Provider"
Set oCommand.ActiveConnection = oConnection

Set oRoot = GetObject("LDAP://RootDSE")
sDNSDomain = oRoot.Get("DefaultNamingContext")
strBase = "<LDAP://" & sDNSDomain & ">"

' Create File System objects for writing text file. 
Set oFSO = CreateObject("Scripting.FileSystemObject")
Set oOutFile = oFSO.OpenTextFile(stFileName, 2, True)

stThisDomain =  UCase(Replace(Replace(Replace(sDNSDomain, "OU=", ""), ",DC=" , "."),"DC=", ""))

On Error Resume Next 

	stInputMessage = "Enter the Username e.g. '" & stThisUser & "'" & vbcrlf & _
				"===========================================" & vbcrlf & _
				"If you want extended group information add " & Chr(34) & _
				"+x" & Chr(34) & " to the username e.g. '" & stThisUser & " +x'" &  vbcrlf & _
				"===========================================" & vbcrlf & _
				"If you want to include group descriptions add " & Chr(34) & _
				"+d" & Chr(34) & " to the username e.g. '" & stThisUser & " +d'" &  vbcrlf & _
				"===========================================" & vbcrlf & _
				"This may take a bit longer to process."
				

	strUserID = InputBox(stInputMessage, "UserName", stThisUser )
	
	
	If Len(strUserID) < 1 Then 
		i =  MsgBox("Either the inputbox was empty," & vbcrlf & "or you pressed [Cancel]", 64, "Exiting")
		WScript.Quit
	End If 
	
	If Err.Number <> 0 Then 
		MsgBox Err.Number & vbcrlf & Err.Description
		WScript.Quit
	End If 
	
On Error goto 0 

			


If InStr(1, strUserID, " ", vbTextCompare) > 0 Then 
'//Check for switches +X = Expand Groups
	If InStr(1, strUserID, "+X", vbTextCompare) > 0 Then 
			bShowNested = True
	Else
		    bShowNested = False
	End If

'//Check for switches +D = Expand Groups
	If InStr(1, strUserID, "+D", vbTextCompare) > 0 Then 
			bInclDescription = True
	Else
		    bInclDescription = False
	End If
	
	
	strUserID = Trim(Left(strUserID, InStr(1, strUserID, " ", vbTextCompare))) 
End If 


If Len(strUserID) < 1 Then
    MsgBox "No Username Provided"
   	WScript.Quit
End If
'

strFilter = "(&(ObjectClass=user)(sAMAccountName=" & strUserID & "))"
 

strAttributes1 = "distinguishedName,pwdLastSet,userAccountControl, LastLogon"
strAttributes2 = "distinguishedName,pwdLastSet,userAccountControl, LastLogonTimestamp"
 
strScope = "subtree" '
 
oCommand.Properties("Page Size") = 100
oCommand.Properties("Timeout") = 60
oCommand.Properties("Searchscope") = 2
oCommand.Properties("Cache Results") = False

On Error Resume Next

strQuery = strBase & ";" & strFilter & ";" & strAttributes2 & ";" & strScope
oCommand.CommandText = strQuery
Set oResults = oCommand.Execute
bLastLogonTimeStamp = True

If Err.Number = -2147467259 Then
    strQuery = strBase & ";" & strFilter & ";" & strAttributes1 & ";" & strScope
    oCommand.CommandText = strQuery
    Set oResults = oCommand.Execute
    bLastLogonTimeStamp = False
    Err.clear	
End If

On Error goto 0 

On Error Resume Next 

  sAdsPath = oResults.Fields("DistinguishedName")
  
  If Err.Number = 3021 Then 
   		Call MsgBox("The ID '" & ucase(strUserID) & "' was not found." , vbCritical, "Not Found")
  		Err.Clear
  		WScript.Quit
  Elseif Err.Number <> 0 Then 
  		Call MsgBox (Err.Number & vbcrlf & Err.Description , vbcritical, "FATAL!")
  End If 
  
On Error Goto 0 

  'MsgBox "Token Size: " & Get_Tokens_size(sAdsPath)
  
If Err.Number = 3021 Then
    Dim iResult
    iResult = MsgBox("User Not Found in AD" & vbcrlf & _
    				sDNSDomain , vbCritical, "Not Found")
    WScript.quit
End If



  Set oADObject = GetObject("LDAP://" & sAdsPath)

'Set objRecordSet = objCommand.Execute
Dim blnPwdExpire, lngFlag, lngDate, dtmPwdLastSet, objDate, dtmLastLogonTimeStamp
Dim stAcctStatus

'Do Until oResults.EOF 

  lngFlag = oResults.Fields("userAccountControl")
  
  blnPwdExpire = True
  If (lngFlag And ADS_UF_PASSWD_CANT_CHANGE) <> 0 Then
    blnPwdExpire = False
  End If
  
  If (lngFlag And ADS_UF_DONT_EXPIRE_PASSWD) <> 0 Then
    blnPwdExpire = False
  End If
  
  'Get pwdLastSet (Long Int) and convert to readable date.
  lngDate = oResults.Fields("pwdLastSet")
  Set objDate = lngDate
  dtmPwdLastSet = Integer8Date(objDate, lngBias)

  
    If bLastLogonTimeStamp Then
    'Get LastLogonTimeStamp (Long Int) and convert to a readable date.
        lngDate = oResults.Fields("LastLogonTimeStamp")
        Set objDate = lngDate
        dtmLastLogonTimeStamp = Integer8Date(objDate, lngBias)
    Else
        lngDate = oResults.Fields("LastLogon")
        Set objDate = lngDate
        dtmLastLogonTimeStamp = Integer8Date(objDate, lngBias)
        oOutFile.WriteLine "*************************************************************"
        oOutFile.WriteLine "The " & Chr(34) & "Last Logon" & Chr(34) & " was obtained from a depreciated attribute." & vbCrLf & _
                                     "This value will only be correct if the user last logged onto" & vbCrLf & _
                                     "the same domain controller that provided the value."
         oOutFile.WriteLine "*************************************************************"
         oOutFile.WriteLine ""
    End If
  
  'Convert boolean value of "AccountDisabled" for use in the report
  If oADObject.AccountDisabled Then
    stAcctStatus = "Disabled"
  Else
    stAcctStatus = "Active"
  End If
  
  On Error Resume Next 
  
  'Get the Account Expiration (Convert if necessary for readability
  Dim dtAcctExpires

  
  dtAcctExpires = oADObject.AccountExpirationDate
    
  If Err.Number = -2147467259 Or CDate(dtAcctExpires) = CDate("1/1/1970") Then
        dtAcctExpires = "NEVER"
  End If

On Error GoTo 0

iTokenSize = Get_Tokens_size(sAdsPath)


 oOutFile.WriteLine "============================================================="
 oOutFile.WriteLine "Report For : " & oADObject.distinguishedName
 oOutFile.WriteLine "Tokensize  : " & iTokenSize
 oOutFile.WriteLine "============================================================="
 oOutFile.WriteLine ""
 oOutFile.WriteLine "User name                  " & vbTab & vbTab & oADObject.sAMAccountName
 oOutFile.WriteLine "Full Name                  " & vbTab & vbTab & oADObject.cn
 oOutFile.WriteLine "Comment                    " & vbTab & vbTab & oADObject.Description
 oOutFile.WriteLine "Account Status             " & vbTab & vbTab & stAcctStatus
 oOutFile.WriteLine "Last Logon                 " & vbTab & vbTab & dtmLastLogonTimeStamp
 
 oOutFile.WriteLine "Account expires            " & vbTab & vbTab & dtAcctExpires
 oOutFile.WriteLine "Password Expires           " & vbTab & vbTab & blnPwdExpire
 oOutFile.WriteLine "Password last set          " & vbTab & vbTab & dtmPwdLastSet
 oOutFile.WriteLine "When Created               " & vbTab & vbTab & oADObject.WhenCreated
 oOutFile.WriteLine "Last Changed               " & vbTab & vbTab & oADObject.WhenChanged

 oOutFile.WriteLine "User profile               " & vbTab & vbTab & oADObject.ProfilePath
 oOutFile.WriteLine "Home directory             " & vbTab & vbTab & oADObject.HomeDirectory
 oOutFile.WriteLine "Logon script               " & vbTab & vbTab & oADObject.ScriptPath
 oOutFile.WriteLine "User Principal Name        " & vbTab & vbTab & oADObject.UserPrincipalName
 oOutFile.WriteLine ""

 oOutFile.WriteLine "============================================================="
 oOutFile.WriteLine "               ------ GROUP MEMBERSHIP ------"
 oOutFile.WriteLine "============================================================="
 
 If bShowNested Then 
 
 oOutFile.WriteLine " (R) after a group name indicates that it's Repeated as a "
 oOutFile.WriteLine " result of group nesting. "
 oOutFile.WriteLine "============================================================="
 
 End If 
 
 oOutFile.WriteLine ""
 
 
 If bShowNested Then 
     
    Set oGroupList = CreateObject("Scripting.Dictionary")
    oGroupList.CompareMode = vbTextCompare
    
    Call EnumGroups(oADObject, 0, 1, "|" , bInclDescription)
 	oOutFile.WriteLine ""
 	oOutFile.WriteLine "Distinct Groups: " & iDistinctGroups
 
 Else
 
	For Each oGroup In oADObject.Groups
		i = i + 1
		stGroup = Replace(oGroup.Name, "CN=", "")
		If bInclDescription Then 
			stDesc = oGroup.Description(0)
			oOutFile.WriteLine PadString(stGroup,  GroupMaxLength) & vbTab & stDesc 
		Else 
			oOutFile.WriteLine stGroup
		End If 
	Next
 
 End If 

 
oOutFile.WriteLine ""
oOutFile.WriteLine ""
oOutFile.WriteLine ""
 
oOutFile.Close

objShell.Run ("NotePad.exe " & stFileName)

End Sub

'================================================================================================================================
 
Function Integer8Date(objDate, lngBias)
' Function to convert Integer8 (64-bit) value
' to a date, adjusted for time zone bias.
  Dim lngAdjust, lngDate
  lngAdjust = lngBias
  If (objDate.HighPart = 0) And (objDate.LowPart = 0) Then
    lngAdjust = 0
  End If
  lngDate = #1/1/1601# + (((objDate.HighPart * (2 ^ 32)) _
    + objDate.LowPart) / 600000000 - lngAdjust) / 1440
  Integer8Date = CDate(lngDate)
End Function



'================================================================================================================================

Function EnumGroups(oADObject, iCount, iFirstTime ,stSpacer, bAddDescription)
                

    Dim iRemainCount 
    Dim oGroupTest
    Dim stLineOut

    Dim sGroups, oGroup, j
    Dim stSuffix 
    stSuffix = ""
        
    On Error Resume Next 
    
    sGroups = oADObject.MemberOf   
    
    If Err.Number <> 0 Then 
    	Call MsgBox(Err.Number & vbtab & Err.Description & vbcrlf & _
    				 "======================================" & _
    				 "oADObject: " & oADObject.Name, vbCritical, "Exiting")
    	WScript.Quit
    End If 
    
    On Error goto 0 
    
    				 
    
    
    If iFirstTime = 1 Then
               
        stLineOut = Replace(Replace(oADObject.Name, "CN=", ""), "\", "")
        
        'Debug.Print stLineOut
        oOutFile.WriteLine stLineOut
        oOutFile.WriteLine "==========================================="
        stSpacer = ""
        
        If IsEmpty(sGroups) Then
            iCount = 0
        ElseIf TypeName(sGroups) = "String" Then
            iCount = 1
        Else
            iCount = UBound(sGroups)
        End If
        
        iFirstTime = 0
        
    End If
    
    
    If IsEmpty(sGroups) Then
        iRemainCount = 0
    ElseIf TypeName(sGroups) = "String" Then
        iRemainCount = 1
    Else
        iRemainCount = UBound(sGroups) + 1
    End If
     
    
      
    For j = 0 To iRemainCount - 1
    
        stSpacer = stSpacer + Space(5) + "|"
               
        If TypeName(sGroups) = "String" Then
            Set oGroup = GetObject("LDAP://" & sGroups)
        Else
            Set oGroup = GetObject("LDAP://" & sGroups(j))
        End If
        
        'Debug.Print oGroup.Name
        
        If oGroupList.Exists(oGroup.SamAccountName) Then
            stSuffix = " (R)"
        Else
            iDistinctGroups = iDistinctGroups + 1
            stSuffix = ""
        End If
        
        
        oGroupList(oGroup.SamAccountName) = True
        stLineOut = stSpacer & "----->" & vbTab & Replace(oGroup.Name, "CN=", "") & stSuffix
        'Debug.Print stLineOut
        If bAddDescription Then 
        	stLineOut = PadString(stLineOut, GroupMaxLength) & vbTab & oGroup.Description(0)
        	oOutFile.WriteLine stLineOut 
        Else 
        	oOutFile.WriteLine stLineOut 
        End If 
        
        If iRemainCount = 1 Then
        	'Strip one character from the right of stSpacer
            'stSpacer = Left(stSpacer, Len(stSpacer) - 1)
            'Add a blank space to the right of stSpacer (Why am I doing this?) 
            'stSpacer = stSpacer + " "
        End If
        
        
        If Len(stSuffix) > 1 Then 
        	'oOutFile.WriteLine stSpacer & "   |" &  "---> [MEMBERSHIP PREVIOUSLY SHOWN ABOVE]"
        	If Len(stSpacer) > 5 Then
        		stSpacer = Left(stSpacer, Len(stSpacer) - 6)
    		End If
        	iRemainCount = iRemainCount - 1
        Else
        	iRemainCount = EnumGroups(oGroup, iRemainCount, iFirstTime, stSpacer, bAddDescription)
        End If 
    
    Next 
    
    
    If Len(stSpacer) > 5 Then
        stSpacer = Left(stSpacer, Len(stSpacer) - 6)
    End If

  
  Set oGroup = Nothing
  EnumGroups = iCount - 1
  
End Function

'================================================================================================================================

Function Get_Tokens_size(strUserDN) 

Const ADS_SECURE_AUTHENTICATION = 1
Dim numEntries:numEntries = 0
Dim adsPath
Dim dso, obj, grps

	adsPath = "LDAP://" & Trim(strUserDn)	

	Set dso = GetObject("GC:")
	Set Obj = dso.OpenDsObject(adsPath,VbNullString, VbNullString, ADS_SECURE_AUTHENTICATION)
	Obj.GetInfoEx ARRAY("TokenGroups"),0
	Grps = Obj.GetEx("TokenGroups") 

	numEntries= ubound(Grps)

Get_Tokens_size = numEntries

End Function


Function PadString(stStringToPad, iLen) 
	
	'//If the length is shorter than the iLen then pad it. Otherwise do nothing.  
	If Len(stStringToPad) < iLen Then 
		Dim i , strPadding 
		For i = 0 To iLen
			strPadding = strPadding & " " 
		Next 
		strPadding = Left(strPadding, iLen - Len(stStringToPad)) 
		stStringToPad = stStringToPad & strPadding
	End If 
	
	PadString = stStringToPad 

End Function 
