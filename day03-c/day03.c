#include <stdio.h>
#include <string.h>
#include <ctype.h>

static int find_greatest(char *str, int from, int to)
{
    for (int ch = '9'; ch >= '0'; ch--)
    {
        char *p = memchr(str + from, ch, to - from);
        if (p != NULL) return p - str;
    }
    return -1;
}

int main()
{
    char line[128];
    int sum = 0;
    while (NULL != fgets(line, sizeof line, stdin))
    {
        int length = strlen(line);
        while (isspace(line[length - 1])) line[--length] = 0; // Trim trailing whitespace (\n)

        int first = find_greatest(line, 0, length - 1);
        int second = find_greatest(line, first + 1, length);
        sum += (line[first] - '0') * 10 + (line[second] - '0');
    }

    printf("Day 03 part 1: %d\n", sum); // 17085
}
