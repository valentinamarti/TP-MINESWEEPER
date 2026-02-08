module View.BoardView where

import Data.Array (bounds)
import Graphics.Gloss
import View.Colors ( numberColor, hiddenCellColor, mineCellColor, safeCellColor
              , flagColor, borderColor, shadowColor, shadowColorSoft, bevelHighlight )
import Types ( Board, Cell, CellState(Hidden, Revealed, Flagged)
            , CellContent(Mine, Safe) )
import Board (getCell)
import View.Constants (cellSize, shadowOffset, shadowOffsetSoft)
import View.Geometry (cellCenter)
import View.Buttons (thickRectFrame)

-- | Double shadow behind a cell for depth
cellShadow :: Float -> Float -> Picture
cellShadow cx cy =
  Pictures
  [ translate (cx + shadowOffsetSoft) (cy - shadowOffsetSoft)
    (Color shadowColorSoft (rectangleSolid (cellSize + 2) (cellSize + 2)))
  , translate (cx + shadowOffset) (cy - shadowOffset)
    (Color shadowColor (rectangleSolid cellSize cellSize))
  ]

-- | Subtle top-left highlight on a cell (bevel) for a raised look.
cellBevel :: Float -> Float -> Picture
cellBevel cx cy =
  let h = cellSize / 2
      t = 1.2
  in translate cx cy $
     Pictures
     [ translate 0 (h - t/2) (Color bevelHighlight (rectangleSolid (cellSize - 2) t))
     , translate (-h + t/2) 0 (Color bevelHighlight (rectangleSolid t (cellSize - 2)))
     ]

-- | Draw a single cell (hidden, flagged, mine, empty or number).
drawCell :: Int -> Int -> Int -> Int -> Cell -> Picture
drawCell row col maxRow maxCol cell =
  case cell of
    (Hidden, _) ->
      Pictures [cellShadow cx cy, Color hiddenCellColor cellPic, cellBevel cx cy, Color borderColor (translate cx cy (thickRectFrame (cellSize/2) (cellSize/2)))]
    (Flagged, _) ->
      Pictures [cellShadow cx cy, Color hiddenCellColor cellPic, cellBevel cx cy, Color flagColor (translate cx cy (circle 10)), Color borderColor (translate cx cy (thickRectFrame (cellSize/2) (cellSize/2)))]
    (Revealed, Mine) ->
      Pictures [cellShadow cx cy, Color mineCellColor cellPic, Color borderColor (translate cx cy (circle 8)), Color borderColor (translate cx cy (thickRectFrame (cellSize/2) (cellSize/2)))]
    (Revealed, Safe 0) ->
      Pictures [cellShadow cx cy, Color safeCellColor cellPic, Color borderColor (translate cx cy (thickRectFrame (cellSize/2) (cellSize/2)))]
    (Revealed, Safe n) ->
      Pictures [cellShadow cx cy, Color safeCellColor cellPic, Color (numberColor n) (translate cx (cy - 2) (Scale 0.22 0.22 (Text (show n)))), Color borderColor (translate cx cy (thickRectFrame (cellSize/2) (cellSize/2)))]
  where
    (cx, cy) = cellCenter row col maxRow maxCol
    cellPic = translate cx cy (rectangleSolid cellSize cellSize)

-- | Get board dimensions (maxRow, maxCol) from a Board.
boardDimensions :: Board -> (Int, Int)
boardDimensions brd = snd (bounds brd)

-- | Draw the whole board (all cells).
drawBoard :: Board -> Picture
drawBoard b = Pictures [ drawCell r c maxR maxC (getCell b (r, c)) | r <- [0..maxR], c <- [0..maxC] ]
  where (maxR, maxC) = boardDimensions b
