
------------------------------------------------------------------------------
-- |
-- Copyright: (c) 2018, 2019 Jose Antonio Ortega Ruiz
-- License: BSD3-style (see LICENSE)
--
-- Maintainer: jao@gnu.org
-- Stability: unstable
-- Portability: portable
-- Created: Sat Nov 24, 2018 21:03
--
--
-- An example of a Haskell-based xmobar. Compile it with
--   ghc --make -- xmobar.hs
-- with the xmobar library installed or simply call:
--   xmobar /path/to/xmobar.hs
-- and xmobar will compile and launch it for you and
------------------------------------------------------------------------------

import Xmobar

-- Example user-defined plugin

-- data HelloWorld = HelloWorld
--     deriving (Read, Show)

-- instance Exec HelloWorld where
--     alias HelloWorld = "hw"
--     run   HelloWorld = return "<fc=red>Hello World!!</fc>"

-- Configuration, using predefined monitors as well as our HelloWorld
-- plugin:

config :: Config
config = defaultConfig {
--   font = "xft:Sans Mono-9"
  font = "-misc-fixed-*-*-*-*-13-*-*-*-*-*-*-*"
  , additionalFonts = []
--   , borderColor = "black"
  , borderColor =  "#4c566a"
--   , border = TopB
  , border = BottomB
--   , bgColor = "black"
  , bgColor =      "#2e3440"
--   , fgColor = "grey"
  , fgColor =      "#d8dee9"
  , alpha = 255
  , position = Top
  , textOffset = -1
  , iconOffset = -1
  , lowerOnStart = True
  , pickBroadest = False
  , persistent = False
  , hideOnStart = False
  , iconRoot = "."
  , allDesktops = True
  , overrideRedirect = False
  , commands = [ Run $ Weather "VGHS" ["-t"," <tempC>°C",
                                        "-L","18","-H","25",
                                        "--normal","green",
                                        "--high","red",
                                        "--low","lightblue"] 36000
               , Run $ Network "enp0s29u1u5" ["-L","0","-H","32",
                                        "--normal","green","--high","red"] 10
--                , Run $ Network "eth1" ["-L","0","-H","32",
--                                         "--normal","green","--high","red"] 10
               , Run $ Cpu ["-L","3","-H","50",
                             "--normal","green","--high","red"] 10
               , Run $ Memory ["-t","Mem: <usedratio>%"] 10
               , Run $ Swap [] 10
--                , Run $ Com "uname" ["-s","-r"] "" 36000
               , Run $ Date "%a %b %_d %Y %H:%M:%S" "date" 10
	       , Run XMonadLog
--                , Run HelloWorld
              ]
  , sepChar = "%"
  , alignSep = "}{"
--   , template = "%cpu% | %memory% * %swap% | %eth0% - %eth1% }\
--                \ %hw% { <fc=#ee9a00>%date%</fc>| %EGPH% | %uname%"
  , template = "%XMonadLog% }{ %cpu% | %memory% * %swap% | %enp0s29u1u5% | <fc=#81a1c1>%date%</fc> [%VGHS%]"
}

main :: IO ()
main = xmobar config
