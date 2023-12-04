const INPUT: &str = include_str!("../../inputs/day03.txt");

fn main() {
    let input = parse_input(INPUT);
    println!("part1: {}", part1(&input, 12));
    println!("part2: {}", part2(&input, 12));
}

fn parse_input(input: &str) -> Vec<usize> {
    input
        .trim()
        .lines()
        .map(|l| usize::from_str_radix(l, 2).unwrap())
        .collect::<Vec<_>>()
}

fn most_common_bit(numbers: &[usize], position: usize) -> usize {
    let mut bit_count = [0usize, 0usize];
    for number in numbers {
        let bit_value = number >> position & 1;
        bit_count[bit_value] += 1;
    }

    if bit_count[1] >= bit_count[0] {
        1
    } else {
        0
    }
}

fn bitmask(length: usize) -> usize {
    usize::from_str_radix("1".repeat(length).as_str(), 2).unwrap()
}

fn part1(numbers: &[usize], bitlength: usize) -> usize {
    let gamma: usize = (0..bitlength)
        .map(|i| most_common_bit(&numbers, i) << i)
        .sum();

    gamma * (!gamma & bitmask(bitlength))
}

fn _part2(numbers: &[usize], bitlength: usize, is_co2: bool) -> usize {
    let mut numbers = numbers.to_vec();
    for i in (0..bitlength).rev() {
        let most_common_bit = most_common_bit(&numbers, i) ^ is_co2 as usize;
        numbers.retain(|number| (number >> i) & 1 == most_common_bit);
        if numbers.len() == 1 {
            break;
        }
    }

    *numbers.first().unwrap() & bitmask(bitlength)
}

fn part2(numbers: &[usize], bitlength: usize) -> usize {
    let oxygen = _part2(&numbers, bitlength, false);
    let co2 = _part2(&numbers, bitlength, true);

    oxygen * co2
}

#[cfg(test)]
mod test {
    use crate::*;

    #[test]
    fn example_part1() {
        let input = r#"
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
"#;
        let input = parse_input(input);
        let expected = 198;
        let actual = part1(&input, 5);
        assert_eq!(expected, actual);
    }

    #[test]
    fn example_part2() {
        let input = r#"
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
"#;
        let input = parse_input(input);
        let expected = 230;
        let actual = part2(&input, 5);
        assert_eq!(expected, actual);
    }
}
