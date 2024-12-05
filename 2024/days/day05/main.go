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

type rule struct {
	x int
	y int
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

func Swap[S ~[]E, E any](s S, i1 int, i2 int) S {
	x1 := s[i1]
	x2 := s[i2]

	slice := slices.Replace(s, i1, i1+1, x2)
	return slices.Replace(slice, i2, i2+1, x1)
}

func Parse(input string) ([]rule, [][]int) {
	sections := strings.Split(input, "\n\n")

	rules := Map(strings.Split(sections[0], "\n"), func(t string) rule {
		values := Map(strings.Split(t, "|"), func(x string) int {
			val, _ := strconv.Atoi(x)

			return val
		})

		return rule{x: values[0], y: values[1]}
	})

	updates := Map(strings.Split(sections[1], "\n"), func(t string) []int {
		return Map(strings.Split(t, ","), func(x string) int {
			val, _ := strconv.Atoi(x)

			return val
		})
	})

	return rules, updates
}

func Validate(update []int, rules []rule) (bool, int) {
	for i, rule := range rules {
		xIndex := slices.Index(update, rule.x)
		yIndex := slices.Index(update, rule.y)

		if xIndex == -1 || yIndex == -1 {
			continue
		}
		if xIndex > yIndex {
			return false, i
		}
	}

	return true, -1
}

func part1(input string) int {
	rules, updates := Parse(input)

	sum := 0
	for _, update := range updates {
		if isValid, _ := Validate(update, rules); !isValid {
			continue
		}

		indexOfMiddle := len(update) / 2
		sum += update[indexOfMiddle]
	}

	return sum
}

func Reorder(update []int, rules []rule, failingRuleIndex int) []int {
	failingRule := rules[failingRuleIndex]
	xIndex := slices.Index(update, failingRule.x)
	yIndex := slices.Index(update, failingRule.y)
	updatedRule := Swap(update, xIndex, yIndex)

	if isValid, failedIndex := Validate(updatedRule, rules); isValid {
		return updatedRule
	} else {
		return Reorder(update, rules, failedIndex)
	}
}

func part2(input string) int {
	rules, updates := Parse(input)

	sum := 0
	for _, update := range updates {
		isValid, failingRuleIndex := Validate(update, rules)
		if isValid {
			continue
		}

		correctedUpdate := Reorder(update, rules, failingRuleIndex)

		indexOfMiddle := len(correctedUpdate) / 2
		sum += correctedUpdate[indexOfMiddle]
	}

	return sum
}
