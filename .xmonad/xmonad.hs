import XMonad
import System.IO

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName

import XMonad.Layout.Magnifier
import XMonad.Layout.ThreeColumns

import XMonad.Util.Cursor
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.SpawnOnce

myStartupHook = do
    spawnOnce "nitrogen --restore &"
    spawnOnce "picom &"
    spawnOnce "lxpolkit &"
    spawnOnce "urxvtd -q -o -f &"
    setWMName "LG3D"
    setDefaultCursor xC_left_ptr

myLayout = (tiled ||| Mirror tiled ||| Full ||| threeCol)
  where
    threeCol = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio
    tiled    = Tall nmaster delta ratio
    nmaster  = 1      -- Default number of windows in the master pane
    ratio    = 1/2    -- Default proportion of screen occupied by master pane
    delta    = 3/100  -- Percent of screen to increment by when resizing panes

myManageHook = composeAll
    [ className =? "Gimp"      --> doFloat
    , className =? "Vncviewer" --> doFloat
    ]

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ ewmh $ docks defaultConfig
        { manageHook = myManageHook <+> manageHook defaultConfig -- make sure to include myManageHook definition from above
        , layoutHook = avoidStruts  $  myLayout
        , startupHook = myStartupHook
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        , terminal = "urxvtc"
        , workspaces = ["web", "irc", "code" ] ++ map show [4..9]
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "slock")
        , ((mod4Mask .|. shiftMask, xK_p), spawn "rofi -show run")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), spawn "scrot")
        ]
