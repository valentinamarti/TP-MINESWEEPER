module View.Colors where

import Graphics.Gloss.Data.Color

-- | Color para cada número de minas adyacentes (1–8).
numberColor :: Int -> Color
numberColor 1 = blue
numberColor 2 = dark green
numberColor 3 = red
numberColor 4 = dark blue
numberColor 5 = dark red
numberColor 6 = cyan
numberColor 7 = black
numberColor 8 = greyN 0.5
numberColor _ = white

-- | Fondo de celda oculta.
hiddenCellColor :: Color
hiddenCellColor = greyN 0.78

-- | Celda con mina revelada.
mineCellColor :: Color
mineCellColor = greyN 0.68

-- | Celda segura revelada (vacía).
safeCellColor :: Color
safeCellColor = greyN 0.92

-- | Bandera.
flagColor :: Color
flagColor = red

-- | Bordes y marcos.
borderColor :: Color
borderColor = black

-- | Sombra de botones/celdas.
shadowColor :: Color
shadowColor = greyN 0.52

shadowColorSoft :: Color
shadowColorSoft = greyN 0.62

-- | Resalte del bevel (arriba-izquierda).
bevelHighlight :: Color
bevelHighlight = white

-- | Sombra del bevel (abajo-derecha).
bevelShadow :: Color
bevelShadow = greyN 0.55

-- | Fondo oscurecido del overlay.
overlayDimColor :: Color
overlayDimColor = makeColor 0 0 0 0.5

-- | Fondo del recuadro del overlay (You Lost / You Won).
overlayBoxColor :: Color
overlayBoxColor = white

-- | Botón del menú seleccionado (celeste).
menuSelectedColor :: Color
menuSelectedColor = makeColor 0.7 0.88 1 1

-- | Botón del menú no seleccionado (gris claro / blanco).
menuUnselectedColor :: Color
menuUnselectedColor = greyN 0.94

-- | Color del texto.
textColor :: Color
textColor = greyN 0.28
