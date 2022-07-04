-- Xmonad is a dynamically tiling X11 window manager that is written and
-- configured in Haskell. Official documentation: https://xmonad.org

-- Base
import XMonad hiding ( (|||) )
import System.IO ( hPutStrLn )
import System.Exit
import qualified XMonad.StackSet as W

-- Data
import Control.Monad ( liftM2 )

-- Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers ( doFullFloat, doCenterFloat, isFullscreen, isDialog )
import XMonad.Hooks.SetWMName

-- Layouts
import XMonad.Layout.Accordion
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Grid
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.TwoPane

-- Layouts modifiers
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.Magnifier
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile

-- Utilities
import XMonad.Util.Cursor
import XMonad.Util.EZConfig ( additionalKeysP, removeKeysP )
import XMonad.Util.Run ( spawnPipe )
import XMonad.Util.SpawnOnce
import XMonad.Util.Ungrab

-- Whether focus follows the mouse pointer
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- "windows key" is usually mod4Mask
myModMask :: KeyMask
myModMask = mod4Mask

-- Sets default terminal
myTerminal :: String
myTerminal = "st"

-- Color of focused border
myFocusedBorderColor :: String
myFocusedBorderColor = "#5e81ac"

-- Color of inactive border
myNormalBorderColor :: String
myNormalBorderColor = "#a3be8c"

-- Width of border around windows
myBorderWidth :: Dimension
myBorderWidth = 1

-- Sets default font
myFont :: String
myFont = "-misc-fixed-*-*-*-*-13-*-*-*-*-*-*-*"

-- Workspaces
xmobarEscape = concatMap doubleLts
  where
    doubleLts '<' = "<<"
    doubleLts x   = [x]

myWorkspaces :: [String]
myWorkspaces = clickable . (map xmobarEscape)
             $ ["1:web","2:irc","3:mail","4:dev","5:gfx","6:media","7:term","8:dir","9:tmp"]
  where
    clickable l = [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>" |
                  (i,ws) <- zip [1..9] l,
                  let n = i ]

-- Startup hook
myStartupHook :: X ()
myStartupHook = do
    spawnOnce "nitrogen --restore &"
    spawnOnce "picom -b &"
    spawnOnce "lxpolkit &"
    spawnOnce "mpd &"
    spawnOnce "urxvtd -q -o -f &"
    spawnOnce "emacs --daemon &"
    setWMName "LG3D"
    setDefaultCursor xC_left_ptr

-- The available layouts
myLayout =
  tiled
  ||| Mirror tiled
  ||| Full
  ||| emptyBSP
  ||| Grid
  ||| spiral ( 6 / 7 )
  ||| twopane
  ||| Mirror twopane
  ||| threeCol
  ||| noBorders (tabbed shrinkText def)
  ||| Accordion
  where
    threeCol = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio
    twopane  = TwoPane delta ratio
    tiled    = ResizableTall nmaster delta ratio []
    nmaster  = 1      -- Default number of windows in the master pane
    ratio    = 1/2    -- Default proportion of screen occupied by master pane
    delta    = 3/100  -- Percent of screen to increment by when resizing panes

-- Window rules
myManageHook = composeAll . concat $
    [ [isDialog       --> doCenterFloat]
    , [className =? c --> doCenterFloat  | c <- myCFloats]
    , [title     =? t --> doFloat        | t <- myTFloats]
    , [resource  =? r --> doFloat        | r <- myRFloats]
    , [resource  =? i --> doIgnore       | i <- myIgnores]
    , [className =? c --> doShift (myWorkspaces !! 0) <+> viewShift (myWorkspaces !! 0) | c <- my1Shifts]
    , [className =? c --> doShift (myWorkspaces !! 1) <+> viewShift (myWorkspaces !! 1) | c <- my2Shifts]
    , [className =? c --> doShift (myWorkspaces !! 2) <+> viewShift (myWorkspaces !! 2) | c <- my3Shifts]
    , [className =? c --> doShift (myWorkspaces !! 3) <+> viewShift (myWorkspaces !! 3) | c <- my4Shifts]
    , [className =? c --> doShift (myWorkspaces !! 4) <+> viewShift (myWorkspaces !! 4) | c <- my5Shifts]
    , [className =? c --> doShift (myWorkspaces !! 5) <+> viewShift (myWorkspaces !! 5) | c <- my6Shifts]
    , [className =? c --> doShift (myWorkspaces !! 6) <+> viewShift (myWorkspaces !! 6) | c <- my7Shifts]
    , [className =? c --> doShift (myWorkspaces !! 7) <+> viewShift (myWorkspaces !! 7) | c <- my8Shifts]
    , [className =? c --> doShift (myWorkspaces !! 8) <+> viewShift (myWorkspaces !! 8) | c <- my9Shifts]
    ]
    where
    viewShift  = doF . liftM2 (.) W.greedyView W.shift
    myCFloats  = ["Galculator", "feh", "mpv", "Xfce4-terminal"]
    myTFloats  = ["Downloads", "Save As..."]
    myRFloats  = []
    myIgnores  = ["desktop_window"]
    my1Shifts  = ["Brave-browser", "Chromium", "Vivaldi-stable", "Firefox-esr"]
    my2Shifts  = ["Hexchat"]
    my3Shifts  = ["Mail", "Thunderbird"]
    my4Shifts  = ["Emacs", "Geany", "Sublime_text"]
    my5Shifts  = ["Gimp", "feh", "Inkscape", "Ristretto"]
    my6Shifts  = ["vlc", "mpv"]
    my7Shifts  = ["kitty", "st-256color", "Terminator", "URxvt"]
    my8Shifts  = ["Thunar", "nemo", "caja", "pcmanfm"]
    my9Shifts  = ["Transmission-gtk", "Uget-gtk"]

-- Status bars and logging
myLogHook :: X ()
myLogHook = fadeInactiveLogHook fadeAmount
  where fadeAmount = 1.0

-- Key bindings
myKeys :: [(String, X ())]
myKeys = [ ("M-<Return>"   , spawn "st"                                       )
         , ("M-S-<Return>" , spawn "thunar"                                   )
         , ("M-S-t"        , spawn "urxvtc"                                   )
         , ("M-]"          , spawn "firefox-esr"                              )
         , ("M-S-="        , unGrab *> spawn "scrot -s"                       )
         , ("M-C-f"        , sendMessage $ JumpToLayout "Full"                )
         , ("M-C-l"        , spawn "slock"                                    )
         , ("M-C-q"        , io ( exitWith ExitSuccess )                      )
         , ("M-C-r"        , spawn $ "xmonad --recompile && xmonad --restart" )
         , ("M-w"          , kill                                             )
         , ("M1-d"         , spawn "dmenu_run"                                )
         , ("M1-e"         , spawn "emacsclient -c -a 'emacs'"                )
         , ("M1-f"         , spawn "thunar"                                   )
         , ("M1-g"         , spawn "geany"                                    )
         , ("M1-n"         , spawn "nitrogen"                                 )
         , ("M1-r"         , spawn "rofi -show run"                           )
         , ("M1-t"         , spawn "transmission-gtk"                         )
         , ("M1-u"         , spawn "uget-gtk"                                 )
         , ("M1-v"         , spawn "pavucontrol"                              )
         , ("M1-w"         , spawn "brave-browser"                            )
         , ("M1-C-m"       , spawn "/usr/local/src/thunderbird/thunderbird"   )
         , ("M1-C-s"       , spawn "/usr/local/src/sublime_text/sublime_text" )
         , ("M1-C-w"       , spawn "/usr/local/src/waterfox/waterfox-bin"     )
         ]

-- Now run xmonad with all the defaults available
main :: IO ()
main = do
    xmproc0 <- spawnPipe "xmobar -x 0 $HOME/.config/xmobar/xmobarrc.hs"
    xmonad . ewmh . docks $ def
        { manageHook  = myManageHook <+> manageHook def
        , layoutHook  = smartBorders . avoidStruts $ myLayout
        , startupHook = myStartupHook
        , logHook     = myLogHook <+> dynamicLogWithPP xmobarPP
                            { ppOutput = hPutStrLn xmproc0
                            , ppTitle  = xmobarColor "green" "" . shorten 50 -- Title of active window
                            , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]     -- order of things in xmobar
                            }
        , modMask            = myModMask
        , focusFollowsMouse  = myFocusFollowsMouse
        , clickJustFocuses   = myClickJustFocuses
        , focusedBorderColor = myFocusedBorderColor
        , normalBorderColor  = myNormalBorderColor
        , borderWidth        = myBorderWidth
        , terminal           = myTerminal
        , workspaces         = myWorkspaces
        }

        `removeKeysP`

        [

        -- unused close window binding
        "M-S-c",

        -- unused terminal binding
        "M-S-<Return>",

        -- unused gmrun binding
        "M-S-p",

        -- unused exit Xmonad binding
        "M-S-q",

        -- unused dmenu binding
        "M-p",

        -- unused restart Xmonad binding
        "M-q"

        ]

        `additionalKeysP` myKeys
