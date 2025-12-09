import Data.List (tails)

main :: IO ()
main = do
    input <- parseInput <$> getContents
    putStrLn $ "Day 09 part 1: " ++ show (part1 input) -- 4735268538
    putStrLn $ "Day 09 part 2: TODO"

parseInput :: String -> [(Int, Int)]
parseInput = map (\s -> let (a, b) = break (== ',') s in (read a, read (drop 1 b))) . lines

part1 :: [(Int, Int)] -> Int
part1 = maximum . map area . allPairs
  where
    allPairs xs = [(x, y) | (x:ys) <- tails xs, y <- ys]
    area ((x1, y1), (x2, y2)) = (abs (x1 - x2) + 1) * (abs (y1 - y2) + 1)
