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

type equation struct {
	testValue int
	numbers   []int
}

func (e equation) IsValid(operatorFn func(int, int) []int) bool {
	var findPermutations func(numbers ...int) []int
	findPermutations = func(numbers ...int) []int {
		if len(numbers) == 2 {
			return operatorFn(numbers[0], numbers[1])
		}

		permutations := []int{}
		for _, v := range operatorFn(numbers[0], numbers[1]) {
			perms := findPermutations(slices.Concat([]int{v}, numbers[2:])...)
			permutations = slices.Concat(permutations, perms)
		}

		return permutations
	}

	permutations := findPermutations(e.numbers...)

	return slices.Contains(permutations, e.testValue)
}

func MustAtoi(str string) int {
	val, _ := strconv.Atoi(str)
	return val
}

func init() {
	input = strings.TrimRight(input, "\n")
}

func main() {
	ans1 := part1(input)
	fmt.Println("Part 1: ", ans1)

	ans2 := part2(input)
	fmt.Println("Part 2: ", ans2)
}

func Parse(input string) []equation {
	lines := strings.Split(input, "\n")

	equations := []equation{}
	for _, line := range lines {
		substrs := strings.Split(line, ": ")
		testValue := MustAtoi(substrs[0])

		numbers := []int{}
		for _, v := range strings.Split(substrs[1], " ") {
			numbers = append(numbers, MustAtoi(v))
		}

		equations = append(equations, equation{
			testValue: testValue,
			numbers:   numbers,
		})
	}

	return equations
}

func part1(input string) int {
	equations := Parse(input)

	operatorFn := func(a, b int) []int {
		return []int{
			a + b,
			a * b,
		}
	}

	sum := 0
	for _, equation := range equations {
		if equation.IsValid(operatorFn) {
			sum += equation.testValue
		}
	}

	return sum
}

func part2(input string) int {
	equations := Parse(input)

	operatorFn := func(a, b int) []int {
		return []int{
			a + b,
			a * b,
			MustAtoi(strconv.Itoa(a) + strconv.Itoa(b)),
		}
	}

	sum := 0
	for _, equation := range equations {
		if equation.IsValid(operatorFn) {
			sum += equation.testValue
		}
	}

	return sum
}
