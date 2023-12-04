const INPUT: &str = include_str!("../../inputs/day01.txt");

fn main() {
    let input = parse_input(INPUT);
    println!("part1: {}", part1(&input));
    println!("part2: {}", part2(&input));
}

fn parse_input(input: &str) -> Vec<Vec<usize>> {
    input
        .trim()
        .split("\n\n")
        .map(|x| {
            x.lines()
                .map(|x| x.parse::<usize>().unwrap())
                .collect::<Vec<usize>>()
        })
        .collect::<Vec<Vec<_>>>()
}

fn part1(input: &[Vec<usize>]) -> usize {
    let mut r = input.iter().map(|x| x.iter().sum()).collect::<Vec<usize>>();
    r.sort();
    *r.last().unwrap()
}

fn part2(input: &[Vec<usize>]) -> usize {
    let mut r = input.iter().map(|x| x.iter().sum()).collect::<Vec<usize>>();
    r.sort();
    r.reverse();
    r.splice(0..3, None).sum()
}

#[cfg(test)]
mod test {
    use crate::*;

    #[test]
    fn example_part1() {
        let input = r#"
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
"#;
        let input = parse_input(input);
        let expected = 24000;
        let actual = part1(&input);
        assert_eq!(expected, actual);
    }

    #[test]
    fn example_part2() {
        let input = r#"
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
"#;
        let input = parse_input(input);
        let expected = 45000;
        let actual = part2(&input);
        assert_eq!(expected, actual);
    }
}
