use std::collections::HashMap;

const INPUT: &str = include_str!("../../inputs/day07.txt");

fn main() {
    let input = parse_input(INPUT);
    println!("part1: {}", part1(&input));
    // println!("part1: {}", y(&input, single_step));
    println!("part2: {}", part2(&input));
}

fn parse_input(input: &str) -> Vec<isize> {
    input
        .trim()
        .split(",")
        .filter_map(|x| x.parse().ok())
        .collect()
}

fn gauss(n: isize) -> isize {
    (n * (n + 1)) / 2
}

// fn single_step(position: isize) -> Box<dyn FnMut(isize, (&isize, &isize)) -> isize> { //
//     Box::new(move |acc, (key, value)| {
//         acc + (key - position).abs() * value
//     })
// }

// fn y(positions: &[isize], cb: Box<dyn FnMut(isize, (&isize, &isize)) -> isize> -> isize) -> isize {
//     let mut position_map: HashMap<isize, isize> = HashMap::new();

//     for position in positions {
//         *position_map.entry(*position).or_insert(0) += 1;
//     }

//     let lower_bound = *position_map.keys().min().unwrap();
//     let upper_bound = *position_map.keys().max().unwrap();

//     let mut fuel_costs = HashMap::new();
//     for position in lower_bound..=upper_bound {
//         let fuel_cost = position_map.iter().fold(0, cb(position));
//         fuel_costs.insert(position, fuel_cost);
//     }

//     println!("{} {} | {:?}", lower_bound, upper_bound, position_map);
//     println!("{:?}", fuel_costs);

//     *fuel_costs.values().min().unwrap()
// }

fn part1(positions: &[isize]) -> isize {
    let mut position_map: HashMap<isize, isize> = HashMap::new();

    for position in positions {
        *position_map.entry(*position).or_insert(0) += 1;
    }

    let lower_bound = *position_map.keys().min().unwrap();
    let upper_bound = *position_map.keys().max().unwrap();

    let mut fuel_costs = HashMap::new();
    for position in lower_bound..=upper_bound {
        let fuel_cost = position_map
            .iter()
            .fold(0, |acc, (key, value)| acc + (key - position).abs() * value);
        fuel_costs.insert(position, fuel_cost);
    }

    println!("{} {} | {:?}", lower_bound, upper_bound, position_map);
    println!("{:?}", fuel_costs);

    *fuel_costs.values().min().unwrap()
}

fn part2(positions: &[isize]) -> isize {
    let mut position_map: HashMap<isize, isize> = HashMap::new();

    for position in positions {
        *position_map.entry(*position).or_insert(0) += 1;
    }

    let lower_bound = *position_map.keys().min().unwrap();
    let upper_bound = *position_map.keys().max().unwrap();

    let mut fuel_costs = HashMap::new();
    for position in lower_bound..=upper_bound {
        let fuel_cost = position_map.iter().fold(0, |acc, (key, value)| {
            acc + gauss((key - position).abs()) * value
        });
        fuel_costs.insert(position, fuel_cost);
    }

    println!("{} {} | {:?}", lower_bound, upper_bound, position_map);
    println!("{:?}", fuel_costs);

    *fuel_costs.values().min().unwrap()
}

#[cfg(test)]
mod test {
    use crate::*;

    #[test]
    fn example_part1() {
        let input = r#"
16,1,2,0,4,2,7,1,2,14
"#;
        let input = parse_input(input);
        let expected = 37;
        let actual = part1(&input);
        assert_eq!(expected, actual);
    }

    #[test]
    fn example_part2() {
        let input = r#"
16,1,2,0,4,2,7,1,2,14
"#;
        let input = parse_input(input);
        let expected = 168;
        let actual = part2(&input);
        assert_eq!(expected, actual);
    }
}
