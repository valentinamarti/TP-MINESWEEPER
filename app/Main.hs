import Graphics.Gloss

main :: IO ()
main = play 
    -- WINDOW CONFIGURATION
    -- (Display title, Size in pixels, Initial position on screen)
    (InWindow "Haskell Minesweeper" (600, 600) (100, 100)) 
    
    -- BACKGROUND COLOR
    white      
    
    -- REFRESH RATE (FPS)
    -- How many times per second the screen is redrawn
    60         
    
    -- INITIAL WORLD STATE
    -- The starting point of the game (currently a simple Integer 0)
    (0 :: Int)
    
    --  DRAWING FUNCTION (Rendering)
    -- Translates the current state into a Picture to be displayed.
    -- The '_' ignores the state to draw a static blue circle.
    -- (\state -> Color blue (Circle 100)) 
    (\_ -> Color blue (Circle 100)) 

    
    -- EVENT HANDLER
    -- Responds to user input (mouse clicks, key presses). 
    -- It takes the Event and the current State, then returns a new State.
    -- (\event state -> state) 
    (\_ s -> s) 

    -- TIME UPDATE FUNCTION
    -- Used for automatic animations. It receives the time passed (dt) 
    -- and the current state. Since Minesweeper is static, we return the state unchanged.
    -- (\dt state -> state)
    (\_ s -> s)