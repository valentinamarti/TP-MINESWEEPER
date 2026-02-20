module RandomUtils where

import Data.List
import System.Random.Stateful (uniformRM, globalStdGen)
import Types

-- | Generate a random coordinate within the range [0..maxRow] x [0..maxCol].
--   Uses uniformRM with globalStdGen (recommended over randomRIO).
randomPosition :: Int -> Int -> IO Position
randomPosition maxRow maxCol = do
  row <- uniformRM (0, maxRow) globalStdGen
  col <- uniformRM (0, maxCol) globalStdGen
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
uniquePositionsAndCount positions =
  let uniquePos = nub positions
  in (uniquePos, length uniquePos)
