package main

import (
	_ "embed"
	"fmt"
	"strings"
)

//go:embed input.txt
var input string

type chart struct {
	chart  string
	width  int
	height int
	length int
}

type Direction int

const (
	Left Direction = iota
	Right
	Up
	Down
)

func (d Direction) Offset(width int) int {
	switch d {
	case Left:
		return -1
	case Right:
		return +1
	case Up:
		return -width
	case Down:
		return width
	}

	panic("unreachable")
}

func (d Direction) Turn() Direction {
	switch d {
	case Left:
		return Up
	case Up:
		return Right
	case Right:
		return Down
	case Down:
		return Left
	}

	panic("unreachable")
}

type Set[T comparable] struct {
	list map[T]struct{}
}

func (s Set[T]) Add(v T) {
	s.list[v] = struct{}{}
}

func (s Set[T]) Contains(v T) bool {
	_, ok := s.list[v]

	return ok
}

func (s Set[T]) Size() int {
	return len(s.list)
}

func NewSet[T comparable]() *Set[T] {
	s := &Set[T]{}
	s.list = make(map[T]struct{})

	return s
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

func Parse(input string) chart {
	width := strings.Index(input, "\n")
	height := strings.Count(input, "\n") + 1

	return chart{
		chart:  strings.ReplaceAll(input, "\n", ""),
		width:  width,
		height: height,
		length: width * height,
	}
}

func IsOutOfBounds(chart chart, position int, prevPosition int) bool {
	if position < 0 || position >= chart.length {
		return true
	}

	prevIndexOnRow := prevPosition % chart.width
	indexOnRow := position % chart.width

	diff := prevIndexOnRow - indexOnRow

	return diff < -1 || diff > 1
}

func Traverse(c chart, position int, direction Direction, visited Set[int]) Set[int] {
	visited.Add(position)

	nextPosition := position + direction.Offset(c.width)

	if IsOutOfBounds(c, nextPosition, position) {
		return visited
	}

	nextChar := c.chart[nextPosition]
	if nextChar == '#' {
		// handle turning, especially in corners i.e.:
		// .#.
		// .^#
		// ...
		for {
			direction = direction.Turn()
			nextPosition = position + direction.Offset(c.width)
			nextChar = c.chart[nextPosition]

			if nextChar != '#' {
				break
			}
		}
	}

	return Traverse(c, nextPosition, direction, visited)
}

func part1(input string) int {
	chart := Parse(input)

	startingPoint := strings.Index(chart.chart, "^")
	visited := Traverse(chart, startingPoint, Up, *NewSet[int]())

	return visited.Size()
}

type posWithDir struct {
	pos int
	dir Direction
}

func HasLoopTraverse(c chart, position int, direction Direction, visited Set[posWithDir]) bool {
	x := posWithDir{pos: position, dir: direction}
	if visited.Contains(x) {
		return true
	}

	visited.Add(x)

	nextPosition := position + direction.Offset(c.width)

	if IsOutOfBounds(c, nextPosition, position) {
		return false
	}

	nextChar := c.chart[nextPosition]
	if nextChar == '#' {
		// handle turning, especially in corners i.e.:
		// .#.
		// .^#
		// ...
		for {
			direction = direction.Turn()
			nextPosition = position + direction.Offset(c.width)
			nextChar = c.chart[nextPosition]

			if nextChar != '#' {
				break
			}
		}
	}

	return HasLoopTraverse(c, nextPosition, direction, visited)
}

func part2(input string) int {
	c := Parse(input)

	startingPoint := strings.Index(c.chart, "^")
	visited := Traverse(c, startingPoint, Up, *NewSet[int]())

	count := 0
	for pos := range visited.list {
		tmpChart := chart{
			chart:  c.chart[:pos] + "#" + c.chart[pos+1:],
			width:  c.width,
			height: c.height,
			length: c.length,
		}

		hasLoop := HasLoopTraverse(tmpChart, startingPoint, Up, *NewSet[posWithDir]())
		if hasLoop {
			count += 1
		}
	}

	return count
}
