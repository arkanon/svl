' openMSX 0.7.0 for Windows

Set oSh = CreateObject("WScript.Shell")

sBin = "openmsx -machine expert -cart hotlogo.rom -diska disk -record openmsx-0.1.txt"

' 0 Hide the window and activate another window
bInForeground = True
oSh.Run sBin, 0, bInForeground

