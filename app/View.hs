module View
  ( drawAppState
  , pixelToCell
  , gameBoardDimensions
  , menuClick
  , lostOverlayClick
  , exitButtonClick
  ) where

import Graphics.Gloss
import Types ( Game, AppState(Menu, InGame), board, gameState, minesRemaining )
import View.Geometry (pixelToCell)
import View.Menu (drawMenu, drawMineCounter, menuClick)
import View.Buttons (drawExitButton, exitButtonClick)
import View.Overlay (overlay, lostOverlayClick)
import View.BoardView (drawBoard, boardDimensions)

-- | Get board dimensions from a Game (for event handling).
gameBoardDimensions :: Game -> (Int, Int)
gameBoardDimensions g = boardDimensions (board g)

-- | Draw the whole app (menu or game) and the exit button on top.
drawAppState :: AppState -> Picture
drawAppState (Menu ms)   = Pictures [ drawMenu ms, drawExitButton ]
drawAppState (InGame g)  = Pictures [ drawGame g, drawExitButton ]

-- | Draw the whole game (mine counter + board + overlay if lost/won).
drawGame :: Game -> Picture
drawGame game = Pictures
  [ drawMineCounter (minesRemaining game) maxR maxC
  , drawBoard (board game)
  , overlay (gameState game)
  ]
  where (maxR, maxC) = boardDimensions (board game)