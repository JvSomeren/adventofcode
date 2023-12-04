/**
 * Parse input
 */
const testInput = `.#..##.###...#######
##.############..##.
.#.######.########.#
.###.#######.####.#.
#####.##.#.##.###.##
..#####..#.#########
####################
#.####....###.#.#.##
##.#################
#####.##.###..####..
..######..##.#######
####.##.####...##..#
.#####..#.######.###
##...#.##########...
#.##########.#######
.####.#.###.###.#.##
....##.##.###..#####
.#.#.###########.###
#.#.#.#####.####.###
###.##.####.##.#..##`;
// const testInput = `......#.#.
// #..#.#....
// ..#######.
// .#.#.###..
// .#..#.....
// ..#....#.#
// #..#....#.
// .##.#..###
// ##...#..#.
// .#....####`;
// const input = document.body.innerText;
const src = testInput.split('\n').map(x => x.split(''));

/**
 * Part one
 */
class Astroid {
    constructor(x, y) {
        this.x = x;
        this.y = y;
        this.canDetectAstroids = [];
        this.otherAstroids = [];
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

    listOtherAstroids(astroids) {
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

        this.otherAstroids = arr.sort((a, b) => a.angle - b.angle);
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

    // sort most detectable astroids desc
    astroids.sort((a, b) => b.canDetectAstroids.length - a.canDetectAstroids.length);

    return astroids[0];
};

console.log('Part one: ', findBestLocation(src).canDetectAstroids.length);

/**
 * Part two
 */
const find200thVaporizedAsteroid = (map) => {
    const astroids = locateAstroids(map);
    const station = findBestLocation(map);

    station.listOtherAstroids(astroids);

    let arr = station.otherAstroids.reduce((acc, astroid) => {
        const index = acc.findIndex((a) => a.angle === astroid.angle);
        if(index !== -1) acc[index].astroids.push(astroid);
        else {
            acc.push({
                angle: astroid.angle,
                astroids: [astroid],
            });
        }

        return acc;
    }, []);

    for(let astroid of arr) {
        astroid.astroids.sort((a, b) => a.distance - b.distance);
    }

    let angle = -(Math.PI / 2) - 0.00000000001;
    let lastAstroid = null;
    for(let i = 0; i < 200; i += 1) {
        let index = arr.findIndex((x) => x.angle > angle);
        if(index !== -1) angle = arr[index].angle;
        else {
            angle = -(Math.PI / 2);
            index = arr.findIndex((x) => x.angle > angle);
        }

        console.log(arr[index], index);
        lastAstroid = arr[index].astroids.splice(0, 1);
        if(arr[index].astroids.length === 0) arr.splice(index, 1);

        // if(typeof arr[index] === 'undefined') return arr;
    }

    return arr;
};

console.log('Part two: ', find200thVaporizedAsteroid(src));
