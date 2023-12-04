const input = typeof window === 'undefined'
  ? require('fs').readFileSync(`${__dirname}/08.txt`, 'utf8')
  : document.body.innerText;

const instrExp = /(\w+) ([-+]\d+)/;
const _part1 = (instructions, index = 0, acc = 0, visited = new Set(), part2 = false) => {
  if(index === instructions.length) return acc;
  const instruction = instrExp.exec(instructions[index]);

  if (visited.has(index)) return part2 ? false : acc;
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

  return _part1(instructions, index, acc, visited, part2);
};

const part1 = instructions => _part1(instructions);

// brute forcing it is :(
const part2 = instrunctions => {
  let acc;

  for(let i = 0; i < instrunctions.length; i += 1) {
    const instrs = [...instrunctions];

    if(instrs[i].startsWith('jmp')) {
      instrs[i] = instrs[i].replace('jmp', 'nop');
    } else if(instrs[i].startsWith('nop')) {
      instrs[i] = instrs[i].replace('nop', 'jmp');
    }

    acc = _part1(instrs, 0, 0, new Set(), true);

    if(acc !== false) break;
  }
  
  return acc;
};

const list = input.split('\n')
  .filter(i => i != '');
const testList = ['nop +0', 'acc +1', 'jmp +4', 'acc +3', 'jmp -3', 'acc -99', 'acc +1', 'jmp -4', 'acc +6'];

console.log('Part 1:', part1(list));
console.log('Part 2:', part2(list));
