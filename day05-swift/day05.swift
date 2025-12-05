let (freshRanges, availableIds) = parseInput()
print("Day 05 part 1: \(countFreshAvailable(freshRanges, availableIds))") // 577
print("Day 05 part 2: \(countTotalFreshIds(freshRanges))") // 350513176552950

func parseInput() -> (freshRanges: [ClosedRange<Int64>], availableIds: [Int64]) {
    let sections = Array(AnyIterator { readLine() }).split(whereSeparator: \.isEmpty)

    let freshRanges = sections[0].map { line -> ClosedRange<Int64> in
        let parts = line.split(separator: "-")
        return Int64(parts[0])!...Int64(parts[1])!
    }

    let availableIds = sections[1].map { Int64($0)! }

    return (freshRanges, availableIds)
}

func countFreshAvailable(_ freshRanges: [ClosedRange<Int64>], _ availableIds: [Int64]) -> Int {
    availableIds.count { id in
        freshRanges.contains { $0.contains(id) }
    }
}

func countTotalFreshIds(_ freshRanges: [ClosedRange<Int64>]) -> Int64 {
    let sorted = freshRanges.sorted { $0.lowerBound < $1.lowerBound }

    var merged: [ClosedRange<Int64>] = []
    for range in sorted {
        if let last = merged.last, range.lowerBound <= last.upperBound + 1 {
            merged[merged.count - 1] = last.lowerBound...max(last.upperBound, range.upperBound)
        } else {
            merged.append(range)
        }
    }

    return merged.reduce(0) { $0 + $1.upperBound - $1.lowerBound + 1 }
}
