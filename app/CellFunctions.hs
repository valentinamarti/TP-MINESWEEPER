module CellFunctions where

import Types

-- | Check if a cell contains a mine
isMine :: Cell -> Bool
isMine (_, Mine) = True
isMine _ = False

-- | Check if a cell is revealed
isRevealed :: Cell -> Bool
isRevealed (Revealed, _) = True
isRevealed _ = False

-- | Check if a cell is flagged
isFlagged :: Cell -> Bool
isFlagged (Flagged, _) = True
isFlagged _ = False

-- | Check if a cell is hidden
isHidden :: Cell -> Bool
isHidden (Hidden, _) = True
isHidden _ = False

-- | Change state to Revealed
revealCell :: Cell -> Cell
revealCell (_, content) = (Revealed, content)

-- | Change state to Flagged
flagCell :: Cell -> Cell
flagCell (_, content) = (Flagged, content)

-- | Change state to Hidden
unflagCell :: Cell -> Cell
unflagCell (_, content) = (Hidden, content)
