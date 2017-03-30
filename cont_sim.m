function [x, t, y_k, t_k] = cont_sim (G_S, G_y, T_E, d_k, dist)
% Continuous answer to stairs on input
% Manfred Lohöfener 01/02/2017
% Allows for substitution/manipulation that can only be done with syms
% 
% Usage: [x, t, y_k, t_k] = cont_sim (G_S, G_y, T_E, d_k, dist)
% G_S is a continuous transfer function delivering x(t) and 
% G_y is a discrete transfer function generating the discrete input y(k) 
% until end time T_E and
% d_k discrete delay 0, 1, … and
% dist disturbance 0 or 1

  [y_k, t_k] = step (G_y, T_E);             % input signal and discrete time
  t_t = linspace (min(t_k), max(t_k), (length(t_k)-1)*10+1);  % cont. time
  y_l = y_k + dist;                         % disturbance
  y_l = [zeros(d_k,1); y_l];                % discrete delay
  y_l = y_l (1:length(t_k));
  y_t = [y_l'; y_l'; y_l'; y_l'; y_l'; y_l'; y_l'; y_l'; y_l'; y_l'];
  y_t = reshape (y_t, [1, length(y_t)*10]); % cont. input
  y_t = y_t (1:length(t_t));
  [x, t] = lsim (G_S, y_t, t_t);            % linear simulation
end
