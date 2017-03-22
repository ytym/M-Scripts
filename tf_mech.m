function G_S = tf_mech (m, d, k)
% System Transfer Function first_step.m
% of Mass-Spring-Damper System of 2nd Order
% Tested with MATLAB + CST and
% with GNU Octave + Control-Package
% Manfred Lohoefener, March 2017, Leipzig
% Example 
%  m   = 30;   % [kg] Mass
%  k   = 10;   % [N/m] Spring Stiffness
%  d   = 40;   % [N.s/m] Friction Damping
%  G_S = tf_mech (m, d, k)

  close all

% System Parameters
  K_S = 1;                % Proportional Gain
  T   = sqrt (m / k);     % [s] Nominal Time Constant
  D   = d / (2 * k * T);  % Nominal Damping Constant

% Formal Stuff
  T_E = 12;               % [s] Simulation End Time 
  x_T = 0: T_E/1000: T_E; % [s] Time Axis
  s   = tf ('s');         % Laplace-Operator

% System Transfer Function
  G_S = K_S / (1 + 2*D*T*s + T^2*s^2);
  step (G_S, x_T)
  print (gcf, [mfilename '.emf'], '-dmeta')
end

% Output

% Transfer function 'G_S' from input 'u1' to output ...
%              1
%  y1:  ---------------
%       3 s^2 + 4 s + 1
% Continuous-time model.
