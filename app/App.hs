module App where

import Control.Monad.State (execState)
import Graphics.Gloss.Interface.IO.Game (Event(..), Key(..), KeyState(Down), MouseButton(..))
import GameInit (createInitialGameFromMenu)
import GameLogic (handleReveal, handleFlag)
import System.Exit (exitSuccess)
import Types ( Game(..), GameState(Lost, Won)
            , Level(Easy), BoardSize(Small)
            , MenuState(..), MenuAction(StartGame, SelectLevel, SelectSize)
            , LostAction(BackToMenu, QuitGame)
            , AppState(Menu, InGame) )
import View (pixelToCell, gameBoardDimensions, menuClick, lostOverlayClick, exitButtonClick)

-- | Apply a click: pixel (px, py), left or right button
applyClick :: Game -> Float -> Float -> Bool -> Game
applyClick game px py isRightClick =
  let (maxR, maxC) = gameBoardDimensions game
      posMaybe = pixelToCell px py maxR maxC
  in case posMaybe of
       Nothing -> game
       Just pos ->
         let action = if isRightClick then handleFlag pos else handleReveal pos
         in execState action game

-- | Handle game event (mouse on board)
handleGameEvent :: Event -> Game -> Game
handleGameEvent event game =
  case event of
    EventKey (MouseButton LeftButton) Down _ (px, py) -> applyClick game px py False
    EventKey (MouseButton RightButton) Down _ (px, py) -> applyClick game px py True
    _ -> game

-- | Handle app event: menu clicks, game clicks, or lost overlay; Start creates game in IO
-- | True if this event is a left click on the global Exit button.
isExitClick :: Event -> Bool
isExitClick (EventKey (MouseButton LeftButton) Down _ (px, py)) = exitButtonClick px py
isExitClick _ = False

handleAppEvent :: Event -> AppState -> IO AppState
handleAppEvent event _state
  | isExitClick event = exitSuccess
handleAppEvent event state =
  case state of
    Menu ms ->
      case event of
        EventKey (MouseButton LeftButton) Down _ (px, py) ->
          case menuClick px py ms of
            Just StartGame -> InGame <$> createInitialGameFromMenu ms
            Just (SelectLevel l) -> return (Menu (ms { menuLevel = l }))
            Just (SelectSize s)  -> return (Menu (ms { menuSize = s }))
            Nothing -> return (Menu ms)
        _ -> return (Menu ms)
    InGame g ->
      case (gameState g, event) of
        (s, EventKey (MouseButton LeftButton) Down _ (px, py))
          | s == Lost || s == Won ->
          case lostOverlayClick px py of
            Just BackToMenu -> return initialAppState
            Just QuitGame   -> exitSuccess
            Nothing         -> return (InGame g)
        (s, _) | s == Lost || s == Won -> return (InGame g)
        (_, ev) -> return (InGame (handleGameEvent ev g))

-- | Initial app state: menu with Easy and Small selected.
initialAppState :: AppState
initialAppState = Menu (MenuState { menuLevel = Easy, menuSize = Small })
