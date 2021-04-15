function e = sim1(p1, p2)

    format longG;
    close all;

    %% real system

    % parameters
    m = 15;
    k = 2;
    b = 0.2;
    u = @(t) ...
           5 * sin(2 * t) + 10.5;

    % initial state
    x0(1) = 0;
    x0(2) = 0;
    tspan = [0: 0.1: 10];

    % compute states by solving the differential equation of the system
    [t, state] = ode45(@(t, state) msd1(t, state, m, b, k, u), tspan, x0);

    % compute the input vectors in every sampling moment
    in = u(t(:));

    %% modeling and parameters estimation
    % given the inputs and the states after the sampling of the real system, we
    % estimate the system model

    % filter poles
    p = [p1, p2];

    % estimation parameters
    syms b_;
    syms m_;
    syms k_;

    % theta_L
    theta_ = [  b_ / m_ - (p(1) + p(2)); ...
                        k_ / m_ - (p(1) * p(2)); ... 
                        1 / m_  ];

    % compute matrix of filtered states (z)
    z1 = lsim(   tf([-1, 0], [1, p(1) + p(2), p(1) * p(2)]), ... 
                        state(:, 1), ... 
                        t   );

    z2 = lsim(   tf([-1], [1, p(1) + p(2), p(1) * p(2)]), ... 
                        state(:, 1), ...
                        t   );

    z3 = lsim(   tf([1], [1, p(1) + p(2), p(1) * p(2)]), ... 
                        in, ...
                        t   );

    z = [z1, z2, z3]';

    % parameters estimation
    eq = theta_ == mean_sq_err(state, z, 1);
    sol = solve(eq, [m_, b_, k_]);
    m__ = double(sol.m_)
    b__ = double(sol.b_)
    k__ = double(sol.k_)

    res = [m__, b__, k__];
    
    e = abs((m - m__) / m) + abs((b - b__) / b) + abs((k - k__) / k);

    % error computation between the real system and the model
    [t__, state__] = ode45(@(t__, state__) msd1(t__, state__, m__, b__, k__, u), tspan, x0);
    err = zeros(length(state), 1);    
    for i = 1:length(state)
       err(i) = abs((state(i, 1) - state__(i, 1)) / state(i, 1));
    end

    %% plots
    
    figure(1);
    plot(t, err, 'Linewidth', 1);
    ylabel('$\big| \frac{y(t) - \hat{y}(t)}{y(t)} \big|$', 'interpreter', 'latex', 'FontWeight', 'bold');
    xlabel('$t(s)$', 'interpreter', 'latex', 'FontWeight', 'bold');
    title('system 1 output error \% for selected $p_1, \; p_2$', 'interpreter', 'latex', 'FontWeight', 'bold');
    
    figure(2);
    plot(t, state(:, 1), 'Linewidth', 1);
    ylabel('system response $y(t)$', 'interpreter', 'latex', 'FontWeight', 'bold');
    xlabel('$t(s)$', 'interpreter', 'latex', 'FontWeight', 'bold');
    title('system 1 response', 'interpreter', 'latex', 'FontWeight', 'bold');
    
end