const INPUT: &str = include_str!("../../inputs/day05.txt");

fn main() {
    let input = parse_input(INPUT);
    println!("part1: {}", part1(&input, 1000, false));
    println!("part2: {}", part1(&input, 1000, true));
}

type Point = (isize, isize);
type Line = (Point, Point);
type Diagram = Vec<Vec<isize>>;

trait MapLine {
    fn map_hor_vert_line(&mut self, a: &Point, b: &Point);
    fn map_diagonal_line(&mut self, a: &Point, b: &Point);
}

impl MapLine for Diagram {
    fn map_hor_vert_line(&mut self, a: &Point, b: &Point) {
        let d_x = b.0 - a.0;
        let d_y = b.1 - a.1;

        if d_x != 0 {
            let is_neg = d_x.is_negative();
            for d_x in 0..=d_x.abs() {
                let x = if is_neg { a.0 - d_x } else { a.0 + d_x };

                self[a.1 as usize][x as usize] += 1;
            }
        }

        if d_y != 0 {
            let is_neg = d_y.is_negative();
            for d_y in 0..=d_y.abs() {
                let y = if is_neg { a.1 - d_y } else { a.1 + d_y };

                self[y as usize][a.0 as usize] += 1;
            }
        }
    }

    fn map_diagonal_line(&mut self, a: &Point, b: &Point) {
        let d_x = b.0 - a.0;
        let d_y = b.1 - a.1;

        let x_neg = d_x.is_negative();
        let y_neg = d_y.is_negative();

        let mut x_range = 0..=d_x.abs();
        let mut y_range = 0..=d_y.abs();

        for _ in 0..=d_x.abs() {
            let d_x = x_range.next().unwrap();
            let d_y = y_range.next().unwrap();
            let x = if x_neg { a.0 - d_x } else { a.0 + d_x };
            let y = if y_neg { a.1 - d_y } else { a.1 + d_y };

            self[y as usize][x as usize] += 1;
        }
    }
}

fn parse_input(input: &str) -> Vec<Line> {
    input
        .trim()
        .lines()
        .map(|l| {
            let line = l
                .split(" -> ")
                .map(|point| {
                    let p = point
                        .split(",")
                        .map(|x| x.parse().unwrap())
                        .collect::<Vec<isize>>();

                    (*p.first().unwrap(), *p.last().unwrap())
                })
                .collect::<Vec<Point>>();

            (*line.first().unwrap(), *line.last().unwrap())
        })
        .collect()
}

fn count_overlapping(diagram: Diagram) -> usize {
    diagram
        .iter()
        .map(|row| row.iter().filter(|&&x| x > 1).count())
        .sum()
}

fn part1(lines: &[Line], diagram_size: isize, should_handle_diagonal: bool) -> usize {
    let mut diagram: Diagram = vec![vec![0; diagram_size as usize]; diagram_size as usize];

    for line in lines {
        let (a, b) = line;

        if !should_handle_diagonal && a.0 != b.0 && a.1 != b.1 {
            continue;
        }

        if a.0 != b.0 && a.1 != b.1 {
            diagram.map_diagonal_line(a, b);
        } else {
            diagram.map_hor_vert_line(a, b);
        }
    }

    count_overlapping(diagram)
}

#[cfg(test)]
mod test {
    use crate::*;

    #[test]
    fn example_part1() {
        let input = r#"
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
"#;
        let input = parse_input(input);
        let expected = 5;
        let actual = part1(&input, 10, false);
        assert_eq!(expected, actual);
    }

    #[test]
    fn example_part2() {
        let input = r#"
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
"#;
        let input = parse_input(input);
        let expected = 12;
        let actual = part1(&input, 10, true);
        assert_eq!(expected, actual);
    }
}
