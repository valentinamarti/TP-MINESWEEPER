module Board where

import Data.Array (array, assocs, bounds, inRange, (!), (//))
import Types
import CellFunctions

-- | True if every cell is either revealed or a mine (victory condition).
allNonMinesRevealed :: Board -> Bool
allNonMinesRevealed b = all (\c -> isRevealed c || isMine c) (snd <$> assocs b)

-- | Get a cell at a specific position
-- | (!) :: Ix i => Array i e -> i -> e (from Data.Array)
getCell :: Board -> Position -> Cell
getCell b pos = b ! pos

-- | Update a cell at a specific position
-- | (//) :: Ix i => Array i e -> [(i, e)] -> Array i e (from Data.Array)
updateCell :: Board -> Position -> Cell -> Board
updateCell b pos cell = b // [(pos, cell)]

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
getNeighbours b pos =
    let
        -- bounds :: Array i e -> (i, i) (from Data.Array)
        boardBounds = bounds b
        -- inRange :: (i, i) -> i -> Bool (from Data.Array)
        isValidPosition = inRange boardBounds
        validNeighbours = filter isValidPosition (generateAllAdjacentPositions pos)
    in
        validNeighbours

-- | Get cells at multiple positions
-- map :: (a -> b) -> [a] -> [b]
getCellsAtPositions :: Board -> [Position] -> [Cell]
getCellsAtPositions b positions = map (getCell b) positions

-- | Count the number of mines in a list of cells
-- isMine :: Cell -> Bool (from CellFunctions)
-- length :: [a] -> Int (the og function)
-- filter :: (a -> Bool) -> [a] -> [a]
countMines :: [Cell] -> Int
countMines cells = length (filter isMine cells)

-- | Count the number of mines adjacent to a given position
countAdjacentMines :: Board -> Position -> Int
countAdjacentMines b pos =
    let
        neighbourPositions = getNeighbours b pos
        neighbourCells = getCellsAtPositions b neighbourPositions
        mineCount = countMines neighbourCells
    in
        mineCount

-- | Reveals one step of the expansion (NO recursion here).
revealOnePosition :: Position -> Board -> (Board, [Position])
revealOnePosition pos b =
    let
        cell = getCell b pos
    in
        case cell of
            (Revealed, _) -> (b, [])
            (Flagged, _)  -> (b, [])
            (Hidden, Mine) -> (updateCell b pos (revealCell cell), [])
            (Hidden, Safe n) ->
                let
                    b1 = updateCell b pos (revealCell cell)
                in
                    case n of
                        0 -> (b1, getNeighbours b1 pos)
                        _ -> (b1, [])

-- | Reveals a whole list of positions (one pass) and return next pending positions
revealBatchPositions :: Board -> [Position] -> (Board, [Position])
revealBatchPositions b pending = foldr
    (\p (bAcc, pendAcc) ->
        let
          (bAcc1, newPs) = revealOnePosition p bAcc
        in
          (bAcc1, newPs ++ pendAcc)
    )
    (b, [])
    pending

-- | Flood fill using pure recursion (pattern matching)
revealConnectedZeros :: Board -> [Position] -> Board
revealConnectedZeros b [] = b
revealConnectedZeros b pending =
      let
        (b1, newPending) = revealBatchPositions b pending
      in
        revealConnectedZeros b1 newPending

-- | Public entry point: reveal/expand starting from one position.
revealCellAt :: Board -> Position -> Board
revealCellAt b pos = revealConnectedZeros b [pos]

-- | Toggle flag at position: Hidden -> Flagged, Flagged -> Hidden
toggleFlagAt :: Board -> Position -> Board
toggleFlagAt b pos =
  let cell = getCell b pos
  in case cell of
       (Hidden, _)  -> updateCell b pos (flagCell cell)
       (Flagged, _) -> updateCell b pos (unflagCell cell)
       _            -> b

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

