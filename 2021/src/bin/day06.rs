const INPUT: &str = include_str!("../../inputs/day06.txt");

fn main() {
    let input = parse_input(INPUT);
    println!("part1: {}", determine_fish_count(input.clone(), 80));
    println!("part2: {}", determine_fish_count(input.clone(), 256));
}

fn parse_input(input: &str) -> [usize; 9] {
    input
        .trim()
        .split(",")
        .filter_map(|x| x.parse::<usize>().ok())
        .fold([0 as usize; 9], |mut acc, i| {
            acc[i] += 1;
            acc
        })
}

fn determine_fish_count(mut fish: [usize; 9], number_of_days: usize) -> usize {
    for _ in 1..=number_of_days {
        fish = fish
            .iter()
            .enumerate()
            .fold([0 as usize; 9], |mut acc, (i, fish_count)| {
                let fish_count = *fish_count;
                if i == 0 {
                    acc[6] += fish_count;
                    acc[8] += fish_count;
                    return acc;
                }

                acc[i - 1] += fish_count;
                acc
            });
    }

    fish.iter().sum()
}

fn _determine_fish_count_alt_remove(fish: [usize; 9], number_of_days: usize) -> usize {
    let mut fish = fish.to_vec();
    for _ in 1..=number_of_days {
        let fish_count = fish.remove(0);
        fish[6] += fish_count;
        fish.push(fish_count);
    }

    fish.iter().sum()
}

fn _determine_fish_count_alt_rotate(mut fish: [usize; 9], number_of_days: usize) -> usize {
    for _ in 1..=number_of_days {
        fish.rotate_left(1);
        fish[6] += fish[8];
    }

    fish.iter().sum()
}

#[cfg(test)]
mod test {
    use crate::*;

    #[test]
    fn example_part1() {
        let input = r#"
3,4,3,1,2
"#;
        let input = parse_input(input);
        let expected = 5934;
        let actual = determine_fish_count(input.clone(), 80);
        assert_eq!(expected, actual);
    }

    #[test]
    fn example_part2() {
        let input = r#"
3,4,3,1,2
"#;
        let input = parse_input(input);
        let expected = 26984457539;
        let actual = determine_fish_count(input.clone(), 256);
        assert_eq!(expected, actual);
    }
}
