module View.Menu where

import Graphics.Gloss
import View.Colors (textColor)
import Types ( MenuState(..), MenuAction(StartGame, SelectLevel, SelectSize)
            , Level(Easy, Medium, Hard), BoardSize(Small, Med, Large) )
import View.Constants ( menuLabelX, levelY, sizeY, startY
                      , menuBtn1X, menuBtn2X, menuBtn3X, menuBtnW, menuBtnH
                      , charWidthAtScale, textHalfHeight, menuTitleCharWidth )
import View.Geometry (topEdge)
import View.Buttons (drawMenuBtn, pointInRect)

-- | Draw the "Minesweeper" title centered at the top of the menu.
drawMinesweeperTitle :: Picture
drawMinesweeperTitle =
  let msg = "Minesweeper"
      titleScale = 0.4
      titleY = 220
      halfW = fromIntegral (length msg) * menuTitleCharWidth * (titleScale / 0.16) / 2
      vertOffset = textHalfHeight * (titleScale / 0.16)
  in Color textColor (translate (-halfW) (titleY - vertOffset) (Scale titleScale titleScale (Text msg)))

-- | Draw the mine counter centered at the top of the screen (above the board).
drawMineCounter :: Int -> Int -> Int -> Picture
drawMineCounter count maxRow maxCol =
  let top = topEdge maxRow maxCol + 25
      str = "Mines: " ++ show count
      scaleMines = 0.25
      halfW = fromIntegral (length str) * charWidthAtScale * (scaleMines / 0.16) / 2
      vertOffset = textHalfHeight * (scaleMines / 0.16)
  in Color textColor (translate (-halfW) (top - vertOffset) (Scale scaleMines scaleMines (Text str)))

-- | Draw the start menu (level and size selection).
drawMenu :: MenuState -> Picture
drawMenu ms = Pictures
  [ drawMinesweeperTitle
  , Color textColor (translate menuLabelX levelY (Scale 0.18 0.18 (Text "Level:")))
  , drawMenuBtn menuBtn1X levelY "Easy"   (menuLevel ms == Easy)
  , drawMenuBtn menuBtn2X levelY "Medium" (menuLevel ms == Medium)
  , drawMenuBtn menuBtn3X levelY "Hard"   (menuLevel ms == Hard)
  , Color textColor (translate menuLabelX sizeY (Scale 0.18 0.18 (Text "Size:")))
  , drawMenuBtn menuBtn1X sizeY "Small"   (menuSize ms == Small)
  , drawMenuBtn menuBtn2X sizeY "Medium"  (menuSize ms == Med)
  , drawMenuBtn menuBtn3X sizeY "Big"     (menuSize ms == Large)
  , drawMenuBtn 0 startY "Play" False
  ]

-- | Detect which menu button was clicked (if any).
menuClick :: Float -> Float -> MenuState -> Maybe MenuAction
menuClick px py _ms
  | pointInRect px py 0 startY menuBtnW menuBtnH = Just StartGame
  | pointInRect px py menuBtn1X levelY menuBtnW menuBtnH = Just (SelectLevel Easy)
  | pointInRect px py menuBtn2X levelY menuBtnW menuBtnH = Just (SelectLevel Medium)
  | pointInRect px py menuBtn3X levelY menuBtnW menuBtnH = Just (SelectLevel Hard)
  | pointInRect px py menuBtn1X sizeY menuBtnW menuBtnH = Just (SelectSize Small)
  | pointInRect px py menuBtn2X sizeY menuBtnW menuBtnH = Just (SelectSize Med)
  | pointInRect px py menuBtn3X sizeY menuBtnW menuBtnH = Just (SelectSize Large)
  | otherwise = Nothing
