module Board where

import Data.Array
import Types
import CellFunctions

-- | Get a cell at a specific position
-- | (!) :: Ix i => Array i e -> i -> e (from Data.Array)
getCell :: Board -> Position -> Cell
getCell board pos = board ! pos

-- | Update a cell at a specific position
-- | (//) :: Ix i => Array i e -> [(i, e)] -> Array i e (from Data.Array)
updateCell :: Board -> Position -> Cell -> Board
updateCell board pos cell = board // [(pos, cell)]

-- | Generate all 8 possible adjacent positions to a given position
generateAllAdjacentPositions :: Position -> [Position]
generateAllAdjacentPositions (row, col) = 
    let
        allPositions = 
            [ (row - 1, col - 1)  -- up-left
            , (row - 1, col)       -- up
            , (row - 1, col + 1)   -- up-right
            , (row, col - 1)       -- left
            , (row, col + 1)       -- right
            , (row + 1, col - 1)   -- down-left
            , (row + 1, col)       -- down
            , (row + 1, col + 1)   -- down-right
            ]
    in
        allPositions

-- | Get the 8 neighbours positions to a given position (handling board boundaries)
getNeighbours :: Board -> Position -> [Position]
getNeighbours board pos = 
    let
        -- bounds :: Array i e -> (i, i) (from from Data.Array)
        boardBounds = bounds board
        
        -- inRange :: (i, i) -> i -> Bool (from from Data.Array)
        isValidPosition = inRange boardBounds
        
        -- filter :: (a -> Bool) -> [a] -> [a] (the og function)
        validNeighbours = filter isValidPosition (generateAllAdjacentPositions pos)
    in
        validNeighbours

-- | Get cells at multiple positions
-- map :: (a -> b) -> [a] -> [b]
getCellsAtPositions :: Board -> [Position] -> [Cell]
getCellsAtPositions board positions = map (getCell board) positions

-- | Count the number of mines in a list of cells
-- isMine :: Cell -> Bool (from CellFunctions)
-- length :: [a] -> Int (the og function)
-- filter :: (a -> Bool) -> [a] -> [a]
countMines :: [Cell] -> Int
countMines cells = length (filter isMine cells)

-- | Count the number of mines adjacent to a given position
countAdjacentMines :: Board -> Position -> Int
countAdjacentMines board pos =
    let
        -- getNeighbours :: Board -> Position -> [Position]
        neighbourPositions = getNeighbours board pos
        
        -- getCellsAtPositions :: Board -> [Position] -> [Cell]
        neighbourCells = getCellsAtPositions board neighbourPositions
        
        -- countMines :: [Cell] -> Int
        mineCount = countMines neighbourCells
    in
        mineCount

