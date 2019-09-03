Wscript.Echo CurDir

Function CurDir 

	Dim sFullPath : sFullPath = WScript.ScriptFullName
	Dim sRev : sRev = StrReverse(sFullPath) 
	Dim iLastSlash : iLastSlash = InStr(1, sRev, "\", vbTextCompare) 
	Dim ScriptPath : ScriptPath = Left(sFullPath, Len(sFullPath) - iLastSlash) 
	CurDir = ScriptPath

End Function 
