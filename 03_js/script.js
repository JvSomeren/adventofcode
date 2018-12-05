const src = document.body.innerText.split("\n").filter(x => x != "");
let board = [];

/**
 * Initialize board
 */
for(let i = 0; i < 1000; i++) {
    let row = [];

    for(let j = 0; j < 1000; j++) {
        row.push('.');
    }

    board.push(row);
}

/**
 * Part one
 */
for(let claim of src) {
    let matches = claim.match(/#(\d{1,}) @ (\d{1,}),(\d{1,}): (\d{1,})x(\d{1,})/);

    // matches[]:
    // 1: id
    // 2: offsetLeft
    // 3: offsetTop
    // 4: width
    // 5: height
    for(let i = 1; i <= 5; i++)
        matches[i] = Number(matches[i]);

    for(let i = matches[3]; i < matches[3] + matches[5]; i++) {
        for(let j = matches[2]; j < matches[2] + matches[4]; j++) {
            if(board[i][j] == '.')
                board[i][j] = matches[1];
            else
                board[i][j] = 'X';
        }
    }
}

let count = 0;
for(let i = 0; i < 1000; i++) {
    for(let j = 0; j < 1000; j++) {
        if(board[i][j] == 'X')
            count++;
    }
}

console.log("Part one:", count);

/**
 * Part two
 */
let bestId = -1;
for(let claim of src) {
    let matches = claim.match(/#(\d{1,}) @ (\d{1,}),(\d{1,}): (\d{1,})x(\d{1,})/);
    let claimed = false;

    // matches[]:
    // 1: id
    // 2: offsetLeft
    // 3: offsetTop
    // 4: width
    // 5: height
    for(let i = 1; i <= 5; i++)
        matches[i] = Number(matches[i]);

    for(let i = matches[3]; i < matches[3] + matches[5]; i++) {
        for(let j = matches[2]; j < matches[2] + matches[4]; j++) {
            if(board[i][j] == 'X')
                claimed = true;
        }
    }

    if(!claimed)
        bestId = matches[1];
}

console.log("Part two:", bestId);
