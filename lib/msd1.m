function dx = msd1(t, x, m, b, k, u)

    dx(1)  = x(2);
    dx(2) = (1 / m) * (- k * x(1) -b * x(2) + u(t));
    
    dx = dx';

end