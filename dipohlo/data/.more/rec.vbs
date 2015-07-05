Set oSh = CreateObject("WScript.Shell")

sBin = "openmsx -machine expert -cart hotlogo.rom -diska disk -record input.txt"

' 0 Hide the window and activate another window
bInForeground = True
oSh.Run sBin, 0, bInForeground

