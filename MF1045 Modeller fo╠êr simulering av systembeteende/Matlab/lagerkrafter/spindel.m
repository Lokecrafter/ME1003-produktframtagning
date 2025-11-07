close all
clc
clear


% Given forces on wheel
F = 300;
K = 1000;

Rwheel = 0.3;
a=0.300;
b=0.500;
h=0.250;


L1 = F/2 - Rwheel*K/b;
L2 = F/2 + Rwheel*K/b;
G1 = (a*L1 + (a+b)*L2)/h - K/2;
G2 = (a*L1 + (a+b)*L2)/h + K/2;




k_point = a+b;
if K < 0
    k_point = a;
end

points = [
    0, 0, 0, a, a+b, k_point;
    h/2, h/2, -h/2, 0, 0, 0
];
forces = [
    0, G1, -G2, 0, 0, K;
    -F, 0, 0, L1, L2, 0;
];


quiver(points(1,:), points(2,:), forces(1,:), forces(2,:))
hold on;
plot([0, 1], [0, 0], '--')
hold on;
plot([0, a/2, a/2, 1], [h, h, h/2, h/2], '-o')
hold on;
plot([0, a/2, a/2, 1], -[h, h, h/2, h/2], '-o')
hold on;
plot(points(1,:), points(2,:), 'ob')