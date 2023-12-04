const INPUT: &str = include_str!("../../inputs/day02.txt");

fn main() {
    let input = parse_input(INPUT);
    println!("part1: {}", part1(&input));
    println!("part2: {}", part2(&input));
}

type Command<'a> = (&'a str, usize);

fn parse_input(input: &str) -> Vec<Command> {
    input
        .trim()
        .lines()
        .map(|l| l.split_whitespace().collect::<Vec<_>>())
        .map(|x| (x[0], x[1].parse().unwrap()))
        .collect::<Vec<_>>()
}

fn part1(input: &[Command]) -> usize {
    let (x, y) = input.iter().fold((0, 0), |acc, command| {
        let (x, y) = acc;
        match command {
            ("forward", d_x) => (x + d_x, y),
            ("down", d_y) => (x, y + d_y),
            ("up", d_y) => (x, y - d_y),
            (_, _) => unreachable!(),
        }
    });

    x * y
}

fn part2(input: &[Command]) -> usize {
    let (x, y, _) = input.iter().fold((0, 0, 0), |acc, instruction| {
        let (x, y, aim) = acc;
        match instruction {
            ("forward", d_x) => (x + d_x, y + (d_x * aim), aim),
            ("down", d_y) => (x, y, aim + d_y),
            ("up", d_y) => (x, y, aim - d_y),
            (_, _) => unreachable!(),
        }
    });

    x * y
}

#[cfg(test)]
mod test {
    use crate::*;

    #[test]
    fn example_part1() {
        let input = r#"
forward 5
down 5
forward 8
up 3
down 8
forward 2
"#;
        let input = parse_input(input);
        let expected = 150;
        let actual = part1(&input);
        assert_eq!(expected, actual);
    }

    #[test]
    fn example_part2() {
        let input = r#"
forward 5
down 5
forward 8
up 3
down 8
forward 2
"#;
        let input = parse_input(input);
        let expected = 900;
        let actual = part2(&input);
        assert_eq!(expected, actual);
    }
}
