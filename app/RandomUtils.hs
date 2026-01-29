module RandomUtils where

import Data.List
import System.Random
import Types

-- | Generate a random coordinate within the range [0..maxRow] x [0..maxCol]
randomPosition :: Int -> Int -> IO Position
randomPosition maxRow maxCol = do
  row <- randomRIO (0, maxRow)
  col <- randomRIO (0, maxCol)
  return (row, col)

-- | Generate a list of n random coordinates (may contain duplicates).
randomPositions :: Int -> Int -> Int -> IO [Position]
randomPositions _ _ 0 = return []
randomPositions maxRow maxCol n = do
  pos <- randomPosition maxRow maxCol
  positions <- randomPositions maxRow maxCol (n - 1)
  return (pos : positions)

-- | Given a list of positions (possibly with duplicates), returns the list without duplicates and its length
--   nub :: Eq a => [a] -> [a] removes duplicate elements, keeping first occurrence.
uniquePositionsAndCount :: [Position] -> ([Position], Int)
uniquePositionsAndCount positions = (nub positions, length (nub positions))
