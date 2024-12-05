clear vars 
clc
clearvars
% Define the degree of the B-spline
p = 2;  % Degree 2 implies an order of 3

% Define the non-uniform knot vector
knot_vector = [0, 0, 0, 1, 2, 3, 4, 4, 5, 5, 5];

% Define 8 control points (you can modify these as needed)
control_points =  [0 2 4 6 8 10 12 14;  % x-coordinates
                  0 7 5 9 2 3 5 1];   % y-coordinates
% Create the B-spline using spmak (order is degree + 1)
order = p + 1;
spline = spmak(knot_vector, control_points);

% Define the parameter range for plotting
u_vals = linspace(knot_vector(order), knot_vector(end-order+1), 100);

% Evaluate the B-spline at the parameter values
curve_points = fnval(spline, u_vals);

% Plot the B-spline curve and control polygon
figure;
plot(curve_points(1, :), curve_points(2, :), 'b-', 'LineWidth', 2);
hold on;
plot(control_points(1, :), control_points(2, :), 'ro--', 'LineWidth', 1.5, 'MarkerSize', 8);
title('B-Spline Curve with Non-Uniform Knots');
xlabel('X');
ylabel('Y');
legend('B-Spline Curve', 'Control Polygon');
grid on;
hold off;
