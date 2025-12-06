import math
import sys

lines = [line.split() for line in sys.stdin]
answer = 0
for *operands, operator in zip(*lines):
    nums = [int(x) for x in operands]
    answer += sum(nums) if operator == "+" else math.prod(nums)

print(f"Day 06 part 1: {answer}")
