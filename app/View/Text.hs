module View.Text where

import Graphics.Gloss
import View.Colors (textColor)
import View.Constants ( charWidthAtScale, textHalfHeight
                      , overlayTitleCharWidth, overlayTitleScale, overlayTitleY )

-- | Draw text centered at (cx, cy) using given character width; vertNudge moves text down (px).
drawCenteredLabelWith :: Float -> Float -> Float -> Float -> Float -> Float -> String -> Picture
drawCenteredLabelWith cx cy hw _hh charW vertNudge label =
  let textScale = min 0.15 (hw * 1.6 / fromIntegral (max 1 (length label)))
      halfW = fromIntegral (length label) * charW * (textScale / 0.16)
      vertOffset = textHalfHeight * (textScale / 0.16)
  in translate (cx - halfW) (cy - vertOffset - vertNudge)
     (Scale textScale textScale (Color textColor (Text label)))

-- | Draw text centered at (cx, cy). Scale chosen so label fits in width 2*hw.
drawCenteredLabel :: Float -> Float -> Float -> Float -> String -> Picture
drawCenteredLabel cx cy hw hh label = drawCenteredLabelWith cx cy hw hh charWidthAtScale 0 label

-- | Draw one line of text centered at (0, overlayTitleY) with overlayTitleScale.
drawOverlayTitle :: String -> Picture
drawOverlayTitle msg =
  let halfW = fromIntegral (length msg) * overlayTitleCharWidth * (overlayTitleScale / 0.16) / 2
      vertOffset = textHalfHeight * (overlayTitleScale / 0.16)
  in translate (-halfW) (overlayTitleY - vertOffset)
     (Scale overlayTitleScale overlayTitleScale (Color textColor (Text msg)))
