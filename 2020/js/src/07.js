const input = typeof window === 'undefined'
  ? require('fs').readFileSync(`${__dirname}/07.txt`, 'utf8')
  : document.body.innerText;

const containerR = /(\w+ \w+) bags contain/;
const contentR = /(\d+) (\w+ \w+) bags?/g;
const listToDict = list => list.reduce((acc, cur) => {
  const container = containerR.exec(cur);
  let content = {};

  let c;
  while ((c = contentR.exec(cur)) != null) {
    content[c[2]] = parseInt(c[1]);
  }
  acc[container[1]] = content;

  return acc;
}, {});

const contains = (bag, bagName) => Object.keys(bag).includes(bagName);

const canContainBag = (bags, searchFor, visited) => {
  return Object.entries(bags)
    .filter(bag => contains(bag[1], searchFor))
    .map(bag => bag[0])
    .reduce((acc, bag) => {
      acc.add(bag);

      return canContainBag(bags, bag, acc);
    }, visited);
};

const part1 = list => canContainBag(listToDict(list), 'shiny gold', new Set()).size;

const bagContentSize = (bags, searchFor) => Object.entries(bags[searchFor])
  .reduce((acc, [bag, amount]) =>
    acc + bagContentSize(bags, bag) * amount, 1);

const part2 = list => bagContentSize(listToDict(list), 'shiny gold') - 1;

const list = input.split('\n').filter(b => b != '');
const testList = 'light red bags contain 1 bright white bag, 2 muted yellow bags.\ndark orange bags contain 3 bright white bags, 4 muted yellow bags.\nbright white bags contain 1 shiny gold bag.\nmuted yellow bags contain 2 shiny gold bags, 9 faded blue bags.\nshiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.\ndark olive bags contain 3 faded blue bags, 4 dotted black bags.\nvibrant plum bags contain 5 faded blue bags, 6 dotted black bags.\nfaded blue bags contain no other bags.\ndotted black bags contain no other bags.'.split('\n');
const testList2 = 'shiny gold bags contain 2 dark red bags.\ndark red bags contain 2 dark orange bags.\ndark orange bags contain 2 dark yellow bags.\ndark yellow bags contain 2 dark green bags.\ndark green bags contain 2 dark blue bags.\ndark blue bags contain 2 dark violet bags.\ndark violet bags contain no other bags.'.split('\n');

console.log('Part 1:', part1(list));
console.log('Part 2:', part2(list));
