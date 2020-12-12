const input = typeof window === 'undefined'
  ? require('fs').readFileSync(`${__dirname}/11.txt`, 'utf8')
  : document.body.innerText;

const adjacentSeat = (grid, y, x, dy, dx) => grid[y - dy][x - dx];

const countAdjacentSeats = (grid, y, x, seatComparisonFn) => {
  let count = 0;

  for(let dy of [-1, 0, 1]) {
    for(let dx of [-1, 0, 1]) {
      if(dy === 0 && dx === 0) continue;
      if(seatComparisonFn(grid, y, x, dy, dx) === '#') count += 1;
    }
  }

  return count;
}

const iterateGrid = (grid, seatComparisonFn, adjacentSeatLimit) => {
  let hasChanged = false;
  const newGrid = [...grid].map((line, y, grid) => {
    return line.map((seat, x) => {
      if(seat === '.') return seat;
      
      const adjacentSeats = countAdjacentSeats(grid, y, x, seatComparisonFn);
      if(seat === 'L' && adjacentSeats === 0) {
        hasChanged = true;
        return '#';
      }
      if(seat === '#' && adjacentSeats >= adjacentSeatLimit) {
        hasChanged = true;
        return 'L';
      }

      return seat;
    });
  });

  return { newGrid, hasChanged };
};

const part1 = (list, seatComparisonFn = adjacentSeat, adjacentSeatLimit = 4) => {
  let grid = list.map(l => ['.', ...l.split(''), '.']);
  const emptyRow = (new Array(grid[0].length)).fill('.');
  grid = [emptyRow, ...grid, emptyRow];
  
  let hasChanged = false;
  do {
    const res = iterateGrid(grid, seatComparisonFn, adjacentSeatLimit);
    grid = res.newGrid;
    hasChanged = res.hasChanged;
  } while(hasChanged);

  return grid.reduce((acc, line) => acc + line.filter(l => l === '#').length, 0);
};

const firstSeatInDirection = (grid, y, x, dy, dx) => {
  y += dy;
  x += dx;

  if(y < 0 || y >= grid.length || x < 0 || x >= grid[0].length) return false;
  if(grid[y][x] !== '.') return grid[y][x];

  return firstSeatInDirection(grid, y, x, dy, dx);
};

const part2 = list => part1(list, firstSeatInDirection, 5);

const list = input.split('\n')
  .filter(l => l != '');
const testList = ['L.LL.LL.LL', 'LLLLLLL.LL', 'L.L.L..L..', 'LLLL.LL.LL', 'L.LL.LL.LL', 'L.LLLLL.LL', '..L.L.....', 'LLLLLLLLLL', 'L.LLLLLL.L', 'L.LLLLL.LL'];

console.log('Part 1:', part1(list));
console.log('Part 2:', part2(list));
