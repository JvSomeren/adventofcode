/**
 * Parse input
 */
const input = document.body.innerText;
const src = input.split('\n').map(x => x.split(',').map(y => {
    return {
        direction: y.charAt(0),
        distance: parseInt(y.slice(1), 10),
    };
})).filter(x => x.length > 1);

/**
 * Part one
 */
const followInstruction = (direction, distance, coordinates) => {
    switch(direction) {
        case 'U':
            coordinates.y -= distance;
            break;
        case 'D':
            coordinates.y += distance;
            break;
        case 'L':
            coordinates.x -= distance;
            break;
        case 'R':
            coordinates.x += distance;
            break;
        default:
            console.error('Faulty input', instruction);
            break;
    }
}

const findPanelSize = (paths) => {
    let coordinates = {
        x: 0,
        y: 0,
        min: {
            x: 0,
            y: 0,
        },
        max: {
            x: 0,
            y: 0,
        },
    };
    
    for(let path of paths) {
        coordinates.x = 0;
        coordinates.y = 0;

        for(let instruction of path) {
            followInstruction(instruction.direction, instruction.distance, coordinates);

            coordinates.min.x = Math.min(coordinates.min.x, coordinates.x);
            coordinates.min.y = Math.min(coordinates.min.y, coordinates.y);
            coordinates.max.x = Math.max(coordinates.max.x, coordinates.x);
            coordinates.max.y = Math.max(coordinates.max.y, coordinates.y);
        }
    }

    return {
        width: Math.abs(coordinates.min.x) + coordinates.max.x,
        height: Math.abs(coordinates.min.y) + coordinates.max.y,
        center: {
            x: Math.abs(coordinates.min.x),
            y: Math.abs(coordinates.min.y),
        }
    };
};

const initializePanelWithSize = (size) => {
    let panel = [];
    
    for(let i = 0; i <= size.height; i += 1) {
        panel[i] = [];
        
        for(let j = 0; j <= size.width; j += 1) {
            panel[i][j] = '.';
        }
    }
    
    return panel;
}

const drawPanel = (paths) => {
    const size = findPanelSize(paths);
    let panel = initializePanelWithSize(size);
    let index = 0;

    panel[size.center.y][size.center.x] = '0';
    for(let path of paths) {
        index += 1;
        let position = {
            x: size.center.x,
            y: size.center.y,
        }
        
        for(let instruction of path) {
            for(let i = 0; i < instruction.distance; i += 1) {
                followInstruction(instruction.direction, 1, position);
                
                if(panel[position.y][position.x] !== '.' && panel[position.y][position.x] !== index.toString()) {
                    panel[position.y][position.x] = 'X';
                } else {
                    panel[position.y][position.x] = index.toString();
                }
            }
        }
    }

    return {
        panel,
        center: size.center,
    };
};

const calculateManhattanDistance = (a, b) => {
    return Math.abs(Math.abs(a.x) - Math.abs(b.x)) + Math.abs(Math.abs(a.y) - Math.abs(b.y));
};

const findClosestIntersection = (paths) => {
    const {panel, center} = drawPanel(paths);
    let distanceToClosestIntersection = Number.MAX_SAFE_INTEGER;

    for(let y in panel) {
        for(let x in panel[y]) {
            if(panel[y][x] === 'X') {
                distanceToClosestIntersection = 
                Math.min(distanceToClosestIntersection, calculateManhattanDistance(
                    center,
                    { x, y }
                ));
            }
        }
    }
        
    return distanceToClosestIntersection;
};

console.log('Part one: ', findClosestIntersection(src));
