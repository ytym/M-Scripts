% Diskreter Regelkreis RK_diskr_T0.m
% Getestet mit MATLAB + CST und 
% mit GNU Octave + Control-Package
% Manfred Lohoefener, HS Merseburg, Maerz 2017

clear
close all

% Parameter
K_S = 1.5;      % Proportionalfaktor
T_1 = 3.0;      % [s] Zeitkonstante
T_2 = 1.0;      % [s] Zeitkonstante

T_U = 0.45;     % [s] Verzugszeit
T_G = 5.20;     % [s] Ausgleichszeit

T_E = 12;       % [s] Simulationsdauer
s   = tf ('s'); % Laplace-Op

% Kontinuierliche Strecke
G_S  = K_S / (1 + (T_1+T_2)*s + T_1*T_2*s^2);

% Diskrete Strecke
T_0  = 0.25;     % [s] Abtastzeit
G_Sd = c2d (G_S, T_0);

% PID-Regler nach Übergangsfunktion, Takahashi (1.1)
K_R = 1.2*T_G / (K_S*(T_U+T_0));
T_N = 2*(T_U+T_0/2)^2 / (T_U+T_0);
T_V = (T_U+T_0) / 2;

q_i = [K_R*(1+T_0/(2*T_N)+T_V/T_0) ...
      -K_R*(1-T_0/(2*T_N)+2*T_V/T_0) K_R*T_V/T_0];
p_i = [1 -1 0];
G_R = tf (q_i, p_i, T_0);

G_w = feedback (G_R, G_Sd);     % Regelkreis w -> y
G_z = feedback (-G_Sd*G_R, -1); % Regelkreis z -> y

figure ('Name', 'Fuehrung_0.25_s', 'NumberTitle', 'off', 'Position', [0 100 800 600]);
  set (gca, 'FontSize', 15); hold on
  plot ([0 T_E], [1 1], 'm', 'LineWidth', 1)
  [x_y, t_y, y_wy, t_wy] = cont_sim (G_S, G_w, T_E, 0, 0);
  plot (t_y, x_y, 'LineWidth', 1)
  stairs (t_wy, y_wy)
  set (findobj (gcf, 'type', 'line'), 'LineWidth', 1);
  axis ([0 T_E -2 2])
  title ('Diskrete Fuehrungssprungantwort mit T0 = 0,25 s', 'fontsize', 18)
  xlabel ('Zeit [s]')
  ylabel ('h(t)')
  legend ('w(t)', 'x(t)', 'y(t)')
  legend boxoff
  txt = {'Streckenparameter K_S, T_1, T_2:'; num2str([K_S T_1 T_2]); ' '
         'Reglerparameter K_R, T_N, T_V:'; num2str([K_R T_N T_V]); ' '
         evalc('G_R')};
  text (5, -0.5, txt, 'fontsize', 13)
  printgcf (mfilename, 0)

% Diskrete Strecke
T_0  = 0.01;     % [s] Abtastzeit
G_Sd = c2d (G_S, T_0);

% PID-Regler nach Übergangsfunktion, Takahashi (1.1)
K_R = 1.2*T_G / (K_S*(T_U+T_0));
T_N = 2*(T_U+T_0/2)^2 / (T_U+T_0);
T_V = (T_U+T_0) / 2;

q_i = [K_R*(1+T_0/(2*T_N)+T_V/T_0) ...
      -K_R*(1-T_0/(2*T_N)+2*T_V/T_0) K_R*T_V/T_0];
p_i = [1 -1 0];
G_R = tf (q_i, p_i, T_0);

G_w = feedback (G_R, G_Sd);     % Regelkreis w -> y
G_z = feedback (-G_Sd*G_R, -1); % Regelkreis z -> y

figure ('Name', 'Fuehrung_0.01_s', 'NumberTitle', 'off', 'Position', [0 100 800 600]);
  set (gca, 'FontSize', 15); hold on
  plot ([0 T_E], [1 1], 'm', 'LineWidth', 1)
  [x_y, t_y, y_wy, t_wy] = cont_sim (G_S, G_w, T_E, 0, 0);
  plot (t_y, x_y, 'LineWidth', 1)
  stairs (t_wy, y_wy)
  set (findobj (gcf, 'type', 'line'), 'LineWidth', 1);
  axis ([0 T_E -2 2])
  title ('Diskrete Fuehrungssprungantwort mit T0 = 0,01 s', 'fontsize', 18)
  xlabel ('Zeit [s]')
  ylabel ('h(t)')
  legend ('w(t)', 'x(t)', 'y(t)')
  legend boxoff
  txt = {'Streckenparameter K_S, T_1, T_2:'; num2str([K_S T_1 T_2]); ' '
         'Reglerparameter K_R, T_N, T_V:'; num2str([K_R T_N T_V]); ' '
         evalc('G_R')};
  text (5, -0.5, txt, 'fontsize', 13)
  printgcf (mfilename, 0)

% Diskrete Strecke
T_0  = 1;     % [s] Abtastzeit
G_Sd = c2d (G_S, T_0);

% PID-Regler nach Übergangsfunktion, Takahashi (1.1)
K_R = 1.2*T_G / (K_S*(T_U+T_0));
T_N = 2*(T_U+T_0/2)^2 / (T_U+T_0);
T_V = (T_U+T_0) / 2;

q_i = [K_R*(1+T_0/(2*T_N)+T_V/T_0) ...
      -K_R*(1-T_0/(2*T_N)+2*T_V/T_0) K_R*T_V/T_0];
p_i = [1 -1 0];
G_R = tf (q_i, p_i, T_0);

G_w = feedback (G_R, G_Sd);     % Regelkreis w -> y
G_z = feedback (-G_Sd*G_R, -1); % Regelkreis z -> y

figure ('Name', 'Fuehrung_1_s', 'NumberTitle', 'off', 'Position', [0 100 800 600]);
  set (gca, 'FontSize', 15); hold on
  plot ([0 T_E], [1 1], 'm', 'LineWidth', 1)
  [x_y, t_y, y_wy, t_wy] = cont_sim (G_S, G_w, T_E, 0, 0);
  plot (t_y, x_y, 'LineWidth', 1)
  stairs (t_wy, y_wy)
  set (findobj (gcf, 'type', 'line'), 'LineWidth', 1);
  axis ([0 T_E -2 2])
  title ('Diskrete Fuehrungssprungantwort mit T0 = 1 s', 'fontsize', 18)
  xlabel ('Zeit [s]')
  ylabel ('h(t)')
  legend ('w(t)', 'x(t)', 'y(t)')
  legend boxoff
  txt = {'Streckenparameter K_S, T_1, T_2:'; num2str([K_S T_1 T_2]); ' '
         'Reglerparameter K_R, T_N, T_V:'; num2str([K_R T_N T_V]); ' '
         evalc('G_R')};
  text (5, -0.5, txt, 'fontsize', 13)
  printgcf (mfilename, 0)
