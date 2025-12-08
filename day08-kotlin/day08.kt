import java.util.PriorityQueue

fun main() {
    val input = generateSequence(::readLine).map { line ->
        val (x, y, z) = line.split(",").map { it.toInt() }
        Coord(x, y, z)
    }.toList()
    println("Day 08 part 1: ${part1(input)}") // 330786
    println("Day 08 part 2: TODO")
}

fun part1(input: List<Coord>): Int {
    val heap = PriorityQueue<CoordPair>(compareByDescending { it.distSq })

    for (pair in allPairs(input)) {
        if (heap.size < 1000) {
            heap.add(pair)
        } else if (pair.distSq < heap.peek().distSq) {
            heap.poll()
            heap.add(pair)
        }
    }

    return buildCircuits(heap.toList())
        .map { it.size }
        .sortedDescending()
        .take(3)
        .reduce(Int::times)
}

data class Coord(val x: Int, val y: Int, val z: Int)

data class CoordPair(val a: Coord, val b: Coord) {
    val distSq: Long = run {
        val dx = (a.x - b.x).toLong()
        val dy = (a.y - b.y).toLong()
        val dz = (a.z - b.z).toLong()
        dx * dx + dy * dy + dz * dz
    }
}

fun allPairs(input: List<Coord>) = sequence {
    for (i in input.indices) {
        for (j in i + 1 until input.size) {
            yield(CoordPair(input[i], input[j]))
        }
    }
}

fun buildCircuits(pairs: Iterable<CoordPair>): Collection<List<Coord>> {
    val parent = mutableMapOf<Coord, Coord>()
    fun find(x: Coord): Coord = if (parent[x] == x) x else find(parent[x]!!).also { parent[x] = it }
    fun union(x: Coord, y: Coord) {
        parent.getOrPut(x) { x }
        parent.getOrPut(y) { y }
        parent[find(y)] = find(x)
    }
    pairs.forEach { union(it.a, it.b) }
    return parent.keys.groupBy { find(it) }.values
}
