fun main() {
    val input = generateSequence(::readLine).map { line ->
        val (x, y, z) = line.split(",").map { it.toInt() }
        Coord(x, y, z)
    }.toList()

    val builder = CircuitBuilder(input)
    repeat(1000) { builder.makeConnection() }
    val answer1 = builder.circuits
        .map { it.size }
        .sortedDescending()
        .take(3)
        .reduce(Int::times)

    while (builder.circuitCount > 1) { builder.makeConnection() }
    val answer2 = builder.lastPair.a.x.toLong() * builder.lastPair.b.x

    println("Day 08 part 1: ${answer1}") // 330786
    println("Day 08 part 2: ${answer2}") // 3276581616
}

class CircuitBuilder(coords: List<Coord>) {
    private val pairIterator: Iterator<CoordPair>
    private val parentMap = mutableMapOf<Coord, Coord>()
    var circuitCount: Int = coords.size
        private set

    lateinit var lastPair: CoordPair
        private set

    val circuits: Collection<List<Coord>>
        get() = parentMap.keys.groupBy { findRoot(it) }.values

    init {
        parentMap.putAll(coords.associateWith { it })
        pairIterator = allPairsByDistance(coords).iterator()
    }

    private fun allPairsByDistance(coords: List<Coord>) =
        coords.indices.asSequence().flatMap { i ->
            (i + 1 until coords.size).map { j -> CoordPair(coords[i], coords[j]) }
        }.sortedBy { it.distSq }

    fun makeConnection() {
        lastPair = pairIterator.next()
        val rootA = findRoot(lastPair.a)
        val rootB = findRoot(lastPair.b)
        if (rootA != rootB) {
            parentMap[rootB] = rootA
            circuitCount--
        }
    }

    private fun findRoot(x: Coord): Coord =
        if (parentMap[x] == x) x else findRoot(parentMap[x]!!).also { parentMap[x] = it }
}

data class Coord(val x: Int, val y: Int, val z: Int)

data class CoordPair(val a: Coord, val b: Coord) {
    val distSq: Long get() {
        val dx = (a.x - b.x).toLong()
        val dy = (a.y - b.y).toLong()
        val dz = (a.z - b.z).toLong()
        return dx * dx + dy * dy + dz * dz
    }
}
