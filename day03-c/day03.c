#include <ctype.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>

// Find the index of the (first) greatest digit in the range [from, to] of str.
static int find_greatest(char *str, int from, int to)
{
    char max_ch = 0;
    int max_i = 0;
    for (int i = from; i <= to; i++)
    {
        if (str[i] > max_ch)
        {
            max_ch = str[i];
            max_i = i;
        }
    }
    return max_i;
}

static int64_t max_joltage(char *bank, int bank_size, int num_batteries_on)
{
    int64_t answer = 0;
    int start_battery = 0;
    for (int i = 0; i < num_batteries_on; i++)
    {
        int next = find_greatest(bank, start_battery, bank_size - num_batteries_on + i);
        answer = answer * 10 + bank[next] - '0';
        start_battery = next + 1;
    }
    return answer;
}

int main()
{
    char line[128];
    int64_t sum1 = 0, sum2 = 0;
    while (NULL != fgets(line, sizeof line, stdin))
    {
        int length = strlen(line);
        while (isspace(line[length - 1]))
            line[--length] = 0;

        sum1 += max_joltage(line, length, 2);
        sum2 += max_joltage(line, length, 12);
    }

    printf("Day 03 part 1: %" PRId64 "\n", sum1); // 17085
    printf("Day 03 part 2: %" PRId64 "\n", sum2); // 169408143086082
}
