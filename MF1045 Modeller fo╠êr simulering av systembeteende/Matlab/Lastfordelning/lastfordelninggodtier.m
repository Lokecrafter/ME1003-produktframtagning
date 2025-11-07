clear all
close all
clc

%% Givna parametervärden
% Geometrier
B1 = 0.410;                     % Masscentrums läge relativit vänster hjul [m]
B2 = 0.410;                     % Masscentrums läge relativit höger hjul [m]
H1 = 0.400;                     % Masscentrums läge över marknivån [m]
L1   = 0.658;
L2   = 0.600;
r    = 0.135;   % Hjulradie [mm]

% Data för drivlinan
u    = 2;       % Utv�xling [-]
eta  = 0.95;    % Verkningsgrad [-]
Mmax = 11.2;      % Maximalt motormoment enligt datablad [Nm]

% Fysikaliska parametrar
m  = 120;                       % Massa hos fordon ink. förare 
mu  = 0.8;      % Friktionstal mellan d�ck och v�gbana [ - ]
g   = 9.81;     % Tyngdacceleration [m/s^2]






Bmin = min(B1,B2);              % Avgör minsta avstånd från masscentrum till hjul [m]
H1max = Bmin/mu;                % Beräknar maximalt tillåtet värde på H1

% Vänsterkurva på gränsen till sladd
left_side(1) = m*g*(B2-mu*H1)/(B1+B2);
right_side(1) = m*g -left_side(1);

% Körning rakt fram
left_side(2) = m*g*B2/(B1+B2);
right_side(2) = m*g -left_side(2);

% Högerkurva på gränsen till sladd
left_side(3) = m*g*(B2+mu*H1)/(B1+B2);
right_side(3) = m*g -left_side(3);



% Acceleration med maximalt motormoment
F(1) = u*eta*Mmax/r;                % Drivande kraft [N]
a(1) = F(1)/m;                      % Acceleration [m/s^2]
front(1)= (m*g*L2 -F(1)*H1)/(L1+L2);
rear(1)= m*g -front(1);

% Konstant hastighet
F(2) = 0;
a(2) = F(2)/m;
front(2)= (m*g*L2 -F(2)*H1)/(L1+L2);
rear(2)= m*g -front(2);

% Bromsning med maximalt bromsmoment
rear(3)= m*g*L1/(L1+L2+mu*H1) ;
front(3)= m*g -rear(3);
F(3) = -mu*rear(3);
a(3) = F(3)/m;



amount_of_acceleration_states = 3;
amount_of_turning_states = 3;

right_front_wheel = zeros(3, 3);

% Front wheels
disp("left front wheel")
disp("                left turn     no turn    right turn")
list_mesgs = ["acceleration   ", "no acceleration", "braking        "];
for i_acc = 1:amount_of_acceleration_states
    message = list_mesgs(i_acc);
    for j_turn = 1:amount_of_turning_states
        right_front_wheel(i_acc, j_turn) = left_side(j_turn) * front(i_acc) / (m*g);
        message = message + "   " + right_front_wheel(i_acc, j_turn);
    end
    disp(message)
end
disp(" ")
disp("Right front wheel")
disp("                left turn     no turn    right turn")
list_mesgs = ["acceleration   ", "no acceleration", "braking        "];
for i_acc = 1:amount_of_acceleration_states
    message = list_mesgs(i_acc);
    for j_turn = 1:amount_of_turning_states
        right_front_wheel(i_acc, j_turn) = right_side(j_turn) * front(i_acc) / (m*g);
        message = message + "   " + right_front_wheel(i_acc, j_turn);
    end
    disp(message)
end

% Rear wheels
disp(" ")
disp("left rear wheel")
disp("                left turn     no turn    right turn")
list_mesgs = ["acceleration   ", "no acceleration", "braking        "];
for i_acc = 1:amount_of_acceleration_states
    message = list_mesgs(i_acc);
    for j_turn = 1:amount_of_turning_states
        right_front_wheel(i_acc, j_turn) = left_side(j_turn) * rear(i_acc) / (m*g);
        message = message + "   " + right_front_wheel(i_acc, j_turn);
    end
    disp(message)
end
disp(" ")
disp("Right rear wheel")
disp("                left turn     no turn    right turn")
list_mesgs = ["acceleration   ", "no acceleration", "braking        "];
for i_acc = 1:amount_of_acceleration_states
    message = list_mesgs(i_acc);
    for j_turn = 1:amount_of_turning_states
        right_front_wheel(i_acc, j_turn) = right_side(j_turn) * rear(i_acc) / (m*g);
        message = message + "   " + right_front_wheel(i_acc, j_turn);
    end
    disp(message)
end