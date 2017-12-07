calculateValue = (spiral, pos) => {
  var value = 0;

  if(spiral[(pos.x-1) + ':' + (pos.y-1)] !== undefined)
    value += spiral[(pos.x-1) + ':' + (pos.y-1)];

  if(spiral[(pos.x-1) + ':' + (pos.y)] !== undefined)
    value += spiral[(pos.x-1) + ':' + (pos.y)];

  if(spiral[(pos.x-1) + ':' + (pos.y+1)] !== undefined)
    value += spiral[(pos.x-1) + ':' + (pos.y+1)];

  if(spiral[(pos.x) + ':' + (pos.y-1)] !== undefined)
    value += spiral[(pos.x) + ':' + (pos.y-1)];

  if(spiral[(pos.x) + ':' + (pos.y+1)] !== undefined)
    value += spiral[(pos.x) + ':' + (pos.y+1)];

  if(spiral[(pos.x+1) + ':' + (pos.y-1)] !== undefined)
    value += spiral[(pos.x+1) + ':' + (pos.y-1)];

  if(spiral[(pos.x+1) + ':' + (pos.y)] !== undefined)
    value += spiral[(pos.x+1) + ':' + (pos.y)];

  if(spiral[(pos.x+1) + ':' + (pos.y+1)] !== undefined)
    value += spiral[(pos.x+1) + ':' + (pos.y+1)];

  return value;
};

moveRight = (move, spiral, pos) => {
  pos.x += 1;

  spiral[pos.x + ':' + pos.y] = calculateValue(spiral, pos);

  if(spiral[pos.x + ':' + (pos.y+1)] === undefined)
    move[0] = 'u';
};

moveUp = (move, spiral, pos) => {
  pos.y += 1;

  spiral[pos.x + ':' + pos.y] = calculateValue(spiral, pos);

  if(spiral[(pos.x-1) + ':' + pos.y] === undefined)
    move[0] = 'l';
};

moveLeft = (move, spiral, pos) => {
  pos.x -= 1;

  spiral[pos.x + ':' + pos.y] = calculateValue(spiral, pos);

  if(spiral[pos.x + ':' + (pos.y-1)] === undefined)
    move[0] = 'd';
};

moveDown = (move, spiral, pos) => {
  pos.y -= 1;

  spiral[pos.x + ':' + pos.y] = calculateValue(spiral, pos);

  if(spiral[(pos.x+1) + ':' + pos.y] === undefined)
    move[0] = 'r';
};
  
const input = 347991;

var spiral = {
  '0:0': 1
};

var pos = {
  x: 0,
  y: 0
};

var move = ['r'];
while(spiral[pos.x + ':' + pos.y] < input) {
  switch(move[0]) {
    case 'r':
      moveRight(move, spiral, pos);
      break;
    case 'u':
      moveUp(move, spiral, pos);
      break;
    case 'l':
      moveLeft(move, spiral, pos);
      break;
    case 'd':
      moveDown(move, spiral, pos);
      break;
  }
}

console.log('Part 2:', spiral[pos.x + ':' + pos.y]);
