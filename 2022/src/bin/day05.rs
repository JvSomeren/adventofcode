const INPUT: &str = include_str!("../../inputs/day05.txt");

fn main() {
    let input = parse_input(INPUT);
    println!("part1: {}", part1(&input));
    // println!("part2: {}", part2(&input));
}

type Crates = Vec<Vec<char>>;
#[derive(Debug)]
struct Move {
    amount: usize,
    from: usize,
    to: usize,
}
type InputType = (Crates, Vec<Move>);

fn parse_input(input: &str) -> InputType {
    let parts = input
        .trim()
        .split("\n\n")
        .collect::<Vec<&str>>();

    // let crates = parts.next().unwrap().split("\n");
    let moves = parts[1].split('\n').map(|l| {
        let s = l.split_whitespace().collect::<Vec<&str>>();

        Move {
            amount: s[1].parse().unwrap(),
            from: s[3].parse().unwrap(),
            to: s[5].parse().unwrap(),
        }
    }).collect::<Vec<_>>();

    println!("{:?}", moves);

    (vec![], vec![])
}

fn part1(input: &InputType) -> &str {
    // let mut r = input.iter().map(|x| x.iter().sum()).collect::<Vec<usize>>();
    // r.sort();
    // *r.last().unwrap();
    ""
}

#[cfg(test)]
mod test {
    use crate::*;

    #[test]
    fn example_part1() {
        let input = r#"
[D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
"#;
        let input = parse_input(input);
        let expected = "CMZ";
        let actual = part1(&input);
        assert_eq!(expected, actual);
    }
}
