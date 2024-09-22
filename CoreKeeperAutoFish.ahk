; -------------------------------------------------------------------------------- ;
;  Core Keeper Auto Fish AutoHotKey script
;  Version: 0.0.4
;  Last Updated: 2024/09/23
;  Author: Tim Martin
; -------------------------------------------------------------------------------- ;

toggle := 0
init := 0
time := A_TickCount

MsgBox, 0, % "Core Keeper Auto Fish", % "Welcome to Core Keeper Auto Fish`n`nThis program automatically fishes for you in the game Core Keeper so that you can afk fish while away from your computer.`n`nTo use this program stand with a water block next to you, on your RIGHT.`n`nEnsure you are holding a fishing rod.`n`nThen press Ctrl + Shift + f to automatically fish.`n`nYou can press Ctrl + Shift + f to stop automatically fishing at any time.`n`nIf it doesn't work, try fishing in a dark place.`n`n`n`nこのプログラムは、Core Keeperの釣りを自動化するマクロツールです。`n`nあなたが外出していても寝ていても、全自動で魚もお宝も釣り上げてくれます。`n`nまずキャラクターの右隣が水になるように立ちましょう。`n`n釣竿を装備していることを確認し、Ctrl + Shift + F を押すと自動釣りがスタートします。`n`n動作中にもう一度 Ctrl + Shift + F を押すと自動釣りを停止することができます。`n`n動作が安定しない場合は、暗い場所で釣りをしてください。"

OK:

Loop {
    stage := 0
    While toggle {
        If WinExist("Core Keeper") {
            If WinActive("Core Keeper") {
                If (init == 0) {
                    ; initialize parameters
                    WinGetPos, WinX, WinY, WinW, WinH
                    Hx1 := WinW * 0.49175
                    Hy1 := WinH * 0.36552
                    Hx2 := WinW * 0.49575
                    Hy2 := WinH * 0.39051
                    Mx := WinW * 0.8
                    My := WinH / 2
                    init := 1
                }

                pixelExFound := 0
                PixelSearch, Px2, Py2, Hx1, Hy1, Hx2, Hy2, 0xC8C8DA, 28, Fast, RGB
                If !ErrorLevel {
                    pixelExFound := 1
                }

                if (stage == 0) {
                    ; setup : attack -> fishing
                    MouseClick, right, Mx, My,,0,U
                    MouseClick, left, Mx, My,,0,D
                    MouseClick, left, Mx, My,,0,U
                    Sleep 100
                    MouseClick, right, Mx, My,,0,D
                    Sleep 150
                    MouseClick, right, Mx, My,,0,U
                    stage := 1
                    time := A_TickCount
                    Sleep 50
                } else If (stage == 1 and A_TickCount > time + 100 and pixelExFound) {
                    ; catching
                    MouseClick, right, Mx, My,,0,D
                    Sleep 100
                    MouseClick, right, Mx, My,,0,U
                    stage := 2
                    Hx1 := Px2 - 2
                    Hx2 := Px2 + 6
                    Hy1 := Py2 - 2
                    Hy2 := Py2 + 6
                    time := A_TickCount
                    Sleep 50
                } else If (stage == 2 and A_TickCount > time + 600) {
                    ; end fishing and go to setup
                    stage := 0
                    Sleep 50
                } else If (A_TickCount > time + 20000) {
                    ; return to initialize parameters
                    stage := 0
                    init := 0
                    Sleep 50
                }

                continue
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
