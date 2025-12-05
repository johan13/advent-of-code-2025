package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	var grid [][]byte
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		grid = append(grid, []byte(scanner.Text()))
	}

	numAccessible := countAndRemoveAccessible(grid)
	accessibleInFirstRound := numAccessible

	totalAccessible := numAccessible
	for numAccessible > 0 {
		numAccessible = countAndRemoveAccessible(grid)
		totalAccessible += numAccessible
	}

	fmt.Printf("Day 04 part 1: %d\n", accessibleInFirstRound) // 1480
	fmt.Printf("Day 04 part 2: %d\n", totalAccessible)        // 8899
}

type Point struct {
	x, y int
}

func countAndRemoveAccessible(grid [][]byte) int {
	var points []Point
	for y, row := range grid {
		for x, char := range row {
			if char == '@' && countNeighbors(grid, x, y) < 4 {
				points = append(points, Point{x, y})
			}
		}
	}
	for _, p := range points {
		grid[p.y][p.x] = '.'
	}
	return len(points)
}

func countNeighbors(grid [][]byte, x0 int, y0 int) int {
	neighbors := 0
	for y := y0 - 1; y <= y0+1; y++ {
		for x := x0 - 1; x <= x0+1; x++ {
			if (x != x0 || y != y0) &&
				y >= 0 && y < len(grid) &&
				x >= 0 && x < len(grid[y]) &&
				grid[y][x] == '@' {
				neighbors++
			}
		}
	}
	return neighbors
}
