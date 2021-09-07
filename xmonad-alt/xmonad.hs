import Control.Monad (forM, forM_)

import XMonad
-- import XMonad.Hooks.DynamicLog (dynamicLogWithPP, xmobarPP)
import qualified XMonad.Hooks.DynamicLog as Log
import qualified XMonad.Hooks.ManageDocks as Docks
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Util.EZConfig (additionalKeys)
import qualified XMonad.Layout.IndependentScreens as LIS
import qualified Graphics.X11.ExtraTypes.XF86 as XF86
import qualified XMonad.Actions.NoBorders as NoBorders

import System.IO (hPutStrLn)

setDualScreen :: X ()
setDualScreen = do
  spawnOnce "xrandr --output eDP-1 --primary --mode 1920x1200 --pos 0x0 --rotate normal --output DP-1 --off --output DP-2 --off --output DP-3 --mode 1920x1080 --pos 1920x0 --rotate normal"

setSingleScreen :: X ()
setSingleScreen = do
  spawnOnce "xrandr --output eDP-1 --primary --mode 1920x1200 --pos 0x0 --rotate normal --output DP-1 --off --output DP-2 --off --output DP-3 --off"

myStartupHook :: Int -> X ()
myStartupHook screenNum = do

  if screenNum > 1
    then setDualScreen
    else setSingleScreen

  -- spawnOnce "nitrogen --restore &"
  -- spawnOnce "picom &"
  spawnOnce "nm-applet &"
  spawnOnce "udiskie --tray &"
  -- spawnOnce "feh --bg-scale /usr/share/backgrounds/gnome/Icescape.jpg &"
  spawnOnce "feh --bg-scale /usr/share/backgrounds/gnome/ColdWarm.jpg &"
  spawnOnce "volumeicon &"
  -- spawnOnce "blueman-applet &"
  -- Do not use the main (laptop) monitor in case there's another one available
  spawnOnce $ unwords
    -- [ "trayer --edge top --align right --height 34 --width 10 --SetDockType true --SetPartialStrut true --expand true"
    [ "trayer --edge top --align right --height 17 --width 10 --SetDockType true --SetPartialStrut true --expand true"
    , "--monitor", show $ if screenNum > 1 then 1 else 0 :: Int
    , "--monitor 0"
    , "--transparent true --alpha 0 --tint 0x0 &"
    ]

  -- set up screenlock
  spawnOnce "xautolock -time 10 -locker slock &"

  -- TOOD: in case of "soft xmonad reload" (mask + Q), all the commands above
  -- are re-run I think.  This is not what we want I guess?

    -- --padding 6 --widthtype request
  -- spawnOnce "/usr/bin/emacs --daemon &"
  -- -- spawnOnce "kak -d -s mysession &"
  -- setWMName "LG3D"


main :: IO ()
main = do
  -- Spawn one xmobar session per each screen
  screenNum <- LIS.countScreens
  xmprocs <- forM [0 .. screenNum-1 :: Int] $ \k -> do
    spawnPipe $ "xmobar -x " ++ show k

  xmonad $ Docks.docks def
    { manageHook = Docks.manageDocks <+> manageHook def
    -- , layoutHook = Docks.avoidStruts $ myLayout
    , layoutHook = Docks.avoidStruts $ layoutHook def
    -- Handle each xmobar session individually
    , logHook = forM_ xmprocs $ \xmproc -> do
        Log.dynamicLogWithPP Log.xmobarPP
          { Log.ppOutput = hPutStrLn xmproc
          , Log.ppTitle = Log.xmobarColor "green" "" . Log.shorten 50
          }
    , startupHook = myStartupHook screenNum
    , modMask = mod4Mask     -- Rebind Mod to the Windows key
    }
    `additionalKeys`
    [
    -- function keys
      ((0, XF86.xF86XK_MonBrightnessUp), spawn "sysbacklight up")
    , ((0, XF86.xF86XK_MonBrightnessDown), spawn "sysbacklight down")

    , ((0, XF86.xF86XK_AudioLowerVolume), spawn "amixer set Master 1%-")
    , ((0, XF86.xF86XK_AudioRaiseVolume), spawn "amixer set Master 1%+")
    , ((0, XF86.xF86XK_AudioMute), spawn "amixer set Master toggle")
    -- , ((0, XF86.xF86XK_AudioMute), spawn "amixer -D pulse set Master 1+ toggle")

    -- , ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock; xset dpms force off")
    , ((mod4Mask .|. shiftMask, xK_z), spawn "slock")
    -- , ((mod4Mask .|. shiftMask, xK_s), spawn "systemctl suspend")

    -- toggle showing xmobar
    , ((mod4Mask, xK_b), sendMessage Docks.ToggleStruts)
    , ((mod4Mask .|. shiftMask, xK_b), withFocused NoBorders.toggleBorder)

    -- -- backlight again
    -- , ((mod4Mask .|. shiftMask, xK_k), spawn "sysbacklight up")
    -- , ((mod4Mask .|. shiftMask, xK_j), spawn "sysbacklight down")
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
