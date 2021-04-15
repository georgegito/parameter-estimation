close all;
clear;
addpath("lib");

%% system 1
% select filter poles p1 and p2 and call sim1(p1, p2)
% default sampling with tspan = [0: 0.1: 10] (can be changed manually)
% parameters error is returned, estimated parameters are printed and figures are displayed
p1 = 0.1;
p2 = 0.5;
fprintf('\n\nSYSTEM 1 \n\n');
err1 = sim1(p1, p2)

%% system 2
% select filter poles p1 and p2 and call sim2(p1, p2)
% default sampling with tspan = [0: 1e-6: 5] (can be changed manually)
% output error is returned, estimated parameters are printed and figures are displayed
p1 = 370;
p2 = 380;
fprintf('\n\nSYSTEM 2 \n\n');
err2 = sim2(p1, p2)