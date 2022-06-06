-- Xmonad is a dynamically tiling X11 window manager that is written and
-- configured in Haskell. Official documentation: https://xmonad.org

-- Base
import XMonad hiding ( (|||) )
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

-- Data
import Data.Monoid
import qualified Data.Map        as M

-- Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

-- Layouts
import XMonad.Layout.Accordion
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Grid
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.TwoPane

-- Layouts modifiers
import XMonad.Layout hiding ( (|||) )
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.Magnifier
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile

-- Utilities
import XMonad.Util.Cursor
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Loggers
import XMonad.Util.Ungrab
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.SpawnOnce

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
myTerminal = "urxvtc"

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
myWorkspaces :: [String]
myWorkspaces = ["WWW","IRC","Email","Code","Shell"]

-- Now run xmonad with all the defaults available
main :: IO ()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . docks
     . withEasySB (statusBarProp "xmobar ~/.config/xmobar/xmobarrc2" (pure myXmobarPP)) defToggleStrutsKey
     $ myConfig

myConfig = def
    { modMask            = myModMask                                   -- Rebind Mod to the Super key
    , layoutHook         = smartBorders . avoidStruts $ myLayout       -- Use custom layouts
    , manageHook         = myManageHook <+> manageHook def             -- Match on certain windows
    , startupHook        = myStartupHook
    , focusedBorderColor = myFocusedBorderColor
    , normalBorderColor  = myNormalBorderColor
    , borderWidth        = myBorderWidth
    , terminal           = myTerminal
    , workspaces         = myWorkspaces
    }
  `additionalKeysP` myKeys

-- Startup hook
myStartupHook :: X ()
myStartupHook = do
    spawnOnce "nitrogen --restore &"
    spawnOnce "picom &"
    spawnOnce "lxpolkit &"
    spawnOnce "urxvtd -q -o -f &"
    setWMName "LG3D"
    setDefaultCursor xC_left_ptr

-- Window rules
myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "Gimp"           --> doFloat
    , isDialog                      --> doFloat
    , className =? "MPlayer"        --> doFloat
    , className =? "Xmessage"       --> doFloat
    , className =? "Firefox-esr"    --> doShift "WWW"
    ]

-- Key bindings
myKeys :: [(String, X ())]
myKeys = [ ("M-S-z"    , spawn "slock"                     )
         , ("M-S-="    , unGrab *> spawn "scrot -s"        )
         , ("M-]"      , spawn "firefox-esr"               )
         , ("M-S-p"    , spawn "rofi -show run"            )
         , ("M-S-t"    , spawn "urxvtc"                    )
         , ("M-C-f"    , sendMessage $ JumpToLayout "Full" )
         ]

-- The available layouts
myLayout =
  tiled
  ||| Mirror tiled
  ||| Full
  ||| emptyBSP
  ||| Grid
  ||| spiral(6/7)
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

-- Status bar configurations
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
