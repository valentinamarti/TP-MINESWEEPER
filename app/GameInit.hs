module GameInit where

import Board (createInitialBoard)
import Config (boardSizeToDims, numMinesForLevelAndSize)
import RandomUtils (randomPositions, uniquePositionsAndCount)
import Types (Game(..), GameState(Playing), MenuState(..))

-- | Create initial game from menu choices (exactly numMines mines).
createInitialGameFromMenu :: MenuState -> IO Game
createInitialGameFromMenu ms = do
  let (maxR, maxC) = boardSizeToDims (menuSize ms)
      numMines = numMinesForLevelAndSize (menuLevel ms) (menuSize ms)
      totalCells = (maxR + 1) * (maxC + 1)
  positions <- randomPositions maxR maxC totalCells
  let (uniquePositions, _) = uniquePositionsAndCount positions
  let mines = take numMines uniquePositions
  let b = createInitialBoard maxR maxC mines
  return (Game { board = b
              , minesRemaining = numMines
              , gameState = Playing
              })
