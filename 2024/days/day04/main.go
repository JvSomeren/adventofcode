package main

import (
	_ "embed"
	"errors"
	"fmt"
	"strings"
)

//go:embed input.txt
var input string

type wordSearch struct {
	input  string
	width  int
	height int
	length int
}

type SearchDirection int

const (
	Left SearchDirection = iota
	Right
	Up
	Down
	LeftUp
	LeftDown
	RightUp
	RightDown
)

var SearchDirections = []SearchDirection{
	Left, Right, Up, Down, LeftUp, LeftDown, RightUp, RightDown,
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

func Map[T, V any](ts []T, fn func(T) V) []V {
	result := make([]V, len(ts))
	for i, t := range ts {
		result[i] = fn(t)
	}
	return result
}

func Any[T any](ts []T, pred func(T) bool) bool {
	for _, v := range ts {
		if pred(v) {
			return true
		}
	}

	return false
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

func Parse(input string) wordSearch {
	width := strings.Index(input, "\n")
	height := strings.Count(input, "\n") + 1

	return wordSearch{
		input:  strings.ReplaceAll(input, "\n", ""),
		width:  width,
		height: height,
		length: width * height,
	}
}

func (d SearchDirection) Offset(width int) int {
	switch d {
	case Left:
		return -1
	case Right:
		return +1
	case Up:
		return -width
	case Down:
		return width
	case LeftUp:
		return -1 - width
	case LeftDown:
		return -1 + width
	case RightUp:
		return +1 - width
	case RightDown:
		return +1 + width
	}

	panic("unreachable")
}

func (s wordSearch) Get(index int) (byte, error) {
	if index < 0 || index >= s.length {
		return 0, errors.New("out of bounds")
	}

	return s.input[index], nil
}

func IsWrapping(search wordSearch, i int, direction SearchDirection, substring string) bool {
	if direction == Up || direction == Down {
		return false
	}

	length := len(substring)
	indexOnRow := i % search.width

	if direction == Left || direction == LeftUp || direction == LeftDown {
		return indexOnRow-length < 0
	}

	return indexOnRow+length > search.width
}

func Check(search wordSearch, index int, direction SearchDirection, substring string) bool {
	if len(substring) == 0 {
		return true
	}

	offset := direction.Offset(search.width)
	i := index + offset

	// check string bounds
	if i < 0 || i >= search.length {
		return false
	}

	// check we're not wrapping rows
	if IsWrapping(search, index, direction, substring) {
		return false
	}

	// check for expected character
	char, _ := search.Get(i)
	if char != substring[0] {
		return false
	}

	return Check(search, i, direction, substring[1:])
}

func part1(input string) int {
	search := Parse(input)

	count := 0
	for i, v := range search.input {
		if v != 'X' {
			continue
		}

		for _, v := range SearchDirections {
			if Check(search, i, v, "MAS") {
				count += 1
			}
		}
	}

	return count
}

func CheckPart2(search wordSearch, index int) bool {
	indexOnRow := index % search.width
	if indexOnRow == 0 || indexOnRow == (search.width-1) {
		return false
	}

	directions := []SearchDirection{LeftUp, LeftDown, RightUp, RightDown}
	offsets := Map(directions, func(d SearchDirection) int {
		return d.Offset(search.width)
	})

	hasErrors := Any(offsets, func(offset int) bool {
		_, err := search.Get(index + offset)

		return err != nil
	})
	if hasErrors {
		return false
	}

	vs := Map(offsets, func(offset int) byte {
		char, _ := search.Get(index + offset)

		return char
	})

	if Count(vs, 'M') != 2 || Count(vs, 'S') != 2 {
		return false
	}

	lu, ld, ru, rd := vs[0], vs[1], vs[2], vs[3]

	// check opposide sides
	if lu == rd || ld == ru {
		return false
	}

	// check side-by-side
	return (lu == ru && ld == rd) || (lu == ld && ru == rd)
}

func part2(input string) int {
	search := Parse(input)

	count := 0
	for i, v := range search.input {
		if v != 'A' {
			continue
		}

		if CheckPart2(search, i) {
			count += 1
		}
	}

	return count
}
