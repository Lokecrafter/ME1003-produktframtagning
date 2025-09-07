classdef SteeringGeometry
    properties
        L1
        L2
        L3
        L4
        alpha
        axle_length
        pointA
        pointB
        pointC
        pointD
        leftAxle
        rightAxle
    end
    methods
        function obj = SteeringGeometry(L1, L3, L4, axle_length)
            obj.L1 = L1;
            obj.L3 = L3;
            obj.L4 = L4;
            obj.alpha = atan(L3 / (2 * L4));
            obj.L2 = L3 - 2 * L1 * sin(obj.alpha);
            obj.axle_length = axle_length;
            obj.pointA = [0; 0];
            obj.pointB = [0; 0];
            obj.pointC = [0; 0];
            obj.pointD = [0; 0];
            obj.leftAxle = [0; 0];
            obj.rightAxle = [0; 0];
        end
        function obj = calculate(obj, right_joint_angle)
            obj.pointA = [0; 0];
            obj.pointB = [obj.L3; 0];
            angleB = right_joint_angle - pi/2 - obj.alpha;
            obj.pointC = obj.pointB + [obj.L1 * cos(angleB); obj.L1 * sin(angleB)];
            vectorAC = obj.pointC - obj.pointA;
            angleBAC = atan2(vectorAC(2), vectorAC(1));
            lengthAC = norm(vectorAC);
            angleDAC = acos((lengthAC^2 + obj.L1^2 - obj.L2^2) / (2 * obj.L1 * lengthAC));
            angleD = angleBAC - angleDAC;
            obj.pointD = obj.pointA + [obj.L1 * cos(angleD); obj.L1 * sin(angleD)];
            obj.leftAxle = obj.pointA + obj.axle_length * [cos(angleD - obj.alpha - pi/2); sin(angleD - obj.alpha - pi/2)];
            obj.rightAxle = obj.pointB + obj.axle_length * [cos(angleB + obj.alpha + pi/2); sin(angleB + obj.alpha + pi/2)];
        end
        function difference = get_radius_difference(obj)
            right_turning_radius = obj.L4 / tan(atan2(-(obj.rightAxle(2) - obj.pointB(2)), -(obj.rightAxle(1) - obj.pointB(1)))) - obj.L3 / 2;
            left_turning_radius = obj.L4 / tan(atan2(obj.leftAxle(2) - obj.pointA(2), obj.leftAxle(1) - obj.pointA(1))) + obj.L3 / 2;
            difference = right_turning_radius - left_turning_radius;
        end
        function radius = get_radius(obj)
            radius = obj.L4 / tan(atan2(-(obj.rightAxle(2) - obj.pointB(2)), -(obj.rightAxle(1) - obj.pointB(1)))) - obj.L3 / 2;
        end
        function draw(obj)
            function plot_line(start_point, end_point, width, color)
                plot([start_point(1), end_point(1)], [start_point(2), end_point(2)], color, 'LineWidth', width); hold on;
            end
            plot_line(obj.pointA, obj.pointB, 2, 'black')
            plot_line(obj.pointB, obj.pointC, 2, 'red')
            plot_line(obj.pointA, obj.pointD, 2, 'red')
            plot_line(obj.pointC, obj.pointD, 2, 'green')
            plot_line([-10000, -obj.L4], [10000, -obj.L4], 2, 'black')
            plot_line([0, -obj.L4 - 10], [0, -obj.L4 + 10], 2, 'black')
            plot_line([obj.L3, -obj.L4 - 10], [obj.L3, -obj.L4 + 10], 2, 'black')
            plot_line(obj.pointB, obj.rightAxle, 3, 'cyan')
            plot_line(obj.pointA, obj.leftAxle, 3, 'cyan')
            plot_line((obj.pointA + 1000 * (obj.leftAxle - obj.pointA)), (obj.pointA - 1000 * (obj.leftAxle - obj.pointA)), 1, "black")
            plot_line((obj.pointB + 1000 * (obj.rightAxle - obj.pointB)), (obj.pointB - 1000 * (obj.rightAxle - obj.pointB)), 1, "black")
            right_turning_radius = obj.L4 / tan(atan2(-(obj.rightAxle(2) - obj.pointB(2)), -(obj.rightAxle(1) - obj.pointB(1)))) - obj.L3 / 2;
            left_turning_radius = obj.L4 / tan(atan2(obj.leftAxle(2) - obj.pointA(2), obj.leftAxle(1) - obj.pointA(1))) + obj.L3 / 2;
            if abs(right_turning_radius) > 0
                theta = linspace(0, 2*pi, 100);
                circle_right = [right_turning_radius * cos(theta) + obj.L3/2; right_turning_radius * sin(theta) - obj.L4];
                plot(circle_right(1, :), circle_right(2, :), 'b--', 'LineWidth', 1);
            end
            if abs(left_turning_radius) > 0
                theta = linspace(0, 2*pi, 100);
                circle_left = [left_turning_radius * cos(theta) + obj.L3/2; left_turning_radius * sin(theta) - obj.L4];
                plot(circle_left(1, :), circle_left(2, :), 'b--', 'LineWidth', 1);
            end
            axis equal
            grid on
            xlim([-2000, 1.1 * (obj.L3 + obj.L1)])
            ylim([-1.1 * (obj.L1 + obj.L4), 1.1 * (obj.L1)])
            drawnow
        end
    end
end
