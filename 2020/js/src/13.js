const input = typeof window === 'undefined'
  ? require('fs').readFileSync(`${__dirname}/13.txt`, 'utf8')
  : document.body.innerText;

const memoize = (fn) => {
  let cache = new Map();

  return (...args) => {
    const profile = args.join('~');

    if (cache.has(profile)) {
      return cache.get(profile);
    } else {
      const result = fn(...args);
      cache.set(profile, result);

      return result;
    }
  }
}

const pipe = (...fns) => (x) => fns.reduce((v, f) => f(v), x);

const parseInput = list => {
  return {
    now: parseInt(list[0]),
    busIds: list[1].split(',')
      .map(x => x === 'x' ? x : parseInt(x)),
  };
};

const part1 = list => pipe(
  parseInput,
  obj => {
    let lowestWait = 99999;
    let useBusId = null;
    for(let busId of obj.busIds) {
      if(busId === 'x') continue;

      let waitTime = busId - obj.now % busId;
      if(waitTime < lowestWait) {
        lowestWait = waitTime;
        useBusId = busId;
      }
    }

    return lowestWait * useBusId;
  }
)(list);

const parseInput2 = list => {
  return list[1].split(',').reduce((acc, cur, index) => {
    if(cur === 'x') return acc;
    acc.busIds.push(parseInt(cur));
    acc.offsets.push(Math.abs(cur - index) % cur);

    return acc;
  }, { busIds: [], offsets: [] });
};

const findT = obj => {
  const k = obj.busIds.length;
  let x = 1; // Initialize result 
  console.log(obj);

	// As per the Chinise remainder 
	// theorem, this loop will 
	// always break. 
	while (true) 
	{ 
		// Check if remainder of 
		// x % num[j] is rem[j] 
		// or not (for all j from 
		// 0 to k-1) 
		let j; 
		for (j = 0; j < k; j += 1) 
			if (x % obj.busIds[j] != obj.offsets[j]) 
			break; 

		// If all remainders 
		// matched, we found x 
		if (j == k) 
			return x; 

		// Else try next numner 
		x += 1; 
	} 

	return x; 
};

const part2 = list => pipe(
  parseInput2,
  findT,
)(list);

const list = input.split('\n')
  .filter(i => i != '');
const testList = ['939', '7,13,x,x,59,x,31,19'];
const testList2 = ['', '17,x,13,19'];
const testList6 = ['', '1789,37,47,1889'];
const testList7 = ['', '3,x,4,x,2'];

console.log('Part 1:', part1(list));
console.log('Part 2:', part2(list));
