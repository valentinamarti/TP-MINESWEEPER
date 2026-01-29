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

-- | Reveals one step of the expansion (NO recursion here).
revealOnePosition :: Position -> Board -> (Board, [Position])
revealOnePosition pos board =
    let 
        cell = (getCell board pos)
    in     
        case cell of
            (Revealed, _) -> (board, [])
            (Flagged, _)  -> (board, [])
            (Hidden, Mine) -> (updateCell board pos (revealCell cell), [])
            (Hidden, Safe n) ->
                let
                    board1 = updateCell board pos (revealCell cell)
                in
                    case n of
                        0 -> (board1, getNeighbours board1 pos)  
                        _ -> (board1, [])

-- | Reveals a whole list of positions (one pass) and return next pending positions
revealBatchPositions :: Board -> [Position] -> (Board, [Position])
revealBatchPositions board pending = foldr
    (\p (bAcc, pendAcc) ->
        let
          (bAcc1, newPs) = revealOnePosition p bAcc
        in
          (bAcc1, newPs ++ pendAcc)
    )
    (board, [])
    pending

-- | Flood fill using pure recursion (pattern matching)
revealConnectedZeros :: Board -> [Position] -> Board
revealConnectedZeros board [] = board
revealConnectedZeros board pending = 
      let
        (board1, newPending) = revealBatchPositions board pending
      in
        revealConnectedZeros board1 newPending

-- | Public entry point: reveal/expand starting from one position.
revealCellAt :: Board -> Position -> Board
revealCellAt board pos = revealConnectedZeros board [pos]

-- | Board bounds for a rectangular board.
createBoardBounds :: Int -> Int -> (Position, Position)
createBoardBounds maxRow maxCol = ((0, 0), (maxRow, maxCol))

-- | All positions in a rectangular board.
generateAllBoardPositions :: Int -> Int -> [Position]
generateAllBoardPositions maxRow maxCol = [(r, c) | r <- [0..maxRow], c <- [0..maxCol]]

-- | Base cell: mines are Mine, non-mines start as Safe 0.
createBaseCell :: [Position] -> Position -> Cell
createBaseCell minePositions pos =
  if pos `elem` minePositions
    then (Hidden, Mine)
    else (Hidden, Safe 0)

-- | Build a board from a "position -> cell" function.
buildBoardFromCellFn :: Int -> Int -> (Position -> Cell) -> Board
buildBoardFromCellFn maxRow maxCol cellFn =
  let
    boardBounds = createBoardBounds maxRow maxCol
    allPositions = generateAllBoardPositions maxRow maxCol
    associations = map (\pos -> (pos, cellFn pos)) allPositions
  in
    array boardBounds associations

-- | Base board: mines placed, non-mines are Safe 0
createBaseBoard :: Int -> Int -> [Position] -> Board
createBaseBoard maxRow maxCol minePositions = buildBoardFromCellFn maxRow maxCol (createBaseCell minePositions)

-- | Final cell: mines are Mine, non-mines are Safe (countAdjacentMines baseBoard pos).
createFinalCell :: Board -> [Position] -> Position -> Cell
createFinalCell baseBoard minePositions pos =
  if pos `elem` minePositions
    then (Hidden, Mine)
    else
      let mineCount = countAdjacentMines baseBoard pos
      in (Hidden, Safe mineCount)

-- | Create initial board from mine positions.
createInitialBoard :: Int -> Int -> [Position] -> Board
createInitialBoard maxRow maxCol minePositions =
  let
    baseBoard = createBaseBoard maxRow maxCol minePositions
  in
    buildBoardFromCellFn maxRow maxCol (createFinalCell baseBoard minePositions)

