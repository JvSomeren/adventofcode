const input = typeof window === 'undefined'
  ? require('fs').readFileSync(`${__dirname}/01.txt`, 'utf8')
  : document.body.innerText;

const _func = (list, target) => {
  if (!list.length) return -1;

  const [x, ...remainder] = list;
  let i;
  for (i = remainder.length - 1; i >= 0; i -= 1) {
    const sum = x + remainder[i];
    if (sum === target) return x * remainder[i];
    if (sum < target) return _func(remainder.slice(0, i + 1), target);
  }

  return _func(remainder, target);
};

const part1 = (list, target) => _func(list.sort((a, b) => a - b), target);

const part2 = (list, target) => {
  const [x, ...remainder] = list;

  const res = part1(remainder, target - x)
  if (res !== -1) return res * x;

  return part2(remainder, target);
};

const list = input
  .split('\n')
  .map(i => parseInt(i))
  .filter(i => !isNaN(i));

const TARGET = 2020;
console.log('Part 1:', part1(list, TARGET));
console.log('Part 2:', part2(list, TARGET));
