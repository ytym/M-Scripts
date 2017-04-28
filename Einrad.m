function Einrad
% Einrad.m – getestet mit MATLAB + CST sowie GNU Octave + Control
% Manfred Lohöfener, HS Merseburg, 12.05.2014

    clear all
    close all	% sicher ist sicher

% Parameter
    k_a = 32500;  % N/m
    d_a = 10000;  % Ns/m
    m_a = 1300;	  % kg
    k_r = 50000;  % N/m
    m_r = 20.0;   % kg

% Übertragungsfunktionen
    s    = tf ('s');                        % LAPLACE-Op
    G_sr = k_r / (m_r*s^2 + d_a*s + k_r+k_a);
    G_ar = (d_a*s+k_a) / (m_r*s^2 + d_a*s + k_r+k_a);
    G_ra = (d_a*s+k_a) / (m_a*s^2 + d_a*s + k_a);

% Systeme – gleich anzeigen
    G_r = minreal (G_sr / (1 - G_ra*G_ar))  % Radbewegung
    G_a = minreal (G_r * G_ra)              % Aufbaubewegung

% Präsentation
    figure ('Name', 'Sprungantwort', 'NumberTitle', 'off', 'Position', [0 100 800 600]);
    set (gca, 'FontSize', 15); hold on
    step (G_r, G_a)
    set (findobj (gcf, 'type', 'line'), 'LineWidth', 1);
    title ('Einrad', 'fontsize', 18)
    xlabel ('Zeit t [s]')
    ylabel ('Positionen x(t)')
    legend ('x_R(t) Rad', 'x_A(t) Aufbau  ')
    legend boxoff
    printgcf (mfilename, 1)
end

%  Octave Output
%  
%  Transfer function 'G_r' from input 'u1' to output ...
%  
%                 2500 s^2 + 1.923e+04 s + 6.25e+04
%   y1:  ---------------------------------------------------
%        s^4 + 507.7 s^3 + 4150 s^2 + 1.923e+04 s + 6.25e+04
%  
%  Continuous-time model.
%  
%  Transfer function 'G_a' from input 'u1' to output ...
%  
%                      1.923e+04 s + 6.25e+04
%   y1:  ---------------------------------------------------
%        s^4 + 507.7 s^3 + 4150 s^2 + 1.923e+04 s + 6.25e+04
%  
%  Continuous-time model.
