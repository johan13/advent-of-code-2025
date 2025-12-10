import Data.List (nub, sort, tails)
import qualified Data.Map.Strict as M

main :: IO ()
main = do
    input <- parseInput <$> getContents
    putStrLn $ "Day 09 part 1: " ++ show (part1 input) -- 4735268538
    putStrLn $ "Day 09 part 2: " ++ show (part2 input) -- 1537458069

parseInput :: String -> [(Int, Int)]
parseInput = map (\s -> let (a, b) = break (== ',') s in (read a, read (drop 1 b))) . lines

part1 :: [(Int, Int)] -> Int
part1 = maximum . map area . allPairs
  where
    allPairs xs = [(x, y) | (x:ys) <- tails xs, y <- ys]
    area ((x1, y1), (x2, y2)) = (abs (x1 - x2) + 1) * (abs (y1 - y2) + 1)

part2 :: [(Int, Int)] -> Int
part2 border = maximum $ map area $ filter (isEnclosed zoneMap zoneXs zoneYs) $ allPairs border
  where
    allPairs xs = [(x, y) | (x:ys) <- tails xs, y <- ys]
    area ((x1, y1), (x2, y2)) = (abs (x1 - x2) + 1) * (abs (y1 - y2) + 1)

    -- Build edges from consecutive border points (including last->first)
    edgeList = zip border (tail border ++ [head border])

    -- Unique sorted coordinates
    xs = sort $ nub $ map fst border
    ys = sort $ nub $ map snd border

    -- Zone coordinates: include midpoints between consecutive values
    zoneXs = interleave xs
    zoneYs = interleave ys

    -- Check if point is on boundary or inside via ray casting
    isInside (px, py) = onBoundary || odd (length (filter crosses verticalEdges))
      where
        -- Point is on boundary if it lies on any edge
        onBoundary = any onEdge edgeList
        onEdge ((x1, y1), (x2, y2))
          | x1 == x2  = px == x1 && py >= min y1 y2 && py <= max y1 y2  -- vertical edge
          | otherwise = py == y1 && px >= min x1 x2 && px <= max x1 x2  -- horizontal edge
        -- Ray casting for interior points
        verticalEdges = filter (\((x1,_),(x2,_)) -> x1 == x2) edgeList
        crosses ((x, y1), (_, y2)) =
          x > px && py >= min y1 y2 && py < max y1 y2

    -- Build map of zone -> inside/outside (computed once)
    zoneMap = M.fromList [((zx, zy), isInside (zx, zy)) | zx <- zoneXs, zy <- zoneYs]

interleave :: [Int] -> [Int]
interleave [] = []
interleave [x] = [x]
interleave (a:b:rest) = a : ((a + b) `div` 2) : interleave (b:rest)

isEnclosed :: M.Map (Int, Int) Bool -> [Int] -> [Int] -> ((Int, Int), (Int, Int)) -> Bool
isEnclosed zoneMap zoneXs zoneYs ((x1, y1), (x2, y2)) =
    all (\k -> M.findWithDefault False k zoneMap) [(zx, zy) | zx <- xsInRange, zy <- ysInRange]
  where
    xsInRange = filter (\x -> x >= min x1 x2 && x <= max x1 x2) zoneXs
    ysInRange = filter (\y -> y >= min y1 y2 && y <= max y1 y2) zoneYs
