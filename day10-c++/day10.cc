#include <charconv>
#include <iostream>
#include <string>
#include <string_view>
#include <vector>

static std::vector<int> parse_ints(std::string_view s) {
    std::vector<int> result;
    const char *ptr = s.data();
    const char *end = ptr + s.size();
    while (ptr < end) {
        int value = 0;
        auto [next, ec] = std::from_chars(ptr, end, value);
        result.push_back(value);
        ptr = next + 1;
    }
    return result;
}

struct Machine {
    std::vector<bool> lights;
    std::vector<std::vector<int>> buttons;
    std::vector<int> joltages;

    // Example input: "[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}"
    Machine(std::string_view line) {
        for (size_t i = 0; i < line.size(); ++i) {
            char c = line[i];
            if (c == '[') {
                while (line[++i] != ']') {
                    lights.push_back(line[i] == '#');
                }
            } else if (c == '(') {
                size_t end = line.find(')', i);
                buttons.push_back(parse_ints(line.substr(i + 1, end - i - 1)));
                i = end;
            } else if (c == '{') {
                size_t end = line.find('}', i);
                joltages = parse_ints(line.substr(i + 1, end - i - 1));
                i = end;
            }
        }
    }
};

int main() {
    std::vector<Machine> machines;
    std::string line;

    while (std::getline(std::cin, line)) {
        machines.emplace_back(line);
    }

    std::cout << machines.size() << std::endl;
}
