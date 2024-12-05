% Define control points
control_points =[0 2 4 6 8 10 12 14;  % x-coordinates
                  0 2 3 6 8 1 7 1];   % y-coordinates

% Degree of the B-spline (quadratic)
degree = 2;

% Number of control points
num_control_points = size(control_points, 2);

% Define a uniform knot vector
knot_vector = [0 1 2 3 4 5 6 7 8 9 10];

% Define symbolic variable t
syms t;
% Initialize symbolic equations for x and y components of the spline
spline_x = 0;
spline_y = 0;

% Compute the spline equation by summing the basis functions and control points
for i = 1:num_control_points
    % Compute the basis function N_{i-1, degree}(t) symbolically
    N_i = bspline_basis_symbolic(i-1, degree, knot_vector, t);
    
    % Update spline equation for x and y components
    spline_x = spline_x + N_i * control_points(1, i);
    spline_y = spline_y + N_i * control_points(2, i);
end

% Display the symbolic equations for the B-spline
disp('B-spline equation for x(t):');
disp(simplify(spline_x));
disp('B-spline equation for y(t):');
disp(simplify(spline_y));

% Plotting the B-spline curve
t_values = linspace(2, 8, 100);  % Range where basis functions are non-zero
curve_x = double(subs(spline_x, t, t_values));
curve_y = double(subs(spline_y, t, t_values));

figure;
hold on;
title('Quadratic B-spline Curve with Uniform Knots');
xlabel('x');
ylabel('y');
grid on;

% Plot the B-spline curve
plot(curve_x, curve_y, 'b-', 'LineWidth', 1.5);

% Plot control points
plot(control_points(1, :), control_points(2, :), 'ro-', 'MarkerFaceColor', 'r', 'LineWidth', 1.5);

% Label control points for clarity
for i = 1:num_control_points
    text(control_points(1, i), control_points(2, i), sprintf('P_%d', i-1), ...
        'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
end

legend('B-spline Curve', 'Control Points');
hold off;

% Function to calculate the symbolic B-spline basis function N_{i, degree}(t)
function N = bspline_basis_symbolic(i, p, knots, t)
    if p == 0
        % Degree 0 basis function
        N = piecewise(knots(i+1) <= t < knots(i+2), 1, 0);
    else
        % Recursive definition for degree > 0
        if knots(i+p+1) ~= knots(i+1)
            term1 = ((t - knots(i+1)) / (knots(i+p+1) - knots(i+1))) * bspline_basis_symbolic(i, p-1, knots, t);
        else
            term1 = 0;
        end
        if knots(i+p+2) ~= knots(i+2)
            term2 = ((knots(i+p+2) - t) / (knots(i+p+2) - knots(i+2))) * bspline_basis_symbolic(i+1, p-1, knots, t);
        else
            term2 = 0;
        end
        N = term1 + term2;
    end
end

