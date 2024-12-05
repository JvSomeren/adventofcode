package main

import (
	_ "embed"
	"fmt"
	"regexp"
	"slices"
	"strconv"
	"strings"
)

//go:embed input.txt
var input string

func init() {
	input = strings.TrimRight(input, "\n")
}

func main() {
	ans1 := part1(input)
	fmt.Println("Part 1: ", ans1)

	ans2 := part2(input)
	fmt.Println("Part 2: ", ans2)
}

func Map[T, V any](ts []T, fn func(T) V) []V {
	result := make([]V, len(ts))
	for i, t := range ts {
		result[i] = fn(t)
	}
	return result
}

func Unzip[T any](ts []T) ([]T, []T) {
	a := []T{}
	b := []T{}

	for i, v := range ts {
		if i%2 == 0 {
			a = append(a, v)
		} else {
			b = append(b, v)
		}
	}

	return a, b
}

func Count[T comparable](ts []T, v T) int {
	count := 0
	for _, x := range ts {
		if x == v {
			count += 1
		}
	}

	return count
}

func Parse(input string) ([]int, []int) {
	re := regexp.MustCompile(`\s+|\n`)

	split := re.Split(input, -1)
	parsed := Map(split, func(value string) int {
		k, _ := strconv.Atoi(value)
		return k
	})
	left, right := Unzip(parsed)
	slices.Sort(left)
	slices.Sort(right)

	return left, right
}

func part1(input string) int {
	left, right := Parse(input)

	sum := 0
	for i, v := range left {
		diff := v - right[i]

		sum += max(-diff, diff)
	}

	return sum
}

func part2(input string) int {
	left, right := Parse(input)

	score := 0
	for _, v := range left {
		count := Count(right, v)

		score += v * count
	}

	return score
}
