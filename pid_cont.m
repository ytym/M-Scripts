function G_C = pid_contr (K_S, T_U, T_G)
%  Controller Transfer Function second_step.m
%  Tested with MATLAB + CST and
%  with GNU Octave + Control- + Symbolic-Package
%  Manfred Lohoefener, March 2017, Leipzig
%  Example
%  K_S = 1;
%  T_U = 0.4;
%  T_G = 5.2;
%  G_C = pid_contr (K_S, T_U, T_G)

  close all

% Controller Parameters
  K_P = 6.93; % Proportional Gain
  T_I = 5.20; % [s] Integral Time Constant
  T_D = 0.23; % [s] Differential Time Constant

% Formal Stuff
  s   = tf ('s');         % Laplace-Op
  T_E = 100;              % [s] Simulation End Time 
  x_T = 0: T_E/1000: T_E; % [s] Time Axis

% Standard-Form PID Controller
  G_C = pidstd (K_P, T_I, T_D, 100);    % with first-order derivative filter
  step (G_C, x_T)
  print (gcf, [mfilename '.emf'], '-dmeta')
  G_C = pidstd (K_P, T_I, T_D);         % for next steps without derivative filter
end

% MATLAB Output

% G_C =
%

% Octave output for example

% Transfer function 'G_C' from input 'u1' to output ...
%       837.1 s^2 + 3605 s + 693
%  y1:  ------------------------
%          1.196 s^2 + 520 s
% Continuous-time model.
