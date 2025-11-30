#!/usr/bin/env bash

part1() {
    # Read the two columns into col1 and col2.
    local -a col1 col2
    while read -r a b; do
        col1+=("$a")
        col2+=("$b")
    done

    # Sort the two arrays.
    mapfile -t col1 < <(printf '%s\n' "${col1[@]}" | sort -n)
    mapfile -t col2 < <(printf '%s\n' "${col2[@]}" | sort -n)

    # Sum up the absolute values of the differences.
    local sum=0 diff
    for i in "${!col1[@]}"; do
        ((diff = col1[i] - col2[i]))
        ((sum += ${diff#-}))
    done
    echo "$sum"
}

part2() {
    # Read the two columns into col1 and col2.
    local -a col1 col2
    while read -r a b; do
        col1+=("$a")
        col2+=("$b")
    done

    # Count the occurrences in col2.
    local -A counts
    for n in "${col2[@]}"; do
        ((counts[$n]++))
    done

    # Multiply each col1 value with the corresponding count from col2 and sum up the products.
    local sum=0
    for n in "${col1[@]}"; do
        ((sum += n * ${counts[$n]:-0}))
    done
    echo "$sum"
}

echo "Day 01 part 1: $(part1 < input.txt)"
echo "Day 01 part 2: $(part2 < input.txt)"
