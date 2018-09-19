import XMonad
-- import XMonad.Hooks.DynamicLog (dynamicLogWithPP, xmobarPP)
import qualified XMonad.Hooks.DynamicLog as Log
import qualified XMonad.Hooks.ManageDocks as Docks
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig (additionalKeys)
import qualified Graphics.X11.ExtraTypes.XF86 as XF86
import System.IO (hPutStrLn)

main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ Docks.docks def
    { manageHook = Docks.manageDocks <+> manageHook defaultConfig
    , layoutHook = Docks.avoidStruts  $  layoutHook defaultConfig
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

    , ((mod4Mask, xK_b     ), sendMessage Docks.ToggleStruts)
    ]
