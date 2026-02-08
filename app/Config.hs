module Config where

import Types (Level(..), BoardSize(..))

-- | Board dimensions (0..maxRow, 0..maxCol) for each size preset.
boardSizeToDims :: BoardSize -> (Int, Int)
boardSizeToDims Small  = (8, 8)
boardSizeToDims Med    = (10, 10)
boardSizeToDims Large  = (12, 12)

-- | Mine density by level (fraction of cells that are mines).
levelToDensity :: Level -> Float
levelToDensity Easy   = 0.1
levelToDensity Medium = 0.2
levelToDensity Hard   = 0.3

-- | Minimum number of mines (e.g. Fácil + Chico = 10).
minMines :: Int
minMines = 10

-- | Number of mines from level and board size (at least minMines).
numMinesForLevelAndSize :: Level -> BoardSize -> Int
numMinesForLevelAndSize level sz =
  let (maxR, maxC) = boardSizeToDims sz
      totalCells = (maxR + 1) * (maxC + 1)
      n = floor (fromIntegral totalCells * levelToDensity level)
  in max minMines n
