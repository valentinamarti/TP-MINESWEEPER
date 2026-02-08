module View.Geometry where

import Data.Array (inRange)
import Graphics.Gloss
import View.Constants (cellSize)
import Types (Position)

-- | Board width in pixels.
boardWidth :: Int -> Int -> Float
boardWidth _ maxCol = fromIntegral (maxCol + 1) * cellSize

boardHeight :: Int -> Int -> Float
boardHeight maxRow _ = fromIntegral (maxRow + 1) * cellSize

-- | Left edge of the board in pixels (Gloss: origin at center, board centered).
leftEdge :: Int -> Int -> Float
leftEdge maxRow maxCol = -boardWidth maxRow maxCol / 2

-- | Top edge of the board in pixels.
topEdge :: Int -> Int -> Float
topEdge maxRow maxCol = boardHeight maxRow maxCol / 2

-- | Column index from pixel X.
colIdx :: Int -> Int -> Float -> Int
colIdx maxRow maxCol px = floor ((px - leftEdge maxRow maxCol) / cellSize)

-- | Row index from pixel Y.
rowIdx :: Int -> Int -> Float -> Int
rowIdx maxRow maxCol py = floor ((topEdge maxRow maxCol - py) / cellSize)

-- | Convert pixel coordinates (Gloss: origin at center) to board (row, col).
pixelToCell :: Float -> Float -> Int -> Int -> Maybe Position
pixelToCell px py maxRow maxCol =
  if inRange ((0, 0), (maxRow, maxCol)) pos then Just pos else Nothing
  where
    pos = (rowIdx maxRow maxCol py, colIdx maxRow maxCol px)

-- | Center of cell (row, col) in pixel coordinates.
cellCenter :: Int -> Int -> Int -> Int -> (Float, Float)
cellCenter row col maxRow maxCol =
  ( leftEdge maxRow maxCol + (fromIntegral col + 0.5) * cellSize
  , topEdge maxRow maxCol - (fromIntegral row + 0.5) * cellSize
  )
