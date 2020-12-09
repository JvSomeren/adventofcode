const input = typeof window === 'undefined'
  ? require('fs').readFileSync(`${__dirname}/08.txt`, 'utf8')
  : document.body.innerText;

const instrExp = /(\w+) ([-+]\d+)/;
const _part1 = (instructions, index = 0, acc = 0, visited = new Set()) => {
  const instruction = instrExp.exec(instructions[index]);

  if (visited.has(index)) return acc;
  else visited.add(index);

  switch (instruction[1]) {
    case 'jmp':
      index += parseInt(instruction[2]);
      break;
    case 'acc':
      acc += parseInt(instruction[2]);
    case 'nop':
    default:
      index += 1;
      break;
  }

  return _part1(instructions, index, acc, visited);
};

const part1 = instructions => _part1(instructions);

const list = input.split('\n')
  .filter(i => i != '');
const testList = ['nop +0', 'acc +1', 'jmp +4', 'acc +3', 'jmp -3', 'acc -99', 'acc +1', 'jmp -4', 'acc +6'];

console.log('Part 1:', part1(list));
