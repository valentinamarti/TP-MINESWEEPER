module View.Constants where

-- | Cell size in pixels (width and height of each cell).
cellSize :: Float
cellSize = 48

-- | Shadow offset (pixels right, pixels down in screen).
shadowOffset :: Float
shadowOffset = 3

shadowOffsetSoft :: Float
shadowOffsetSoft = 5

-- | Bevel line thickness.
bevelThick :: Float
bevelThick = 1.5

-- | Border thickness in pixels (for thick frame).
borderThick :: Float
borderThick = 2.5

-- | Menu layout: button half-width, half-height.
menuBtnW, menuBtnH :: Float
menuBtnW = 76
menuBtnH = 28

levelY, sizeY, startY :: Float
levelY = 80
sizeY = 0
startY = -80

menuBtnSpacing :: Float
menuBtnSpacing = 162

menuLabelX, menuBtn1X, menuBtn2X, menuBtn3X :: Float
menuLabelX = -318
menuBtn1X = -menuBtnSpacing
menuBtn2X = 0
menuBtn3X = menuBtnSpacing

-- | Text centering (character width at scale 0.16).
charWidthAtScale :: Float
charWidthAtScale = 5.5

-- | Título "Minesweeper" en el menú (Gloss lo dibuja ancho, usamos más para centrar a la izquierda).
menuTitleCharWidth :: Float
menuTitleCharWidth = 9.5

overlayCharWidth :: Float
overlayCharWidth = 8.5

overlayTitleCharWidth :: Float
overlayTitleCharWidth = 7.6

textHalfHeight :: Float
textHalfHeight = 6

-- | Exit button (top-right).
exitBtnX, exitBtnY :: Float
exitBtnX = 330
exitBtnY = 340

exitBtnW, exitBtnH :: Float
exitBtnW = 42
exitBtnH = 18

-- | Overlay (lost/won) buttons.
lostBtnW, lostBtnH :: Float
lostBtnW = 108
lostBtnH = 32

lostButtonsY :: Float
lostButtonsY = -85

lostBackX, lostQuitX :: Float
lostBackX = -92
lostQuitX = 108

overlayTitleScale, overlayTitleY :: Float
overlayTitleScale = 0.4
overlayTitleY = 28
