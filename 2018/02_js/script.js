const src = document.body.innerText.split('\n').filter(x => x != "");
let twice = thrice = 0;

/**
 * Part one
 */
for(let id of src) {
    let obj = {};
    let hasTwice = hasThrice = false;

    for(let letter of id) {
        if(typeof obj[letter] == 'undefined')
            obj[letter] = 1;
        else
            obj[letter]++;
    }

    for(let letter in obj) {
        switch(obj[letter]) {
            case 2:
                hasTwice = true;
                break;
            case 3:
                hasThrice = true;
                break;
            default:
                break;
        }
    }

    if(hasTwice) twice++;
    if(hasThrice) thrice++;
}

console.log('Part one: ', twice * thrice);

/**
 * Part two
 */
remove_character = (str, char_pos) => {
    part1 = str.substring(0, char_pos);
    part2 = str.substring(char_pos + 1, str.length);
    return (part1 + part2);
}

let found = false;
for(let i = 0; i < src.length; i++) {
    for(let j = i + 1; j < src.length; j++) {
        let differences = [];

        let str1 = src[i].split('');
        let str2 = src[j].split('');

        for(let k = 0; k < str1.length; k++) {
            if(str1[k] != str2[k])
                differences.push(k);
        }

        if(differences.length == 1) {
            console.log('Part two: ', remove_character(src[i], differences[0]));
            found = true;
            break;
        }
    }

    if(found)
        break;
}
