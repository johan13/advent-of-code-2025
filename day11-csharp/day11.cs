var input = ParseInput();
Console.WriteLine($"Day 11 part 1: {CountPaths1(input)}"); // 658
Console.WriteLine($"Day 11 part 2: {CountPaths2(input)}"); // 371113003846800

static IDictionary<string, string[]> ParseInput()
{
    var result = new Dictionary<string, string[]>();
    while (Console.ReadLine() is string line)
    {
        string[] parts = line.Split(": ");
        result.Add(parts[0], parts[1].Split(" "));
    }

    return result;
}

static int CountPaths1(IDictionary<string, string[]> input)
{
    int CountRecursively(string node) => node switch
    {
        "out" => 1,
        _ => input[node].Sum(CountRecursively)
    };

    return CountRecursively("you");
}


static long CountPaths2(IDictionary<string, string[]> input)
{
    var memo = new Dictionary<(string, bool, bool), long>();
    long CountRecursively(string node, bool visitedDac, bool visitedFft)
    {
        if (node == "out") return visitedDac && visitedFft ? 1 : 0;
        if (memo.TryGetValue((node, visitedDac, visitedFft), out long cached)) return cached;

        long count = input[node].Sum(next => CountRecursively(next, visitedDac || node == "dac", visitedFft || node == "fft"));
        memo.Add((node, visitedDac, visitedFft), count);
        return count;
    }

    return CountRecursively("svr", false, false);
}
