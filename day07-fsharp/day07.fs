open System

let rec countSplits beams = function
    | [] -> 0
    | (firstLine: string)::lines ->
        let (splitting, notSplitting) = beams |> List.partition (fun b -> firstLine[b] = '^')
        let newBeams =
            (splitting |> List.collect (fun b -> [b-1; b+1])) @ notSplitting
            |> List.distinct
        List.length splitting + countSplits newBeams lines

let part1 = function
    | [] -> 0
    | (firstLine: string)::lines -> countSplits [firstLine.IndexOf('S')] lines

let lines =
    Seq.initInfinite (fun _ -> Console.ReadLine())
    |> Seq.takeWhile (fun line -> line <> null)
    |> Seq.toList

printfn $"Day 07 part 1: {part1 lines}" // 1537
printfn "Day 07 part 2: TODO"
