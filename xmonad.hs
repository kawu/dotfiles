import XMonad
-- import XMonad.Hooks.DynamicLog (dynamicLogWithPP, xmobarPP)
import qualified XMonad.Hooks.DynamicLog as Log
import qualified XMonad.Hooks.ManageDocks as Docks
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig (additionalKeys)
import qualified XMonad.Layout.IndependentScreens as LIS
import qualified Graphics.X11.ExtraTypes.XF86 as XF86
import qualified XMonad.Actions.NoBorders as NoBorders

import System.IO (hPutStrLn)

main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ Docks.docks def
    { manageHook = Docks.manageDocks <+> manageHook defaultConfig
    , layoutHook = Docks.avoidStruts $ layoutHook defaultConfig
    -- , layoutHook = Docks.avoidStruts $ myLayout
    , logHook = Log.dynamicLogWithPP Log.xmobarPP
        { Log.ppOutput = hPutStrLn xmproc
        , Log.ppTitle = Log.xmobarColor "green" "" . Log.shorten 50
        }
    , modMask = mod4Mask     -- Rebind Mod to the Windows key
    }
    `additionalKeys`
    [
    -- function keys
      ((0, XF86.xF86XK_MonBrightnessUp), spawn "sudo sysbacklight up")
    , ((0, XF86.xF86XK_MonBrightnessDown), spawn "sudo sysbacklight down")
    , ((0, XF86.xF86XK_AudioLowerVolume), spawn "amixer set Master 2-")
    , ((0, XF86.xF86XK_AudioRaiseVolume), spawn "amixer set Master 2+")
    -- , ((0, XF86.xF86XK_AudioMute), spawn "amixer set Master toggle")
    , ((0, XF86.xF86XK_AudioMute), spawn "amixer -D pulse set Master 1+ toggle")

    , ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock; xset dpms force off")

    -- toggle showing xmobar
    , ((mod4Mask, xK_b), sendMessage Docks.ToggleStruts)
    , ((mod4Mask .|. shiftMask, xK_b), withFocused NoBorders.toggleBorder)
    ]


-- myLayout =
--   tiled ||| Mirror tiled ||| NoBorders.noBorders Full
--   where
--     -- default tiling algorithm partitions the screen into two panes
--     tiled   = Tall nmaster delta ratio
--  
--     -- The default number of windows in the master pane
--     nmaster = 1
--  
--     -- Default proportion of screen occupied by master pane
--     ratio   = 1/2
--  
--     -- Percent of screen to increment by when resizing panes
--     delta = 3/100
