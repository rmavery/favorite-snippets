Option Explicit

Dim objGroup, strDN, objMemberList
Dim objConnection, objCommand, objRootDSE, strDNSDomain

' Dictionary object to track group membership.
Set objMemberList = CreateObject("Scripting.Dictionary")
objMemberList.CompareMode = vbTextCompare

' Check for required argument.
If Wscript.Arguments.Count < 1 Then
  Wscript.Echo "Required argument <Distinguished Name> " _
    & "of group missing."
  Wscript.Echo "For example:" & vbCrLf _
    & "cscript //nologo EnumGroup.vbs " _
    & """cn=Test Group,ou=Sales,dc=MyDomain,dc=com"""
  Wscript.Quit(0)
End If

' Bind to the group object with the LDAP provider.
strDN = Wscript.Arguments(0)
On Error Resume Next
Set objGroup = GetObject("LDAP://" & strDN)
If Err.Number <> 0 Then
  On Error GoTo 0
  Wscript.Echo "Group not found" & vbCrLf & strDN
  Wscript.Quit(1)
End If
On Error GoTo 0

' Retrieve DNS domain name from RootDSE.
Set objRootDSE = GetObject("LDAP://RootDSE")
strDNSDomain = objRootDSE.Get("defaultNamingContext")

' Setup ADO.
Set objConnection = CreateObject("ADODB.Connection")
Set objCommand = CreateObject("ADODB.Command")
objConnection.Provider = "ADsDSOObject"
objConnection.Open "Active Directory Provider"
Set objCommand.ActiveConnection = objConnection
objCommand.Properties("Page Size") = 100
objCommand.Properties("Timeout") = 30
objCommand.Properties("Cache Results") = False

' Enumerate group membership.
Wscript.Echo "Members of group " & objGroup.sAMAccountName
Call EnumGroup(objGroup, "  ")

' Clean Up.
objConnection.Close
Set objGroup = Nothing
Set objRootDSE = Nothing
Set objCommand = Nothing
Set objConnection = Nothing

Sub EnumGroup(objADGroup, strOffset)
' Recursive subroutine to enumerate group membership.
' objMemberList is a dictionary object with global scope.
' objADGroup is a group object bound with the LDAP provider.
' This subroutine outputs a list of group members, one member
' per line. Nested group members are included. Users are also
' included if their primary group is objADGroup. objMemberList
' prevents an infinite loop if nested groups are circular.

  Dim strFilter, strAttributes, objRecordSet, intGroupToken
  Dim objMember, strQuery, strNTName

' Retrieve "primaryGroupToken" of group.
  objADGroup.GetInfoEx Array("primaryGroupToken"), 0
  intGroupToken = objADGroup.Get("primaryGroupToken")

' Use ADO to search for users whose "primaryGroupID" matches the
' group "primaryGroupToken".
  strFilter = "(primaryGroupID=" & intGroupToken & ")"
  strAttributes = "sAMAccountName"
  strQuery = "<LDAP://" & strDNSDomain & ">;" & strFilter & ";" _
    & strAttributes & ";subtree"
  objCommand.CommandText = strQuery
  Set objRecordSet = objCommand.Execute
  Do Until objRecordSet.EOF
    strNTName = objRecordSet.Fields("sAMAccountName")
    If Not objMemberList(strNTName) Then
      objMemberList(strNTName) = True
      Wscript.Echo strOffset & strNTName & " (Primary)"
    Else
      Wscript.Echo strOffset & strNTName & " (Primary, Duplicate)"
    End If
    objRecordSet.MoveNext
  Loop

  For Each objMember In objADGroup.Members
    If Not objMemberList(objMember.sAMAccountName) Then
      objMemberList(objMember.sAMAccountName) = True
      If UCase(Left(objMember.objectCategory, 8)) = "CN=GROUP" Then
        Wscript.Echo strOffset & objMember.sAMAccountName & " (Group)"
        Call EnumGroup(objMember, strOffset & "  ")
      Else
        Wscript.Echo strOffset & objMember.sAMAccountName
      End If
    Else
      Wscript.Echo strOffset & objMember.sAMAccountName & " (Duplicate)"
    End If
  Next
  Set objMember = Nothing
  Set objRecordSet = Nothing
End Sub

