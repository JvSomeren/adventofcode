/**
 * Parse input
 */
const testInput = '123456789012'
const input = document.body.innerText;
const src = input.replace(/\W/g, '');

/**
 * Part one (quick and dirty)
 */
const validateImage = (string, width, height) => {
    const digitsPerLayer = width * height;
    const layerCount = string.length / digitsPerLayer;
    let layers = new Array(layerCount);
    let layerDigitCount = new Array(layerCount);
    
    for(let i = 0; i < layerCount; i += 1) {
        layers[i] = new Array(digitsPerLayer);

        for(let j = 0; j < digitsPerLayer; j += 1) {
            layers[i][j] = parseInt(string[i * digitsPerLayer + j], 10);
        }

        layerDigitCount[i] = layers[i].reduce((acc, cur) => {
            acc[cur] += 1
            return acc;
        }, new Array(10).fill(0));
    }

    layerDigitCount = layerDigitCount.sort((a, b) => {
        if(a[0] < b[0]) return -1;
        return 1;
    });

    return layerDigitCount[0][1] * layerDigitCount[0][2];
};

console.log('Part one: ', validateImage(src, 25, 6));
