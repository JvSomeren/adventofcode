const input = typeof window === 'undefined'
  ? require('fs').readFileSync(`${__dirname}/04.txt`, 'utf8')
  : document.body.innerText;

const filterPart1 = p => Object.keys(p).length === 8
  || (Object.keys(p).length === 7 && !Object.keys(p).includes('cid'));

const _part1 = list => list.map(p => p.map(x => x.split(':')))
  .map(p => p.reduce((acc, cur) => {
    acc[cur[0]] = cur[1];
    return acc;
  }, {}))
  .filter(filterPart1);

const part1 = list => _part1(list).length;

const validateHeight = value => {
  const unit = value.slice(-2);
  const height = value.replace(unit, '');
  if (unit === 'cm') return height >= '150' && height <= '193';
  if (unit === 'in') return height >= '59' && height <= '76';

  return false;
};

const pidExp = /^\d{9}$/;
const hclExp = /^#[0-9a-f]{6}$/;
const validateProperty = ([key, value]) => {
  switch (key) {
    case 'byr': return value >= '1920' && value <= '2002';
    case 'iyr': return value >= '2010' && value <= '2020';
    case 'eyr': return value >= '2020' && value <= '2030';
    case 'hgt': return validateHeight(value);
    case 'hcl': return hclExp.test(value);
    case 'ecl': return ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth']
      .includes(value);
    case 'pid': return pidExp.test(value);
    case 'cid': return true;
  };
};

const validatePassport = p => Object.entries(p).every(validateProperty);

const part2 = list => _part1(list).filter(validatePassport).length;

const list = input.split('\n\n')
  .map(p => p.replace(/\n/g, ' '))
  .map(p => p.split(' ')
    .filter(k => k != ''));

console.log('Part 1:', part1(list));
console.log('Part 2:', part2(list));
