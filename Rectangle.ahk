#Requires AutoHotkey v2.0

SIZE_INCREMENT := 30
MIN_WINDOW_WIDTH := 0.25
MIN_WINDOW_HEIGHT := 0.25
WIN_DELAY := 0

SetWinDelay WIN_DELAY

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
    WinMove(left, top, w, h // 2, "A")
}

; Bottom Half
^#Down:: {
    GetMonitorInfo(&left, &top, &right, &bottom, &w, &h, "A")
    WinRestore("A")
    WinMove(left, top + h // 2, w, h // 2, "A")
}

; Top Left
^#U:: {
    GetMonitorInfo(&left, &top, &right, &bottom, &w, &h, "A")
    WinRestore("A")
    WinMove(left, top, w // 2, h // 2, "A")
}

; Top Right
^#I:: {
    GetMonitorInfo(&left, &top, &right, &bottom, &w, &h, "A")
    WinRestore("A")
    WinMove(left + w // 2, top, w // 2, h // 2, "A")
}

; Bottom Left
^#J:: {
    GetMonitorInfo(&left, &top, &right, &bottom, &w, &h, "A")
    WinRestore("A")
    WinMove(left, top + h // 2, w // 2, h // 2, "A")
}

; Bottom Right
^#K:: {
    GetMonitorInfo(&left, &top, &right, &bottom, &w, &h, "A")
    WinRestore("A")
    WinMove(left + w // 2, top + h // 2, w // 2, h // 2, "A")
}

; Maximize
^#Enter:: WinMaximize("A")

; Maximize Height
^#+Up:: {
    GetMonitorInfo(, &top, , , , &h, "A")
    WinMove(, top, , h, "A")
}

; Make Smaller
^#-:: {
    GetMonitorInfo(&left, &top, , , &monW, &monH, "A")
    WinGetPos(&x, &y, &winW, &winH, "A")

    if (winW - SIZE_INCREMENT > monW * MIN_WINDOW_WIDTH) {
        x := x + SIZE_INCREMENT // 2
        winW := winW - SIZE_INCREMENT
    }

    if (winH - SIZE_INCREMENT > monH * MIN_WINDOW_HEIGHT) {
        y := y + SIZE_INCREMENT // 2
        winH := winH - SIZE_INCREMENT
    }

    WinRestore("A")
    WinMove(Max(left, x), Max(top, y), winW, winH, "A")
}

; Make Larger
^#=:: {
    GetMonitorInfo(&left, &top, , , &monW, &monH, "A")
    WinGetPos(&x, &y, &winW, &winH, "A")
    WinRestore("A")
    WinMove(
        Max(left, x - SIZE_INCREMENT // 2),
        Max(top, y - SIZE_INCREMENT // 2),
        Min(monW, monW - x + SIZE_INCREMENT // 2, winW + SIZE_INCREMENT),
        Min(monH, monH - y + SIZE_INCREMENT // 2, winH + SIZE_INCREMENT),
        "A"
    )
}

; Center
^#C:: {
    GetMonitorInfo(&left, &top, &right, &bottom, &monW, &monH, "A")
    WinGetPos(, , &winW, &winH, "A")
    WinMove(left + monW // 2 - winW // 2, top + monH // 2 - winH // 2, , , "A")
}

; Restore
^#Backspace:: WinRestore("A")

; Next Display -- leverages existing windows command Shift+Windows+Right
^#!Right:: Send("#+{Right}")

; Previous Display -- leverages existing windows command Shift+Windows+Left
^#!Left:: Send("#+{Left}")
