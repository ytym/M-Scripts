function G_W = pid_loop
% Closed Loop Control 
% Tested with MATLAB + CST and
% with GNU Octave + Control- + Symbolic-Package
% Manfred Lohoefener, March 2017, Leipzig

  clear
  close all

% Formal Stuff - Laplace-Op given with G_S
  T_E = 12;               % s Simulation End Time
  x_T = 0: T_E/1000: T_E; % [s] Time Axis

% System Transfer Function
  G_S = first_step;

% Standard-Form PID Controller without Derivative Filter
  G_C = second_step;

% Closed Loop Control
  G_W1 = G_C*G_S / (1 + G_C*G_S)          % Possible Solution
  G_W2 = feedback (G_C*G_S, 1)            % Optimal Solution
  G_W  = minreal (feedback (G_C*G_S, 1)); % Normalized Form
  step (G_W, x_T)
  print (gcf, [mfilename '.emf'], '-dmeta')
end

% Octave Output

% Transfer function 'G_S' from input 'u1' to output ...
%              1
%  y1:  ---------------
%       3 s^2 + 4 s + 1
% Continuous-time model.

% Transfer function 'G_C' from input 'u1' to output ...
%       8.288 s^2 + 36.04 s + 6.93
%  y1:  --------------------------
%                 5.2 s
% Continuous-time model.

% Transfer function 'G_W1' from input 'u1' to output ...
%            129.3 s^5 + 734.6 s^4 + 900.8 s^3 + 331.5 s^2 + 36.04 s
%  y1:  -----------------------------------------------------------------
%       243.4 s^6 + 778.3 s^5 + 1329 s^4 + 1117 s^3 + 358.6 s^2 + 36.04 s
% Continuous-time model.

% Transfer function 'G_W2' from input 'u1' to output ...
%            8.288 s^2 + 36.04 s + 6.93
%  y1:  -------------------------------------
%       15.6 s^3 + 29.09 s^2 + 41.24 s + 6.93
% Continuous-time model.

% Transfer function 'ans' from input 'u1' to output ...
%          0.5313 s^2 + 2.31 s + 0.4442
%  y1:  ----------------------------------
%       s^3 + 1.865 s^2 + 2.643 s + 0.4442
% Continuous-time model.
