% Diskreter Regelkreis RK_diskr_T22.m
% Getestet mit MATLAB + CST und 
% mit GNU Octave + Control- + Symbolic-Package
% Manfred Lohoefener, HS Merseburg, Maerz 2017

clear
close all

% Parameter
K_S = 1.5;    % Proportionalfaktor
T_1 = 3.0;    % [s] Zeitkonstante
T_2 = 1.0;    % [s] Zeitkonstante

K_krit = 22.60;  % probiert
T_krit = 1.93;   % [s] Periodendauer

T_E = 12;     % [s] Simulationsdauer
T_0 = 0.25;   % [s] Abtastzeit

s = tf ('s');       % Laplace-Op

% Kontinuierliche und diskrete Strecke
G_S = K_S / (1 + (T_1+T_2)*s + T_1*T_2*s^2);
G_Sd = c2d (G_S, T_0);

% PID-Regler nach Schwingungsversuch, Takahashi (2.2)
K_R = 0.6 * K_krit*(1-T_0/T_krit);
T_N = 5*K_R*T_krit / (6*K_krit);
T_V = 3*K_krit*T_krit / (40*K_R);

q_i = [K_R*(1+T_0/(2*T_N)+T_V/T_0) ...
      -K_R*(1-T_0/(2*T_N)+2*T_V/T_0) K_R*T_V/T_0];
p_i = [1 -1 0];
r_i  = [K_R*T_0/T_N 0 0];
G_R1 = tf (q_i, p_i, T_0);
G_R2 = tf (r_i, p_i, T_0);

G_w = minreal (G_R2 * feedback (1, G_Sd*G_R1)); % Regelkreis w -> y
G_z = feedback (-G_Sd * G_R1, -1);              % Regelkreis z -> y

G_w_krit = feedback (K_krit, G_Sd); % Stab.-grenze w -> y

figure ('Name', 'Fuehrung', 'NumberTitle', 'off', 'Position', [0 100 800 600]);
  set (gca, 'FontSize', 15); hold on
  line ([0 T_E], [1 1], 'Color', 'm', 'LineWidth', 1)
  [x_y, t_y, y_wy, t_wy] = cont_sim (G_S, G_w, T_E, 0, 0);
  plot (t_y, x_y, 'LineWidth', 1)
  stairs (t_wy, y_wy)
  set (findobj (gcf, 'type', 'line'), 'LineWidth', 1);
  axis ([0 T_E -2 2])
  title ('Diskrete Fuehrungssprungantwort nach Takahashi (2.2)', 'fontsize', 18)
  xlabel ('Zeit [s]')
  ylabel ('h(t)')
  legend ('w(t)', 'x(t)', 'y(t)')
  legend boxoff
  txt = {'Streckenparameter K_S, T_1, T_2:'; num2str([K_S T_1 T_2]); ' '
         'Reglerparameter K_R, T_N, T_V:'; num2str([K_R T_N T_V]); ' '
         evalc('G_R1')};
  text (4.2, -1, txt, 'fontsize', 13)
  printgcf (mfilename, 0)

figure ('Name', 'Stoerung', 'NumberTitle', 'off', 'Position', [200 200 800 600]);
  set (gca, 'FontSize', 15); hold on
  line ([0 T_E], [1 1], 'Color', 'm', 'LineWidth', 1)
  [x_z, t_y, y_zy, t_zy] = cont_sim (G_S, G_z, T_E, 0, 1);
  plot (t_y, x_z, 'LineWidth', 1)
  stairs (t_zy, y_zy)
  set (findobj (gcf, 'type', 'line'), 'LineWidth', 1);
  axis ([0 T_E -1.6 1.1])
  title ('Diskrete Stoersprungantwort nach Takahashi (2.2)', 'fontsize', 18)
  xlabel ('Zeit [s]')
  ylabel ('h(t)')
  legend ('z(t)', 'x(t)', 'y(t)')
  legend boxoff
  txt = {'Streckenparameter K_S, T_1, T_2:'; num2str([K_S T_1 T_2]); ' '
         'Reglerparameter K_R, T_N, T_V:'; num2str([K_R T_N T_V]); ' '
         evalc('G_R1')};
  text (4.2, 0.2, txt, 'fontsize', 13)
  printgcf (mfilename, 0)

figure ('Name', 'Pol-Nullstellen', 'NumberTitle', 'off', 'Position', [100 0 800 600]);
  set (gca, 'FontSize', 15); hold on
  pzmap (G_z)
  set (findobj (gcf, 'type', 'line'), 'LineWidth', 2);
  plot_circ ('m')                 % Einheitskreis
  line ([0, 0],get (gca, 'ylim'), 'LineWidth', 1)
  title ('Diskretes Pol-Nullstellenbild nach Takahashi (2.2)', 'fontsize', 18)
  xlabel ('Realteil')
  ylabel ('Imaginaerteil')
  legend ('Polstellen', 'Nullstellen', 'Einheitskreis', 'location', 'north')
  legend boxoff
  txt = {'Nullstellen (Fuehrung):'; num2str(zero (G_z)'); ' '
         'Polstellen (Stoerung):'; num2str(pole (G_z)')};
  text (-0.8, -0.3, txt, 'fontsize', 11)
  printgcf (mfilename, 0)

figure ('Name', 'Stabilitaet', 'NumberTitle', 'off', 'Position', [300 100 800 600]);
  set (gca, 'FontSize', 15); hold on
  line ([0 T_E], [1 1], 'Color', 'm', 'LineWidth', 1)
  [x_y, t_y, y_wy, t_wy] = cont_sim (G_S, G_w_krit, T_E, 0, 0);
  plot (t_y, x_y, 'LineWidth', 1)
  stairs (t_wy, y_wy)
  set (findobj (gcf, 'type', 'line'), 'LineWidth', 1);
  axis ([0 T_E -0.5 2.5])
  title ('Stabilitaetsgrenze nach Takahashi (2.2)', 'fontsize', 18)
  xlabel ('Zeit [s]')
  ylabel ('h(t)')
  legend ('w(t)', 'x(t)', 'y(t)')
  legend boxoff
  txt = {'Streckenparameter K_S, T_1, T_2:'; num2str([K_S T_1 T_2]); ' '
         'Stabilitaetsgrenze K_{krit}, T_{krit}:'; num2str([K_krit T_krit])};
  text (5, 1, txt, 'fontsize', 13)
  printgcf (mfilename, 0)
