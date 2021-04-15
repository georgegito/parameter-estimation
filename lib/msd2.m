function dx = msd2(t, x, RC_inv, LC_inv)

    u1 = @(t) ...
                    2 * sin(t);
    u2 = 1;
    du2 = 0;
    
    dx(1)  = x(2);
    dx(2) = -RC_inv * x(2) - LC_inv * x(1) + RC_inv * du2 + LC_inv * u2 + RC_inv * u1(t);
    
    dx = dx';

end