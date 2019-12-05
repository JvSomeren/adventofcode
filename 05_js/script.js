/**
 * Parse input
 */
const input = document.body.innerText;
const src = input.split(',');

/**
 * Part one
 */
class Program {
    constructor(instructionArray) {
        this.instructions = instructionArray.map(x => new Instruction(x))
        this.instructionPointer = 0;
        this.outputValue = 0;
    }

    get instruction() {
        return this.instructions[this.instructionPointer];
    }

    getInstructionByIndex(index) {
        return this.instructions[index].instruction;
    }

    getParameter(offset) {
        return this.instructions[this.instructionPointer + offset].instruction;
    }

    getParametersAsArray(parameterCount) {
        let returnArray = [];

        for(let i = 1; i <= parameterCount; i += 1) {
            const paramMode = this.instruction.getParamMode(i);

            if(paramMode == 0) {
                returnArray.push(this.getInstructionByIndex(this.getParameter(i)));
            } else if(paramMode == 1) {
                returnArray.push(this.getParameter(i));
            }
        }

        return returnArray;
    }

    add() {
        const [a, b, outputPosition] = [...this.getParametersAsArray(2), this.getParameter(3)];

        this.instructions[outputPosition].instruction = a + b;
        this.instructionPointer += 4;
    }
    
    multiply() {
        const [a, b, outputPosition] = [...this.getParametersAsArray(2), this.getParameter(3)];

        this.instructions[outputPosition].instruction = a * b;
        this.instructionPointer += 4;
    }

    input() {
        const [a, outputPosition] = [1, this.getParameter(1)];

        this.instructions[outputPosition].instruction = a;
        this.instructionPointer += 2;
    }

    output() {
        const [a] = this.getParametersAsArray(1);

        if(a !== 0) {
            if(this.outputValue !== 0) console.error('Faulty program');
            else this.outputValue = a;
        }
        this.instructionPointer += 2;
    }
}

class Instruction {
    constructor(value) {
        this.instruction = Number(value);
    }

    get opcode() {
        return this.mask(-2, 2);
    }

    getParamMode(paramNumber) {
        const paramOffset = -2;
        return this.mask(paramOffset - paramNumber);
    }

    mask(start, length = 1) {
        const end = start + length;
        return Number(this.instruction.toString().slice(start, end < 0 ? end : undefined));
    }
}

const executeProgram = (program) => {
    while(true) {
        const instruction = program.instruction;
        let finished = false;

        switch(instruction.opcode) {
            case 1:
                program.add();
                break;
            case 2:
                program.multiply();
                break;
            case 3:
                program.input();
                break;
            case 4:
                program.output();
                break;
            case 99:
                finished = true;
                break;
            default:
                debugger;
                console.error('Faulty instruction');
                return false;
        }

        if(finished) break;
    }

    return program.outputValue;
};

console.log('Part one: ', executeProgram(new Program(src)));
