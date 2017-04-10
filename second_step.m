function G_C = second_step
% Controller Transfer Function second_step.m
% Tested with MATLAB + CST and
% with GNU Octave + Control- + Symbolic-Package
% Manfred Lohoefener, March 2017, Leipzig

  clear
  close all

% Controller Parameters
  K_P = 6.93; % Proportional Gain
  T_I = 5.20; % [s] Integral Time Constant
  T_D = 0.23; % [s] Differential Time Constant

% Formal Stuff
  s   = tf ('s');         % Laplace-Op
  T_E = 100;              % [s] Simulation End Time 
  x_T = 0: T_E/1000: T_E; % [s] Time Axis

% Standard-Form PID Controller with First-Order Derivative Filter
  G_C = pidstd (K_P, T_I, T_D, 100);
  step (G_C, x_T)
  print (gcf, [mfilename '.emf'], '-dmeta')
  G_C = pidstd (K_P, T_I, T_D); % for next steps without filter
end

% Output MATLAB

% G_C =
%             1      1              s      
%  Kp * (1 + ---- * --- + Td * ------------)
%             Ti     s          (Td/N)*s+1 
%  with Kp = 6.93, Ti = 5.2, Td = 0.23, N = 100
% Continuous-time PIDF controller in standard form

% Octave Output

% Transfer function 'G_C' from input 'u1' to output ...
%       837.1 s^2 + 3605 s + 693
%  y1:  ------------------------
%          1.196 s^2 + 520 s
% Continuous-time model.
