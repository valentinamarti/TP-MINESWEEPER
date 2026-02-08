module Main where

import Graphics.Gloss
import Graphics.Gloss.Interface.IO.Game (playIO)
import App (initialAppState, handleAppEvent)
import View (drawAppState)

main :: IO ()
main = do
  let windowWidth = 800
      windowHeight = 800
  playIO
    (InWindow "Haskell Minesweeper" (windowWidth, windowHeight) (80, 80))
    white
    60
    initialAppState
    (\s -> return (drawAppState s))
    handleAppEvent
    (\_ s -> return s)
