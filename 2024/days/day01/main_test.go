package main

import (
	"testing"
)

var example = `3   4
4   3
2   5
1   3
3   9
3   3`

func TestPart1(t *testing.T) {
	const want = 11

	if got := part1(example); got != want {
		t.Fatalf("part1() = %v, want %v", got, want)
	}
}

func TestPart2(t *testing.T) {
	const want = 31

	if got := part2(example); got != want {
		t.Fatalf("part2() = %v, want %v", got, want)
	}
}
