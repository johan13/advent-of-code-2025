from math import prod
from sys import stdin

def apply_op(operator, str_operands):
    operands = map(int, str_operands)
    return sum(operands) if operator == "+" else prod(operands)

def part1(lines):
    return sum(
        apply_op(op, nums)
        for *nums, op in zip(*[line.split() for line in lines])
    )

def part2(lines):
    # Ignore empty columns. Instead, assume that the operator is in the first column of each problem.
    columns = [c for c in ("".join(row) for row in zip(*lines)) if c.strip()]
    answer, operands = 0, []
    for col in reversed(columns):
        operands.append(col[:-1])
        if col[-1] in "+*":
            answer += apply_op(col[-1], operands)
            operands = []
    return answer

lines = stdin.read().splitlines()
print(f"Day 06 part 1: {part1(lines)}") # 5877594983578
print(f"Day 06 part 2: {part2(lines)}") # 11159825706149
