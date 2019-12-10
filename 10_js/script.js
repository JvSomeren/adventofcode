/**
 * Parse input
 */
const input = document.body.innerText;
const src = input.split('\n').map(x => x.split(''));

/**
 * Part one
 */
class Astroid {
    constructor(x, y) {
        this.x = x;
        this.y = y;
        this.canDetectAstroids = [];
    }

    equals(otherAstroid) {
        return this.x === otherAstroid.x && this.y === otherAstroid.y;
    }

    findDetectableAstroids(astroids) {
        let arr = [];

        for(let astroid of astroids) {
            if(this.equals(astroid)) continue;
            let dx = astroid.x - this.x;
            let dy = astroid.y - this.y;
            let distance = Math.sqrt(dx*dx + dy*dy);
            let angle = Math.atan2(dy, dx);

            arr.push({
                astroid,
                distance,
                angle,
            });
        }

        arr = arr.sort((a, b) => a.distance - b.distance);

        this.canDetectAstroids = arr.reduce((acc, cur) => {
            if(acc.findIndex((a) => a.angle === cur.angle) === -1) acc.push(cur);;

            return acc;
        }, []);
    }
}

const locateAstroids = (map) => {
    let astroids = [];

    for(let y = 0; y < map.length; y += 1) {
        for(let x = 0; x < map[y].length; x += 1) {
            const position = map[x][y];
            
            if(position === '#') astroids.push(new Astroid(x, y));
        }
    }

    return astroids;
};

const findBestLocation = (map) => {
    const astroids = locateAstroids(map);

    for(let astroid of astroids) {
        astroid.findDetectableAstroids(astroids);
    }

    astroids.sort((a, b) => b.canDetectAstroids.length - a.canDetectAstroids.length);

    return astroids[0];
};

console.log('Part one: ', findBestLocation(src).canDetectAstroids.length);
