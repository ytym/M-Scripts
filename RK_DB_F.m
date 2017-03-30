% Diskreter Regelkreis RK_DB_F.m
% Getestet mit MATLAB + CST und 
% mit GNU Octave + Control-Package
% Manfred Lohoefener, HS Merseburg, Maerz 2017

clear
close all

% Parameter
K_S = 1.5;    % Proportionalfaktor
T_1 = 3.0;    % [s] Zeitkonstante
T_2 = 1.0;    % [s] Zeitkonstante

T_E = 6;      % [s] Simulationsdauer
T_0 = 0.5;    % [s] Abtastzeit
s = tf ('s');       % Laplace-Op
z = tf ('z', T_0);  % Verschiebe-Op

% Kontinuierliche und diskrete Strecke
G_S = K_S / (1 + (T_1+T_2)*s + T_1*T_2*s^2);
G_Sd= c2d (G_S, T_0);
[b_i, a_i] = tfdata (G_Sd, 'v');
% MATLAB-Octave-Kompatibilitaet
b_i=[zeros(1, length(a_i)-length(b_i)) b_i];

% Dead-Beat-Regler Führung
q_i = a_i / sum (b_i);
p_i = eye (1, length (b_i)) - b_i/sum (b_i);
G_R = tf (q_i, p_i, T_0);

G_w = minreal (feedback (G_R, G_Sd));      % w -> y
G_z = minreal (feedback (-G_Sd*G_R, -1));  % z -> y

figure ('Name', 'Fuehrung', 'NumberTitle', 'off', 'Position', [0 100 800 600]);
  set (gca, 'FontSize', 15); hold on
  plot ([0 T_E], [1 1], 'm', 'LineWidth', 1)
  [x_y, t_y, y_wy, t_wy] = cont_sim (G_S, G_w, T_E, 0, 0);
  plot (t_y, x_y, 'LineWidth', 1)
  stairs (t_wy, y_wy)
  set (findobj (gcf, 'type', 'line'), 'LineWidth', 1);
  axis ([0 T_E -1.1 1.1])
  title ('Dead-Beat-Fuehrungssprungantwort Fuehrungsfall', 'fontsize', 18)
  xlabel ('Zeit [s]')
  ylabel ('h(t)')
  legend ('w(t)', 'x(t)', 'y(t)')
  legend boxoff
  txt = {'Streckenparameter K_S, T_1, T_2:'; num2str([K_S T_1 T_2]); ' '
         evalc('G_R')};
  text (2, -0.1, txt, 'fontsize', 13)
  printgcf (mfilename, 0)

figure ('Name', 'Stoerung', 'NumberTitle', 'off', 'Position', [200 200 800 600]);
  set (gca, 'FontSize', 15); hold on
  plot ([0 T_E], [1 1], 'm', 'LineWidth', 1) 
  [x_z, t_y, y_zy, t_zy] = cont_sim (G_S, G_z, T_E, 0, 1);
  plot (t_y, x_z, 'LineWidth', 1)
  stairs (t_zy, y_zy)
  set (findobj (gcf, 'type', 'line'), 'LineWidth', 1);
  axis ([0 T_E -1.1 1.1])
  title ('Dead-Beat-Stoersprungantwort Fuehrungsfall', 'fontsize', 18)
  xlabel ('Zeit [s]')
  ylabel ('h(t)')
  legend ('z(t)', 'x(t)', 'y(t)')
  legend boxoff
  txt = {'Streckenparameter K_S, T_1, T_2:'; num2str([K_S T_1 T_2]); ' '
         evalc('G_R')};
  text (2, -0.4, txt, 'fontsize', 13)
  printgcf (mfilename, 0)

figure ('Name', 'Pol-Nullstellen', 'NumberTitle', 'off', 'Position', [100 0 800 600]);
  set (gca, 'FontSize', 15); hold on
  pzmap (G_z)
  set (findobj (gcf, 'type', 'line'), 'LineWidth', 2);
  plot_circ ('m')                 % Einheitskreis
  axis ([-1 1 -1 1])
  title ('Dead-Beat-Pol-Nullstellenbild Fuehrungsfall', 'fontsize', 18)
  xlabel ('Realteil')
  ylabel ('Imaginaerteil')
  legend ('Polstellen', 'Nullstellen', 'Einheitskreis', 'location', 'north')
  legend boxoff
  txt = {'Nullstellen Regelkreis:'; num2str(zero (G_z)'); ' '
         'Polstellen Regelkreis:'; num2str(pole (G_z)')};
  text (-0.6, -0.2, txt, 'fontsize', 12)
  printgcf (mfilename, 0)
