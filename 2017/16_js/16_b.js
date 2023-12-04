const src = document.body.innerText;

let programs = 'abcdefghijklmnop';
programs = programs.split('');
let start = programs.join('');

spinPrograms = (n) => {
    return programs.slice(-n).concat(programs.slice(0, programs.length - n));
}

exchangePrograms = (a, b) => {
    let arr = [...programs];
    arr[a] = programs[b];
    arr[b] = programs[a];

    return arr;
}

partnerPrograms = (a, b) => {
    let arr = [...programs];
    let i = programs.indexOf(a);
    let j = programs.indexOf(b);

    arr[i] = programs[j];
    arr[j] = programs[i];

    return arr;
}

let iterations = 1000000000
for(let it = 0; it < iterations; it++) {
    if(it == 1)
        console.log('Part one:', programs.join(""));
        
    src.split(',').forEach((item) => {
        let matches;

        switch(item[0]) {
            case 's':
                programs = spinPrograms(item.match(/s(\d{1,})/)[1]);
                break;
            case 'x':
                matches = item.match(/x(\d{1,})\/(\d{1,})/);
                programs = exchangePrograms(matches[1], matches[2]);
                break;
            case 'p':
                matches = item.match(/p(\w)\/(\w)/);
                programs = partnerPrograms(matches[1], matches[2]);
                break;
            default:
                break;
        }
    });

    if(programs.join('') == start)
        it += (Math.floor(iterations/(it+1))-1) * (it+1)
}

console.log('Part two: ', programs.join(""));
