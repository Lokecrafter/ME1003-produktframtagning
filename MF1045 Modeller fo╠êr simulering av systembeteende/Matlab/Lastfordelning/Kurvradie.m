clear all
close all
clc

L1 = 200;
L3 = 668;
L4 = 1258;

alpha = atan(L3 ./ (2 .* L4));
L2 = L3 - 2 .* L1 .* sin(alpha);


disp(["Alpha: ", alpha])
disp(["L2: ", L2])





% Render steering geometry

spindel_left = [
    -L3 * 0.5;
    0
]
spindel_right = [
    L3 * 0.5;
    0
]

right_steering_angle = deg2rad(30);


angle = right_steering_angle% - alpha;
right_arm = [
    spindel_right(1) - L1 .* sin(angle);
    spindel_right(2) - L1 .* cos(angle)
]


function plot_line(start_point, end_point, color)
    plot([start_point(1), end_point(1)], [start_point(2), end_point(2)], color, 'LineWidth', 2); hold on;
end

% Plot lines
plot_line(spindel_left, spindel_right, 'black')
plot_line(spindel_right, right_arm, 'red')









left_spindel_to_right_arm = right_arm - spindel_left;
angle = atan2(left_spindel_to_right_arm(2), left_spindel_to_right_arm(1));


beta = acos(-(L2^2 - norm(left_spindel_to_right_arm)^2 - L1^2) / (2 * L2 * norm(left_spindel_to_right_arm))); % Cosine rule
left_arm_angle = angle - beta;
left_arm = [
    spindel_left(1) + L1 * cos(left_arm_angle);
    spindel_left(2) + L1 * sin(left_arm_angle)
];

plot_line(spindel_left, left_arm, 'blue')




distance = norm(left_arm - right_arm);
disp(["Distance: ", distance])
disp(["L2: ", L2])