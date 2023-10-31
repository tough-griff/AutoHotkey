#Requires AutoHotkey v2.0

; Get the position and size of the monitor containing the specified window.
GetMonitorInfo(&Left?, &Top?, &Right?, &Bottom?, &Width?, &Height?, WinTitle := "A") {
    winHandle := WinExist(WinTitle)
    monHandle := DllCall("MonitorFromWindow", "ptr", winHandle, "uint", 0x2)

    monInfo := Buffer(40)
    NumPut("uint", 40, monInfo)
    DllCall("GetMonitorInfoA", "ptr", monHandle, "ptr", monInfo)

    Left := NumGet(monInfo, 4, "int")
    Top := NumGet(monInfo, 8, "int")
    Right := NumGet(monInfo, 12, "int")
    Bottom := NumGet(monInfo, 16, "int")
    Width := Right - Left
    Height := Bottom - Top
}

; Left Half
^#Left:: {
    GetMonitorInfo(&left, &top, &right, &bottom, &w, &h, "A")
    WinRestore("A")
    WinMove(left, top, w // 2, h, "A")
}
; Right Half
^#Right:: {
    GetMonitorInfo(&left, &top, &right, &bottom, &w, &h, "A")
    WinRestore("A")
    WinMove(left + w // 2, top, w // 2, h, "A")
}
; Top Half
^#Up:: {
    GetMonitorInfo(&left, &top, &right, &bottom, &w, &h, "A")
    WinRestore("A")
    WinMove(left, top, right - left, h // 2, "A")
}
; Bottom Half
^#Down:: {
    GetMonitorInfo(&left, &top, &right, &bottom, &w, &h, "A")
    WinRestore("A")
    WinMove(left, top + h // 2, right - left, h // 2, "A")
}

; Maximize
^#Enter:: WinMaximize("A")
; Maximize Height
^#+Up:: {
    GetMonitorInfo(, &top, , , , &h, "A")
    WinMove(, top, , h, "A")
}
; Center
^#C:: {
    GetMonitorInfo(&left, &top, &right, &bottom, &monW, &monH, "A")
    WinGetPos(, , &winW, &winH, "A")
    WinMove(left + monW // 2 - winW // 2, top + monH // 2 - winH // 2, , , "A")
}
; Restore
^#Backspace:: WinRestore("A")

; Next Display
^#!Right:: Send("+#{Right}")
; Previous Display
^#!Left:: Send("+#{Left}")
