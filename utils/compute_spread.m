function [output, input_mn] = compute_spread(input)
    input = input(:, ~any(isnan(input), 1));
    
    input_std = std(input, [], 2);
    input_mn = mean(input, 2);
    input_spread_t = [input_mn-2*input_std input_mn input_mn+2*input_std];
    input_max = max(input_spread_t, [], 2);
    input_min = min(input_spread_t, [], 2);
    
    output = [input_max', fliplr(input_min')];
end