import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks


-- layouts = avoidStruts (tiled ||| Mirror tiled ||| Full) ||| Full
--    where tiled   = Tall nmaster delta ratio
--          nmaster = 1
--          ratio = 1/2
--          delta = 3/100

main = do
    xmonad $ def
        { terminal = "xfce4-terminal"
          , modMask = mod4Mask
--          , layoutHook = layouts
--          , logHook = dynamicLogWithPP dzenPP
        }
