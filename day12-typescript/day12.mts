import { readFileSync } from "node:fs";

const [presents, regions] = parseInput();
console.log(`Day 12 part 1: ${part1(presents, regions)}`);
console.log(`Day 12 part 2: TODO`);

type Present = string[];
type Region = { width: number; height: number; presentCount: number[] };

function parseInput(): [Present[], Region[]] {
    const sections = readFileSync(0, "utf-8").trim().split("\n\n");

    const presents = sections.slice(0, -1).map<Present>(str => str.split("\n").slice(1));
    const regions = sections
        .at(-1)!
        .split("\n")
        .map<Region>(str => {
            const [, w, h, c] = /^(\d+)x(\d+): ([0-9 ]+)$/.exec(str)!;
            if (!w || !h || !c) console.log(str);
            return { width: Number(w), height: Number(h), presentCount: c.split(" ").map(Number) };
        });

    return [presents, regions];
}

function part1(presents: Present[], regions: Region[]) {
    return regions.reduce((c, r) => (presentsFit(presents, r) ? c + 1 : c), 0);
}

function presentsFit(presents: Present[], region: Region) {
    return true; // TODO
}
