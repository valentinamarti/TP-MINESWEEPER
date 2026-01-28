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
