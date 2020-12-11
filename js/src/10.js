const input = typeof window === 'undefined'
  ? require('fs').readFileSync(`${__dirname}/10.txt`, 'utf8')
  : document.body.innerText;

const memoize = (fn) => {
  let cache = new Map();

  return (...args) => {
    const profile = args.join('~');

    if(cache.has(profile)) {
      return cache.get(profile);
    } else {
      const result = fn(...args);
      cache.set(profile, result);

      return result;
    }
  }
}

const pipe = (...fns) => (x) => fns.reduce((v, f) => f(v), x);

const numSort = (a, b) => a - b;

const part1 = list => pipe(
  list => [0, ...list].sort(numSort),
  list => list.reduce((acc, cur, i, arr) => {
    if(i === 0) return acc;

    const diff = cur - arr[i - 1];
    acc[diff] = acc[diff] + 1;

    return acc;
  }, [0, 0, 0, 1]),
  diffs => diffs[1] * diffs[3],
)(list);

const calculateDifferentParts = memoize(list => {
  if(list.length === 1) return 1;

  return list.slice(1)
    .filter(x => x - list[0] <= 3)
    .reduce((acc, _, index, l) => acc + calculateDifferentParts(list.slice(index + 1)), 0);
});

const part2 = list => pipe(
  list => [...list].sort(numSort),
  list => [0, ...list, list[list.length - 1] + 3],
  calculateDifferentParts,
)(list);

const list = input.split('\n')
  .filter(i => i != '')
  .map(i => parseInt(i));
const testList = [16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4];
const testList2 = [28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19, 38, 39, 11, 1, 32, 25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3];

console.log('Part 1:', part1(list));
console.log('Part 2:', part2(list));
