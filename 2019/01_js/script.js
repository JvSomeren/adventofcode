const src = document.body.innerText;

/**
 * Parse input
 */
const massesOfModules = src.split('\n')
    .map((mass) => parseInt(mass, 10))
    .filter((mass) => !Number.isNaN(mass));

/**
 * Part one
 */
const calculateSumOfFuelRequirements = (masses) => {
    return masses.reduce((sum, mass) => {
        return sum + Math.floor(mass / 3) - 2;
    }, 0);
};

console.log('Part one: ', calculateSumOfFuelRequirements(massesOfModules));

/**
 * Part two
 */
const calculateFuelRequirementsWithFuelMass = (mass) => {
    const fuelRequirement = Math.floor(mass / 3) - 2;

    if(fuelRequirement <= 0) {
        return 0;
    }

    return fuelRequirement + calculateFuelRequirementsWithFuelMass(fuelRequirement);
};

const calculateSumOfFuelRequirementsWithFuelMass = (masses) => {
    return masses.reduce((sum, mass) => {
        return sum + calculateFuelRequirementsWithFuelMass(mass);
    }, 0);
};

console.log('Part two: ', calculateSumOfFuelRequirementsWithFuelMass(massesOfModules));
