const input = typeof window === 'undefined'
  ? require('fs').readFileSync(`${__dirname}/02.txt`, 'utf8')
  : document.body.innerText;

const _part1 = str => {
  str = str.split(' ');

  let [lower, upper] = str[0].split('-')
  let letter = str[1][0];
  str = str[2];

  let count = 0;
  for (let s of str) s === letter ? count++ : null;

  return count >= lower && count <= upper;
};

const _part2 = str => {
  str = str.split(' ');

  let [lower, upper] = str[0].split('-')
  let letter = str[1][0];
  str = str[2];

  return (str[lower - 1] === letter) != (str[upper - 1] === letter);
};

const part1 = list => list.filter(_part1).length;
const part2 = list => list.filter(_part2).length;

const list = input.split('\n')
  .filter(i => i != '');
const testList = ['1-3 a: abcde', '1-3 b: cdefg', '2-9 c: ccccccccc'];

console.log('Part 1:', part1(list));
console.log('Part 2:', part2(list));
