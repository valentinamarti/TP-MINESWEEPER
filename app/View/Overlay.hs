module View.Overlay where

import Graphics.Gloss
import View.Colors (overlayDimColor, overlayBoxColor, borderColor, shadowColor, shadowColorSoft)
import Types (GameState(Lost, Won), LostAction(BackToMenu, QuitGame))
import View.Constants (lostBackX, lostQuitX, lostBtnW, lostBtnH, lostButtonsY)
import View.Text (drawOverlayTitle)
import View.Buttons (drawOverlayBtn, pointInRect, thickRectFrame)

-- | Overlay when the game is lost or won: dim, box, title, two buttons.
overlay :: GameState -> Picture
overlay Lost = gameOverOverlay "You Lost"
overlay Won  = gameOverOverlay "You Won"
overlay _    = Blank

gameOverOverlay :: String -> Picture
gameOverOverlay msg = Pictures
  [ Color overlayDimColor (rectangleSolid 1200 1200)
  , translate 4 (-4) (Color shadowColorSoft (rectangleSolid 328 148))
  , translate 2 (-2) (Color shadowColor (rectangleSolid 324 144))
  , Color overlayBoxColor (translate 0 0 (rectangleSolid 320 140))
  , Color borderColor (translate 0 0 (thickRectFrame 160 70))
  , drawOverlayTitle msg
  , drawOverlayBtn lostBackX lostButtonsY "Back to Menu"
  , drawOverlayBtn lostQuitX lostButtonsY "End Game"
  ]

-- | Detect which overlay button was clicked (if any).
lostOverlayClick :: Float -> Float -> Maybe LostAction
lostOverlayClick px py
  | pointInRect px py lostBackX lostButtonsY lostBtnW lostBtnH = Just BackToMenu
  | pointInRect px py lostQuitX lostButtonsY lostBtnW lostBtnH = Just QuitGame
  | otherwise = Nothing
