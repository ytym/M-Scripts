% Kontinuierlicher Regelkreis RK_kont.m
% Getestet mit MATLAB + CST und 
% mit GNU Octave + Control-Package
% Manfred Lohoefener, HS Merseburg, Maerz 2017

  clear
  close all

% Parameter
  K_S = 1.5;    % Proportionalfaktor
  T_1 = 3.0;    % [s] Zeitkonstante
  T_2 = 1.0;    % [s] Zeitkonstante
  
  T_U = 0.45;   % [s] Verzugszeit
  T_G = 5.20;   % [s] Ausgleichszeit
  
  T_E = 12;     % [s] Simulationsdauer
  D_t = 0.01;   % [s] Schrittweite 10 ms
  t_x = 0:D_t:T_E;  % [s] Zeitachse
  
  s   = tf ('s'); % Laplace-Op
  G_S = K_S / (1 + (T_1+T_2)*s + T_1*T_2*s^2);

% Chien, Hrones und Reswick fuer Fuehrung aperiodisch
  K_Rw = 0.6*T_G / (K_S*T_U);
  T_Nw = T_G;
  T_Vw = 0.5 * T_U;
  G_Rw = pidstd (K_Rw, T_Nw, T_Vw, 100); % PID-T1 wegen G_wy
  G_wx = feedback (G_Rw*G_S, 1);      % w -> x
  G_wy = feedback (G_Rw, G_S);        % w -> y

% Chien, Hrones und Reswick fuer Stoerung aperiodisch
  K_Rz = 0.95*T_G / (K_S*T_U);
  T_Nz = 2.4 * T_U;
  T_Vz = 0.42 * T_U;
  G_Rz = pidstd (K_Rz, T_Nz, T_Vz);
  G_zx = feedback (G_S, G_Rz);      % z -> x
  G_zy = feedback (-G_Rz*G_S, -1);  % z -> y

figure ('Name', 'Fuehrung', 'NumberTitle', 'off', 'Position', [0 100 800 600]);
  set (gca, 'FontSize', 15); hold on
  plot ([0 T_E], [1 1], 'm', 'LineWidth', 1)
  step (G_wx, G_wy, t_x)
  set (findobj (gcf, 'type', 'line'), 'LineWidth', 1);
  hold on
  axis ([0 T_E 0 2])
  coordgrd
  title ('Kontinuierliche Fuehrungssprungantwort nach C-H-R', 'fontsize', 18)
  xlabel ('Zeit [s]')
  ylabel ('h(t)')
  legend ('w(t)', 'x(t)', 'y(t)')
  legend boxoff
  txt = {'Streckenparameter K_S, T_1, T_2:'; num2str([K_S T_1 T_2]); ' '
          'Reglerparameter K_R, T_N, T_V:'; num2str([K_Rw T_Nw T_Vw]); ' '
          evalc('G_R=minreal(G_Rw)')};
  text (4, 0.8, txt, 'fontsize', 13)
  hold off
  printgcf (mfilename, 0)

figure ('Name', 'Stoerung', 'NumberTitle', 'off', 'Position', [200 200 800 600]);
  set (gca, 'FontSize', 15); hold on
  plot ([0 T_E], [1 1], 'm', 'LineWidth', 1)
  step (G_zx, G_zy, t_x)
  set (findobj (gcf, 'type', 'line'), 'LineWidth', 1);
  hold on
  axis ([0 T_E -1.5 1.1])
  coordgrd
  title ('Kontinuierliche Stoersprungantwort nach C-H-R', 'fontsize', 18)
  xlabel ('Zeit [s]')
  ylabel ('h(t)')
  legend ('z(t)', 'x(t)', 'y(t)')
  legend boxoff
  txt = {'Streckenparameter K_S, T_1, T_2:'; num2str([K_S T_1 T_2]); ' '
          'Reglerparameter K_R, T_N, T_V:'; num2str([K_Rz T_Nz T_Vz]); ' '
          evalc('G_R=minreal(G_Rz)')};
  text (4.5, -0.1, txt, 'fontsize', 13)
  hold off
  printgcf (mfilename, 0)

figure ('Name', 'Pol-Nullstellen', 'NumberTitle', 'off', 'Position', [100 0 800 600]);
  set (gca, 'FontSize', 15); hold on
  pzmap (G_wx, G_zx)
  set (findobj (gcf, 'type', 'line'), 'LineWidth', 2);
  axis ([-5 0 -2 2])
  coordgrd
  title ('Kontinuierliches Pol-Nullstellenbild', 'fontsize', 18)
  xlabel ('Realteil')
  ylabel ('Imaginaerteil')
  legend ('G_{wx} Polstellen (Fuehrung)', 'G_{zx} Polstellen (Stoerung)', ...
    'G_{wx} Nullstellen (Fuehrung)', 'G_{zx} Nullstellen (Stoerung)', 'location', 'north')
  legend boxoff
  txt = {'Nullstellen (Fuehrung):'; num2str(zero (G_wx)'); ' '
         'Polstellen (Fuehrung):'; num2str(pole (G_wx)'); ' '
         'Nullstellen (Stoerung):'; num2str(zero (G_zx)'); ' '
         'Polstellen (Stoerung):'; num2str(pole (G_zx)')};
  text (-4.8, 0, txt, 'fontsize', 10)
  hold off
  printgcf (mfilename, 0)

% Regelguete berechnen
  [x_w, t_w] = step (G_wx, t_x);
  e_w = 1-x_w;
  RG = e_w'*e_w*D_t;
