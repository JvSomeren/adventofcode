const input = typeof window === 'undefined'
  ? require('fs').readFileSync(`${__dirname}/12.txt`, 'utf8')
  : document.body.innerText;

const pipe = (...fns) => (x) => fns.reduce((v, f) => f(v), x);

const part1 = (list, dx = 1, dy = 0, useWaypoint = false) => pipe(
  list => list.reduce((acc, cur) => {
    const instruction = cur[0];
    let value = parseInt(cur.slice(1));
    const movementCoords = {
      x: useWaypoint ? 'dx' : 'x',
      y: useWaypoint ? 'dy' : 'y',
    };

    if(instruction === 'L' || instruction === 'R') value = value / 90;

    switch (instruction) {
      case 'N':
        acc[movementCoords.y] += value; break;
      case 'E':
        acc[movementCoords.x] += value; break;
      case 'S':
        acc[movementCoords.y] -= value; break;
      case 'W':
        acc[movementCoords.x] -= value; break;
      case 'L':
        value = -value + 4;
      case 'R':
        for(let i = 0; i < value; i += 1) {
          const { dx, dy } = acc;
          acc.dx = dy;
          acc.dy = -dx;
        }
        break;
      case 'F':
        acc.x += acc.dx * value;
        acc.y += acc.dy * value;
        break;
    }

    return acc;
  }, { x: 0, y: 0, dy, dx }),
  obj => Math.abs(obj.x) + Math.abs(obj.y),
)(list);

const part2 = list => part1(list, 10, 1, true);

const list = input.split('\n')
  .filter(l => l != '');
const testList = ['F10', 'N3', 'F7', 'R90', 'F11'];

console.log('Part 1:', part1(list));
console.log('Part 2:', part2(list));
