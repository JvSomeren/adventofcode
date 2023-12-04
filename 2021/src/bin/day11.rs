use std::collections::{HashMap, HashSet};

const INPUT: &str = include_str!("../../inputs/day11.txt");

fn main() {
    let input = parse_input(INPUT);
    println!("part1: {}", part1(&input));
}

type Point = (isize, isize);
type OctopusMap = HashMap<Point, isize>;

fn parse_input(input: &str) -> OctopusMap {
    let mut octopus_map = OctopusMap::new();

    input.trim().lines().enumerate().for_each(|(y, l)| {
        l.split("").enumerate().for_each(|(x, value)| {
            if !value.is_empty() {
                octopus_map.insert((x as isize, y as isize), value.parse().unwrap());
            }
        });
    });
    
    octopus_map
}

fn part1(input: &OctopusMap) -> usize {
    let mut flashes = 0;
    let mut map = input.clone();

    for _ in 0..1 {
        // let seen = HashSet::new();
        // increase all by 1
        map = map.iter_mut().map(|(p, charge)| {
            (*p, *charge + 1)
        }).collect();

        // find all > 9
        let flashing = map.iter()
            .filter(|(_, charge)| **charge > 9)
            .map(|(p, _)| *p)
            .collect::<Vec<Point>>();
        let mut seen = HashSet::new();

        // for all > 9's
        // - add to seen
        // - increase adjacent with 1, if > 9 add to seen
        // finally set all > 9's to 0

        for octopus in flashing {
            seen.insert(octopus);
            map.insert(octopus, 0);

            // update around point
        }
    }
    
    flashes
}

#[cfg(test)]
mod test {
    use crate::*;

    #[test]
    fn example_part1() {
        let input = r#"
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
"#;
        let input = parse_input(input);
        let expected = 1656;
        let actual = part1(&input);
        assert_eq!(expected, actual);
    }
}
