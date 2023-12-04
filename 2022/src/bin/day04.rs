use std::ops::RangeInclusive;

const INPUT: &str = include_str!("../../inputs/day04.txt");

fn main() {
    let input = parse_input(INPUT);
    println!("part1: {}", part1(&input));
    println!("part2: {}", part2(&input));
}

type Inner = (RangeInclusive<usize>, RangeInclusive<usize>);
type InputType = Vec<Inner>;

fn parse_input(input: &str) -> InputType {
    input
        .trim()
        .lines()
        .flat_map(|l| l.split(','))
        .flat_map(|r| r.split('-'))
        .map(|x| x.parse::<usize>().unwrap())
        .collect::<Vec<_>>()
        .chunks_exact(4)
        .map(|x| {
            (
                RangeInclusive::new(x[0], x[1]),
                RangeInclusive::new(x[2], x[3]),
            )
        })
        .collect::<Vec<_>>()
}

trait RangeContainsRange {
    fn contains_range(&self, other: &Self) -> bool;
}

trait RangeOverlapsRange {
    fn overlaps_range(&self, other: &Self) -> bool;
}

impl RangeContainsRange for RangeInclusive<usize> {
    fn contains_range(&self, other: &Self) -> bool {
        self.start() <= other.start() && other.end() <= self.end()
    }
}

impl RangeOverlapsRange for RangeInclusive<usize> {
    fn overlaps_range(&self, other: &Self) -> bool {
        self.start() <= other.end() && self.start() >= other.start()
        || other.start() <= self.end() && other.start() >= self.start()
    }
}

fn part1(input: &InputType) -> usize {
    input
        .iter()
        .filter(|x| x.0.contains_range(&x.1) || x.1.contains_range(&x.0))
        .count()
}

fn part2(input: &InputType) -> usize {
    input.iter().filter(|x| x.0.overlaps_range(&x.1)).count()
}

#[cfg(test)]
mod test {
    use crate::*;

    #[test]
    fn example_part1() {
        let input = r#"
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
"#;
        let input = parse_input(input);
        let expected = 2;
        let actual = part1(&input);
        assert_eq!(expected, actual);
    }

    #[test]
    fn example_part2() {
        let input = r#"
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
"#;
        let input = parse_input(input);
        let expected = 4;
        let actual = part2(&input);
        assert_eq!(expected, actual);
    }
}
