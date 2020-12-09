const input = typeof window === 'undefined'
  ? require('fs').readFileSync(`${__dirname}/05.txt`, 'utf8')
  : document.body.innerText;

const LOWER = (i, obj) => {
  obj.upper = obj.lower + (obj.bound >> i);

  return obj;
};

const UPPER = (i, obj) => {
  obj.lower = obj.upper - (obj.bound >> i);

  return obj;
};

const A = {
  F: LOWER,
  L: LOWER,
  B: UPPER,
  R: UPPER,
};

const findInRange = (str, lower, upper) => {
  let obj = { lower, upper, bound: upper };

  obj = str.split('').reduce((acc, cur, i) => {
    return A[cur](i + 1, acc);
  }, obj);

  return obj.lower;
};

const seatId = str => {
  let row = 0;
  let column = 0;

  row = findInRange(str.slice(0, 7), 0, 127);

  column = findInRange(str.slice(7), 0, 7);

  return row * 8 + column;
};

const numSort = (a, b) => a - b;

const _part1 = list => list.map(seatId)
  .sort(numSort);

const part1 = list => _part1(list).reverse()[0];

const neighbourSeatId = (seatId, i, arr) => i !== 0 && seatId + 1 !== arr[i + 1];

const part2 = list => _part1(list).find(neighbourSeatId) + 1;

const list = input.split('\n')
  .filter(i => i != '');
const testList = ['FBFBBFFRLR', 'BFFFBBFRRR', 'FFFBBBFRRR', 'BBFFBBFRLL'];

console.log('Part 1:', part1(list));
console.log('Part 2:', part2(list));
