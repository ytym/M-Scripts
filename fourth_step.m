function G_W = fourth_step
% Closed Loop Control - Analytic Solution fourth_step.m
% Tested with MATLAB + CST and
% with GNU Octave + Control- + Symbolic-Package
% Manfred Lohoefener, March 2017, Leipzig

clear
close all

% Formal Stuff - Laplace-Op given with G_S
  T_E = 12;               % [s] Simulation End Time
  x_T = 0: T_E/1000: T_E; % [s] Time Axis

% System Transfer Function
  G_S = first_step;

% Standard-Form PID Controller without Derivative Filter
  G_C = second_step;

% Closed Loop Control - Analytic Solution
  [b_i a_i] = tfdata (G_S, 'v');
  b_i = [zeros(1, length (a_i)-length (b_i)) b_i];  % MATLAB - Octave Compatibility
  [q_i p_i] = tfdata (G_C, 'v');
  p_i = [zeros(1, length (q_i)-length (p_i)) p_i];  % MATLAB - Octave Compatibility
  G_W = tf (conv (q_i, b_i), conv (p_i, a_i) + conv (q_i, b_i));
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

%>> G_W = fourth_step
%Transfer function 'G_W' from input 'u1' to output ...
%         0.5313 s^2 + 2.31 s + 0.4442
% y1:  ----------------------------------
%      s^3 + 1.865 s^2 + 2.643 s + 0.4442
%Continuous-time model.
