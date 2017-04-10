% Continuous Control Circuit sixth_step.m
% Tested with MATLAB + CST and
% with GNU Octave + Control- + Symbolic-Package
% Manfred Lohoefener, March 2017, Leipzig

clear
close all
s = tf ('s'); % Laplace-Op

% System Parameters
K_S = 1.5;    % Proportional Gain
T_1 = 3.0;    % s Time Constant
T_2 = 1.0;    % s Time Constant

% Controller Parameters
K_P = 4.62;    % Proportional Gain
T_I = 5.20;    % s Integral Time Constant
T_D = 0.23;    % s Differential Time Constant
%T_E =  100;    % s Simulation End Time 

% Closed Loop Control - Symbolic Solution
syms K_S_s T_1_s T_2_s K_P_s T_I_s T_D_s s_s

G_S_s = K_S_s / (1 + (T_1_s+T_2_s)*s_s + T_1_s*T_2_s*s_s^2)
G_C_s = K_P_s * (1 + 1/(T_I_s*s_s) + T_D_s*s_s/(1+T_D_s*s_s/100))
G_W_s = G_C_s*G_S_s / (1 + G_C_s*G_S_s)

warning off                     % for GNU Octave
symbols = {K_S_s, T_1_s, T_2_s, K_P_s, T_I_s, T_D_s};
values = {K_S, T_1, T_2, K_P, T_I, T_D};
G_W = syms2tf (simplify (subs (G_W_s, symbols, values)))
warning on
G_W = minreal (G_W)
step (G_W)
print (gcf, [mfilename '.emf'], '-dmeta')
