use std::collections::HashSet;

const INPUT: &str = include_str!("../../inputs/day03.txt");

fn main() {
    let input = parse_input(INPUT);
    println!("part1: {}", part1(&input));
    println!("part2: {}", part2(&input));
}

fn parse_input(input: &str) -> Vec<&str> {
    input.trim().lines().collect::<Vec<_>>()
}

fn part1(input: &[&str]) -> usize {
    input
        .iter()
        .map(|b| {
            let mid = b.len() / 2;
            let (a, b) = b.split_at(mid);

            let unique_a: HashSet<char> = a.chars().collect();
            let unique_b: HashSet<char> = b.chars().collect();

            let res = unique_a.intersection(&unique_b);

            let t = *res.last().unwrap() as u8;
            let res = match t {
                b'a'..=b'z' => t - b'a' + 1,
                b'A'..=b'Z' => t - b'A' + 26 + 1,
                _ => unreachable!(),
            };

            res as usize
        })
        .sum()
}

fn part2(input: &[&str]) -> usize {
    input.chunks(3).map(|chunk| {

        let unique_a: HashSet<char> = chunk[0].chars().collect();
        let unique_b: HashSet<char> = chunk[1].chars().collect();
        let unique_c: HashSet<char> = chunk[2].chars().collect();

        let intersection_ab: HashSet<&char> = unique_a.intersection(&unique_b).collect();
        let intersection_bc: HashSet<&char> = unique_b.intersection(&unique_c).collect();

        let res = intersection_ab.intersection(&intersection_bc);
        
        let t = **res.last().unwrap() as u8;
        let res = match t {
            b'a'..=b'z' => t - b'a' + 1,
            b'A'..=b'Z' => t - b'A' + 26 + 1,
            _ => unreachable!(),
        };

        res as usize
    }).sum()
}

#[cfg(test)]
mod test {
    use crate::*;

    #[test]
    fn example_part1() {
        let input = r#"
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
"#;
        let input = parse_input(input);
        let expected = 157;
        let actual = part1(&input);
        assert_eq!(expected, actual);
    }

    #[test]
    fn example_part2() {
        let input = r#"
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
"#;
        let input = parse_input(input);
        let expected = 70;
        let actual = part2(&input);
        assert_eq!(expected, actual);
    }
}
