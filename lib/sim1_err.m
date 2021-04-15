%% testing sim1 error for variable p1, p2
data = [];
for p1 = 0.1: 0.2: 5
    for p2 = p1: 0.2: 5
        data = [data; p1, p2, sim1(p1, p2)];
    end
end

[min, index] = min(data(:, 3));
p1 = data(index, 1)
p2 = data(index, 2)