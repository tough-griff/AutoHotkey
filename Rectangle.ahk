#Requires AutoHotkey v2.0

; Get the position and size of the monitor containing the specified window.
GetMonitorInfo(&Left, &Top, &Right, &Bottom, &Width, &Height, WinTitle) {
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

^#Enter:: WinMaximize("A")
^#!Left:: Send("+#{Left}")
^#!Right:: Send("+#{Right}")

^#C:: {
    GetMonitorInfo(&left, &top, &right, &bottom, &monW, &monH, "A")
    WinGetPos(, , &winW, &winH, "A")
    WinMove(left + monW // 2 - winW // 2, top + monH // 2 - winH // 2, , , "A")
}

^#Left:: {
    GetMonitorInfo(&left, &top, &right, &bottom, &w, &h, "A")
    WinRestore("A")
    WinMove(left, top, w // 2, h, "A")
}

^#Right:: {
    GetMonitorInfo(&left, &top, &right, &bottom, &w, &h, "A")
    WinRestore("A")
    WinMove(left + w // 2, top, w // 2, h, "A")
}

^#Up:: {
    GetMonitorInfo(&left, &top, &right, &bottom, &w, &h, "A")
    WinRestore("A")
    WinMove(left, top, right - left, h // 2, "A")
}

^#Down:: {
    GetMonitorInfo(&left, &top, &right, &bottom, &w, &h, "A")
    WinRestore("A")
    WinMove(left, top + h // 2, right - left, h // 2, "A")
}
