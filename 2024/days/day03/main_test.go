package main

import (
	"testing"
)

var example = `xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))`

func TestPart1(t *testing.T) {
	const want = 161

	if got := part1(example); got != want {
		t.Fatalf("part1() = %v, want %v", got, want)
	}
}

var example2 = `xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))`

func TestPart2(t *testing.T) {
	const want = 48

	if got := part2(example2); got != want {
		t.Fatalf("part2() = %v, want %v", got, want)
	}
}
