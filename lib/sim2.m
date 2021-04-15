function e = sim2(p1, p2)
    
    format longG;
%     close all;

    u1= @(t) ...
                    2 * sin(t);
    du1 = @(t) ...
                    2 * cos(t);
    u2 = 1;
    du2 = 0;

    tspan = [0: 1e-6: 5];
%     tspan = [0: 0.01: 5];
    N = length(tspan);
    state = zeros(N, 2);

    %% measurements
    
    for i = 1:N
        state_ = v(tspan(i));
        state(i, 1) = state_(1);
        state(i, 2) = state_(2);
    end

    Vc = state(:, 1);
    
    % add random error in measurements
%     Vc(2000000) =  Vc(2000000) + 100 *  Vc(2000000);
%     Vc(2700000) =  Vc(2700000) + 250 *  Vc(2700000);
%     Vc(4700000) =  Vc(4700000) + 50 *  Vc(4700000);

    in1 = double(u1(tspan))';
    in2 = ones(N, 1);

    % filter poles
    p = [p1, p2];

%     theta_star = [  1 / (R_ * C_); ...
%                                 1 / (L_ * C_); ...
%                                 1 / (R_ * C_); ...
%                                 1 / (L_ * C_); ...
%                                 1 / (R_ * C_); ...
%                                 0  ];

    %% filtering 
    % compute matrix of filtered states (z)
    z1 = lsim(   tf([-1, 0], [1, p(1) + p(2), p(1) * p(2)]), ... 
                        Vc, ... 
                        tspan'   );

    z2 = lsim(   tf([-1], [1, p(1) + p(2), p(1) * p(2)]), ... 
                        Vc, ...
                        tspan'   );

    z3 = lsim(   tf([1, 0], [1, p(1) + p(2), p(1) * p(2)]), ... 
                        in2, ...
                        tspan'   );
                    
    z4 = lsim(   tf([1], [1, p(1) + p(2), p(1) * p(2)]), ... 
                        in2, ...
                        tspan'   );

    z5 = lsim(  tf([1, 0], [1, p(1) + p(2), p(1) * p(2)]), ... 
                        in1, ...
                        tspan'   );
                    
    z6 = lsim(   tf([1], [1, p(1) + p(2), p(1) * p(2)]), ... 
                        in1, ...
                        tspan'   );

    z = [z1, z2, z3, z4, z5, z6]';

    %% estimated parameters computation
    res = mean_sq_err(state, z, 1) + [p(1) + p(2); p(1) * p(2); 0; 0; 0; 0];
    RC_inv = res(1)
    LC_inv = res(2)
    
    [t_, Vc_] = ode45(@(t_, Vc_) msd2(t_, Vc_, RC_inv, LC_inv), tspan, [0, 0]);
    
    
    %% mean abs output error computation
    % Vc are the real system outputs and Vc(:, 1) are the model outputs
    sum = 0;
    for t = 1: N
        sum = sum + abs((Vc(t) - Vc_(t, 1)));
    end
    e = sum / N;
    
%% plots
    figure(3);
    plot(tspan, Vc, 'Linewidth', 0.1);
    ylabel('system response $V_C(t)$', 'interpreter', 'latex', 'FontWeight', 'bold');
    xlabel('$t(s)$', 'interpreter', 'latex', 'FontWeight', 'bold');
    title('system 2 response', 'interpreter', 'latex', 'FontWeight', 'bold');

end
