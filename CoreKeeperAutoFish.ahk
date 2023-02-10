; -------------------------------------------------------------------------------- ;
;  Core Keeper Auto Fish AutoHotKey script
;  Version: 0.0.4
;  Last Updated: 2022/12/02
;  Author: Tim Martin
; -------------------------------------------------------------------------------- ;

toggle := 0
init := 0
time := A_TickCount

MsgBox, 0, % "Core Keeper Auto Fish", % "Welcome to Core Keeper Auto Fish`n`nThis program automatically fishes for you in the game Core Keeper so that you can afk fish while away from your computer.`n`nTo use this program stand with a water block next to you, on your RIGHT.`n`nEnsure you are holding a fishing rod.`n`nThen press Ctrl + Shift + f to automatically fish.`n`nYou can press Ctrl + Shift + f to stop automatically fishing at any time.`n`n`n`nこのプログラムは、Core Keeperの釣りを自動化するマクロツールです。`n`nあなたが外出していても寝ていても、全自動で魚もお宝も釣り上げてくれます。`n`nまずキャラクターの右隣が水になるように立ちましょう。`n`n釣竿を装備していることを確認し、Ctrl + Shift + F を押すと自動釣りがスタートします。`n`n動作中にもう一度 Ctrl + Shift + F を押すと自動釣りを停止することができます。"

OK:

Loop {
    stage := 0
    While toggle {
        If WinExist("Core Keeper") {
            If WinActive("Core Keeper") {
                If (init == 0) {
                    WinGetPos, WinX, WinY, WinW, WinH
                    Fx1 := (WinW / 2) - (0.1883 * WinH)
                    Fy1 := 0.785 * WinH
                    Fx2 := (WinW / 2) + (0.186 * WinH)
                    Fy2 := 0.790 * WinH
                    Rx1 := (WinW / 2) - (0.1883 * WinH)
                    Ry1 := 0.785 * WinH
                    Rx2 := (WinW / 2) + (0.186 * WinH)
                    Ry2 := 0.790 * WinH
                    Hx1 := WinW * 0.49175
                    Hy1 := WinH * 0.36552
                    Hx2 := WinW * 0.49575
                    Hy2 := WinH * 0.39051
                    Mx := WinW * 0.8
                    My := WinH / 2
                    init == 1
                }

                pixelFound := 0
                PixelSearch, Px1, Py1, Fx1, Fy1, Fx2, Fy2, 0xDE9325, 1, Fast
                If !ErrorLevel
                    pixelFound := 1
                If !pixelFound {
                    PixelSearch, Px1, Py1, Fx1, Fy1, Fx2, Fy2, 0xC25D1C, 1, Fast
                    If !ErrorLevel
                        pixelFound := 1
                }

                If !pixelFound {
                    pixelExFound := 0
                    PixelSearch, Px2, Py2, Hx1, Hy1, Hx2, Hy2, 0xDAC8C8, 3, Fast
                    If !ErrorLevel {
                        pixelExFound := 1
                    }

                    if (stage == 0) {
                        MouseClick, right, Mx, My,,0,U
                        MouseClick, left, Mx, My,,0,D
                        MouseClick, left, Mx, My,,0,U
                        Sleep 100
                        MouseClick, right, Mx, My,,0,D
                        Sleep 150
                        MouseClick, right, Mx, My,,0,U
                        stage := 1
                        time := A_TickCount
                    } else If (stage == 1 and A_TickCount > time + 100 and pixelExFound) {
                        MouseClick, right, Mx, My,,0,D
                        Sleep 100
                        MouseClick, right, Mx, My,,0,U
                        stage := 2
                        Hx1 := Px2 - 2
                        Hx2 := Px2 + 2
                        Hy1 := Py2 - 2
                        Hy2 := Py2 + 2
                        time := A_TickCount
                    } else If (stage == 2 and A_TickCount > time + 600) {
                        stage := 0
                    } else If (A_TickCount > time + 20000) {
                        stage := 0
                    }

                    continue
                }

                pixelFound := 0
                PixelSearch, Px3, Py3, Rx1, Ry1, Rx2, Ry2, 0x1E2CBE, 1, Fast
                If !ErrorLevel {
                    pixelFound := 1
                }
                If !pixelFound {
                    PixelSearch, Px3, Py3, Rx1, Ry1, Rx2, Ry2, 0x0B3ACD, 1, Fast
                    If !ErrorLevel {
                        pixelFound := 1
                    }
                }

                If !pixelFound {
                    MouseClick, right, Mx, My,,0,D
                    continue
                } else {
                    MouseClick, right, Mx, My,,0,U
                    continue
                }
            } else {
                MsgBox, 4, % "Core Keeper Auto Fish - Core Keeper not active", % "You cannot fish if Core Keeper is not the active window.`n`nWould you like to make Core Keeper the active window?"
                IfMsgBox, Yes
                    WinActivate
                else IfMsgBox, No
                    toggle := 0
                continue
            }
        } else {
            MsgBox, 0, % "Core Keeper Auto Fish - Core Keeper not running", % "Core Keeper is not runing.`n`nPlease run Core Keeper before attempting to fish."
            toggle := 0
            continue
        }
    }
}
return

$^+f::
    toggle := !toggle
    init := 0
    Return