const input = typeof window === 'undefined'
  ? require('fs').readFileSync(`${__dirname}/06.txt`, 'utf8')
  : document.body.innerText;

const part1 = list => list.map(l => l.replace(/\n/g, ''))
  .map(g => new Set(g.split('')).size)
  .reduce((acc, cur) => acc + cur);

const intersect = (a, b) => new Set([...a].filter(x => b.has(x)));

const _part2 = group => group.trim()
  .split('\n')
  .map(r => new Set(r.split('')))
  .reduce((acc, cur) => intersect(acc, cur));

const part2 = list => list.map(_part2)
  .reduce((acc, cur) => acc + cur.size, 0);

const list = input.split('\n\n');
const testList = ['abc', 'a\nb\nc', 'ab\nac', 'a\na\na\na', 'b'];

console.log('Part 1:', part1(list));
console.log('Part 2:', part2(list));
