#Requires AutoHotkey v2.0
#SingleInstance Force

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
; Ctrl-Win-LeftArrow
^#Left:: {
    GetMonitorInfo(&left, &top, &right, &bottom, &w, &h, "A")
    WinRestore()
    WinMove(left, top, w // 2, h)
}

; Right Half
; Ctrl-Win-RightArrow
^#Right:: {
    GetMonitorInfo(&left, &top, &right, &bottom, &w, &h, "A")
    WinRestore()
    WinMove(left + w // 2, top, w // 2, h)
}

; Top Half
; Ctrl-Win-UpArrow
^#Up:: {
    GetMonitorInfo(&left, &top, &right, &bottom, &w, &h, "A")
    WinRestore()
    WinMove(left, top, w, h // 2)
}

; Bottom Half
; Ctrl-Win-DownArrow
^#Down:: {
    GetMonitorInfo(&left, &top, &right, &bottom, &w, &h, "A")
    WinRestore()
    WinMove(left, top + h // 2, w, h // 2)
}

; Top Left
; Ctrl-Win-U
^#U:: {
    GetMonitorInfo(&left, &top, &right, &bottom, &w, &h, "A")
    WinRestore()
    WinMove(left, top, w // 2, h // 2)
}

; Top Right
; Ctrl-Win-I
^#I:: {
    GetMonitorInfo(&left, &top, &right, &bottom, &w, &h, "A")
    WinRestore()
    WinMove(left + w // 2, top, w // 2, h // 2)
}

; Bottom Left
; Ctrl-Win-J
^#J:: {
    GetMonitorInfo(&left, &top, &right, &bottom, &w, &h, "A")
    WinRestore()
    WinMove(left, top + h // 2, w // 2, h // 2)
}

; Bottom Right
; Ctrl-Win-K
^#K:: {
    GetMonitorInfo(&left, &top, &right, &bottom, &w, &h, "A")
    WinRestore()
    WinMove(left + w // 2, top + h // 2, w // 2, h // 2)
}

; Maximize
; Ctrl-Win-Enter
^#Enter:: WinMaximize("A")

; Maximize Height
; Ctrl-Win-Shift-UpArrow
^#+Up:: {
    GetMonitorInfo(, &top, , , , &h, "A")
    WinMove(, top, , h)
}

; Make Smaller
; Ctrl-Win-Minus
^#-:: {
    GetMonitorInfo(&left, &top, , , &monW, &monH, "A")
    WinGetPos(&x, &y, &winW, &winH)

    if (winW - SIZE_INCREMENT > monW * MIN_WINDOW_WIDTH) {
        x := x + SIZE_INCREMENT // 2
        winW := winW - SIZE_INCREMENT
    }

    if (winH - SIZE_INCREMENT > monH * MIN_WINDOW_HEIGHT) {
        y := y + SIZE_INCREMENT // 2
        winH := winH - SIZE_INCREMENT
    }

    WinRestore()
    WinMove(Max(left, x), Max(top, y), winW, winH)
}

; Make Larger
; Ctrl-Win-Equals
^#=:: {
    GetMonitorInfo(&left, &top, , , &monW, &monH, "A")
    WinGetPos(&x, &y, &winW, &winH)
    WinRestore()
    WinMove(
        Max(left, x - SIZE_INCREMENT // 2),
        Max(top, y - SIZE_INCREMENT // 2),
        Min(monW, monW - (x - left) + SIZE_INCREMENT // 2, winW + SIZE_INCREMENT),
        Min(monH, monH - (y - top) + SIZE_INCREMENT // 2, winH + SIZE_INCREMENT)
    )
}

; Center
; Ctrl-Win-C
^#C:: {
    GetMonitorInfo(&left, &top, &right, &bottom, &monW, &monH, "A")
    WinGetPos(, , &winW, &winH)
    WinMove(left + monW // 2 - winW // 2, top + monH // 2 - winH // 2)
}

; Restore
; Ctrl-Win-Backspace
^#Backspace:: WinRestore("A")

; Next Display -- leverages existing windows command Shift+Windows+Right
; Ctrl-Win-Alt-RightArrow
^#!Right:: Send("#+{Right}")

; Previous Display -- leverages existing windows command Shift+Windows+Left
; Ctrl-Win-Alt-LeftArrow
^#!Left:: Send("#+{Left}")
