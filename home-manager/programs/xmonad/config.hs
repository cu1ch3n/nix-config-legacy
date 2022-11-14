import Control.Monad (forM_, join)
import Data.Function (on)
import Data.List (sortBy)
import XMonad
import XMonad.Actions.DynamicProjects
import XMonad.Hooks.DynamicLog (xmobarProp)
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Hooks.ManageDocks (avoidStruts, ToggleStruts (ToggleStruts))
import XMonad.Layout.Gaps (Direction2D (..), gaps)
import XMonad.Layout.Magnifier (magnifiercz')
import XMonad.Layout.MultiToggle.Instances (StdTransformers (NBFULL))
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.Spacing (spacing)
import XMonad.Layout.ThreeColumns (ThreeCol (ThreeColMid))
import XMonad.Prompt
import XMonad.StackSet (focusDown, focusUp, swapDown, swapUp)
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig (additionalKeysP, removeKeysP)
import XMonad.Util.NamedWindows (getName)
import XMonad.Util.Run (safeSpawn)
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Layout.ResizableTile
import XMonad.Layout.MultiToggle

main :: IO ()
main = do
  xmonad . ewmhFullscreen . ewmh . xmobarProp . dynamicProjects projects $ myConfig

myConfig =
  def
    { modMask = mod4Mask, -- Command/Windows key
      terminal = "alacritty",
      layoutHook = myLayoutHook,
      startupHook = myStartupHook,
      workspaces = myWorkspace,
      borderWidth = 2,
      normalBorderColor = "#D8DEE9",
      focusedBorderColor = "#8FBCBB",
      focusFollowsMouse = False,
      clickJustFocuses = False
    }
    `additionalKeysP` addKeys
    `removeKeysP` rmKeys

wwwWs :: WorkspaceId
wwwWs = "www"
fsmWs :: WorkspaceId
fsmWs = "fsm"
thmWs :: WorkspaceId
thmWs = "thm"
vbxWs :: WorkspaceId
vbxWs = "vbx"
musWs :: WorkspaceId
musWs = "mus"
pdfWs :: WorkspaceId
pdfWs = "pdf"
obsWs :: WorkspaceId
obsWs = "obs"
nixWs :: WorkspaceId
nixWs = "nix"
etcWs :: WorkspaceId
etcWs = "etc"


myWorkspace :: [WorkspaceId]
myWorkspace = [wwwWs, fsmWs, thmWs, vbxWs, musWs, pdfWs, obsWs, nixWs, etcWs]

projects :: [Project]
projects =
  [ Project
      { projectName = wwwWs,
        projectDirectory = "~/",
        projectStartHook = Just . spawn $ "chromium"
      },
    Project
      { projectName = fsmWs,
        projectDirectory = "~/",
        projectStartHook = Just . spawn $ "thunar"
      },
    Project
      { projectName = thmWs,
        projectDirectory = proofsDir,
        projectStartHook = Just . spawn $ "sublime4 " ++ proofsDir
      },
    Project
      { projectName = vbxWs,
        projectDirectory = "~/",
        projectStartHook = Just . spawn $ "VirtualBox"
      },
    Project
      { projectName = musWs,
        projectDirectory = "~/",
        projectStartHook = Just $ do
          spawn "alacritty -e spt"
          spawn "spotify"
      },
    Project
      { projectName = pdfWs,
        projectDirectory = "~/",
        projectStartHook = Just . spawn $ "sioyek"
      },
    Project
      { projectName = obsWs,
        projectDirectory = "~/Videos",
        projectStartHook = Just . spawn $ "obs"
      },
    Project
      { projectName = nixWs,
        projectDirectory = nixHomeDir,
        projectStartHook = Just . spawn $ "code -n " ++ nixHomeDir
      },

    Project
      { projectName = etcWs,
        projectDirectory = "~/",
        projectStartHook = Nothing
      }
  ]
  where
    proofsDir = "~/Research/Proofs"
    nixHomeDir = "~/nix-config"

addKeys :: [(String, X ())]
addKeys =
  [ ("M-<Space>", spawn "rofi -show drun"),
    ("M-C-<Space>", spawn "rofi -show window"),
    ("M-f", spawn "rofi -show filebrowser"),
    ("M-S-<Space>", switchProjectPrompt projectsTheme),
    ("M-/", shiftToProjectPrompt projectsTheme),
    ("M-<Tab>", sendMessage NextLayout),

    -- Focus
    ("M-<Left>", windows focusUp),
    ("M-<Right>", windows focusDown),
    ("M-S-<Left>", windows swapUp),
    ("M-S-<Right>", windows swapDown),

    -- Resize
    ("M-C-<Left>", sendMessage Shrink),
    ("M-C-<Right>", sendMessage Expand),
    ("M-C-<Up>", sendMessage MirrorExpand),
    ("M-C-<Down>", sendMessage MirrorShrink)
  ]

projectsTheme :: XPConfig
projectsTheme =
  amberXPConfig
    { bgColor = "#2E3440",
      fgColor = "#81A1C1",
      bgHLight = "#3B4252",
      fgHLight = "#8FBCBB",
      promptBorderWidth = 0,
      font = "xft:Fira Code:size=14:antialias=true",
      height = 100,
      position = CenteredAt 0.5 0.5
    }

rmKeys :: [String]
rmKeys = ["M-q"] -- let home-manger refresh settings

myLayoutHook =
  avoidStruts
    . smartBorders
    $ (tiled ||| full)
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled = gapSpaced 5 $ ResizableTall nmaster delta ratio []
    full = gapSpaced 5 Full

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio = 1 / 2

    -- Percent of screen to increment by when resizing panes
    delta = 5 / 100

    -- Gaps bewteen windows
    myGaps gap = gaps [(U, gap), (D, gap), (L, gap), (R, gap)]
    gapSpaced g = spacing g . myGaps g

myStartupHook :: X ()
myStartupHook = do
  spawnOnce "autorandr -c"
  spawnOnce "fcitx5"
  spawnOnce "mullvad-vpn"
