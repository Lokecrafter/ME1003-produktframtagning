%%  LastfordelningSida.m
% Program f�r ber�kning av lastf�rdelning och maximal hastighet vid kurvtagning
% 
% Anders S�derberg KTH Maskinkonstruktion 2024-08-21

%% St�dar arbetsminnet, commad window sa
clear all
close all
clc

%% Givna parameterv�rden
B1 = 0.410;                     % Masscentrums l�ge relativit v�nster hjul [m]
B2 = 0.410;                     % Masscentrums l�ge relativit h�ger hjul [m]
H1 = 0.400;                     % Masscentrums l�ge �ver markniv�n [m]
m  = 120;                       % Massa hos fordon ink. f�rare 
mu = 0.8;                       % Friktion mellan d�ck och v�gbana [-]
g  = 9.81;                      % Tyngdaccelation [m/s^2]

%% Best�mning av masscentrums maximala h�jd �ver marken f�r att undvika tippning
Bmin = min(B1,B2);              % Avg�r minsta avst�nd fr�n masscentrum till hjul [m]
H1max = Bmin/mu;                % Ber�knar maximalt till�tet v�rde p� H1

%% Best�mning av maximal kurvhastighet f�r att undvika sladd
R = [5:20];                     % Kurvradier [m]
v  = sqrt(mu*g*R);              % Maximal hastiget f�r att undvika sladd [m/s]

%% Best�mning av normalkrafter i olika k�rfall
% V�nsterkurva p� gr�nsen till sladd
N1(1) = m*g*(B2-mu*H1)/(B1+B2); % Normalkraft p� v�nster sida [N]
N2(1) = m*g -N1(1);             % Normalkraft p� h�ger sida [N]
% K�rning rakt fram
N1(2) = m*g*B2/(B1+B2);         % Normalkraft p� v�nster sida [N]
N2(2) = m*g -N1(2);             % Normalkraft p� h�ger sida [N]
% H�gerkurva p� gr�nsen till sladd
N1(3) = m*g*(B2+mu*H1)/(B1+B2); % Normalkraft p� v�nster sida [N]
N2(3) = m*g -N1(3);             % Normalkraft p� h�ger sida [N]

%% Presentation av resultat
% Skriver ut massecntrums maximalt till�tna h�jd �ver marken
disp(' ')
disp(['H1max = ' num2str(round(H1max*1e3)) ' mm']);
disp(' ')
% Graf som visar vmax som funktion av kurvradien
figure
plot(R,v*3.6)
xlabel('Kurvradie R [m]')
ylabel('Gränshastighet för sladd v_m_a_x [km/h]')
grid on
% Tabell med lastf�rdelning
Fall ={'Vänster kurva   ' 'Rakt            ' 'Höger kurva     '};
disp(['               ' 'Vänster   ' 'Höger'])
for i =1:3
    disp([Fall{i} num2str(round(N1(i)/(m*g)*100)) '%      ' num2str(round(N2(i)/(m*g)*100)) '% '])
end


disp(' ')
disp("Normalkrafter i olika k�rfall")

disp(['               ' 'V�nster N1   ' 'H�ger N2'])
for i = 1:3
    disp([Fall{i} num2str(N1(i)) ' N    ' num2str(N2(i)) ' N'])
end

%% EOF


