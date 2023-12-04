const INPUT: &str = include_str!("../../inputs/day01.txt");

fn main() {
    let input = parse_input(INPUT);
    println!("part1: {}", part1(&input));
    println!("part2: {}", part2(&input));
}

fn parse_input(input: &str) -> Vec<usize> {
    input
        .trim()
        .lines()
        .map(|x| x.parse::<usize>().unwrap())
        .collect::<Vec<_>>()
}

fn part1(input: &[usize]) -> usize {
    input.windows(2).filter(|x| x[0] < x[1]).count()
}

fn part2(input: &[usize]) -> usize {
    input
        .windows(3)
        .map(|x| x[0] + x[1] + x[2])
        .collect::<Vec<_>>()
        .windows(2)
        .filter(|x| x[0] < x[1])
        .count()
}

#[cfg(test)]
mod test {
    use crate::*;

    #[test]
    fn example_part1() {
        let input = r#"
199
200
208
210
200
207
240
269
260
263
"#;
        let input = parse_input(input);
        let expected = 7;
        let actual = part1(&input);
        assert_eq!(expected, actual);
    }

    #[test]
    fn example_part2() {
        let input = r#"
199
200
208
210
200
207
240
269
260
263
"#;
        let input = parse_input(input);
        let expected = 5;
        let actual = part2(&input);
        assert_eq!(expected, actual);
    }
}
