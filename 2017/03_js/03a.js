const input = 347991;
var spiral = [1, 8];
var totalSum = 9;
var newOuterCircle;

for(i = 1; totalSum < input; i++) {
  newOuterCircle = (spiral[i] - 4) + (4 * 3);
  totalSum += newOuterCircle;
  spiral.push(newOuterCircle);
}

const quadrantLength = spiral[spiral.length-1] / 4;

var quadrant = 1;

while(totalSum - quadrantLength * quadrant > input) {
  quadrant++;
}

const middleOfQuadrant = totalSum - (quadrantLength * (quadrant - 1)) - quadrantLength / 2;

var steps = spiral.length - 1;

if(middleOfQuadrant > input)
  steps += middleOfQuadrant - input;
else
  steps += input - middleOfQuadrant;

console.log('Part 1:', steps);
