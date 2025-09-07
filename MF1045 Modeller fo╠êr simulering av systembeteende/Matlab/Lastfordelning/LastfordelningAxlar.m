%% LastfordelningAxlar
% Program f�r best�mning av lastf�rdelning mellan fram och bakaxel p�
% gokarten under olika k�rfall
%
% Anders S�derberg, KTH-Maskinkonstruktion, 2024-08-21
%

%% St�dar
clear all
close all
clc

%% Givna in data
% Massa och masscentrum f�r gokart inkl. f�rare
L1   = 0.658;
L2   = 0.600;
H1   = 0.100;
m    = 120;     % Massa inkl. f�rare [kg]
r    = 0.135;   % Hjulradie [mm]
% Data f�r drivlinan
u    = 2;       % Utv�xling [-]
eta  = 0.95;    % Verkningsgrad [-]
Mmax = 11.2;      % Maximalt motormoment enligt datablad [Nm]
% Fysikaliska parametrar
mu  = 0.8;      % Friktionstal mellan d�ck och v�gbana [ - ]
g   = 9.81;     % Tyngdacceleration [m/s^2]

%% Ber�kning av lastf�rdelning mellan fram och bakaxel f�r olika k�rfall
% Acceleration med maximalt motormoment
F(1) = u*eta*Mmax/r;                % Drivande kraft [N]
a(1) = F(1)/m;                      % Acceleration [m/s^2]
N1(1)= (m*g*L2 -F(1)*H1)/(L1+L2);
N2(1)= m*g -N1(1);

% Konstant hastighet
F(2) = 0;
a(2) = F(2)/m;
N1(2)= (m*g*L2 -F(2)*H1)/(L1+L2);
N2(2)= m*g -N1(2);

% Acceleration med maximalt motormoment
N2(3)= m*g*L1/(L1+L2+mu*H1) ;
N1(3)= m*g -N2(3);
F(3) = -mu*N2(3);
a(3) = F(3)/m;

% Tabell med lastf�rdelning
Fall ={'Acceleration        ' 'Konstant hastighet  ' 'Inbromsning         '};
disp(['                    ' 'Fram   ' 'Bak'])
for i =1:3
    disp([Fall{i} num2str(round(N1(i)/(m*g)*100)) '%      ' num2str(round(N2(i)/(m*g)*100)) '% '])
end

disp(' ')
disp(['Normalkrafter        ' 'Fram   ' 'Bak' '                        Drivkraft'])
for i =1:3
    disp([Fall{i} num2str(N1(i)) ' N      ' num2str(N2(i)) ' N        ' num2str(F(i)) ' N'])
end


