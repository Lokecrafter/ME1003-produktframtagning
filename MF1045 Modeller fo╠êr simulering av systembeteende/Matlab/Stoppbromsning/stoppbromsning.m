%% stoppbromsning.m
% Huvudprogram för simulering av stoppbromsning med låst skivbroms.
%
% Anders Söderberg, KTH - Maskinkonstruktion, 2024-08-21

%% Städar
clear all
clc
close all

%% Systemparametrar
% Definera systemparametar som globala
global r L1 L2 H1 H2 m g f c rho A mu

% Data för gokart
m   = 120;         % Massa gokart inkl. förare [kg]
r   = 0.135;       % Hjulradie [m]
L1  = 0.628;       % Masscentrum relativt framaxel [m]
L2  = 0.628;       % Masscentrum relativit bakaxel [m]
H1  = 0.40;        % Masscentrum relativit marknivå [m]
H2  = 0.10;        % Angeppspunkt för Fluft relativit masscentrum [m]
A   = 0.5;         % Projicerad area för luftmotstånd [m^2]

% Fysikaliska parametrar
mu  = 0.8;         % Friktionstal mellan däck och vägbana [-]
f   = 0.012;       % Rullmotståndskoefficient [-]
g   = 9.81;        % Tyngdacceleration [m/s^2]
c   = 0.6;         % Luftmotståndskoefficient [-]
rho = 1.22;        % Denstitet hos luft [kg/m^3]  
  
%% Simulering av stoppbromsing
% Definiera tidsintervall och begynnelsevillkor
tstart = 0;                                                 % Starttid för simulering [s]
tend   = 10;                                                % Sluttid för simulering [s] 
vstart = 50/3.6;                                            % Utgångshastighet [m/s]
sstart = 0;                                                 % Utgångssträcka [m]
tspan  = [tstart tend];                                     % Start- och sluttid för simulering [s]
IC     = [vstart sstart];                                   % Sätter initialvillkor så att vi bromsar från utgångshastigheten och utgångsposition 
% Lös problem med lämplig ode-lösare
opt    = odeset('RelTol',1e-9);                             % Sätter toleranser på lösaren
[T,Y] = ode45('derivatabromsning',tspan,IC,opt);            % Anropar ode-lösare
% Dela upp tillståndsmatris på vektorer
V      = Y(:,1);                                            % Hastighet [m/s]
S      = Y(:,2);                                            % Sträcka [m]
% Beräkna kontaktkrafter och erforderlig bromsmoment
Frull  = f*m*g*(V>0);                                       % Rullmotstånd [N]
Fluft  = 0.5*c*rho*A*V.^2.*(V>0);                           % Luftmotstånd [N]
N2     = (m*g*L1-Frull*H1+Fluft*H2)./(L1+L2+mu*H1*(V>0));   % Normalkraft mellan bakdäck och vägbana [N]
N1     =  m*g-N2;                                           % Normalkraft mellan framdäck och vägbana [N]
F      = -mu*N2.*(V>0);                                     % Bromsande friktionskraft mellan bakdäck och vägbana [N]
M      =  mu*N2*r.*(V>0);                                   % Erforderligt bromsmoment för att låsa bakaxeln [Nm]

% Utvärdering av inbromsingsförlopp
i = find(V<1e-4,1);     % Hittar index till stillåstende
t   = T(i);             % Inbromsningstid [s]
s   = S(i);             % Bromssträcka [m]
Mb  = max(M);           % Maximalt erfoderligt bromsmoment [Nm]

%% Presentation av resultat
% Grafer som visar hastighet och sträcka
figure(1)
subplot(2,1,1)
plot(T,V*3.6,'LineWidth',2)
grid on
xlabel('t [s]')
ylabel('v [km/h]')
subplot(2,1,2)
plot(S,V*3.6,'LineWidth',2)
grid on
xlabel('s [m]')
ylabel('v [km/h]')
% Grafer som visar kontaktkrafter mellan däck och vägbana samt erforderligt
% bromsmoment
figure(2)
subplot(2,1,1)
plot(T,[N1 N2],'LineWidth',2)
grid on
xlabel('t [s]')
ylabel('N_1, N_2 [N]')
legend('N_1','N_2')
subplot(2,1,2)
plot(T,M,'LineWidth',2)
grid on
xlabel('t [s]')
ylabel('M [Nm]')
% Utskrift i command window
disp(['Stopptid:     ' num2str(t) ' s'])
disp(['Stoppsträcka: ' num2str(s) ' m'])
disp(['Bromsmoment:  ' num2str(Mb) ' Nm'])


%% EOF
