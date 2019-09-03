Public Function GetOrdinal( _
       ByVal Number As Integer) As String
  ' Accepts an integer, 
  '    returns the ordinal suffix

  ' Handles special case three digit numbers 
  ' ending with 11, 12 or 13 - ie, 111th, 
  '        112th, 113th, 211th, et al
  If CType(Number, String).Length > 2 Then
    Dim intEndNum As Integer = +
      CType(CType(Number, String). _
        Substring(CType(Number, String).Length - 2, 2), _
        Integer)
    If intEndNum >= 11 And intEndNum <= 13 Then
        Select Case intEndNum
            Case 11, 12, 13
                Return "th"
        End Select
    End If
  End If

  If Number >= 21 Then
    ' Handles 21st, 22nd, 23rd, et al
    Select Case CType(Number.ToString.Substring( _
       Number.ToString.Length - 1, 1), Integer)
       Case 1
           Return "st"
       Case 2
           Return "nd"
       Case 3
           Return "rd"
       Case 0, 4 To 9
           Return "th"
    End Select
  Else
    ' Handles 1st to 20th
    Select Case Number
       Case 1
           Return "st"
       Case 2
           Return "nd"
       Case 3
           Return "rd"
       Case 4 To 20
           Return "th"
    End Select
  End If
End Function

