/**
 * Parse input
 */
const input = document.body.innerText;
const src = input.split('\n').map(x => x.split(')')).filter(x => x.length > 1);

/**
 * Part one
 */
class Orbit {
    constructor(id) {
        this.id = id;
        this.parent = null;
        this._children = [];
    }

    get orbits() {
        return this.parent || false;
    }

    set orbits(_parent) {
        this.parent = _parent;
        _parent.children = this;
    }

    get children() {
        return this._children;
    }

    set children(child) {
        this._children.push(child);
    }

    static directAndIndirectOrbitCount(COM, depth = 0) {
        let sum = depth;

        for(let child of COM.children) {
            sum += Orbit.directAndIndirectOrbitCount(child, depth + 1);
        }

        return sum;
    }
}

const constructMap = (orbits, parent) => {
    let index;
    let children = [];

    do {
        index = orbits.findIndex((o => o[0] === parent.id));
        
        if(index !== -1) children.push(orbits.splice(index, 1)[0]);
    } while(index !== -1);

    for(let child of children) {
        let orbit = new Orbit(child[1]);
        orbit.orbits = parent;

        constructMap(orbits, orbit);
    }
};

const calculateDirectAndIndirectOrbits = (orbits) => {
    const COM = new Orbit('COM');

    constructMap(orbits, COM);

    return Orbit.directAndIndirectOrbitCount(COM);
};

console.log('Part one: ', calculateDirectAndIndirectOrbits([...src]));
