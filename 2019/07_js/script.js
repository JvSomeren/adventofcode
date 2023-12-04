/**
 * Parse input
 */
const input = document.body.innerText;
const src = input.split(',');

/**
 * Part one & part two
 */
class AmplifyController {
    constructor(instructionArray, sequence) {
        this.instructions = instructionArray;
        this.sequence = sequence;
    }

    run() {
        let output = 0;

        for(let phaseSetting of this.sequence) {
            output = new Program([...this.instructions], [phaseSetting, output]).execute();
        }
        
        return output;
    }

    static getAllPhaseSettingPermutations(input) {
        let permutations = [];

        for(let i = 0; i < input.length; i += 1) {
            let remainder = this.getAllPhaseSettingPermutations(input.slice(0, i).concat(input.slice(i + 1)));

            if(!remainder.length) {
                permutations.push([input[i]]);
            } else {
                for(let j = 0; j < remainder.length; j += 1) {
                    permutations.push([input[i]].concat(remainder[j]));
                }
            }
        }

        return permutations;
    }
}

class Program {
    constructor(instructionArray, input) {
        this.instructions = instructionArray.map(x => new Instruction(x))
        this._input = input;
        this.instructionPointer = 0;
        this.outputValue = 0;
    }

    get instruction() {
        return this.instructions[this.instructionPointer];
    }

    get inputValue() {
        if(this._input instanceof Array) return this._input.shift();

        return this._input;
    }

    execute() {
        while(true) {
            let finished = false;
    
            switch(this.instruction.opcode) {
                case 1:
                    this.add();
                    break;
                case 2:
                    this.multiply();
                    break;
                case 3:
                    this.input();
                    break;
                case 4:
                    this.output();
                    break;
                case 5:
                    this.jumpIfTrue();
                    break;
                case 6:
                    this.jumpIfFalse()
                    break;
                case 7:
                    this.lessThan();
                    break;
                case 8:
                    this.equals();
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
    
        return this.outputValue;
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
        const [a, outputPosition] = [this.inputValue, this.getParameter(1)];

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

    jumpIfTrue() {
        const [a, b] = this.getParametersAsArray(2);

        if(a !== 0) this.instructionPointer = b;
        else this.instructionPointer += 3;
    }

    jumpIfFalse() {
        const [a, b] = this.getParametersAsArray(2);

        if(a === 0) this.instructionPointer = b;
        else this.instructionPointer += 3;
    }

    lessThan() {
        const [a, b, outputPosition] = [...this.getParametersAsArray(2), this.getParameter(3)];

        this.instructions[outputPosition].instruction = a < b ? 1 : 0;
        this.instructionPointer += 4;
    }

    equals() {
        const [a, b, outputPosition] = [...this.getParametersAsArray(2), this.getParameter(3)];

        this.instructions[outputPosition].instruction = a === b ? 1 : 0;
        this.instructionPointer += 4;
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

const findLargestOutputSignal = (instructions) => {
    let sequences = AmplifyController.getAllPhaseSettingPermutations([0, 1, 2, 3, 4]);
    let maxThrusterSignal = 0;

    for(let sequence of sequences) {
        let thrusterSignal = new AmplifyController(instructions, sequence).run();
        maxThrusterSignal = Math.max(maxThrusterSignal, thrusterSignal);
    }

    return maxThrusterSignal;
};

console.log('Part one: ', findLargestOutputSignal(src));

/**
 * Part two
 */
const p2 = (instructions) => {
    let sequences = AmplifyController.getAllPhaseSettingPermutations([0, 1, 2, 3, 4]);
    let maxThrusterSignal = 0;

    for(let sequence of sequences) {
        const amplifiers = {
            A: new AmplifyController(instructions, sequence),
            B: new AmplifyController(instructions, sequence),
            C: new AmplifyController(instructions, sequence),
            D: new AmplifyController(instructions, sequence),
            E: new AmplifyController(instructions, sequence),
        };

    }
};

console.log('Part two: ', p2(src));
