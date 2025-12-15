#include <algorithm>
#include <charconv>
#include <cstdint>
#include <deque>
#include <functional>
#include <iostream>
#include <limits>
#include <queue>
#include <string>
#include <string_view>
#include <tuple>
#include <vector>

template<typename T>
std::ostream& operator<<(std::ostream& os, const std::vector<T>& vec) {
    for (size_t i = 0; i < vec.size(); ++i) {
        if (i > 0) os << ",";
        os << vec[i];
    }
    return os;
}

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

static int button_presses_to_turn_on(const Machine &machine) {
    uint16_t target_pattern = 0;
    for (size_t i = 0; i < machine.lights.size(); ++i) {
        if (machine.lights[i]) target_pattern |= 1 << i;
    }

    std::vector<uint16_t> buttons;
    for (auto indices : machine.buttons) {
        uint16_t button = 0;
        for (int i : indices) button |= 1 << i;
        buttons.push_back(button);
    }

    // Start from the target pattern and look for all lights off instead of the other way around.
    std::deque<std::tuple<uint16_t, int>> queue;
    queue.push_back(std::make_tuple(target_pattern, 0));
    for (;;) {
        auto [pattern, count] = queue.front();
        queue.pop_front();
        count++;
        for (uint16_t bit_flips : buttons) {
            uint16_t new_pattern = pattern ^ bit_flips;
            if (new_pattern == 0)
                return count;
            else
                queue.push_back(std::make_tuple(new_pattern, count));
        }
    }
}

int main() {
    std::vector<Machine> machines;
    std::string line;

    while (std::getline(std::cin, line)) {
        machines.emplace_back(line);
    }

    int answer1 = 0;
    for (auto m : machines) {
        answer1 += button_presses_to_turn_on(m);
    }

    std::cout << "Day 10 part 1: " << answer1 << std::endl; // 411
}
