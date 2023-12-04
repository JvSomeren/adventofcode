/**
 * Parse input
 */
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

/**
 * Part two (quicker and dirtier)
 */
const decodeImage = (string, width, height) => {
    const digitsPerLayer = width * height;
    const layerCount = string.length / digitsPerLayer;
    let layers = new Array(layerCount);
    let finalImage = new Array(digitsPerLayer).fill(-1);
    
    for(let i = 0; i < layerCount; i += 1) {
        layers[i] = new Array(digitsPerLayer);

        for(let j = 0; j < digitsPerLayer; j += 1) {
            layers[i][j] = parseInt(string[i * digitsPerLayer + j], 10);
        }
    }
    
    for(let i = 0; i < digitsPerLayer; i += 1) {
        let j = 0;

        while(finalImage[i] === -1) {
            if(layers[j][i] !== 2) {
                finalImage[i] = layers[j][i];
                break;
            }

            j += 1;
        }
    }

    document.body.innerHTML = '';
    document.body.style.backgroundColor = 'gray';
    for(let i = 0; i < height; i += 1) {
        let p = document.createElement("div");
        for(let j = 0; j < width; j += 1) {
            let c = document.createElement("span");
            c.style.display = 'inline-block';
            c.style.width = '5px';
            c.style.height = '5px';
            c.style.backgroundColor = finalImage[i * width + j] === 0 ? 'black' : 'white';

            p.appendChild(c);
        }

        document.body.appendChild(p);
    }

    return finalImage;
};

console.log('Part two: ', decodeImage(src, 25, 6));
