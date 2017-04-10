function G_W = fifth_step
% Closed Loop Control - Symbolic Solution fifth_step.m
% Tested with MATLAB + CST and
% with GNU Octave + Control- + Symbolic-Package
% Manfred Lohoefener, March 2017, Leipzig

  clear
  close all

% Input Parameters
  m   = 30;   % [kg] Mass
  k   = 10;   % [N/m] Spring Stiffness
  d   = 40;   % [N.s/m] Friction Damping

% System Parameters
  K_S = 1;                % Proportional Gain
  T   = sqrt (m / k);     % [s] Nominal Time Constant
  D   = d / (2 * k * T);  % Nominal Damping Constant

% Controller Parameters
  K_P = 6.93; % Proportional Gain
  T_I = 5.20; % [s] Integral Time Constant
  T_D = 0.23; % [s] Differential Time Constant

% Formal Stuff
  T_E = 12;               % [s] Simulation End Time 
  x_T = 0: T_E/1000: T_E; % [s] Time Axis

% Closed Loop Control - Symbolic Solution
  syms K_S_s T_s D_s K_P_s T_I_s T_D_s s_s

  G_S_s = K_S_s / (1 + 2*D_s*T_s*s_s + T_s^2*s_s^2);
  G_C_s = K_P_s * (1 + 1/(T_I_s*s_s) + T_D_s*s_s);
  G_W_s = G_C_s*G_S_s / (1 + G_C_s*G_S_s);

  warning off             % for GNU Octave
  symbols = {K_S_s, T_s, D_s, K_P_s, T_I_s, T_D_s};
  values = {K_S, T, D, K_P, T_I, T_D};
  G_W = syms2tf (simplify (subs (G_W_s, symbols, values)));
  warning on

  G_W = minreal (G_W);
  step (G_W, x_T)
  print (gcf, [mfilename '.emf'], '-dmeta')
end

% MATLAB Output

% G_W =
%      0.5313 s^2 + 2.31 s + 0.4442
%   ----------------------------------
%   s^3 + 1.865 s^2 + 2.643 s + 0.4442
% Continuous-time transfer function.

% Octave Output

%>> G_W = fifth_step
%Transfer function 'G_W' from input 'u1' to output ...
%         0.5313 s^2 + 2.31 s + 0.4442
% y1:  ----------------------------------
%      s^3 + 1.865 s^2 + 2.643 s + 0.4442
%Continuous-time model.
