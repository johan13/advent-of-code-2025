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

// static int button_presses_for_correct_joltage(const Machine &machine) {
//     auto cmp = [](const auto &a, const auto &b) {
//         // Compare count (3rd element) first, then joltage sum (2nd element) to break ties
//         int count_a = std::get<2>(a);
//         int count_b = std::get<2>(b);
//         if (count_a != count_b) return count_a > count_b; // Lower count has higher priority
//         return std::get<1>(a) < std::get<1>(b); // Greater joltage_sum has higher priority
//     };
//     std::priority_queue<std::tuple<std::vector<int>, int, int>, // joltages, joltage_sum, count
//                         std::vector<std::tuple<std::vector<int>, int, int>>,
//                         decltype(cmp)> queue(cmp);

//     int num_joltages = machine.joltages.size();
//     queue.push(std::make_tuple(std::vector<int>(num_joltages), 0, 0));
//     for (;;) {
//         auto [joltages, joltage_sum, count] = queue.top();
//         // std::cout << "Pop: joltages=" << joltages << " joltage_sum=" << joltage_sum << " count=" << count << std::endl;
//         queue.pop();
//         count++;
//         for (auto button : machine.buttons) {
//             for (int i : button) joltages[i]++;

//             // Check if we are there and if we have overshot the target.
//             bool all_equal = true;
//             bool all_less_or_equal = true;
//             for (int i = 0; i < num_joltages; ++i) {
//                 if (joltages[i] != machine.joltages[i]) all_equal = false;
//                 if (joltages[i] > machine.joltages[i]) all_less_or_equal = false;
//             }
//             if (all_equal) return count;
//             if (all_less_or_equal)
//                 queue.push(std::make_tuple(joltages, joltage_sum + button.size(), count));

//             // Undo the button press for next iteration
//             for (int i : button) joltages[i]--;
//         }
//     }
// }

static int button_presses_for_correct_joltage(const Machine &machine) {
    int best = std::numeric_limits<int>::max();
    std::function<void(const std::vector<int>&, int)> solve = [&](const std::vector<int> &remaining, int count) {
        // std::cout << "---\n";
        if (count >= best) return;
        // std::cout << "remaining=" << remaining << " count=" << count << std::endl;

        if (remaining == std::vector<int>(remaining.size())) {
            // std::cout << "found " << count << (count < best ? " best" :"") << std::endl;
            if (count < best) best = count;
            return;
        }

        // Create a vector of (button_indices, lower_bound) and sort by ascending lower bound.
        std::vector<std::pair<std::vector<int>, int>> buttons_with_upper_bound;
        for (const auto& button : machine.buttons) {
            int upper_bound = std::numeric_limits<int>::max();
            for (int b : button)  upper_bound = std::min(upper_bound, remaining[b]);
            buttons_with_upper_bound.push_back({ button, upper_bound });
        }

        std::sort(buttons_with_upper_bound.begin(), buttons_with_upper_bound.end(),
                  [](const auto& a, const auto& b) { return a.second < b.second; });

        for (const auto& [button, upper_bound] : buttons_with_upper_bound) {
            // std::cout << "button=" << button << " upper_bound=" << upper_bound << std::endl;
            for (int i = upper_bound; i > 0; i--) {
                std::vector<int> new_remaining = remaining;
                for (int b : button) new_remaining[b] -= i;
                solve(new_remaining, count + i);
            }
        }
    };

    solve(machine.joltages, 0);
    // std::cout << "best=" << best << std::endl;
    return best;
}

int main() {
    std::vector<Machine> machines;
    std::string line;

    while (std::getline(std::cin, line)) {
        machines.emplace_back(line);
    }

    int answer1 = 0, answer2 = 0;
    for (auto m : machines) {
        std::cout << m.buttons.size() << " buttons, " << m.joltages.size() << " joltages" << std::endl;
        answer1 += button_presses_to_turn_on(m);
        answer2 += button_presses_for_correct_joltage(m);
    }

    std::cout << "Day 10 part 1: " << answer1 << std::endl; // 411
    std::cout << "Day 10 part 2: " << answer2 << std::endl;
}
