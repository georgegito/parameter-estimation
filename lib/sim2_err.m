%% testing sim2 error for variable p1, p2
data = [];
for p1 = 200: 20: 700
    for p2 = p1: 10: 700
        data = [data; p1, p2, sim2(p1, p2)];
    end
end

[min, index] = min(data(:, 3));
p1 = data(index, 1)
p2 = data(index, 2)