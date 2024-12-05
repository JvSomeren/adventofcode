package main

import (
	_ "embed"
	"fmt"
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

func Every[T any](ts []T, pred func(T) bool) bool {
	for _, v := range ts {
		if !pred(v) {
			return false
		}
	}

	return true
}

func Parse(input string) [][]int {
	reports := strings.Split(input, "\n")

	return Map(reports, func(report string) []int {
		levels := strings.Split(report, " ")

		return Map(levels, func(level string) int {
			x, _ := strconv.Atoi(level)

			return x
		})
	})
}

func CheckReport(report []int) (bool, int) {
	isIncr := report[0] < report[1]

	for i := 0; i < len(report)-1; i++ {
		if isIncr && report[i] > report[i+1] {
			return false, i
		}
		if !isIncr && report[i] < report[i+1] {
			return false, i
		}

		diff := report[i] - report[i+1]
		if diff == 0 || max(-diff, diff) > 3 {

			return false, i
		}
	}

	return true, -1
}

func part1(input string) int {
	reports := Parse(input)

	safe := 0
	for _, v := range reports {
		if isSafe, _ := CheckReport(v); isSafe {
			safe += 1
		}
	}

	return safe
}

func CheckReportWithTolerance(report []int) bool {
	isSafe, faultyIndex := CheckReport(report)
	if isSafe {
		return true
	}

	// check when we remove either the level at faultyIndex or the one after that
	for x := range 2 {
		r := slices.Concat(report[:faultyIndex+x], report[faultyIndex+x+1:])

		if isSafe, _ = CheckReport(r); isSafe {
			return true
		}
	}

	// check when we remove the first level
	r := report[1:]
	if isSafe, _ = CheckReport(r); isSafe {
		return true
	}

	return false
}

func part2(input string) int {
	reports := Parse(input)

	safe := 0
	for _, v := range reports {
		if CheckReportWithTolerance(v) {
			safe += 1
		}
	}

	return safe
}
