#!/usr/bin/env bash

part1() {
    local pos=50 zeros=0
    while read -r line; do
        local direction="${line:0:1}"
        local count="${line:1}"
        [[ "$direction" == L ]] && ((count = -count))
        ((pos = ((pos + count) % 100 + 100) % 100))
        ((pos == 0 )) && ((zeros++))
    done
    echo "$zeros"
}

part2() {
    local pos=50 zeros=0
    while read -r line; do
        local direction="${line:0:1}"
        local count="${line:1}"
        if [[ "$direction" == R ]]; then
            ((pos += count))
            while ((pos >= 100)); do
                ((pos -= 100))
                ((zeros++))
            done
        else
            ((pos == 0)) && ((zeros--)) # Special case for starting at zero.
            ((pos -= count))
            while ((pos < 0)); do
                ((pos += 100))
                ((zeros++))
            done
            ((pos == 0)) && ((zeros++)) # Special case for stopping at zero.
        fi
    done
    echo "$zeros"
}

echo "Day 01 part 1: $(part1 < input.txt)" # 1031
echo "Day 01 part 2: $(part2 < input.txt)" # 5831
