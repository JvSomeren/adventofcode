use std::collections::{HashMap, HashSet};

const INPUT: &str = include_str!("../../inputs/day09.txt");

fn main() {
    let input = parse_input(INPUT);
    println!("part1: {}", part1(&input));
    println!("part2: {}", part2(&input));
}

type Point = (isize, isize);
type HeightMap = HashMap<Point, isize>;
type Basin = HashSet<Point>;

fn parse_input(input: &str) -> HeightMap {
    let mut height_map = HeightMap::new();

    input.trim().lines().enumerate().for_each(|(y, l)| {
        l.split("").enumerate().for_each(|(x, value)| {
            if !value.is_empty() {
                height_map.insert((x as isize, y as isize), value.parse().unwrap());
            }
        });
    });

    height_map
}

fn find_lowest_points(height_map: &HeightMap) -> Vec<(&Point, &isize)> {
    height_map
        .iter()
        .filter(|((x, y), value)| {
            let neighbours: [Point; 4] = [(x - 1, *y), (x + 1, *y), (*x, y - 1), (*x, y + 1)];

            neighbours
                .iter()
                .all(|p| !height_map.contains_key(p) || height_map.get(p).unwrap() > value)
        })
        .collect::<Vec<(&Point, &isize)>>()
}

fn part1(height_map: &HeightMap) -> isize {
    let lowest_points = find_lowest_points(height_map);

    // calculate risk factor
    lowest_points.iter().map(|(_, value)| *value + 1).sum()
}

fn determine_basin(height_map: &HeightMap, basin: &mut Basin, (x, y): Point) {
    let point = &(x, y);
    if !height_map.contains_key(point) || *height_map.get(point).unwrap() == 9 {
        return;
    }
    basin.insert((x, y));

    [(x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)]
        .iter()
        .for_each(|p| {
            if !basin.contains(p) {
                determine_basin(height_map, basin, *p);
            }
        });
}

fn part2(height_map: &HeightMap) -> usize {
    let lowest_points = find_lowest_points(height_map);

    let mut basin_sizes = lowest_points
        .iter()
        .map(|(p, _)| {
            let mut basin: Basin = HashSet::new();

            determine_basin(&height_map, &mut basin, **p);

            basin.len()
        })
        .collect::<Vec<usize>>();

    basin_sizes.sort();
    basin_sizes.reverse();

    basin_sizes[0..3].iter().product()
}

#[cfg(test)]
mod test {
    use crate::*;

    #[test]
    fn example_part1() {
        let input = r#"
2199943210
3987894921
9856789892
8767896789
9899965678
"#;
        let input = parse_input(input);
        let expected = 15;
        let actual = part1(&input);
        assert_eq!(expected, actual);
    }

    #[test]
    fn example_part2() {
        let input = r#"
2199943210
3987894921
9856789892
8767896789
9899965678
"#;
        let input = parse_input(input);
        let expected = 1134;
        let actual = part2(&input);
        assert_eq!(expected, actual);
    }
}
