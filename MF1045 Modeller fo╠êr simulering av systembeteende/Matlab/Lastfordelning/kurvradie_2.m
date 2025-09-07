clear all
close all
clc

% Inställningar
visa_animation = true; % Sätt till true för animation, false för en vinkel
vald_vinkel = deg2rad(30); % Vinkel i radianer om du inte vill animera
animation_duration = 10; % Sekunder

L1 = 200;
L3 = 668;
L4 = 1258;

alpha = atan(L3 ./ (2 .* L4));
L2 = L3 - 2 .* L1 .* sin(alpha);

if visa_animation
    vinklar = linspace(deg2rad(-36.742), deg2rad(36.742), 100);
    fig = figure;
    k = 1;
    dir = 1; % 1 = framåt, -1 = bakåt
    while ishandle(fig)
        clf;
        right_steering_angle = vinklar(k);
        % ...beräkning och plottning...
        pointA = [0; 0];
        pointB = [L3; 0];

        angleB = right_steering_angle - pi/2 - alpha;
        pointC = pointB + [L1 * cos(angleB); L1 * sin(angleB)];

        vectorAC = pointC - pointA;
        angleBAC = atan2(vectorAC(2), vectorAC(1));
        lengthAC = norm(vectorAC);
        angleDAC = acos((lengthAC^2 + L1^2 - L2^2) / (2 * L1 * lengthAC)); % Cosine rule

        angleD = angleBAC - angleDAC;
        pointD = pointA + [L1 * cos(angleD); L1 * sin(angleD)];

        leftAxle = pointA + 30 * [cos(angleD - alpha - pi/2); sin(angleD - alpha - pi/2)];
        rightAxle = pointB + 30 * [cos(angleB + alpha + pi/2); sin(angleB + alpha + pi/2)];

        % Plot lines
        plot_line(pointA, pointB, 2, 'black')
        plot_line(pointB, pointC, 2, 'red')
        plot_line(pointA, pointD, 2, 'red')
        plot_line(pointC, pointD, 2, 'green')

        % Extras
        plot_line([-10000, -L4], [10000, -L4], 2, 'black') % Rear axle
        plot_line([0, -L4 - 10], [0, -L4 + 10], 2, 'black') % Left rear wheel
        plot_line([L3, -L4 - 10], [L3, -L4 + 10], 2, 'black') % Right rear wheel
        plot_line(pointB, rightAxle, 2, 'black') % Right front axle
        plot_line(pointA, leftAxle, 2, 'black') % Left front axle

        % Extensions for visualization
        plot_line((pointA + 1000 * (leftAxle - pointA)), (pointA - 1000 * (leftAxle - pointA)), 1, "black")
        plot_line((pointB + 1000 * (rightAxle - pointB)), (pointB - 1000 * (rightAxle - pointB)), 1, "black")

        axis equal
        grid on
        xlim([-8.1 * L1, 8.1 * (L3 + L1)])
        ylim([-1.1 * (L1 + L4), 1.1 * (L1)])
        title(['right\_steering\_angle = ', num2str(rad2deg(right_steering_angle), '%.1f'), '°'])
        drawnow
        pause(animation_duration / length(vinklar))

        k = k + dir;
        if k == length(vinklar) || k == 1
            dir = -dir; % Byt riktning när vi når slutet eller början
        end
    end
else
    right_steering_angle = vald_vinkel;
    figure;
    % ...beräkning och plottning...
    pointA = [0; 0];
    pointB = [L3; 0];

    angleB = right_steering_angle - pi/2 - alpha;
    pointC = pointB + [L1 * cos(angleB); L1 * sin(angleB)];

    vectorAC = pointC - pointA;
    angleBAC = atan2(vectorAC(2), vectorAC(1));
    lengthAC = norm(vectorAC);
    angleDAC = acos((lengthAC^2 + L1^2 - L2^2) / (2 * L1 * lengthAC)); % Cosine rule

    angleD = angleBAC - angleDAC;
    pointD = pointA + [L1 * cos(angleD); L1 * sin(angleD)];

    leftAxle = pointA + 30 * [cos(angleD - alpha - pi/2); sin(angleD - alpha - pi/2)];
    rightAxle = pointB + 30 * [cos(angleB + alpha + pi/2); sin(angleB + alpha + pi/2)];

    % Plot lines
    plot_line(pointA, pointB, 2, 'black')
    plot_line(pointB, pointC, 2, 'red')
    plot_line(pointA, pointD, 2, 'red')
    plot_line(pointC, pointD, 2, 'green')

    % Extras
    plot_line([-10000, -L4], [10000, -L4], 2, 'black') % Rear axle
    plot_line([0, -L4 - 10], [0, -L4 + 10], 2, 'black') % Left rear wheel
    plot_line([L3, -L4 - 10], [L3, -L4 + 10], 2, 'black') % Right rear wheel
    plot_line(pointB, rightAxle, 2, 'black') % Right front axle
    plot_line(pointA, leftAxle, 2, 'black') % Left front axle

    % Extensions for visualization
    plot_line((pointA + 1000 * (leftAxle - pointA)), (pointA - 1000 * (leftAxle - pointA)), 1, "black")
    plot_line((pointB + 1000 * (rightAxle - pointB)), (pointB - 1000 * (rightAxle - pointB)), 1, "black")

    axis equal
    grid on
    xlim([-8.1 * L1, 8.1 * (L3 + L1)])
    ylim([-1.1 * (L1 + L4), 1.1 * (L1)])
    title(['right\_steering\_angle = ', num2str(rad2deg(right_steering_angle), '%.1f'), '°'])
end

function plot_line(start_point, end_point, width, color)
    plot([start_point(1), end_point(1)], [start_point(2), end_point(2)], color, 'LineWidth', width); hold on;
end


max_angle_b = pi + acos((L1^2 + L3^2 - (L1 + L2)^2) / (2 * L1 * L3));
max_right_steering_angle = max_angle_b + alpha - 3*pi/2;
disp(["Max right steering angle (deg): ", rad2deg(max_right_steering_angle)])