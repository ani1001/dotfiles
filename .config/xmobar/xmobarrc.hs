

Config { font = "-misc-fixed-*-*-*-*-13-*-*-*-*-*-*-*"
    , bgColor = "#2e3440"
    , fgColor = "#d8dee9"
    , position = Top
    , lowerOnStart = True
    , allDesktops = True
    , pickBroadest = False
    , overrideRedirect = False
    , commands = [    Run Weather "VGHS" ["-t"," <tempC>°C","-L","64","-H","77","--normal","#a3be8c","--high","#d08770","--low","#81a1c1"] 36000
                    , Run Network "usb0" ["-L","0","-H","32","--normal","#a3be8c","--high","#d08770"] 10
                    , Run MultiCpu ["-L","15","-H","50","--normal","#a3be8c","--high","#d08770"] 10
                    , Run Memory [] 10
                    , Run Swap [] 10
                    , Run TopProc [] 10
                    , Run Date "%a %b %_d %Y %H:%M:%S" "date" 10
                    , Run UnsafeStdinReader
    ]
    , sepChar = "%"
    , alignSep = "}{"
    , template = "%UnsafeStdinReader% }{ %multicpu% | %memory% * %swap% | %usb0% | <fc=#b48ead>%date%</fc> | %VGHS% "
}
