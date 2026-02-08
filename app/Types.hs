module Types where

import Data.Array

-- | Visual State of the cell
data CellState = Hidden | Revealed | Flagged
    deriving (Eq, Show)

-- | What the cell hides
-- 'Safe Int' tells us how many adjacent mines are
data CellContent = Mine | Safe Int
    deriving (Eq, Show)

-- | A cell is the product of its state and its content
type Cell = (CellState, CellContent)

-- | The coordinates are defined by the pair (row, column)
type Position = (Int, Int)

-- | The board is an array indexed by Position
type Board = Array Position Cell

-- | Represents the state of the game
data GameState = Playing | Won | Lost
    deriving (Eq, Show)

-- | Represents the full game
data Game = Game
    { board :: Board
    , minesRemaining :: Int
    , gameState :: GameState
    }  deriving (Eq, Show)

-- | Difficulty level (percentage of cells that are mines, approx.)
data Level = Easy | Medium | Hard
    deriving (Eq, Show, Bounded, Enum)

-- | Board size preset: (maxRow, maxCol)
data BoardSize = Small | Med | Large
    deriving (Eq, Show, Bounded, Enum)

-- | State of the start menu (level and size selection).
data MenuState = MenuState
    { menuLevel :: Level
    , menuSize  :: BoardSize
    } deriving (Eq, Show)

-- | Action triggered by a click on the menu.
data MenuAction = StartGame | SelectLevel Level | SelectSize BoardSize
    deriving (Eq, Show)

-- | Action triggered by a click on the "You Lost" overlay.
data LostAction = BackToMenu | QuitGame
    deriving (Eq, Show)

-- | Full app state: either at menu or in a game.
data AppState = Menu MenuState | InGame Game
    deriving (Eq, Show)
