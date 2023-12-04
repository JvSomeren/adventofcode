use std::collections::HashSet;

const INPUT: &str = include_str!("../../inputs/day04.txt");

fn main() {
    let input = parse_input(INPUT);
    println!("part1: {}", part1(&input.0, &input.1));
    println!("part2: {}", part2(&input.0, &input.1));
}

type Board = Vec<Vec<usize>>;

fn parse_input(input: &str) -> (Vec<usize>, Vec<Board>) {
    if let [numbers, boards @ ..] = input.trim().split("\n\n").collect::<Vec<_>>().as_slice() {
        let numbers = numbers
            .split(",")
            .map(|x| x.parse().unwrap())
            .collect::<Vec<usize>>();
        let boards = boards
            .iter()
            .map(|board| {
                board
                    .split("\n")
                    .map(|l| {
                        l.split_whitespace()
                            .map(|x| x.parse::<usize>().unwrap())
                            .collect::<Vec<_>>()
                    })
                    .collect::<Vec<_>>()
            })
            .collect::<Vec<_>>();

        return (numbers, boards);
    }

    unreachable!()
}

fn calculate_board_score(drawn_numbers: &[usize], board: &Board) -> usize {
    board
        .iter()
        .flatten()
        .filter(|x| !drawn_numbers.contains(x))
        .sum()
}

fn check_board(drawn_numbers: &[usize], board: &Board) -> Option<usize> {
    let row_count = board.len();
    let column_count = board.first().unwrap().len();

    for i in 0..row_count {
        // check all rows
        if (0..column_count).all(|j| drawn_numbers.contains(&board[i][j])) {
            return Some(
                calculate_board_score(drawn_numbers, board) * drawn_numbers.last().unwrap(),
            );
        }

        // check all columns
        if (0..column_count).all(|j| drawn_numbers.contains(&board[j][i])) {
            return Some(
                calculate_board_score(drawn_numbers, board) * drawn_numbers.last().unwrap(),
            );
        }
    }

    None
}

fn part1(numbers: &[usize], boards: &[Board]) -> usize {
    for i in 5..numbers.len() {
        let winning = boards
            .iter()
            .find_map(|board| check_board(&numbers[0..i], &board));

        if let Some(score) = winning {
            return score;
        }
    }
    unreachable!()
}

fn part2(numbers: &[usize], boards: &[Board]) -> usize {
    let mut boards = boards.iter().collect::<HashSet<_>>();

    for i in 5..numbers.len() {
        let winners = boards
            .iter()
            .filter_map(|board| {
                check_board(&numbers[0..i], &board).map(|score| (board.clone(), score))
            })
            .collect::<Vec<_>>();
        for (board, _) in &winners {
            boards.remove(board);
        }
        if boards.is_empty() {
            return winners.first().unwrap().1;
        }
    }
    unreachable!()
}

#[cfg(test)]
mod test {
    use crate::*;

    #[test]
    fn example_part1() {
        let input = r#"
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
"#;
        let input = parse_input(input);
        let expected = 4512;
        let actual = part1(&input.0, &input.1);
        assert_eq!(expected, actual);
    }

    #[test]
    fn example_part2() {
        let input = r#"
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
"#;
        let input = parse_input(input);
        let expected = 1924;
        let actual = part2(&input.0, &input.1);
        assert_eq!(expected, actual);
    }
}
