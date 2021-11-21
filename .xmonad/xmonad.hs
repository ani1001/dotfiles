import XMonad
import System.IO

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

import XMonad.Util.Cursor
import XMonad.Util.EZConfig
import XMonad.Util.Loggers
import XMonad.Util.Ungrab
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.SpawnOnce

import XMonad.Layout.Accordion
import XMonad.Layout.Grid
import XMonad.Layout.Magnifier
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

myModMask            = mod4Mask
myTerminal           = "xterm"
-- myWorkspaces         = ["1:web","2:irc","3:mail","4:dev","5:comm","6:tmp","7:dvi","8","9"]
myWorkspaces         = ["WWW","IRC","Email","Code","Shell"]
myFocusedBorderColor = "#5e81ac"      -- Color of focused border
myNormalBorderColor  = "#a3be8c"      -- Color of inactive border
myBorderWidth        = 2              -- Width of border around windows

myStartupHook = do
    spawnOnce "nitrogen --restore &"
    spawnOnce "xcompmgr &"
    spawnOnce "lxpolkit &"
    spawnOnce "urxvtd -q -o -f &"
    setWMName "LG3D"
    setDefaultCursor xC_left_ptr

main :: IO ()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . withEasySB (statusBarProp "xmobar ~/.config/xmobar/xmobar.hs" (pure myXmobarPP)) defToggleStrutsKey
     $ myConfig

myConfig = def
    { modMask     = myModMask      -- Rebind Mod to the Super key
    , layoutHook  = myLayout       -- Use custom layouts
    , manageHook  = myManageHook   -- Match on certain windows
    , startupHook = myStartupHook
    , focusedBorderColor = myFocusedBorderColor
    , normalBorderColor = myNormalBorderColor
    , borderWidth = myBorderWidth
    , terminal = myTerminal
    , workspaces = myWorkspaces
    }
  `additionalKeysP`
    [ ("M-S-z" , spawn "slock")
    , ("M-S-=" , unGrab *> spawn "scrot -s"        )
    , ("M-]"   , spawn "firefox"                   )
    , ("M-S-p" , spawn "rofi -show run"            )
    ]

myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "Gimp"           --> doFloat
    , isDialog                      --> doFloat
    , className =? "MPlayer"        --> doFloat
    , className =? "Xmessage"       --> doFloat
    , className =? "Firefox-bin"    --> doShift "www"
--    , className =? "Rhythmbox"      --> doShift "8"
--    , className =? "XDvi"           --> doShift "7:dvi"
    ]

myLayout = ( 
             tiled                             |||
	     Mirror tiled                      |||
	     Full                              |||
	     Grid                              |||
	     spiral(6/7)                       |||
             threeCol                          |||
	     noBorders (tabbed shrinkText def) |||
	     Accordion

	     )
  where
    threeCol = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio
    tiled    = Tall nmaster delta ratio
    nmaster  = 1      -- Default number of windows in the master pane
    ratio    = 1/2    -- Default proportion of screen occupied by master pane
    delta    = 3/100  -- Percent of screen to increment by when resizing panes

myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = magenta " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap " " "" . xmobarBorder "Top" "#8be9fd" 2
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""
