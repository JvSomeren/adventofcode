const input = typeof window === 'undefined'
  ? require('fs').readFileSync(`${__dirname}/09.txt`, 'utf8')
  : document.body.innerText;

const pipe = (...fns) => (x) => fns.reduce((v, f) => f(v), x);

const noSumInPreamble = preamble => (target, i, arr) => {
  if (i < preamble) return false;

  return !arr.slice(i - preamble, i)
    .some((x, _, subArr) => {
      const val = target - x;
      return val !== x && subArr.includes(val)
    });
}

const part1 = (list, preamble = 25) => list.find(noSumInPreamble(preamble));

const numSort = (a, b) => a - b;

const findRangeOfSum = list => invalidNum => list.reduce((acc, cur, index, list) => {
  if (acc.sum === invalidNum) return acc;
  while (acc.sum + cur > invalidNum) {
    acc.sum = acc.sum - list[acc.lowerIndex++];
  }

  return {
    sum: acc.sum + cur,
    lowerIndex: acc.lowerIndex,
    upperIndex: index,
  };
}, { sum: 0, lowerIndex: 0, upperIndex: 0 });

const sortInRange = list => result => list.slice(result.lowerIndex, result.upperIndex).sort(numSort);

const sumFirstAndLastElement = list => list[0] + list[list.length - 1];

const part2 = (list, preamble = 25) => pipe(part1, findRangeOfSum(list), sortInRange(list), sumFirstAndLastElement)(list);

const list = input.split('\n')
  .filter(i => i != '')
  .map(i => parseInt(i));
const testList = [35, 20, 15, 25, 47, 40, 62, 55, 65, 95, 102, 117, 150, 182, 127, 219, 299, 277, 309, 576];

console.log('Part 1:', part1(list));
console.log('Part 2:', part2(list));
