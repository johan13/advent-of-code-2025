open System
open System.Collections.Generic

let countSplits = function
    | [] -> 0
    | (firstLine: string)::allButFirstLine ->
        let rec loop beams = function
            | [] -> 0
            | (line: string)::rest ->
                let (splitting, notSplitting) = beams |> List.partition (fun x -> line[x] = '^')
                let newBeams =
                    (splitting |> List.collect (fun x -> [x-1; x+1])) @ notSplitting
                    |> List.distinct
                List.length splitting + loop newBeams rest
        loop [firstLine.IndexOf('S')] allButFirstLine

let countTimelines = function
    | [] -> 0L
    | (firstLine: string)::grid ->
        let height = List.length grid
        let memo = Dictionary<int * int, int64>()
        let rec loop x y =
            match memo.TryGetValue((x, y)) with
            | true, v -> v
            | false, _ ->
                let result =
                    if y >= height then
                        1L
                    elif grid[y][x] = '^' then
                        loop (x - 1) (y + 1) + loop (x + 1) (y + 1)
                    else
                        loop x (y + 1)
                memo[(x, y)] <- result
                result
        loop (firstLine.IndexOf('S')) 0

let input =
    Seq.initInfinite (fun _ -> Console.ReadLine())
    |> Seq.takeWhile (not << isNull)
    |> Seq.toList

printfn $"Day 07 part 1: {countSplits input}" // 1537
printfn $"Day 07 part 2: {countTimelines input}" // 18818811755665
