function theta = mean_sq_err(state, z, dim)

    sum1 = 0;
    sum2 = 0;

    N = length(state);

    for i = 1:N
        sum1 = sum1 + z(:, i) * z(:, i)';
        sum2 = sum2 + z(:, i) * state(i, dim);
    end

    sum1 = sum1 / N;
    sum2 = sum2 / N;
    
    theta = sum1 \ sum2;
    
end