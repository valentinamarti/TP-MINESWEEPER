module GameLogic where

import Control.Monad.State
import Types (Game(..), GameState(Playing, Lost, Won), Position)
import Board (allNonMinesRevealed, revealCellAt, toggleFlagAt, getCell)
import CellFunctions (isMine, isRevealed, isFlagged)

-- | Update game when player left-clicks (reveal cell).
handleReveal :: Position -> State Game ()
handleReveal pos = do
  g <- get
  case gameState g of
    Playing -> do
      let newBoard = revealCellAt (board g) pos
      let cell = getCell newBoard pos
      let lost = isRevealed cell && isMine cell
      let won = not lost && allNonMinesRevealed newBoard
      let newState | lost = Lost
                   | won  = Won
                   | otherwise = Playing
      put (g { board = newBoard, gameState = newState })
    _ -> return ()

-- | Update game when player right-clicks (toggle flag).
handleFlag :: Position -> State Game ()
handleFlag pos = do
  g <- get
  case gameState g of
    Playing -> do
      let newBoard = toggleFlagAt (board g) pos
      let cell = getCell newBoard pos
      let delta = if isFlagged cell then -1 else 1
      put (g { board = newBoard, minesRemaining = minesRemaining g + delta })
    _ -> return ()
