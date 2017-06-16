% Parameterschätzung Antrieb.m
% Prof. Dr. M. Lohöfener, HS Merseburg, 11.12.2008
% z. B. Modell eines Gleichstrommotors 

load Antrieb_Ausg_Vekt.csv
load Antrieb_Messmatr.csv

Theta=inv(Antrieb_Messmatr'*Antrieb_Messmatr)*Antrieb_Messmatr'*Antrieb_Ausg_Vekt

EW=eig(2*Antrieb_Messmatr'*Antrieb_Messmatr)
