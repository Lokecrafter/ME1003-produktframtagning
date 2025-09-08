clear all
close all
clc

L1 = 200;
L3 = 668;
L4 = 1258;
axle_length = 100;

geometry = SteeringGeometry(L1, L3, L4, axle_length);



% Calculate and display the maximum angle that the right spindle can achive without the linkage locking
alpha = atan(L3 / (2 * L4));
L2 = L3 - 2 * L1 * sin(alpha);
max_angle_b = pi + acos((L1^2 + L3^2 - (L1 + L2)^2) / (2 * L1 * L3));
max_right_steering_angle = max_angle_b + alpha - 3*pi/2;
disp(["Max right steering angle (deg): ", rad2deg(max_right_steering_angle)])





% Drawing some steering positions
angles = [deg2rad(29.3581), deg2rad(15), 0];
for i = 1:length(angles)
    right_steering_angle = angles(i);
    geometry = geometry.calculate(right_steering_angle);
    geometry.draw();
    difference = geometry.get_radius_difference();
end







% Plotting radius difference vs angle
angles = linspace(deg2rad(35), deg2rad(15), 500);
differences = zeros(size(angles));
radiuses = zeros(size(angles));
for i = 1:length(angles)
    right_steering_angle = angles(i);
    geometry = geometry.calculate(right_steering_angle);
    differences(i) = geometry.get_radius_difference();
    radiuses(i) = geometry.get_radius()/1000;
end
figure;
plot(radiuses, differences/1000, 'LineWidth', 2);
xlabel('Right Turing Radius (m)');
ylabel('Radius Difference (m)');
title('Radius Difference vs Right Turning Radius');
grid on;















% Secant method to find angle for zero radius difference
x0 = deg2rad(15);
x1 = deg2rad(35);
geometry = geometry.calculate(x0);
diff0 = geometry.get_radius_difference();

for i = 1:30
    disp(['Iteration ', num2str(i), ': Angle = ', num2str(rad2deg(x1), '%.4f'), '°']);
    geometry = geometry.calculate(x1);
    diff1 = geometry.get_radius_difference();

    if abs(diff1) < 1e-10
        break;
    end
    % Update x0 and x1 for the next iteration
    x_temp = x1 - diff1 * (x1 - x0) / (diff1 - diff0);
    x0 = x1;
    x1 = x_temp;
    diff0 = diff1;
end



% Final calculation and display
geometry = geometry.calculate(x1);
radius = geometry.get_radius();

disp(['Zero radius difference at right steering angle: ', num2str(rad2deg(x1), '%.4f'), '° with radius: ', num2str(radius/1000, '%.6f'), ' m']);
hold on; plot(radius/1000, 0, 'ro', 'MarkerSize', 10);



