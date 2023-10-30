#Requires AutoHotkey v2.0

WinGetMonInfo(&Left?, &Top?, &Right?, &Bottom?, &W?, &H?, WinTitle := "A") {
    winHandle := WinExist("A")
    monHandle := DllCall("MonitorFromWindow", "ptr", winHandle, "uint", 0x2)
    monInfo := Buffer(40)
    NumPut("uint", 40, monInfo)

    DllCall("GetMonitorInfoA", "ptr", monHandle, "ptr", monInfo)
    Left := NumGet(monInfo, 4, "int")
    Top := NumGet(monInfo, 8, "int")
    Right := NumGet(monInfo, 12, "int")
    Bottom := NumGet(monInfo, 16, "int")
    W := Right - Left
    H := Bottom - Top
}

^#Enter:: WinMaximize("A")
^#!Left:: Send("+#{Left}")
^#!Right:: Send("+#{Right}")

^#C:: {
    WinGetMonInfo(&left, &top, &right, &bottom, &monW, &monH, "A")
    WinGetPos(, , &winW, &winH, "A")
    WinMove(left + monW // 2 - winW // 2, top + monH // 2 - winH // 2, , , "A")
}

^#Left:: {
    WinGetMonInfo(&left, &top, &right, &bottom, &w, &h, "A")
    WinRestore("A")
    WinMove(left, top, w // 2, h, "A")
}

^#Right:: {
    WinGetMonInfo(&left, &top, &right, &bottom, &w, &h, "A")
    WinRestore("A")
    WinMove(left + w // 2, top, w // 2, h, "A")
}

^#Up:: {
    WinGetMonInfo(&left, &top, &right, &bottom, &w, &h, "A")
    WinRestore("A")
    WinMove(left, top, right - left, h // 2, "A")
}

^#Down:: {
    WinGetMonInfo(&left, &top, &right, &bottom, &w, &h, "A")
    WinRestore("A")
    WinMove(left, top + h // 2, right - left, h // 2, "A")
}
