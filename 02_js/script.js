/**
 * Parse input
 */
const src = document.body.innerText.split(',').map(x => parseInt(x, 10));

/**
 * Part one
 */
const getParametersAsArray = (instructions, instructionPointer) => {
    return [
        instructions[instructions[instructionPointer + 1]],
        instructions[instructions[instructionPointer + 2]],
        instructions[instructionPointer + 3],
    ];
};

const add = (instructions, instructionPointer) => {
    const [a, b, outputPosition] = getParametersAsArray(instructions, instructionPointer);

    instructions[outputPosition] = a + b;
    return instructions;
};

const multiply = (instructions, instructionPointer) => {
    const [a, b, outputPosition] = getParametersAsArray(instructions, instructionPointer);

    instructions[outputPosition] = a * b;
    return instructions;
};

const executeProgram = (instructions) => {
    let instructionPointer = 0;

    while(true) {
        let finished = false;

        switch(instructions[instructionPointer]) {
            case 1:
                instructions = add(instructions, instructionPointer);
                instructionPointer += 4;
                break;
            case 2:
                instructions = multiply(instructions, instructionPointer);
                instructionPointer += 4;
                break;
            case 99:
                finished = true;
                break;
            default:
                console.error('Faulty input');
                return false;
        }

        if(finished) break;
    }

    return instructions[0];
};

const prepareProgram = (i) => {
    let instructions = [...i];

    instructions[1] = 12;
    instructions[2] = 2;

    return executeProgram(instructions);
};

console.log('Part one: ', prepareProgram(src));
