import Graphics.X11.ExtraTypes.XF86
import XMonad
import XMonad.ManageHook
import qualified XMonad
import qualified Data.Map as M
-- Actions
import XMonad.Actions.SpawnOn
import XMonad.Actions.TopicSpace
import XMonad.Actions.DynamicWorkspaceGroups
-- Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
-- Layout
import XMonad.Layout.Dwindle
import XMonad.Layout.Gaps
import XMonad.Layout.Magnifier
import XMonad.Layout.Spacing
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Fullscreen
import XMonad.Prompt.Workspace
import qualified XMonad.StackSet as W
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
-- Utils
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig
import XMonad.Util.Loggers
import XMonad.Util.SpawnOnce
import XMonad.Util.Ungrab
import XMonad.Util.NamedScratchpad
-- Data
import Data.Monoid
--Propmpt
import XMonad.Prompt (XPConfig (..), XPPosition (CenteredAt), deleteAllDuplicates, emacsLikeXPKeymap)
import XMonad.Prompt.XMonad

-- Variables
myTerminal :: String
myTerminal = "alacritty"

main :: IO ()
main =
  xmonad
    . ewmhFullscreen
    . ewmh
    $ withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) 
                 defToggleStrutsKey
                 myConfig

myConfig =
  def
    { modMask = mod4Mask, -- Rebind Mod to the Super key
      workspaces = myWorkspaces,
      layoutHook = avoidStruts $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) $ spacingWithEdge 5 $ myLayout, -- Use custom layouts
      startupHook = myStartupHook,
      manageHook = myManageHook,
      terminal = myTerminal
    }
    `additionalKeysP` [ ("M-S-z", spawn "xscreensaver-command -lock"),
                        ("M-S-=", unGrab *> spawn "scrot -s"),
                        ("M-]", spawn "firefox"),
                        ("M-p", spawn "rofi -combi-modi window,drun,ssh  -show combi -icon-theme 'Papirus' -show-icons"),
                        ("M-o", spawn "dmenu_run"),
                        ("M-s k", spawn "dmenu-pkill -cpu"),
                        -- Screenshot
                        ("M-s p", spawn "flameshot gui"),
                        -- FullScreen
                        --("M-s f", toggleCollapse),
                        ("M-s f", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts), -- full screen view
                        -- Volume controls
                        ("M-<F2>", spawn "amixer set Master 2%-"),
                        ("M-<F3>", spawn "amixer set Master 2%+"),
                        ("<XF86AudioLowerVolume>", spawn "amixer set Master 2%-"),
                        ("<XF86AudioRaiseVolume>", spawn "amixer set Master 2%+"),
                        -- Brightness
                        ("<XF86MonBrightnessDown>", spawn "lux -s 10%"),
                        ("<XF86MonBrightnessUp>", spawn "lux -a 10%"),
                        -- Dynamic Workspace
                        ("M-y n", promptWSGroupAdd myXPConfig "Name this group: "),
                        ("M-y g", promptWSGroupView myXPConfig "Go to group: "),
                        ("M-y d", promptWSGroupForget myXPConfig "Forget group: "),
                        -- Scratchpads
                        ("M-s t", namedScratchpadAction myScratchPads "terminal"),
                        ("M-s e", namedScratchpadAction myScratchPads "emacs-scratch"),
                        ("M-s m", namedScratchpadAction myScratchPads "music"),
                        ("M-s n", spawn "/home/juice/Personal/quick-search/mdn-search.sh")
                      ]


-- Scratchpads
myScratchPads :: [NamedScratchpad]
myScratchPads = [ 
                NS "terminal" spawnTerm findTerm manageTerm,
                NS "emacs-scratch" spawnEmacsScratch findEmacsScratch defaultFloating,
                NS "music" spawnPav findPav managePav
              ]
  where
    spawnTerm = myTerminal ++ " -t scratchpad"
    findTerm = title =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 1
                 w = 1
                 t = 1 -h
                 l = 1 -w
    findEmacsScratch = title =? "emacs-scratch"
    -- spawnEmacsScratch = "emacsclient -a='' -nc -F='(quote (name . \"emacs-scratch\"))' "
    -- spawnEmacsScratch = "emacsclient --alternate-editor='' --no-wait --create-frame --frame-parameters='(quote (name . \"emacs-scratch\"))'"
    spawnEmacsScratch = "emacsclient --alternate-editor='' -nc --frame-parameters='(quote (name . \"emacs-scratch\"))'"
    manageEmacs = customFloating $ W.RationalRect l t w h
               where
                 h = 0.7
                 w = 0.7
                 t = 0.7 -h
                 l = 0.7 -w
    spawnPav = "spotify"
    findPav = className=? "Spotify"
    managePav = customFloating $ W.RationalRect l t w h -- and I'd like it fixed using the geometry below
               where
                  h = 1
                  w = 1
                  t = 1 -h
                  l = 1 -w


-- Propmt config
myXPConfig :: XPConfig
myXPConfig = def
    { promptBorderWidth = 1
    , position = CenteredAt (2 / 4) (2 / 6)
    , height = 30
    , historySize = 50
    , historyFilter = deleteAllDuplicates
    , defaultText = []
    , autoComplete = Nothing
    , showCompletionOnTab = False
    , alwaysHighlight = True
    , maxComplRows = Just 5
    , promptKeymap = emacsLikeXPKeymap
    }


-- Hooks
myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook =
  composeAll
    [ className =? "Gimp" --> doFloat,
      isDialog --> doFloat,
      title =? "Mozilla Firefox" --> doShift ( myWorkspaces !! 3 ),
      className =? "Google-chrome" --> doShift (myWorkspaces !! 1),
      className =? "Spotify" --> doShift (myWorkspaces !! 7)
    ] <+> namedScratchpadManageHook myScratchPads

myStartupHook = do
  -- spawnOn "1:chat" "/var/lib/snapd/snap/bin/slack"
  spawnOn "4:music" "qutebrowser"
  spawn "polybar -q example -c ~/.config/polybar/config.ini"
  -- spawnOn "2:work" "/usr/bin/google-chrome-stable"

myWorkspaces = ["1:chat", "2:work", "3:dev", "4:personal", "5:personal", "6", "7", "8:music", "9"]


toggleCollapse :: X ()
toggleCollapse = do
  sendMessage ToggleStruts
  toggleWindowSpacingEnabled
  sendMessage ToggleGaps

-- Fullscreen
toggleFullscreen :: X ()
toggleFullscreen =
    withWindowSet $ \ws ->
    withFocused $ \w -> do
        let fullRect = W.RationalRect 0 0 1 1
        let isFullFloat = w `M.lookup` W.floating ws == Just fullRect
        windows $ if isFullFloat then W.sink w else W.float w fullRect

-- My Layouts --
myLayout = tiled ||| Mirror tiled ||| Full ||| threeCol ||| Spiral R XMonad.Layout.Dwindle.CCW (3/2) (11/10)
  where
    threeCol = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio
    tiled = Tall nmaster delta ratio
    nmaster = 1 -- Default number of windows in the master pane
    ratio = 1 / 2 -- Default proportion of screen occupied by master pane
    delta = 3 / 100 -- Percent of screen to increment by when resizing panes

-- xMobar --
myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = magenta " • "
    , ppTitle           = wrap (white    "[") (white    "]") . magenta . ppWindow
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap " " "" . xmobarBorder "Top" "#8be9fd" 2
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
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
