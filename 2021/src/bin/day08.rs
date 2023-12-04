use std::{collections::HashSet, iter::FromIterator};

const INPUT: &str = include_str!("../../inputs/day08.txt");

fn main() {
    let input = parse_input(INPUT);
    println!("part1: {}", part1(&input));
    println!("part2: {}", part2(&input));
}

type Entry = (Vec<String>, Vec<String>);

fn parse_input(input: &str) -> Vec<Entry> {
    input
        .trim()
        .lines()
        .map(|l| {
            let x: Vec<Vec<String>> = l
                .split(" | ")
                .map(|x| x.split_whitespace().map(|x| x.to_string()).collect())
                .collect();
            (x[0].clone(), x[1].clone())
        })
        .collect()
}

fn part1(entries: &[Entry]) -> usize {
    entries
        .iter()
        .map(|entry| {
            entry
                .1
                .iter()
                .filter(|digit| {
                    let length = digit.len();

                    length == 2 || length == 3 || length == 4 || length == 7
                })
                .count()
        })
        .sum()
}

fn l(pattern: &Vec<String>, length: usize) -> HashSet<char> {
    let iter = pattern.iter().find(|x| x.len() == length).unwrap().chars();

    HashSet::from_iter(iter)
}

// fn t(pattern: &Vec<String>, base: &Vec<&str>, expected_diff: usize) -> Vec<&str> {
//     pattern.iter().find(|x| {
//         base.iter().filter(|c| x.contains(*c)).count() == expected_diff
//     }).unwrap().split("").filter(|x| !x.is_empty()).collect::<Vec<&str>>()
// }

fn determine_value(entry: &Entry) -> usize {
    let pattern = &entry.0;

    let one = l(pattern, 2);
    let four = l(pattern, 4);
    let seven = l(pattern, 3);
    let eight = l(pattern, 7);

    let two_three_five = pattern
        .iter()
        .filter(|x| x.len() == 5)
        .map(|x| HashSet::from_iter(x.chars()))
        .collect::<Vec<HashSet<char>>>();
    let three = two_three_five
        .iter()
        .find(|x| one.difference(x).count() == 0)
        .unwrap();
    let five = two_three_five
        .iter()
        .find(|x| x != &three && four.difference(x).count() == 1)
        .unwrap();
    let two = two_three_five
        .iter()
        .find(|x| x != &three && x != &five)
        .unwrap();

    let zero_six_nine = pattern
        .iter()
        .filter(|x| x.len() == 6)
        .map(|x| HashSet::from_iter(x.chars()))
        .collect::<Vec<HashSet<char>>>();
    let six = zero_six_nine
        .iter()
        .find(|x| seven.difference(x).count() == 1)
        .unwrap();
    let nine = zero_six_nine
        .iter()
        .find(|x| x != &six && four.difference(x).count() == 0)
        .unwrap();
    let zero = zero_six_nine
        .iter()
        .find(|x| x != &six && x != &nine)
        .unwrap();

    entry
        .1
        .iter()
        .map(|x| HashSet::from_iter(x.chars()))
        .map(|x: HashSet<char>| match x {
            _ if x == one => 1,
            _ if x == *two => 2,
            _ if x == *three => 3,
            _ if x == four => 4,
            _ if x == *five => 5,
            _ if x == *six => 6,
            _ if x == seven => 7,
            _ if x == eight => 8,
            _ if x == *nine => 9,
            _ if x == *zero => 0,
            _ => unreachable!(),
        })
        .fold(0, |acc, x| acc * 10 + x)
}

fn part2(entries: &[Entry]) -> usize {
    entries.iter().map(determine_value).sum()
}

#[cfg(test)]
mod test {
    use crate::*;

    #[test]
    fn example_part1() {
        let input = r#"
be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
"#;
        let input = parse_input(input);
        let expected = 26;
        let actual = part1(&input);
        assert_eq!(expected, actual);
    }

    #[test]
    fn example_part2_single() {
        let input = r#"
acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf
"#;
        let input = parse_input(input);
        let expected = 5353;
        let actual = part2(&input);
        assert_eq!(expected, actual);
    }

    #[test]
    fn example_part2_single_b() {
        let input = r#"
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
"#;
        let input = parse_input(input);
        let expected = 9361;
        let actual = part2(&input);
        assert_eq!(expected, actual);
    }

    #[test]
    fn example_part2() {
        let input = r#"
be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
"#;
        let input = parse_input(input);
        let expected = 61229;
        let actual = part2(&input);
        assert_eq!(expected, actual);
    }
}
