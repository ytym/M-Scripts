% Rekursive Parameterschaetzung Antrieb_RLS.m
% Prof. Dr. M. Lohoefener, HS Merseburg, 18.12.2008
% z. B. Modell eines Gleichstrommotors 

clear all	% vorsichtshalber
close all

load Antrieb_Ausg_Vekt.csv  % Messwerte
load Antrieb_Messmatr.csv	% mit zurueckliegenden Werten

[nr, nc] = size (Antrieb_Messmatr);	% Dimensionen erfassen
P = 100000*eye (nc, nc);			% Praezisionsmatrix anlegen
Theta = zeros (nc, 1);			  % Parametervektor anlegen
Theta_k = zeros (nr, nc);		% nur um Verlauf zu plotten
lambda = 0.99;					    % gewaehlt 

for i = 1: nr						    % Rekursion startet 
	m = Antrieb_Messmatr (i, :)';	% Messwertvektor holen 
	ev = Antrieb_Ausg_Vekt (i, 1)-m'*Theta;	% Modellfehler bestimmen 
	K = P*m / (lambda+m'*P*m);	% Korrekturvektor berechnen 
	Theta = Theta + K*ev;			  % neue Parameterschaetzung
	P = (P-K*m'*P) / lambda;		% neue Praezisionsmatrix
	Theta_k(i, :) = Theta';		% nur für Plot 
end

plot (0: nr-1, Theta_k);
title ('P a r a m e t e r s c h a e t z u n g   G l e i c h s t r o m m o t o r');
xlabel ('Abtastpunkte k');
ylabel ('Parameterwerte');
legend ('a1', 'a2', 'a3', 'b1', 'b2', 'b3');
legend boxoff
text (0.1, -0.25, 'Werte im letzten Abtastschritt');
for i = 1:nc
	text (0.5, -0.275-0.05*i, sprintf('Theta(%d) = %f', i, Theta(i)));
end
grid on
