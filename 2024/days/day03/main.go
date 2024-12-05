package main

import (
	_ "embed"
	"fmt"
	"regexp"
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

func part1(input string) int {
	re := regexp.MustCompile(`mul\((\d+),(\d+)\)`)
	muls := re.FindAllStringSubmatch(input, -1)

	total := 0
	for _, v := range muls {
		a, _ := strconv.Atoi(v[1])
		b, _ := strconv.Atoi(v[2])

		total += a * b
	}

	return total
}

func part2(input string) int {
	re := regexp.MustCompile(`mul\((\d+),(\d+)\)|do\(\)|don't\(\)`)
	muls := re.FindAllStringSubmatch(input, -1)

	isEnabled := true
	total := 0
	for _, v := range muls {
		if instruction := v[0]; instruction == "do()" {
			isEnabled = true
			continue
		} else if instruction == "don't()" {
			isEnabled = false
			continue
		} else if !isEnabled {
			continue
		}

		a, _ := strconv.Atoi(v[1])
		b, _ := strconv.Atoi(v[2])

		total += a * b
	}

	return total
}
