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

    getChildById(id) {
        if(this.id === id) return this;

        for(let child of this.children) {
            const c = child.getChildById(id)
            if(c) return c;
        }

        return false;
    }

    orbitalTransfersToPoint(targetId, transferCount = 0, visitedOrbits = []) {
        const childrenAndParentArray = [...this.children, this.parent];
        let additionalTransfers = transferCount;
        visitedOrbits.push(this.id);

        if(this.id === targetId) return transferCount;

        for(let orbit of childrenAndParentArray) {
            if(orbit === null) continue;

            if(visitedOrbits.indexOf(orbit.id) === -1) {
                additionalTransfers = orbit.orbitalTransfersToPoint(targetId, transferCount + 1, visitedOrbits);

                if(additionalTransfers !== -1) return additionalTransfers;
            }
        }
        
        return -1;
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

/**
 * Part two
 */
const calculateOrbitalTransfersRequired = (orbits) => {
    const COM = new Orbit('COM');

    constructMap(orbits, COM);

    const YOU = COM.getChildById('YOU');
    return YOU.orbitalTransfersToPoint('SAN') - 2; // offset -2 because we don't count YOU and SAN orbit transfer
};

console.log('Part two: ', calculateOrbitalTransfersRequired([...src]));
