const src = document.body.innerText;
let frequency = 0;

/**
 * Parse input
 */
const changes = src.split('\n').map((change) => {
    let num = parseInt(change.substring(1));

    if(!Number.isNaN(num)) {
        return {
            value: num,
            increment: change.startsWith('+')
        };
    }

    return { value: 0, increment: true };
}).filter(change => change.value != 0);

/**
 * Part one
 */
changes.forEach((change) => {
    if(change.increment)
        frequency += change.value;
    else
        frequency -= change.value;
});

console.log('Part one: ', frequency);

/**
 * Part two
 */
let frequenciesFound = [];
let i = 0;
frequency = 0;
while(true) {
    let index = i % changes.length;

    if(changes[index].increment)
        frequency += changes[index].value;
    else
        frequency -= changes[index].value;

    if(frequenciesFound.indexOf(frequency) != -1) {
        frequenciesFound.push(frequency);
        break;
    }

    frequenciesFound.push(frequency);
    i++;
}

console.log('Part two: ', frequenciesFound.pop());
