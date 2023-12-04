const INPUT: &str = include_str!("../../inputs/day10.txt");

fn main() {
    let input = parse_input(INPUT);
    println!("part1: {}", part1(&input));
    println!("part2: {}", part2(&input));
}


fn parse_input(input: &str) -> Vec<Vec<char>> {
    input.trim().lines().map(|l| l.chars().collect())
        .collect()
}

fn part1(lines: &Vec<Vec<char>>) -> usize {
    let mut score = 0;

    for line in lines {
        let mut queue = vec![];

        for bracket in line {
            match *bracket {
                '(' | '[' | '{' | '<' => queue.push(*bracket),
                ')' | ']' | '}' | '>' => {
                    let last_bracket = queue.pop().unwrap();
                    let expected_bracket = match *bracket {
                        ')' => '(',
                        ']' => '[',
                        '}' => '{',
                        '>' => '<',
                        _ => unreachable!(),
                    };

                    if last_bracket != expected_bracket {
                        score += match *bracket {
                            ')' => 3,
                            ']' => 57,
                            '}' => 1197,
                            '>' => 25137,
                            _ => unreachable!()
                        };
                        break;
                    }
                },
                _ => unreachable!(),
            };
        }
    }
    
    score
}

fn part2(lines: &Vec<Vec<char>>) -> usize {
    let mut scores: Vec<usize> = vec![];

    for line in lines {
        let mut queue = vec![];

        for bracket in line {
            match *bracket {
                '(' | '[' | '{' | '<' => queue.push(*bracket),
                ')' | ']' | '}' | '>' => {
                    let last_bracket = queue.pop().unwrap();
                    let expected_bracket = match *bracket {
                        ')' => '(',
                        ']' => '[',
                        '}' => '{',
                        '>' => '<',
                        _ => unreachable!(),
                    };

                    if last_bracket != expected_bracket {
                        queue.clear();
                        break;
                    }
                },
                _ => unreachable!(),
            };
        }

        if queue.len() != 0 {
            let mut line_score = 0;
            while let Some(bracket) = queue.pop() {
                line_score *= 5;
                line_score += match bracket {
                    '(' => 1,
                    '[' => 2,
                    '{' => 3,
                    '<' => 4,
                    _ => unreachable!(),
                };
            }
            scores.push(line_score);
        }
    }

    scores.sort();

    *scores.get(scores.len() / 2).unwrap()
}

#[cfg(test)]
mod test {
    use crate::*;

    #[test]
    fn example_part1() {
        let input = r#"
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
"#;
        let input = parse_input(input);
        let expected = 26397;
        let actual = part1(&input);
        assert_eq!(expected, actual);
    }

    #[test]
    fn example_part2() {
        let input = r#"
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
"#;
        let input = parse_input(input);
        let expected = 288957;
        let actual = part2(&input);
        assert_eq!(expected, actual);
    }
}
