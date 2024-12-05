package main

import (
	"testing"
)

var example = `MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX`

func TestPart1(t *testing.T) {
	const want = 18

	if got := part1(example); got != want {
		t.Fatalf("part1() = %v, want %v", got, want)
	}
}

func TestPart2(t *testing.T) {
	const want = 9

	if got := part2(example); got != want {
		t.Fatalf("part2() = %v, want %v", got, want)
	}
}
