module View.Buttons where

import Graphics.Gloss
import View.Colors ( borderColor, shadowColor, shadowColorSoft
              , bevelHighlight, bevelShadow
              , menuSelectedColor, menuUnselectedColor )
import View.Constants ( shadowOffset, shadowOffsetSoft, bevelThick, borderThick
                      , menuBtnW, menuBtnH, exitBtnX, exitBtnY, exitBtnW, exitBtnH
                      , lostBtnW, lostBtnH, overlayCharWidth, charWidthAtScale )
import View.Text (drawCenteredLabelWith)

-- | True if (px, py) is inside rectangle centered at (cx, cy) with half-width hw, half-height hh
pointInRect :: Float -> Float -> Float -> Float -> Float -> Float -> Bool
pointInRect px py cx cy hw hh = px >= cx - hw && px <= cx + hw && py >= cy - hh && py <= cy + hh

-- | Bevel effect: highlight top-left, shadow bottom-right (drawn at origin)
bevelRect :: Float -> Float -> Picture
bevelRect hw hh =
  let t = bevelThick
      top    = translate 0 (hh - t/2) (Color bevelHighlight (rectangleSolid (hw*2 + t*2) t))
      left   = translate (-hw - t/2) 0 (Color bevelHighlight (rectangleSolid t (hh*2 + t*2)))
      bottom = translate 0 (-hh + t/2) (Color bevelShadow (rectangleSolid (hw*2 + t*2) t))
      right  = translate (hw + t/2) 0 (Color bevelShadow (rectangleSolid t (hh*2 + t*2)))
  in Pictures [top, left, bottom, right]

-- | Thick rectangle frame (4 edges) centered at origin
thickRectFrame :: Float -> Float -> Picture
thickRectFrame hw hh =
  let t = borderThick
      top    = translate 0 (hh - t/2) (rectangleSolid (hw*2 + t) t)
      bottom = translate 0 (-hh + t/2) (rectangleSolid (hw*2 + t) t)
      left   = translate (-hw + t/2) 0 (rectangleSolid t (hh*2 + t))
      right  = translate (hw - t/2)  0 (rectangleSolid t (hh*2 + t))
  in Pictures [top, bottom, left, right]

-- | Draw a button with optional character width and vertical nudge for label
drawButtonWith :: Float -> Float -> Float -> Float -> String -> Bool -> Float -> Float -> Picture
drawButtonWith cx cy hw hh label selected charW vertNudge =
  let fillColor = if selected then menuSelectedColor else menuUnselectedColor
      w = hw * 2
      h = hh * 2
      softShadow = translate (cx + shadowOffsetSoft) (cy - shadowOffsetSoft)
                   (Color shadowColorSoft (rectangleSolid (w + 4) (h + 4)))
      shadowPic  = translate (cx + shadowOffset) (cy - shadowOffset)
                   (Color shadowColor (rectangleSolid w h))
      bgPic      = translate cx cy (Color fillColor (rectangleSolid w h))
      bevelPic   = translate cx cy (bevelRect hw hh)
      framePic   = translate cx cy (Color borderColor (thickRectFrame hw hh))
      labelPic   = drawCenteredLabelWith cx cy hw hh charW vertNudge label
  in Pictures [ softShadow, shadowPic, bgPic, bevelPic, framePic, labelPic ]

drawButton :: Float -> Float -> Float -> Float -> String -> Bool -> Picture
drawButton cx cy hw hh label selected = drawButtonWith cx cy hw hh label selected charWidthAtScale 0

-- | Draw a menu button (fixed size).
drawMenuBtn :: Float -> Float -> String -> Bool -> Picture
drawMenuBtn cx cy label selected = drawButton cx cy menuBtnW menuBtnH label selected

-- | Draw overlay button (larger, text centered; small nudge down for vertical center).
drawOverlayBtn :: Float -> Float -> String -> Picture
drawOverlayBtn cx cy label = drawButtonWith cx cy lostBtnW lostBtnH label False overlayCharWidth 2.5

-- | Draw the global "Exit" button.
drawExitButton :: Picture
drawExitButton = drawButton exitBtnX exitBtnY exitBtnW exitBtnH "Exit" False

-- | True if (px, py) is inside the Exit button.
exitButtonClick :: Float -> Float -> Bool
exitButtonClick px py = pointInRect px py exitBtnX exitBtnY exitBtnW exitBtnH