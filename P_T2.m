% Pol-Nullstellen der Beispielregelstrecke P_T2.m 
% kontinuierlich und diskret
% Getestet mit MATLAB + CST und 
% mit GNU Octave + Control-Package
% Manfred Lohoefener, HS Merseburg, 03.11.2014

clear
close all

% Parameter
  K   = 1.5;  % Proportionalfaktor
  T_1 = 3.0;  % [s] Zeitkonstante
  T_2 = 1.0;  % [s] Zeitkonstante
  T_0 = 0.5;  % [s] Abtastzeit

  T_E = 12;   % [s] Simulationsdauer
  D_t = 0.02; % [s] Schrittweite
  t_x = 0:D_t:T_E;  % [s] Zeitachse
  s = tf ('s');

% Übertragungsfunktionen
  G_S = K / ((1 + T_1*s)*(1 + T_2*s));  % kontinuierlich
  G_z = c2d (G_S, T_0);                 % diskret

  [x, t] = step (G_S, t_x);
  [x_d, t_d] = step (G_z, T_E);

figure ('Name', 'Sprungantwort', 'NumberTitle', 'off', 'Position', [0 100 800 600]);
  set (gca, 'FontSize', 15); hold on
  line ([0 T_E], [1 1], 'Color', 'm', 'LineWidth', 1);
  plot (t, x, 'LineWidth', 1);
  stairs (t_d, x_d, 'LineWidth', 1)
  set (findobj (gcf, 'type', 'line'), 'LineWidth', 1);
  line (get (gca, 'xlim'), [1.5 1.5], 'Color', 'g', 'LineWidth', 1)
  axis ([0 T_E 0 1.6])
  title ('UEbergangsfunktion / Sprungantwort', 'fontsize', 18)
  xlabel ('Zeit [s]')
  ylabel ('h(t)')
  legend ('\sigma(t) Einheitssprung', 'h(t) kontinuierlich', 'h(k) diskret', ...
    'h(t=\infty), h(k=\infty) Asymptote            ', 'location', 'east')
  legend boxoff
  text (0.4, 1.25, evalc ('G_S'), 'FontName', 'Courier', 'FontSize', 11)
  text (3.2, 0.3, evalc ('G_z'), 'FontName', 'Courier', 'FontSize', 11)
  printgcf (mfilename, 0)

figure ('Name', 'Pol-Nullstellen', 'NumberTitle', 'off', 'Position', [100 0 800 600]);
  set (gca, 'FontSize', 15); hold on
  pzmap (G_S, G_z)
  set (findobj (gcf, 'type', 'line'), 'LineWidth', 2);
  plot_circ ('m')                 % Einheitskreis
  title ('Pol-Nullstellenbild', 'fontsize', 18)
  xlabel ('Realteil')
  ylabel ('Imaginaerteil')
  legend ('G_S(s) kontinuierliche Pole              ', 'G_S(z) diskrete Pole', ...
    'G_S(z) diskrete Nullstellen', 'Einheitskreis')
  legend boxoff
  txt = {'Nullstellen G_S(s):'; num2str(zero (G_S)'); ' '
          'Polstellen G_S(s):'; num2str(pole (G_S)'); ' '
          'Nullstellen G_S(z):'; num2str(zero (G_z)'); ' '
          'Polstellen G_S(z):'; num2str(pole (G_z)')};
  text (-0.7, 0, txt, 'fontsize', 15)
  printgcf (mfilename, 0)
  