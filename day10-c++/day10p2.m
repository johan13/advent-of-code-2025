1; % This is a script file - not a function file.

function sum_x = fewest_button_presses(buttons, joltages)
    % Build a matrix with one column per button and one row per joltage. (elements = 0 or 1)
    matrix = zeros(length(joltages), length(buttons));
    for col = 1:length(buttons)
        matrix(buttons{col} + 1, col) = 1;
    endfor

    % Solve matrix * x = joltages for non-negative integer x with minimum sum(x).
    [n, m] = size(matrix);
    [x] = glpk(
        ones(m, 1),                 % Objective: minimize sum(x) which is c'*x where c = [1,1,...,1]
        matrix,
        joltages,
        zeros(m, 1),                % Lower bounds: x >= 0
        repmat(max(joltages), m, 1),% Upper bounds: set to max of joltages for each variable
        repmat('S', n, 1),          % 'S' means equality (=)
        repmat('I', m, 1));         % 'I' means integer)
    sum_x = sum(x);
endfunction

function [buttons, joltages] = parse_line(line)
    % Extract from first "(" to "{"
    first_paren = index(line, "(");
    brace_pos = index(line, "{");
    buttons_part = line(first_paren:brace_pos-1);
    joltages_part = line(brace_pos:end);

    % Parse the buttons
    buttons = {};
    start_pos = 1;
    while true
        paren_start = index(buttons_part(start_pos:end), "(");
        if paren_start == 0
            break;
        endif
        paren_start += start_pos - 1;
        paren_end = index(buttons_part(paren_start:end), ")") + paren_start - 1;

        button_text = buttons_part(paren_start+1:paren_end-1);
        buttons{end+1} = str2num(["[" button_text "]"])(:);
        start_pos = paren_end + 1;
    endwhile

    % Parse the joltages
    brace_start = index(joltages_part, "{");
    brace_end = index(joltages_part, "}");
    joltages_text = joltages_part(brace_start+1:brace_end-1);
    joltages = str2num(["[" joltages_text "]"])(:);
endfunction

total_button_presses = 0;
while !feof(stdin)
    [buttons, joltages] = parse_line(fgetl(stdin));
    total_button_presses += fewest_button_presses(buttons, joltages);
endwhile
fprintf('Day 10 part 2: %d\n', total_button_presses); % 16063
