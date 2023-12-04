const INPUT: &str = include_str!("../../inputs/day02.txt");

fn main() {
    let input = parse_input(INPUT);
    println!("part1: {}", part1(&input));
    println!("part2: {}", part2(&input));
}

fn parse_input(input: &str) -> Vec<(char, char)> {
    input
        .trim()
        .lines()
        .map(|x| (x.chars().nth(0).unwrap(), x.chars().nth(2).unwrap()))
        .collect::<Vec<(_, _)>>()
}

fn part1(input: &[(char, char)]) -> usize {
    input
        .iter()
        .map(|(op, me)| {
            let shape_points = match me {
                'X' => 1, // rock
                'Y' => 2, // paper
                'Z' => 3, // scissors
                _ => unreachable!(),
            };

            let outcome_points = {
                let score = (*op as i32) - (*me as i32) + 23;
                if score == -1 || score == 2 {
                    6
                } else if score == 0 {
                    3
                } else {
                    0
                }
            };

            shape_points + outcome_points
        })
        .sum()
}

fn part2(input: &[(char, char)]) -> usize {
    input
        .iter()
        .map(|(op, outcome)| {
            let outcome_points = match outcome {
                'X' => 0, // loss
                'Y' => 3, // draw
                'Z' => 6, // win
                _ => unreachable!(),
            };

            let offset = match outcome {
                'X' => 2, // loss
                'Y' => 0, // draw
                'Z' => 1, // win
                _ => unreachable!(),
            };
            let shape = (((*op as u8) - b'A') + offset) % 3 + b'A' + 23;

            let shape_points = match shape as char {
                'X' => 1, // rock
                'Y' => 2, // paper
                'Z' => 3, // scissors
                _ => unreachable!(),
            };

            shape_points + outcome_points
        })
        .sum()
}

#[cfg(test)]
mod test {
    use crate::*;

    #[test]
    fn example_part1() {
        let input = r#"
A Y
B X
C Z
"#;
        let input = parse_input(input);
        let expected = 15;
        let actual = part1(&input);
        assert_eq!(expected, actual);
    }

    #[test]
    fn example_part2() {
        let input = r#"
A Y
B X
C Z
"#;
        let input = parse_input(input);
        let expected = 12;
        let actual = part2(&input);
        assert_eq!(expected, actual);
    }
}
