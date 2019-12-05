/**
 * Parse input
 */
const input = '109165-576723';
const src = input.split('-').map(x => parseInt(x, 10));

/**
 * Part one
 */
Array.prototype.range = (start, end) => {
    return Array(end - start + 1).fill().map((_, idx) => (start + idx).toString());
};

const hasEqualOrGreaterDigitSequence = (password) => {
    const digits = [...password];
    return digits.every((number, idx) => idx === 0 || digits[idx - 1] <= number)
};

const validatePassword = (password) => {
    if(!/(\d)\1/.test(password)) return false;

    return hasEqualOrGreaterDigitSequence(password);
};

const calculateValidPasswordCount = (start, end) => {
    let list = new Array().range(start, end);

    list = list.filter(validatePassword);

    return list.length;
};

console.log('Part one: ', calculateValidPasswordCount(src[0], src[1]));
