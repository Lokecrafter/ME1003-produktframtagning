close all
clc
clear


% Given forces on wheel
F = 300;
K = 100;

% Geometry
R = 30 * 10^(-2); % Wheel radius
dist_between_bearings = 20 * 10^(-2); % Distance between bearings



% Ascii art of geometry

%      F
%      \/
% |         |
% |         |
% |         |
% |         |______________________
% |         
% |          ______________________
% |         |             /\      /\
% |         |             L1      L2
% |         |
% |         |




%Beräkna lagerkrafter vid given kraft F

L1 = F - K/dist_between_bearings;
L2 = K/dist_between_bearings;




spindle_diameters = [
    0,   100,  100.1,  400,  400.1, 1000;
    200, 200, 150, 150, 100, 100
] * 10^(-3); % Enter diameters in millimeters
spindle_turn_axis = [
    50, 50;
    max(spindle_diameters(2, :)) * 1000, -max(spindle_diameters(2, :)) * 1000
] * 10^(-3);



subplot(1, 2, 1);
axis equal;
plot(spindle_diameters(1, :), spindle_diameters(2, :), '-ob', 'LineWidth', 2);
hold on;
plot(spindle_diameters(1, :), -spindle_diameters(2, :), '-ob', 'LineWidth', 2);
hold on;
plot(spindle_turn_axis(1, :), spindle_turn_axis(2, :), '--', 'LineWidth', 2);


interp1(spindle_diameters(1, :), spindle_diameters(2, :), 1*10^(-3))



subplot(1, 2, 2);
axis equal;
plot([0, 1, 1, 0], [1, 1, 0, 0], 'o-', 'LineWidth', 2);