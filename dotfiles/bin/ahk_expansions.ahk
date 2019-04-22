#SingleInstance force


; ---------- "auto reload" ----------

FileGetTime ScriptStartModTime, %A_ScriptFullPath%
SetTimer CheckReload, 1000, 0x7FFFFFFF ; ms & priority

; from here: https://stackoverflow.com/a/45488494
CheckReload() {
    global ScriptStartModTime
    FileGetTime curModTime, %A_ScriptFullPath%
    If (curModTime <> ScriptStartModTime) {
        Loop
        {
            reload
            Sleep 300 ; ms
            MsgBox 0x2, %A_ScriptName%, Reload failed. ; 0x2 = Abort/Retry/Ignore
            IfMsgBox Abort
                ExitApp
            IfMsgBox Ignore
                break
        } ; loops reload on "Retry"
    }
}


; ---------- actual content here ----------

:*:-abm::
  Send, axel.bock.mail@gmail.com
  Return

:*:-mab::
  Send, mr.axel.bock@gmail.com
  Return

:*:-ssb::
  Send, sihtsielbasopsid@gmail.com
  Return

:*:.ab::
  Send, axel.bock
  Return

:*:-abpkd::
  Send, axel.bock@pkd.de
  Return

:*:-dt::
  ; from here: https://is.gd/3u6MKQ
  Send, %A_YYYY%-%A_MM%-%A_DD%
  Return

:*://ts::
  Send, %A_YYYY%%A_MM%%A_DD%_%A_Hour%%A_Min%%A_Sec%
  Return
