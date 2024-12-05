package main

import (
	"testing"
)

var example = `7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9`

func TestPart1(t *testing.T) {
	const want = 2

	if got := part1(example); got != want {
		t.Fatalf("part1() = %v, want %v", got, want)
	}
}

func TestPart2(t *testing.T) {
	const want = 4

	if got := part2(example); got != want {
		t.Fatalf("part2() = %v, want %v", got, want)
	}
}
