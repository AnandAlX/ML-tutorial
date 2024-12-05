clearvars
clc
% 1. Define Parameters
A = 3;
disp(['Value of A: ', num2str(A)]);

% 2. Define End Points of the Curve based on A
start_point = [-A, A + 1];            % P0
end_point = [2 * A + 2, 2 * A - 1];   % P1
disp(['Start Point (P0): ', mat2str(start_point)]);
disp(['End Point (P1): ', mat2str(end_point)]);

% 3. Define Tangents based on scaling factors
tangent_start = 1 * [0.89, 0.41];     % T0 (scaled)
tangent_end = 100 * [0.44, -0.91];    % T1 (scaled)
disp(['Tangent at Start Point (T0): ', mat2str(tangent_start)]);
disp(['Tangent at End Point (T1): ', mat2str(tangent_end)]);

% 4. Hermite Basis Functions
syms t; % Symbolic variable for parameter t
hermite_h0 = 2 * t^3 - 3 * t^2 + 1;
hermite_h1 = -2 * t^3 + 3 * t^2;
hermite_h2 = t^3 - 2 * t^2 + t;
hermite_h3 = t^3 - t^2;

% 5. Parametric Equations of the Hermite Curve
curve_x = hermite_h0 * start_point(1) + hermite_h1 * end_point(1) + hermite_h2 * tangent_start(1) + hermite_h3 * tangent_end(1); % x-component
curve_y = hermite_h0 * start_point(2) + hermite_h1 * end_point(2) + hermite_h2 * tangent_start(2) + hermite_h3 * tangent_end(2); % y-component

% 6. Converting Symbolic Equations to Functions
curve_x_func = matlabFunction(curve_x);
curve_y_func = matlabFunction(curve_y);

% 7. Generate Points for Plotting
t_values = linspace(0, 1, 100); % Parameter t values between 0 and 1
x_values = curve_x_func(t_values); % x-coordinates of Hermite curve
y_values = curve_y_func(t_values); % y-coordinates of Hermite curve

% 8. Plot the Hermite Curve with Modified Appearance
figure;
plot(x_values, y_values, 'r-', 'LineWidth', 3); % Curve with red color and increased thickness
hold on;

% 9. Plot End Points
scatter([start_point(1), end_point(1)], [start_point(2), end_point(2)], 120, 'b', 'filled'); % Blue end points with increased size

% 10. Plot Tangents as Arrows at End Points
quiver(start_point(1), start_point(2), tangent_start(1), tangent_start(2), 0.2, 'm', 'LineWidth', 2, 'MaxHeadSize', 3); % Magenta tangent at start
quiver(end_point(1), end_point(2), tangent_end(1), tangent_end(2), 0.02, 'm', 'LineWidth', 2, 'MaxHeadSize', 3); % Magenta tangent at end

% 11. Set Plot Properties
xlabel('X-axis', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Y-axis', 'FontSize', 12, 'FontWeight', 'bold');
title(['Hermite Cubic Curve with A = ', num2str(A)], 'FontSize', 14, 'FontWeight', 'bold');
grid on;
axis equal;

% Display Legend
legend('Hermite Curve', 'End Points', 'Tangent at Start', 'Tangent at End', 'Location', 'best');
hold off;
