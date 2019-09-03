Function isLink(stNoteString As String) As Boolean

    Dim sLinkRegEx As String: sLinkRegEx = "^https?\:\/\/(([a-z0-9]{2,})\.){1,}([a-z0-9]{2,5})\/?(([^*,!@#$\^*()\\\ \[\]]){1,})?$"
    
    Dim regex As Object
    Dim matches As Object
    
    Set regex = CreateObject("VBScript.RegExp")
    
    
    With regex
        .Pattern = sLinkRegEx
        .Global = True
        .ignorecase = True
    End With
    
    Set matches = regex.Execute(stNoteString)
    If matches.count = 1 Then
        isLink = True
    Else
        isLink = False
    End If

End Function