import XMonad
import System.IO

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName

import XMonad.Layout.Accordion
import XMonad.Layout.Grid
import XMonad.Layout.Magnifier
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

import XMonad.Util.Cursor
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.SpawnOnce

myModMask            = mod4Mask
myTerminal           = "urxvtc"
myWorkspaces         = ["1:web","2:irc","3:mail","4:dev","5:comm","6:tmp","7:dvi","8","9"]
myFocusedBorderColor = "#5e81ac"      -- Color of focused border
myNormalBorderColor  = "#a3be8c"      -- Color of inactive border
myBorderWidth        = 2              -- Width of border around windows

myStartupHook = do
    spawnOnce "nitrogen --restore &"
    spawnOnce "picom &"
    spawnOnce "lxpolkit &"
    spawnOnce "urxvtd -q -o -f &"
    setWMName "LG3D"
    setDefaultCursor xC_left_ptr

myLayout = (tiled ||| Mirror tiled ||| Full ||| Grid ||| spiral(6/7) ||| threeCol ||| noBorders (tabbed shrinkText def) ||| Accordion)
  where
    threeCol = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio
    tiled    = Tall nmaster delta ratio
    nmaster  = 1      -- Default number of windows in the master pane
    ratio    = 1/2    -- Default proportion of screen occupied by master pane
    delta    = 3/100  -- Percent of screen to increment by when resizing panes

myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "Gimp"           --> doFloat
    , className =? "MPlayer"        --> doFloat
    , className =? "Xmessage"       --> doFloat
    , className =? "Firefox"        --> doShift "1:web"
    , className =? "Rhythmbox"      --> doShift "8"
    , className =? "XDvi"           --> doShift "7:dvi"
    ]

myKeys = [ ((myModMask, xK_b), sendMessage ToggleStruts)
         , ((myModMask .|. shiftMask, xK_z), spawn "slock")
         , ((myModMask .|. shiftMask, xK_p), spawn "rofi -show run")
         , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
         , ((0, xK_Print), spawn "scrot")
         ]

main :: IO ()
main = do
    xmproc0 <- spawnPipe "xmobar -x 0 $HOME/.config/xmobar/xmobarrc2"
    xmonad . ewmh . docks $ def
        { manageHook = myManageHook <+> manageHook def
        , layoutHook = smartBorders . avoidStruts $ myLayout
        , startupHook = myStartupHook
        , logHook = dynamicLogWithPP $ xmobarPP
                        { ppOutput = hPutStrLn xmproc0
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        , modMask = myModMask
        , focusedBorderColor = myFocusedBorderColor
        , normalBorderColor = myNormalBorderColor
        , borderWidth = myBorderWidth
        , terminal = myTerminal
        , workspaces = myWorkspaces
        } `additionalKeys` myKeys