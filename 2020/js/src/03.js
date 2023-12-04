const input = typeof window === 'undefined'
  ? require('fs').readFileSync(`${__dirname}/03.txt`, 'utf8')
  : document.body.innerText;

const part1 = (list, dx = 3, dy = 1) => {
  const map = list.map(l => l.split(''));

  let y = 0;
  let x = 0;
  let treesEncountered = 0;

  while (y < map.length - 1) {
    y += dy;
    if (y > map.length - 1) break;
    x = (x + dx) % map[y].length;

    if (map[y][x] === '#') treesEncountered += 1;
  }

  return treesEncountered;
};

const part2 = list => {
  return [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]].map(d => part1(list, d[0], d[1]))
    .reduce((cur, acc) => cur * acc, 1);
};

const list = input.split('\n').filter(i => i != '');
const testList = ['..##.......', '#...#...#..', '.#....#..#.', '..#.#...#.#', '.#...##..#.', '..#.##.....', '.#.#.#....#', '.#........#', '#.##...#...', '#...##....#', '.#..#...#.#'];

console.log('Part 1:', part1(list));
console.log('Part 2:', part2(list));
